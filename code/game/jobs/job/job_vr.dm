/datum/job
	//Requires a ckey to be whitelisted in jobwhitelist.txt
	var/whitelist_only = 0

	//Does not display this job on the occupation setup screen
	var/latejoin_only = 0

	//Every hour playing this role gains this much time off. (Can be negative for off duty jobs!)
	var/timeoff_factor = 3

	//What type of PTO is that job earning?
	var/pto_type

	//Disallow joining as this job midround from off-duty position via going on-duty
	var/disallow_jobhop = FALSE

	//Time required in the department as other jobs before playing this one (in hours)
	var/dept_time_required = 0

	//Do we forbid ourselves from earning PTO?
	var/playtime_only = FALSE

	var/requestable = TRUE

// Check client-specific availability rules.
/datum/job/proc/player_has_enough_pto(client/C)
	return timeoff_factor >= 0 || (C && LAZYACCESS(C.department_hours, pto_type) > 0)

/datum/job/proc/player_has_enough_playtime(client/C)
	return (available_in_playhours(C) == 0)

/datum/job/proc/available_in_playhours(client/C)
	if(C && CONFIG_GET(flag/use_playtime_restriction_for_jobs) && dept_time_required)
		if(isnum(C.play_hours[pto_type])) // Has played that department before
			return max(0, dept_time_required - C.play_hours[pto_type])
		else // List doesn't have that entry, maybe never played, maybe invalid PTO type (you should fix that...)
			return dept_time_required // Could be 0, too, which is fine! They can play that
	return 0

// Special treatment for some the more complicated heads

// Captain gets every department combined
/datum/job/captain/available_in_playhours(client/C)
	if(C && CONFIG_GET(flag/use_playtime_restriction_for_jobs) && dept_time_required)
		var/remaining_time_needed = dept_time_required
		for(var/key in C.play_hours)
			if(isnum(C.play_hours[key]) && !(key == PTO_TALON))
				remaining_time_needed = max(0, remaining_time_needed - C.play_hours[key])
		return remaining_time_needed
	return 0

// HoP gets civilian, cargo, and exploration combined
/datum/job/hop/available_in_playhours(client/C)
	if(C && CONFIG_GET(flag/use_playtime_restriction_for_jobs) && dept_time_required)
		var/remaining_time_needed = dept_time_required
		if(isnum(C.play_hours[PTO_CIVILIAN]))
			remaining_time_needed = max(0, remaining_time_needed - C.play_hours[PTO_CIVILIAN])
		if(isnum(C.play_hours[PTO_CARGO]))
			remaining_time_needed = max(0, remaining_time_needed - C.play_hours[PTO_CARGO])
		if(isnum(C.play_hours[PTO_EXPLORATION]))
			remaining_time_needed = max(0, remaining_time_needed - C.play_hours[PTO_EXPLORATION])
		return remaining_time_needed
	return 0

/datum/job/proc/get_request_reasons()
	return list()
