/datum/category_item/player_setup_item/occupation
	name = "Occupation"
	sort_order = 1

/datum/category_item/player_setup_item/occupation/load_character(list/save_data)
	pref.alternate_option	= save_data["alternate_option"]
	pref.job_civilian_high	= save_data["job_civilian_high"]
	pref.job_civilian_med	= save_data["job_civilian_med"]
	pref.job_civilian_low	= save_data["job_civilian_low"]
	pref.job_medsci_high	= save_data["job_medsci_high"]
	pref.job_medsci_med		= save_data["job_medsci_med"]
	pref.job_medsci_low		= save_data["job_medsci_low"]
	pref.job_engsec_high	= save_data["job_engsec_high"]
	pref.job_engsec_med		= save_data["job_engsec_med"]
	pref.job_engsec_low		= save_data["job_engsec_low"]
	//VOREStation Add
	pref.job_talon_low		= save_data["job_talon_low"]
	pref.job_talon_med		= save_data["job_talon_med"]
	pref.job_talon_high		= save_data["job_talon_high"]
	//VOREStation Add End
	pref.player_alt_titles	= check_list_copy(save_data["player_alt_titles"])

/datum/category_item/player_setup_item/occupation/save_character(list/save_data)
	save_data["alternate_option"]	= pref.alternate_option
	save_data["job_civilian_high"]	= pref.job_civilian_high
	save_data["job_civilian_med"]	= pref.job_civilian_med
	save_data["job_civilian_low"]	= pref.job_civilian_low
	save_data["job_medsci_high"]	= pref.job_medsci_high
	save_data["job_medsci_med"]		= pref.job_medsci_med
	save_data["job_medsci_low"]		= pref.job_medsci_low
	save_data["job_engsec_high"]	= pref.job_engsec_high
	save_data["job_engsec_med"]		= pref.job_engsec_med
	save_data["job_engsec_low"]		= pref.job_engsec_low
	//VOREStation Add
	save_data["job_talon_low"]		= pref.job_talon_low
	save_data["job_talon_med"]		= pref.job_talon_med
	save_data["job_talon_high"]		= pref.job_talon_high
	//VOREStation Add End
	save_data["player_alt_titles"]	= check_list_copy(pref.player_alt_titles)

/datum/category_item/player_setup_item/occupation/sanitize_character()
	pref.alternate_option	= sanitize_integer(pref.alternate_option, 0, 2, initial(pref.alternate_option))
	pref.job_civilian_high	= sanitize_integer(pref.job_civilian_high, 0, 65535, initial(pref.job_civilian_high))
	pref.job_civilian_med	= sanitize_integer(pref.job_civilian_med, 0, 65535, initial(pref.job_civilian_med))
	pref.job_civilian_low	= sanitize_integer(pref.job_civilian_low, 0, 65535, initial(pref.job_civilian_low))
	pref.job_medsci_high	= sanitize_integer(pref.job_medsci_high, 0, 65535, initial(pref.job_medsci_high))
	pref.job_medsci_med		= sanitize_integer(pref.job_medsci_med, 0, 65535, initial(pref.job_medsci_med))
	pref.job_medsci_low		= sanitize_integer(pref.job_medsci_low, 0, 65535, initial(pref.job_medsci_low))
	pref.job_engsec_high	= sanitize_integer(pref.job_engsec_high, 0, 65535, initial(pref.job_engsec_high))
	pref.job_engsec_med 	= sanitize_integer(pref.job_engsec_med, 0, 65535, initial(pref.job_engsec_med))
	pref.job_engsec_low 	= sanitize_integer(pref.job_engsec_low, 0, 65535, initial(pref.job_engsec_low))
	//VOREStation Add
	pref.job_talon_high		= sanitize_integer(pref.job_talon_high, 0, 65535, initial(pref.job_talon_high))
	pref.job_talon_med 		= sanitize_integer(pref.job_talon_med, 0, 65535, initial(pref.job_talon_med))
	pref.job_talon_low 		= sanitize_integer(pref.job_talon_low, 0, 65535, initial(pref.job_talon_low))
	//VOREStation Add End
	if(!(pref.player_alt_titles)) pref.player_alt_titles = new()

	if(!job_master)
		return

	for(var/datum/job/job in job_master.occupations)
		var/alt_title = pref.player_alt_titles[job.title]
		if(alt_title && !(alt_title in job.alt_titles))
			pref.player_alt_titles -= job.title

