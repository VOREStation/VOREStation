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
	pref.player_alt_titles	= save_data["player_alt_titles"]

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
	save_data["player_alt_titles"]	= pref.player_alt_titles

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

/datum/category_item/player_setup_item/occupation/content(mob/user, limit = 25, list/splitJobs = list())
	if(!job_master)
		return

	. = list()
	. += "<tt><center>"
	. += "<b>Choose occupation chances</b><br>Unavailable occupations are crossed out.<br>"
	. += "<script type='text/javascript'>function setJobPrefRedirect(level, rank) { window.location.href='?src=\ref[src];level=' + level + ';set_job=' + encodeURIComponent(rank); return false; }</script>"
	. += "<table width='100%' cellpadding='1' cellspacing='0'><tr><td width='20%' valign='top'>" // Table within a table for alignment, also allows you to easily add more columns.
	. += "<table width='100%' cellpadding='1' cellspacing='0'>"
	var/index = -1

	//The job before the current job. I only use this to get the previous jobs color when I'm filling in blank rows.
	var/datum/job/lastJob
	var/datum/department/last_department = null // Used to avoid repeating the look-ahead check for if a whole department can fit.

	var/list/all_valid_jobs = list()
	// If the occupation window gets opened before SSJob initializes, then it'll just be blank, with no runtimes.
	// It will work once init is finished.

	for(var/D in SSjob.department_datums)
		var/datum/department/department = SSjob.department_datums[D]
		if(department.centcom_only) // No joining as a centcom role, if any are ever added.
			continue

		for(var/J in department.primary_jobs)
			all_valid_jobs += department.jobs[J]

	for(var/datum/job/job in all_valid_jobs)
		if(job.latejoin_only) continue //VOREStation Code
		var/datum/department/current_department = SSjob.get_primary_department_of_job(job)

		// Should we add a new column?
		var/make_new_column = FALSE
		if(++index > limit)
			// Ran out of rows, make a new column.
			make_new_column = TRUE

		else if(job.title in splitJobs)
			// Is hardcoded to split at this job title.
			make_new_column = TRUE

		else if(current_department != last_department)
			// If the department is bigger than the limit then we have to split.
			if(limit >= current_department.primary_jobs.len)
				// Look ahead to see if we would need to split, and if so, avoid it.
				if(index + current_department.primary_jobs.len > limit)
					// Looked ahead, and determined that a new column is needed to avoid splitting the department into two.
					make_new_column = TRUE


		if(make_new_column)
/*******
			if((index < limit) && (lastJob != null))
				//If the cells were broken up by a job in the splitJob list then it will fill in the rest of the cells with
				//the last job's selection color and blank buttons that do nothing. Creating a rather nice effect.
				for(var/i = 0, i < (limit - index), i++)
					. += "<tr bgcolor='[lastJob.selection_color]'><td width='60%' align='right'>//>&nbsp</a></td><td><a>&nbsp</a></td></tr>"
*******/
			. += "</table></td><td width='20%' valign='top'><table width='100%' cellpadding='1' cellspacing='0'>"
			index = 0
		last_department = current_department

		. += "<tr bgcolor='[job.selection_color]'><td width='60%' align='right'>"

		var/rank = job.title
		lastJob = job
		. += "<a href='?src=\ref[src];job_info=[rank]'>"
		if(jobban_isbanned(user, rank))
			. += "<del>[rank]</del></td></a><td><b> \[BANNED]</b></td></tr>"
			continue
		if(!job.player_old_enough(user.client))
			var/available_in_days = job.available_in_days(user.client)
			. += "<del>[rank]</del></td></a><td> \[IN [(available_in_days)] DAYS]</td></tr>"
			continue
		//VOREStation Add
		if(!job.player_has_enough_playtime(user.client))
			var/available_in_hours = job.available_in_playhours(user.client)
			. += "<del>[rank]</del></td></a><td> \[IN [round(available_in_hours, 0.1)] DEPTHOURS]</td></tr>"
			continue
		if(!is_job_whitelisted(user,rank))
			. += "<del>[rank]</del></td></a><td><b> \[WHITELIST ONLY]</b></td></tr>"
			continue
		//VOREStation Add End
		if(job.is_species_banned(user.client.prefs.species, user.client.prefs.organ_data["brain"]) == TRUE)
			. += "<del>[rank]</del></td></a><td> \[THIS RACE/BRAIN TYPE CANNOT TAKE THIS ROLE.\]</td></tr>"
			continue
		if((job.minimum_character_age || job.min_age_by_species) && user.client && (user.client.prefs.age < job.get_min_age(user.client.prefs.species, user.client.prefs.organ_data["brain"])))
			. += "<del>[rank]</del></td></a><td> \[MINIMUM CHARACTER AGE FOR SELECTED RACE/BRAIN TYPE: [job.get_min_age(user.client.prefs.species, user.client.prefs.organ_data["brain"])]\]</td></tr>"
			continue
		if((pref.job_civilian_low & ASSISTANT) && job.type != /datum/job/assistant)
			. += "<font color=grey>[rank]</font></a></td><td></td></tr>"
			continue
		if((rank in SSjob.get_job_titles_in_department(DEPARTMENT_COMMAND) ) || (rank == "AI"))//Bold head jobs
			. += "<b>[rank]</b></a>"
		else
			. += "[rank]</a>"

		. += "</td><td width='40%'>"

		var/prefLevelLabel = "ERROR"
		var/prefLevelColor = "pink"
		var/prefUpperLevel = -1 // level to assign on left click
		var/prefLowerLevel = -1 // level to assign on right click
		if(pref.GetJobDepartment(job, 1) & job.flag)
			prefLevelLabel = "High"
			prefLevelColor = "55cc55"
			prefUpperLevel = 4
			prefLowerLevel = 2
		else if(pref.GetJobDepartment(job, 2) & job.flag)
			prefLevelLabel = "Medium"
			prefLevelColor = "eecc22"
			prefUpperLevel = 1
			prefLowerLevel = 3
		else if(pref.GetJobDepartment(job, 3) & job.flag)
			prefLevelLabel = "Low"
			prefLevelColor = "cc5555"
			prefUpperLevel = 2
			prefLowerLevel = 4
		else
			prefLevelLabel = "NEVER"
			prefLevelColor = "black"
			prefUpperLevel = 3
			prefLowerLevel = 1

		. += "<a href='?src=\ref[src];set_job=[rank];level=[prefUpperLevel]' oncontextmenu='javascript:return setJobPrefRedirect([prefLowerLevel], \"[rank]\");'>"

		if(job.type == /datum/job/assistant)//Assistant is special
			if(pref.job_civilian_low & ASSISTANT)
				. += " <font color=55cc55>\[Yes]</font>"
			else
				. += " <font color=black>\[No]</font>"
			if(LAZYLEN(job.alt_titles)) //Blatantly cloned from a few lines down.
				. += "</a></td></tr><tr bgcolor='[lastJob.selection_color]'><td width='60%' align='center'>&nbsp</td><td><a href='?src=\ref[src];select_alt_title=\ref[job]'>\[[pref.GetPlayerAltTitle(job)]\]</a></td></tr>"
			. += "</a></td></tr>"
			continue

		. += " <font color=[prefLevelColor]>\[[prefLevelLabel]]</font>"
		if(LAZYLEN(job.alt_titles))
			. += "</a></td></tr><tr bgcolor='[lastJob.selection_color]'><td width='60%' align='center'>&nbsp</td><td><a href='?src=\ref[src];select_alt_title=\ref[job]'>\[[pref.GetPlayerAltTitle(job)]\]</a></td></tr>"
		. += "</a></td></tr>"
	. += "</td'></tr></table>"
	. += "</center></table><center>"

	switch(pref.alternate_option)
		if(GET_RANDOM_JOB)
			. += "<u><a href='?src=\ref[src];job_alternative=1'>Get random job if preferences unavailable</a></u>"
		if(BE_ASSISTANT)
			. += "<u><a href='?src=\ref[src];job_alternative=1'>Be assistant if preference unavailable</a></u>"
		if(RETURN_TO_LOBBY)
			. += "<u><a href='?src=\ref[src];job_alternative=1'>Return to lobby if preference unavailable</a></u>"

	. += "<a href='?src=\ref[src];reset_jobs=1'>\[Reset\]</a></center>"
	. += "</tt>"
	. = jointext(.,null)

