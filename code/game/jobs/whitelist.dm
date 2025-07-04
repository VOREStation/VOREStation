#define WHITELISTFILE "data/whitelist.txt"

GLOBAL_LIST_EMPTY(whitelist)
GLOBAL_LIST_EMPTY(job_whitelist)
GLOBAL_LIST_EMPTY(alien_whitelist)

// Not yet implemented
//ADMIN_VERB(open_whitelist_editor, R_ADMIN, "Open Whitelist Editor", "Opens the editor for alien- and jobwhitelists.", ADMIN_CATEGORY_GAME)
//	if(user.holder)
//		user.holder.whitelist_editor = new /datum/whitelist_editor()
//		user.holder.whitelist_editor.tgui_interact(user.mob)

/datum/whitelist_editor

/datum/whitelist_editor/tgui_state(mob/user)
	return GLOB.tgui_admin_state

/datum/whitelist_editor/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "WhitelistEdit")
		ui.open()

/datum/whitelist_editor/tgui_data(mob/user)
	var/list/data = list()

	data["alienwhitelist"] = GLOB.alien_whitelist
	data["jobwhitelist"] = GLOB.job_whitelist

	return data

/datum/whitelist_editor/tgui_static_data(mob/user)
	var/list/data = list()

	data["species_requiring_whitelist"] = GLOB.whitelisted_species

	return data

/datum/whitelist_editor/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("add_alienwhitelist")
			if (!CONFIG_GET(flag/sql_enabled))
				to_chat(ui.user, "This action is not supported while the database is disabled. Please edit [global.config.directory]/alienwhitelist.txt.")
				return
			// TODO: Add to database
			. = TRUE

		if("remove_alienwhitelist")
			if (!CONFIG_GET(flag/sql_enabled))
				to_chat(ui.user, "This action is not supported while the database is disabled. Please edit [global.config.directory]/alienwhitelist.txt.")
				return
			// TODO: Remove from database
			. = TRUE

		if("reload_alienwhitelist")
			reload_alienwhitelist()
			. = TRUE

		if("reload_jobwhitelist")
			reload_jobwhitelist()
			. = TRUE

/proc/load_whitelist()
	GLOB.whitelist = file2list(WHITELISTFILE)
	if(!GLOB.whitelist.len)	GLOB.whitelist = null

/proc/check_whitelist(mob/M /*, var/rank*/)
	if(!GLOB.whitelist)
		return 0
	return ("[M.ckey]" in GLOB.whitelist)

/proc/load_alienwhitelist(dbfail = FALSE)
	if (CONFIG_GET(flag/sql_enabled) && !dbfail)
		var/datum/db_query/query_load_alienwhistelist = SSdbcore.NewQuery("SELECT ckey, entry FROM [format_table_name("whitelist")] WHERE kind = 'species'")
		if(!query_load_alienwhistelist.Execute())
			message_admins("Error loading alienwhitelist from database. Loading from [global.config.directory]/alienwhitelist.txt.")
			log_sql("Error loading alienwhitelist from database. Loading from [global.config.directory]/alienwhitelist.txt.")
			load_alienwhitelist(dbfail = TRUE)
			return
		else
			while(query_load_alienwhistelist.NextRow())
				var/ckey = query_load_alienwhistelist.item[1]
				var/entry = query_load_alienwhistelist.item[2]

				var/list/our_whitelists = GLOB.alien_whitelist[ckey]
				if(!our_whitelists) // Guess this is their first/only whitelist entry
					our_whitelists = list()
					GLOB.alien_whitelist[ckey] = our_whitelists
				our_whitelists += entry
		qdel(query_load_alienwhistelist)
	else
		var/text = file2text("[global.config.directory]/alienwhitelist.txt")
		if (!text)
			log_misc("Failed to load [global.config.directory]/alienwhitelist.txt")
		else
			var/lines = splittext(text, "\n") // Now we've got a bunch of "ckey = something" strings in a list
			for(var/line in lines)
				var/list/left_and_right = splittext(line, " - ") // Split it on the dash into left and right
				if(LAZYLEN(left_and_right) != 2)
					warning("Alien whitelist entry is invalid: [line]") // If we didn't end up with a left and right, the line is bad
					continue
				var/key = left_and_right[1]
				if(key != ckey(key))
					warning("Alien whitelist entry appears to have key, not ckey: [line]") // The key contains invalid ckey characters
					continue
				var/list/our_whitelists = GLOB.alien_whitelist[key] // Try to see if we have one already and add to it
				if(!our_whitelists) // Guess this is their first/only whitelist entry
					our_whitelists = list()
					GLOB.alien_whitelist[key] = our_whitelists
				our_whitelists += left_and_right[2]

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
			log_misc("Failed to load [global.config.directory]/jobwhitelist.txt")
		else
			var/lines = splittext(text, "\n") // Now we've got a bunch of "ckey = something" strings in a list
			for(var/line in lines)
				var/list/left_and_right = splittext(line, " - ") // Split it on the dash into left and right
				if(LAZYLEN(left_and_right) != 2)
					warning("Alien whitelist entry is invalid: [line]") // If we didn't end up with a left and right, the line is bad
					continue
				var/key = left_and_right[1]
				if(key != ckey(key))
					warning("Alien whitelist entry appears to have key, not ckey: [line]") // The key contains invalid ckey characters
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
	var/datum/job/job = job_master.GetJob(rank)
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
		if(lowertext(rank) in our_whitelists)
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
	var/list/our_whitelists = GLOB.alien_whitelist[M.ckey]
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
	if(GLOB.alien_whitelist)
		for (var/s in GLOB.alien_whitelist)
			if(findtext(s,"[M.ckey] - [module]"))
				return 1
			if(findtext(s,"[M.ckey] - All"))
				return 1

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