/datum/category_item/player_setup_item/occupation/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	var/list/jobs_data = list()
	var/list/all_valid_jobs = list()
	for(var/D in SSjob.department_datums)
		var/datum/department/department = SSjob.department_datums[D]
		if(department.centcom_only) // No joining as a centcom role, if any are ever added.
			continue

		for(var/J in department.primary_jobs)
			all_valid_jobs += department.jobs[J]

		jobs_data[department.name] = list()

	for(var/datum/job/job in all_valid_jobs)
		if(job.latejoin_only)
			continue
		var/datum/department/current_department = SSjob.get_primary_department_of_job(job)
		// for the is_job_whitelisted check..
		usr = user
		var/list/job_data = list(
			"title" = job.title,
			"ref" = REF(job),
			"selection_color" = job.selection_color,
			// reasons you can't select it
			"banned" = !!jobban_isbanned(user, job.title),
			"denylist_days" = !job.player_old_enough(user.client),
			"available_in_days" = !job.available_in_days(user.client),
			"denylist_playtime" = !job.player_has_enough_playtime(user.client),
			"available_in_hours" = job.available_in_playhours(user.client),
			"denylist_whitelist" = !is_job_whitelisted(user, job.title),
			// tigercat2000 - these shouldn't exist >:(
			"denylist_character_age" = FALSE,
			"min_age" = job.get_min_age(pref.species, pref.organ_data[O_BRAIN]),
			"special_color" = "",
			"selected" = 0,
			"selected_title" = "",
			"alt_titles" = list(),
		)

		if((job.minimum_character_age || job.min_age_by_species) && user.client && (user.read_preference(/datum/preference/numeric/human/age) < job.get_min_age(user.client.prefs.species, user.client.prefs.organ_data[O_BRAIN])))
			job_data["denylist_character_age"] = TRUE

		if((pref.job_civilian_low & ASSISTANT) && job.type != /datum/job/assistant)
			job_data["special_color"] = "gray"
		if((job.title in SSjob.get_job_titles_in_department(DEPARTMENT_COMMAND) ) || (job.title == JOB_AI))//Bold head jobs
			job_data["special_color"] = "bold"

		if(job.type == /datum/job/assistant)//Assistant is special
			if(pref.job_civilian_low & ASSISTANT)
				job_data["selected"] = 4
			else
				job_data["selected"] = 0
		else if(pref.GetJobDepartment(job, 1) & job.flag)
			job_data["selected"] = 3
		else if(pref.GetJobDepartment(job, 2) & job.flag)
			job_data["selected"] = 2
		else if(pref.GetJobDepartment(job, 3) & job.flag)
			job_data["selected"] = 1
		else
			job_data["selected"] = 0

		job_data["selected_title"] = pref.GetPlayerAltTitle(job)
		for(var/title in job.alt_titles)
			job_data["alt_titles"] += title

		UNTYPED_LIST_ADD(jobs_data[current_department.name], job_data)

	data["jobs"] = jobs_data
	data["alternate_option"] = pref.alternate_option

	return data

/datum/category_item/player_setup_item/occupation/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	. = ..()
	if(.)
		return

	var/mob/user = ui.user

	switch(action)
		if("reset_jobs")
			ResetJobs()
			return TOPIC_REFRESH_UPDATE_PREVIEW

		if("job_alternative")
			if(pref.alternate_option == GET_RANDOM_JOB || pref.alternate_option == BE_ASSISTANT)
				pref.alternate_option += 1
			else if(pref.alternate_option == RETURN_TO_LOBBY)
				pref.alternate_option = 0
			return TOPIC_REFRESH

		if("select_alt_title")
			var/datum/job/J = locate(params["job"])
			if(istype(J))
				var/choices = list(J.title) + J.alt_titles
				var/choice = tgui_input_list(user, "Choose a title for [J.title].", "Choose Title", choices, pref.GetPlayerAltTitle(J))
				if(choice)
					SetPlayerAltTitle(J, choice)
					return TOPIC_REFRESH_UPDATE_PREVIEW

		if("set_job")
			if(SetJob(user, params["set_job"], text2num(params["level"])))
				return TOPIC_REFRESH_UPDATE_PREVIEW
			return TOPIC_HANDLED

		if("job_info")
			var/rank = params["rank"]
			var/datum/job/job = job_master.GetJob(rank)
			if(!istype(job))
				return TOPIC_NOACTION

			var/dat = list()

			dat += "<p style='background-color: [job.selection_color]'><br><br><p>"
			if(job.alt_titles)
				dat += span_italics(span_bold("Alternate titles:") + " [english_list(job.alt_titles)].")
			send_rsc(user, job.get_job_icon(), "job[ckey(rank)].png")
			dat += "<img src=job[ckey(rank)].png width=96 height=96 style='float:left;'>"
			if(job.departments)
				dat += span_bold("Departments:") + " [english_list(job.departments)]."
				if(LAZYLEN(job.departments_managed))
					dat += "You manage these departments: [english_list(job.departments_managed)]"

			dat += "You answer to " + span_bold("[job.supervisors]") + " normally."

			dat += "<hr style='clear:left;'>"
			if(CONFIG_GET(string/wikiurl))
				dat += "<a href='byond://?src=\ref[src];job_wiki=[rank]'>Open wiki page in browser</a>"

			var/alt_title = pref.GetPlayerAltTitle(job)
			var/list/description = job.get_description_blurb(alt_title)
			if(LAZYLEN(description))
				dat += html_encode(description[1])
				if(description.len > 1)
					if(!isnull(description[2]))
						dat += "<br>"
						dat += html_encode(description[2])

			var/datum/browser/popup = new(user, "Job Info", "[capitalize(rank)]", 430, 520, src)
			popup.set_content(jointext(dat,"<br>"))
			popup.open()
			return TOPIC_HANDLED

