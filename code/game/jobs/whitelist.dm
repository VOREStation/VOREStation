#define WHITELISTFILE "data/whitelist.txt"
#define VALID_KINDS list("job", "species", "language", "robot")

GLOBAL_LIST_EMPTY(whitelist)
GLOBAL_LIST_EMPTY(job_whitelist)
GLOBAL_LIST_EMPTY(alien_whitelist)
GLOBAL_LIST_EMPTY(language_whitelist)
GLOBAL_LIST_EMPTY(robot_whitelist)

ADMIN_VERB(open_whitelist_editor, R_ADMIN|R_SERVER, "Open Whitelist Editor", "Opens the editor for alien- and jobwhitelists.", ADMIN_CATEGORY_SERVER_CONFIG)
	if(user.holder)
		user.holder.whitelist_editor = new /datum/whitelist_editor()
		user.holder.whitelist_editor.tgui_interact(user.mob)

/datum/whitelist_editor

/datum/whitelist_editor/tgui_state(mob/user)
	return ADMIN_STATE(R_ADMIN)

/datum/whitelist_editor/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "WhitelistEdit")
		ui.open()

/datum/whitelist_editor/tgui_data(mob/user)
	var/list/data = list(
		"alienwhitelist" = GLOB.alien_whitelist,
		"languagewhitelist" = GLOB.language_whitelist,
		"robotwhitelist" = GLOB.robot_whitelist,
		"jobwhitelist" = GLOB.job_whitelist
	)

	return data

/datum/whitelist_editor/tgui_static_data(mob/user)
	var/list/whitelist_jobs = list()
	for(var/datum/job/our_job in GLOB.job_master.occupations)
		if(our_job.whitelist_only)
			whitelist_jobs += our_job.title

	var/list/whitelisted_language = list()
	for(var/language, value in GLOB.all_languages)
		var/datum/language/current_lang = value
		if(current_lang.flags & WHITELISTED)
			whitelisted_language += language

	var/list/data = list(
		"species_with_whitelist" = GLOB.whitelisted_species,
		"language_with_whitelist" = whitelisted_language,
		"robot_with_whitelist" = GLOB.whitelisted_module_types,
		"jobs_with_whitelist" = whitelist_jobs
	)

	return data

/datum/whitelist_editor/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("add_alienwhitelist")
			if (!CONFIG_GET(flag/sql_enabled))
				to_chat(ui.user, span_warning("This action is not supported while the database is disabled. Please edit [global.config.directory]/alienwhitelist.txt."))
				return
			var/ckey = params["ckey"]
			if(ckey != ckey(ckey))
				to_chat(ui.user, span_warning("Error, invalid ckey. Did you enter the key?"))
				return FALSE
			var/kind = params["type"]
			if(!(kind in VALID_KINDS))
				to_chat(ui.user, span_warning("Error, invalid type entered."))
				return FALSE
			var/role = params["role"]
			switch(kind)
				if("job")
					var/datum/job/job = GLOB.job_master.GetJob(role)
					if(!job)
						to_chat(ui.user, span_warning("Error, invalid job entered. Check spelling and capitalization."))
						return FALSE
					if(!job.whitelist_only)
						to_chat(ui.user, span_warning("Error, job \"[role]\" is not a whitelist job."))
						return FALSE
				if("species")
					if(!(role in GLOB.playable_species))
						to_chat(ui.user, span_warning("Error, invalid species entered. Check spelling and capitalization."))
						return FALSE
					if(!(role in GLOB.whitelisted_species))
						to_chat(ui.user, span_warning("Error, species \"[role]\" is not a whitelist species."))
						return FALSE
				if("language")
					var/datum/language/chosen_language = GLOB.all_languages[role]
					if(!chosen_language)
						to_chat(ui.user, span_warning("Error, invalid language entered. Check spelling and capitalization."))
						return FALSE
					if(!(chosen_language.flags & WHITELISTED))
						to_chat(ui.user, span_warning("Error, language \"[role]\" is not a whitelist language."))
						return FALSE
				if("robot")
					if(!(role in GLOB.robot_modules))
						to_chat(ui.user, span_warning("Error, invalid robot module entered. Check spelling and capitalization."))
						return FALSE
					if(!(role in GLOB.whitelisted_module_types))
						to_chat(ui.user, span_warning("Error, robot module \"[role]\" is not a whitelist robot module."))
						return FALSE
			var/datum/db_query/command_add = SSdbcore.NewQuery(
				"INSERT INTO [format_table_name("whitelist")] (ckey, kind, entry) VALUES (:ckey, :kind, :entry)",
				list("ckey" = ckey, "kind" = kind, "entry" = role)
			)
			if(!command_add.Execute())
				log_sql("Error while trying to add [ckey] to the [role] [kind] whitelist.")
				to_chat(ui.user, span_warning("Error while trying to add [ckey] to the [role] [kind] whitelist. Please review SQL logs."))
				qdel(command_add)
				return FALSE
			qdel(command_add)
			log_and_message_admins("added [ckey]'s [role] entry to [kind] whitelsit.", ui.user)
			return TRUE

		if("remove_alienwhitelist")
			if (!CONFIG_GET(flag/sql_enabled))
				to_chat(ui.user, "This action is not supported while the database is disabled. Please edit [global.config.directory]/alienwhitelist.txt.")
				return FALSE
			var/ckey = params["ckey"]
			if(ckey != ckey(ckey))
				to_chat(ui.user, span_warning("Error, invalid ckey. Did you enter the key?"))
				return FALSE
			var/kind = params["type"]
			if(!(kind in VALID_KINDS))
				to_chat(ui.user, span_warning("Error, invalid type entered."))
				return FALSE
			var/role = params["role"]
			var/datum/db_query/command_remove = SSdbcore.NewQuery(
				"DELETE FROM [format_table_name("whitelist")] WHERE ckey = :ckey AND kind = :kind AND entry = :entry",
				list("ckey" = ckey, "kind" = kind, "entry" = role)
			)
			if(!command_remove.Execute())
				log_sql("Error while trying to remove [ckey] from the [role] [kind] whitelist.")
				to_chat(ui.user, span_warning("Error while trying to remove [ckey] from the [role] [kind] whitelist. Please review SQL logs."))
				qdel(command_remove)
				return FALSE
			qdel(command_remove)
			log_and_message_admins("removed [ckey]'s [role] entry from [kind] whitelsit.", ui.user)
			return TRUE

		if("reload_alienwhitelist")
			reload_alienwhitelist()
			return TRUE

		if("reload_jobwhitelist")
			reload_jobwhitelist()
			return TRUE

