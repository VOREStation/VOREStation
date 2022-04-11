// This checks an individual player's activity level.  People who have been afk for a few minutes aren't punished as much as those
// who were afk for hours, as they're most likely gone for good.
/datum/metric/proc/assess_player_activity(var/mob/M)
	. = 100
	if(!M)
		. = 0
		return

	if(!M.client) // Logged out.  They might come back but we can't do any meaningful assessments for now.
		. = 0
		return

	var/afk = M.client.is_afk(1 MINUTE)
	if(afk) // Deduct points based on length of AFK-ness.
		switch(afk) // One minute is equal to 600, for reference.
			if(1 MINUTE to 10 MINUTES) // People gone for this emough of time hopefully will come back soon.
				. -= round( (afk / 200), 1)
			if(10 MINUTES to 30 MINUTES)
				. -= round( (afk / 150), 1)
			if(30 MINUTES to INFINITY) // They're probably not coming back if it's been 30 minutes.
				. -= 100
	. = max(. , 0) // No negative numbers, or else people could drag other, non-afk players down.

// This checks a whole department's collective activity.
/datum/metric/proc/assess_department(var/department)
	if(!department)
		return
	var/departmental_activity = 0
	var/departmental_size = 0
	for(var/mob/M in player_list)
		if(guess_department(M) != department) // Ignore people outside the department we're assessing.
			continue
		departmental_activity += assess_player_activity(M)
		departmental_size++
	if(departmental_size)
		departmental_activity = departmental_activity / departmental_size // Average it out.
	return departmental_activity

/datum/metric/proc/assess_all_departments(var/cutoff_number = 3, var/list/department_blacklist = list())
	var/list/activity = list()
	for(var/department in departments)
		activity[department] = assess_department(department)
//		log_debug("Assessing department [department].  They have activity of [activity[department]].")

	var/list/most_active_departments = list()	// List of winners.
	var/highest_activity = null 				// Department who is leading in activity, if one exists.
	var/highest_number = 0						// Activity score needed to beat to be the most active department.
	for(var/i = 1, i <= cutoff_number, i++)
//		log_debug("Doing [i]\th round of counting.")
		for(var/department in activity)
			if(department in department_blacklist) // Blacklisted?
				continue
			if(activity[department] > highest_number && activity[department] > 0) // More active than the current highest department?
				highest_activity = department
				highest_number = activity[department]

		if(highest_activity) // Someone's a winner.
			most_active_departments.Add(highest_activity)	// Add to the list of most active.
			activity.Remove(highest_activity) 				// Remove them from the other list so they don't win more than once.
//			log_debug("[highest_activity] has won the [i]\th round of activity counting.")
			highest_activity = null // Now reset for the next round.
			highest_number = 0
		//todo: finish
	return most_active_departments

/datum/metric/proc/assess_all_living_mobs() // Living refers to the type, not the stat variable.
	. = 0
	var/num = 0
	for(var/mob/living/L in player_list)
		. += assess_player_activity(L)
		num++
	if(num)
		. = round(. / num, 0.1)

/datum/metric/proc/assess_all_dead_mobs() // Ditto.
	. = 0
	var/num = 0
	for(var/mob/observer/dead/O in player_list)
		. += assess_player_activity(O)
		num++
	if(num)
		. = round(. / num, 0.1)

/datum/metric/proc/assess_all_outdoor_mobs()
	. = 0
	var/num = 0
	for(var/mob/living/L in player_list)
		var/turf/T = get_turf(L)
		if(istype(T) && !istype(T, /turf/space) && T.is_outdoors())
			. += assess_player_activity(L)
			num++
	if(num)
		. = round(. / num, 0.1)