/datum/category_item/player_setup_item/occupation/OnTopic(href, href_list, user)
	if(href_list["reset_jobs"])
		ResetJobs()
		return TOPIC_REFRESH

	else if(href_list["job_alternative"])
		if(pref.alternate_option == GET_RANDOM_JOB || pref.alternate_option == BE_ASSISTANT)
			pref.alternate_option += 1
		else if(pref.alternate_option == RETURN_TO_LOBBY)
			pref.alternate_option = 0
		return TOPIC_REFRESH

	else if(href_list["select_alt_title"])
		var/datum/job/job = locate(href_list["select_alt_title"])
		if (job)
			var/choices = list(job.title) + job.alt_titles
			var/choice = tgui_input_list(usr, "Choose a title for [job.title].", "Choose Title", choices, pref.GetPlayerAltTitle(job))
			if(choice && CanUseTopic(user))
				SetPlayerAltTitle(job, choice)
				return (pref.equip_preview_mob ? TOPIC_REFRESH_UPDATE_PREVIEW : TOPIC_REFRESH)

	else if(href_list["set_job"])
		if(SetJob(user, href_list["set_job"], text2num(href_list["level"])))
			return (pref.equip_preview_mob ? TOPIC_REFRESH_UPDATE_PREVIEW : TOPIC_REFRESH)

	else if(href_list["job_info"])
		var/rank = href_list["job_info"]
		var/datum/job/job = job_master.GetJob(rank)
		var/dat = list()

		dat += "<p style='background-color: [job.selection_color]'><br><br><p>"
		if(job.alt_titles)
			dat += "<i><b>Alternate titles:</b> [english_list(job.alt_titles)].</i>"
		send_rsc(user, job.get_job_icon(), "job[ckey(rank)].png")
		dat += "<img src=job[ckey(rank)].png width=96 height=96 style='float:left;'>"
		if(job.departments)
			dat += "<b>Departments:</b> [english_list(job.departments)]."
			if(LAZYLEN(job.departments_managed))
				dat += "You manage these departments: [english_list(job.departments_managed)]"

		dat += "You answer to <b>[job.supervisors]</b> normally."

		dat += "<hr style='clear:left;'>"
		if(config.wikiurl)
			dat += "<a href='?src=\ref[src];job_wiki=[rank]'>Open wiki page in browser</a>"

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

	else if(href_list["job_wiki"])
		var/rank = href_list["job_wiki"]
		open_link(user,"[config.wikiurl][rank]")

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