/proc/load_whitelist()
	GLOB.whitelist = world.file2list(WHITELISTFILE)
	if(!GLOB.whitelist.len)	GLOB.whitelist = null

/proc/check_whitelist(mob/M /*, var/rank*/)
	if(!GLOB.whitelist)
		return 0
	return ("[M.ckey]" in GLOB.whitelist)

/proc/load_alienwhitelist(dbfail = FALSE)
	if (CONFIG_GET(flag/sql_enabled) && !dbfail)
		var/datum/db_query/query_load_alienwhistelist = SSdbcore.NewQuery("SELECT ckey, entry, kind FROM [format_table_name("whitelist")] WHERE kind IN ('species', 'language', 'robot')")
		if(!query_load_alienwhistelist.Execute())
			message_admins("Error loading alienwhitelist from database. Loading from [global.config.directory]/alienwhitelist.txt.")
			log_sql("Error loading alienwhitelist from database. Loading from [global.config.directory]/alienwhitelist.txt.")
			load_alienwhitelist(dbfail = TRUE)
			qdel(query_load_alienwhistelist)
			return
		while(query_load_alienwhistelist.NextRow())
			var/ckey = query_load_alienwhistelist.item[1]
			var/entry = query_load_alienwhistelist.item[2]
			switch(query_load_alienwhistelist.item[3])
				if("species")
					LAZYADD(GLOB.alien_whitelist[ckey], entry)
				if("language")
					LAZYADD(GLOB.language_whitelist[ckey], entry)
				if("robot")
					LAZYADD(GLOB.robot_whitelist[ckey], entry)

		qdel(query_load_alienwhistelist)
	else
		var/text = file2text("[global.config.directory]/alienwhitelist.txt")
		if (!text)
			log_world("Failed to load [global.config.directory]/alienwhitelist.txt")
		else
			var/lines = splittext(text, "\n") // Now we've got a bunch of "ckey = something" strings in a list
			for(var/line in lines)
				var/list/data_entry = splittext(line, " - ") // Split it on the dash into left and right
				if(LAZYLEN(data_entry) != 3)
					WARNING("Alien whitelist entry is invalid: [line]") // If we didn't end up with a left and right, the line is bad
					continue
				var/key = data_entry[2]
				if(key != ckey(key))
					WARNING("Alien whitelist entry appears to have key, not ckey: [line]") // The key contains invalid ckey characters
					continue
				var/type = data_entry[1]
				switch(type)
					if("species")
						LAZYADD(GLOB.alien_whitelist[key], data_entry[3])
					if("language")
						LAZYADD(GLOB.language_whitelist[key], data_entry[3])
					if("robot")
						LAZYADD(GLOB.robot_whitelist[key], data_entry[3])
					else
						WARNING("Alien whitelist entry type is invalid: [line]")
						return

	#ifdef TESTING
	var/msg = "Alienwhitelist Built:\n"
	for(var/key in GLOB.alien_whitelist)
		msg += "\t[key]:\n"
		for(var/value in GLOB.alien_whitelist[key])
			msg += "\t\t- [value]\n"
	testing(msg)
	#endif

/proc/reload_alienwhitelist()
	GLOB.alien_whitelist.Cut()
	GLOB.language_whitelist.Cut()
	GLOB.robot_whitelist.Cut()
	load_alienwhitelist()

