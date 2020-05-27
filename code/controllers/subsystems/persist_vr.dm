////////////////////////////////
//// Paid Leave Subsystem
//// For tracking how much department PTO time players have accured
////////////////////////////////

SUBSYSTEM_DEF(persist)
	name = "Persist"
	priority = 20
	wait = 15 MINUTES
	flags = SS_BACKGROUND|SS_NO_INIT|SS_KEEP_TIMING
	runlevels = RUNLEVEL_GAME|RUNLEVEL_POSTGAME
	var/list/currentrun = list()

/datum/controller/subsystem/persist/fire(var/resumed = FALSE)
	update_department_hours(resumed)

// Do PTO Accruals
/datum/controller/subsystem/persist/proc/update_department_hours(var/resumed = FALSE)
	if(!config.time_off)
		return

	establish_db_connection()
	if(!dbcon.IsConnected())
		src.currentrun.Cut()
		return
	if(!resumed)
		src.currentrun = human_mob_list.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun
	while (currentrun.len)
		var/mob/M = currentrun[currentrun.len]
		currentrun.len--
		if (QDELETED(M) || !istype(M) || !M.mind || !M.client || TICKS2DS(M.client.inactivity) > wait)
			continue

		// Try and detect job and department of mob
		var/datum/job/J = detect_job(M)
		if(!istype(J) || !J.pto_type || !J.timeoff_factor)
			if (MC_TICK_CHECK)
				return
			continue

		// Do not collect useless PTO
		var/department_earning = J.pto_type
		clear_unused_pto(M)

		// Determine special PTO types and convert properly
		if(department_earning == PTO_CYBORG)
			if(isrobot(M))
				var/mob/living/silicon/robot/C = M
				if(C?.module?.pto_type)
					department_earning = C.module.pto_type
			if(department_earning == PTO_CYBORG)
				if (MC_TICK_CHECK)
					return
				continue

		// Update client whatever
		var/client/C = M.client
		var/wait_in_hours = wait / (1 HOUR)
		var/pto_factored = wait_in_hours * J.timeoff_factor
		LAZYINITLIST(C.department_hours)
		LAZYINITLIST(C.play_hours)
		var/dept_hours = C.department_hours
		var/play_hours = C.play_hours
		if(isnum(dept_hours[department_earning]))
			dept_hours[department_earning] += pto_factored
		else
			dept_hours[department_earning] = pto_factored

		// If they're earning PTO they must be in a useful job so are earning playtime in that department
		if(J.timeoff_factor > 0)
			if(isnum(play_hours[department_earning]))
				play_hours[department_earning] += wait_in_hours
			else
				play_hours[department_earning] = wait_in_hours

		// Cap it
		dept_hours[department_earning] = min(config.pto_cap, dept_hours[department_earning])

		// Okay we figured it out, lets update database!
		var/sql_ckey = sql_sanitize_text(C.ckey)
		var/sql_dpt = sql_sanitize_text(department_earning)
		var/sql_bal = text2num("[C.department_hours[department_earning]]")
		var/sql_total = text2num("[C.play_hours[department_earning]]")
		var/DBQuery/query = dbcon.NewQuery("INSERT INTO vr_player_hours (ckey, department, hours, total_hours) VALUES ('[sql_ckey]', '[sql_dpt]', [sql_bal], [sql_total]) ON DUPLICATE KEY UPDATE hours = VALUES(hours), total_hours = VALUES(total_hours)")
		query.Execute()

		if (MC_TICK_CHECK)
			return

// This proc tries to find the job datum of an arbitrary mob.
/datum/controller/subsystem/persist/proc/detect_job(var/mob/M)
	// Records are usually the most reliable way to get what job someone is.
	var/datum/data/record/R = find_general_record("name", M.real_name)
	if(R) // We found someone with a record.
		var/recorded_rank = R.fields["real_rank"]
		if(recorded_rank)
			. = job_master.GetJob(recorded_rank)
			if(.) return

	// They have a custom title, aren't crew, or someone deleted their record, so we need a fallback method.
	// Let's check the mind.
	if(M.mind && M.mind.assigned_role)
		. = job_master.GetJob(M.mind.assigned_role)

// This proc tries makes sure old Command PTO doesn't linger
/datum/controller/subsystem/persist/proc/clear_unused_pto(var/mob/M)
	var/client/C = M.client
	LAZYINITLIST(C.department_hours)
	if(C.department_hours[DEPARTMENT_COMMAND])
		C.department_hours[DEPARTMENT_COMMAND] = null
		C.department_hours.Remove(DEPARTMENT_COMMAND)