// must stay for job popup to work
/datum/category_item/player_setup_item/occupation/OnTopic(href, href_list, user)
	if(href_list["job_wiki"])
		var/rank = href_list["job_wiki"]
		open_link(user,"[CONFIG_GET(string/wikiurl)][rank]")

	return ..()

/datum/category_item/player_setup_item/occupation/proc/SetPlayerAltTitle(datum/job/job, new_title)
	// remove existing entry
	pref.player_alt_titles -= job.title
	// add one if it's not default
	if(job.title != new_title)
		pref.player_alt_titles[job.title] = new_title

/datum/category_item/player_setup_item/occupation/proc/SetJob(mob/user, role, level)
	var/datum/job/job = job_master.GetJob(role)
	if(!job)
		return 0

	if(job.type == /datum/job/assistant)
		if(pref.job_civilian_low & job.flag)
			pref.job_civilian_low &= ~job.flag
		else
			pref.job_civilian_low |= job.flag
		return 1

	SetJobDepartment(job, level)
	return 1

/datum/category_item/player_setup_item/occupation/proc/reset_jobhigh()
	pref.job_civilian_med |= pref.job_civilian_high
	pref.job_medsci_med |= pref.job_medsci_high
	pref.job_engsec_med |= pref.job_engsec_high
	pref.job_talon_med |= pref.job_talon_high //VOREStation Add
	pref.job_civilian_high = 0
	pref.job_medsci_high = 0
	pref.job_engsec_high = 0
	pref.job_talon_high = 0 //VOREStation Add

// Level is equal to the desired new level of the job. So for a value of 4, we want to disable the job.
/datum/category_item/player_setup_item/occupation/proc/SetJobDepartment(var/datum/job/job, var/level)
	if(!job || !level)
		return 0

	switch(job.department_flag)
		if(CIVILIAN)
			pref.job_civilian_low &= ~job.flag
			pref.job_civilian_med &= ~job.flag
			pref.job_civilian_high &= ~job.flag
			switch(level)
				if(1)
					reset_jobhigh()
					pref.job_civilian_high = job.flag
				if(2)
					pref.job_civilian_med |= job.flag
				if(3)
					pref.job_civilian_low |= job.flag
		if(MEDSCI)
			pref.job_medsci_low &= ~job.flag
			pref.job_medsci_med &= ~job.flag
			pref.job_medsci_high &= ~job.flag
			switch(level)
				if(1)
					reset_jobhigh()
					pref.job_medsci_high = job.flag
				if(2)
					pref.job_medsci_med |= job.flag
				if(3)
					pref.job_medsci_low |= job.flag
		if(ENGSEC)
			pref.job_engsec_low &= ~job.flag
			pref.job_engsec_med &= ~job.flag
			pref.job_engsec_high &= ~job.flag
			switch(level)
				if(1)
					reset_jobhigh()
					pref.job_engsec_high = job.flag
				if(2)
					pref.job_engsec_med |= job.flag
				if(3)
					pref.job_engsec_low |= job.flag
		//VOREStation Add
		if(TALON)
			pref.job_talon_low &= ~job.flag
			pref.job_talon_med &= ~job.flag
			pref.job_talon_high &= ~job.flag
			switch(level)
				if(1)
					reset_jobhigh()
					pref.job_talon_high = job.flag
				if(2)
					pref.job_talon_med |= job.flag
				if(3)
					pref.job_talon_low |= job.flag
		//VOREStation Add End

	return 1

/datum/category_item/player_setup_item/occupation/proc/ResetJobs()
	pref.job_civilian_high = 0
	pref.job_civilian_med = 0
	pref.job_civilian_low = 0

	pref.job_medsci_high = 0
	pref.job_medsci_med = 0
	pref.job_medsci_low = 0

	pref.job_engsec_high = 0
	pref.job_engsec_med = 0
	pref.job_engsec_low = 0

	//VOREStation Add
	pref.job_talon_high = 0
	pref.job_talon_med = 0
	pref.job_talon_low = 0
	//VOREStation Add End

	pref.player_alt_titles.Cut()

/datum/preferences/proc/GetPlayerAltTitle(datum/job/job)
	return (job.title in player_alt_titles) ? player_alt_titles[job.title] : job.title

/datum/preferences/proc/GetJobDepartment(var/datum/job/job, var/level)
	if(!job || !level)	return 0
	switch(job.department_flag)
		if(CIVILIAN)
			switch(level)
				if(1)
					return job_civilian_high
				if(2)
					return job_civilian_med
				if(3)
					return job_civilian_low
		if(MEDSCI)
			switch(level)
				if(1)
					return job_medsci_high
				if(2)
					return job_medsci_med
				if(3)
					return job_medsci_low
		if(ENGSEC)
			switch(level)
				if(1)
					return job_engsec_high
				if(2)
					return job_engsec_med
				if(3)
					return job_engsec_low
		//VOREStation Add
		if(TALON)
			switch(level)
				if(1)
					return job_talon_high
				if(2)
					return job_talon_med
				if(3)
					return job_talon_low
		//VOREStation Add End
	return 0