/proc/is_alien_whitelisted(client/C, var/datum/species/species)
	//They are admin or the whitelist isn't in use
	if(whitelist_overrides(C))
		return TRUE

	//You did something wrong
	if(!C || !species)
		return FALSE

	//The species isn't even whitelisted
	if(!(species.spawn_flags & SPECIES_IS_WHITELISTED))
		return TRUE

	//Search the whitelist
	var/list/our_whitelists = GLOB.alien_whitelist[C.ckey]
	if("All" in our_whitelists)
		return TRUE
	if(species.name in our_whitelists)
		return TRUE

	// Go apply!
	return FALSE

/proc/load_jobwhitelist(dbfail = FALSE)
	if (CONFIG_GET(flag/sql_enabled) && !dbfail)
		var/datum/db_query/query_load_jobwhitelist = SSdbcore.NewQuery("SELECT ckey, entry FROM [format_table_name("whitelist")] WHERE kind = 'job'")
		if(!query_load_jobwhitelist.Execute())
			message_admins("Error loading jobwhitelist from database. Loading from [global.config.directory]/jobwhitelist.txt.")
			log_sql("Error loading jobwhitelist from database. Loading from [global.config.directory]/jobwhitelist.txt.")
			load_jobwhitelist(dbfail = TRUE)
			return
		else
			while(query_load_jobwhitelist.NextRow())
				var/ckey = query_load_jobwhitelist.item[1]
				var/entry = query_load_jobwhitelist.item[2]

				var/list/our_whitelists = GLOB.job_whitelist[ckey]
				if(!our_whitelists) // Guess this is their first/only whitelist entry
					our_whitelists = list()
					GLOB.job_whitelist[ckey] = our_whitelists
				our_whitelists += entry
		qdel(query_load_jobwhitelist)
	else
		var/text = file2text("[global.config.directory]/jobwhitelist.txt")
		if (!text)
			log_world("Failed to load [global.config.directory]/jobwhitelist.txt")
		else
			var/lines = splittext(text, "\n") // Now we've got a bunch of "ckey = something" strings in a list
			for(var/line in lines)
				var/list/left_and_right = splittext(line, " - ") // Split it on the dash into left and right
				if(LAZYLEN(left_and_right) != 2)
					WARNING("Job whitelist entry is invalid: [line]") // If we didn't end up with a left and right, the line is bad
					continue
				var/key = left_and_right[1]
				if(key != ckey(key))
					WARNING("Job whitelist entry appears to have key, not ckey: [line]") // The key contains invalid ckey characters
					continue
				var/list/our_whitelists = GLOB.job_whitelist[key] // Try to see if we have one already and add to it
				if(!our_whitelists) // Guess this is their first/only whitelist entry
					our_whitelists = list()
					GLOB.job_whitelist[key] = our_whitelists
				our_whitelists += left_and_right[2]

/proc/reload_jobwhitelist()
	GLOB.job_whitelist.Cut()
	load_jobwhitelist()

/proc/is_job_whitelisted(mob/M, var/rank)
	// Check if the job actually requires a whitelist
	var/datum/job/job = GLOB.job_master.GetJob(rank)
	if(!job.whitelist_only)
		return TRUE

	// Visitor not Assistant
	if(rank == JOB_ALT_VISITOR)
		return TRUE

	// Let R_ADMIN permission bypass the whitelist
	if(check_rights(R_ADMIN, 0))
		return TRUE

	// Whitelist empty
	if(!GLOB.job_whitelist)
		return FALSE

	//Search the whitelist
	if(M && M.client && rank)
		var/list/our_whitelists = GLOB.job_whitelist[M.client.ckey]
		if("All" in our_whitelists)
			return TRUE
		if(rank in our_whitelists)
			return TRUE

	return FALSE

/proc/is_lang_whitelisted(mob/M, var/datum/language/language)
	//They are admin or the whitelist isn't in use
	if(whitelist_overrides(M))
		return TRUE

	//You did something wrong
	if(!M || !language)
		return FALSE

	//The language isn't even whitelisted
	if(!(language.flags & WHITELISTED))
		return TRUE

	//Search the whitelist
	var/list/our_whitelists = GLOB.language_whitelist[M.ckey]
	if("All" in our_whitelists)
		return TRUE
	if(language.name in our_whitelists)
		return TRUE

	return FALSE

/proc/is_borg_whitelisted(mob/M, var/module)
	//They are admin or the whitelist isn't in use
	if(whitelist_overrides(M))
		return 1

	//You did something wrong
	if(!M || !module)
		return 0

	//Module is not even whitelisted
	if(!(module in GLOB.whitelisted_module_types))
		return 1

	//If we have a loaded file, search it
	var/list/our_whitelists = GLOB.robot_whitelist[M.ckey]
	if("All" in our_whitelists)
		return TRUE
	if(module in our_whitelists)
		return TRUE

/proc/whitelist_overrides(client/C)
	if(!CONFIG_GET(flag/usealienwhitelist))
		return TRUE
	if(ismob(C)) //Someone fed a mob into this by mistake. Bad, but we planned ahead for these mistakes.
		var/mob/mob = C
		C = mob.client

	if(check_rights_for(C, R_ADMIN|R_EVENT|R_DEBUG))
		return TRUE

	return FALSE

#undef WHITELISTFILE
#undef VALID_KINDS
