/datum/tgui_module/late_choices
	name = "Late Join"
	tgui_id = "LateChoices"

/datum/tgui_module/late_choices/tgui_status(mob/user, datum/tgui_state/state)
	if(!isnewplayer(user))
		return STATUS_CLOSE
	return STATUS_INTERACTIVE

/proc/get_user_job_priority(mob/user, datum/job/job)
	. = 0

	if(!user?.client?.prefs)
		return

	if(user.client.prefs.GetJobDepartment(job, 1) & job.flag)
		. = 1
	else if(user.client.prefs.GetJobDepartment(job, 2) & job.flag)
		. = 2
	else if(user.client.prefs.GetJobDepartment(job, 3) & job.flag)
		. = 3

/proc/department_flag_to_name(department)
	switch(department)
		if(DEPARTMENT_COMMAND)
			. = "Command"
		if(DEPARTMENT_SECURITY)
			. = "Security"
		if(DEPARTMENT_ENGINEERING)
			. = "Engineering"
		if(DEPARTMENT_MEDICAL)
			. = "Medical"
		if(DEPARTMENT_RESEARCH)
			. = "Research"
		if(DEPARTMENT_CARGO)
			. = "Supply"
		if(DEPARTMENT_CIVILIAN)
			. = "Service"
		if(DEPARTMENT_PLANET)
			. = "Expedition"
		if(DEPARTMENT_SYNTHETIC)
			. = "Silicon"
		if(DEPARTMENT_TALON)
			. = "Offmap"
		else
			. = "Unknown"

/proc/character_old_enough_for_job(datum/preferences/prefs, datum/job/job)
	if(!job.minimum_character_age && !job.min_age_by_species)
		return TRUE

	var/min_age = job.get_min_age(prefs.species, prefs.organ_data[O_BRAIN])
	if(prefs.read_preference(/datum/preference/numeric/human/age) >= min_age)
		return TRUE
	return FALSE

/datum/tgui_module/late_choices/tgui_data(mob/new_player/user)
	var/list/data = ..()

	var/name = user.client.prefs.read_preference(/datum/preference/toggle/human/name_is_always_random) ? "friend" : user.client.prefs.real_name

	data["name"] = name
	data["duration"] = roundduration2text()

	if(emergency_shuttle?.going_to_centcom())
		data["evac"] = "Gone"
	else if(emergency_shuttle?.online())
		if(emergency_shuttle.evac)
			data["evac"] = "Emergency"
		else
			data["evac"] = "Crew Transfer"
	else
		data["evac"] = "None"

	var/list/jobs = list()

	for(var/datum/job/job in job_master.occupations)
		if(job && user.IsJobAvailable(job.title))
			// Check for jobs with minimum age requirements
			if(!character_old_enough_for_job(user.client.prefs, job))
				continue

			var/active = 0
			// Only players with the job assigned and AFK for less than 10 minutes count as active
			for(var/mob/M in player_list)
				if(M.mind?.assigned_role == job.title && M.client?.inactivity <= 10 MINUTES)
					active++

			// Figure out departments
			var/list/departments = list()

			for(var/department in job.departments)
				departments += department_flag_to_name(department)

			UNTYPED_LIST_ADD(jobs, list(
				"title" = job.title,
				"priority" = get_user_job_priority(user, job),
				"departments" = departments,
				"current_positions" = job.current_positions,
				"active" = active,
				"offmap" = job.offmap_spawn,
			))

	data["jobs"] = jobs

	return data

/datum/tgui_module/late_choices/tgui_act(action, params, datum/tgui/ui)
	. = ..()
	if(.)
		return

	if(!isnewplayer(ui.user))
		return
	var/mob/new_player/new_user = ui.user

	switch(action)
		if("join")
			var/job = params["job"]

			if(!CONFIG_GET(flag/enter_allowed))
				to_chat(new_user, span_notice("There is an administrative lock on entering the game!"))
				return
			else if(ticker && ticker.mode && ticker.mode.explosion_in_progress)
				to_chat(new_user, span_danger("The station is currently exploding. Joining would go poorly."))
				return

			var/datum/species/S = GLOB.all_species[new_user.client.prefs.species]
			if(!is_alien_whitelisted(new_user.client, S))
				tgui_alert(new_user, "You are currently not whitelisted to play [new_user.client.prefs.species].")
				return 0

			if(!(S.spawn_flags & SPECIES_CAN_JOIN))
				tgui_alert_async(new_user,"Your current species, [new_user.client.prefs.species], is not available for play on the station.")
				return 0

			new_user.AttemptLateSpawn(job, new_user.read_preference(/datum/preference/choiced/living/spawnpoint))
