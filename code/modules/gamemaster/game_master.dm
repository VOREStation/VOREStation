// This is a sort of successor to the various event systems created over the years.  It is designed to be just a tad smarter than the
// previous ones, checking various things like player count, department size and composition, individual player activity,
// individual player (IC) skill, and such, in order to try to choose the best actions to take in order to add spice or variety to
// the round.

/datum/game_master
	var/suspended = FALSE 				// If true, it will not do anything.
	var/list/available_actions = list()	// A list of 'actions' that the GM has access to, to spice up a round, such as events.
	var/danger = 0						// The GM's best guess at how chaotic the round is.  High danger makes it hold back.
	var/staleness = -20					// Determines liklihood of the GM doing something, increases over time.
	var/danger_modifier = 1				// Multiplier for how much 'danger' is accumulated.
	var/staleness_modifier = 1			// Ditto.  Higher numbers generally result in more events occuring in a round.
	var/ticks_completed = 0				// Counts amount of ticks completed.  Note that this ticks once a minute.
	var/next_action = 0					// Minimum amount of time of nothingness until the GM can pick something again.
	var/departments = list(				// List of departments the GM considers for choosing events for.
		ROLE_COMMAND,
		ROLE_SECURITY,
		ROLE_ENGINEERING,
		ROLE_MEDICAL,
		ROLE_RESEARCH,
		ROLE_CARGO,
		ROLE_CIVILIAN,
		ROLE_SYNTHETIC
		)

/datum/game_master/New()
	..()
	available_actions = init_subtypes(/datum/gm_action)
//	var/actions = typesof(/datum/gm_actions)
//	for(var/type in actions)
//		available_actions.Add(new type)

/datum/game_master/proc/process()
	if(ticker && ticker.current_state == GAME_STATE_PLAYING)
		adjust_staleness(1)
		adjust_danger(-1)
		ticks_completed++

		var/global_afk = assess_all_living_mobs()
		global_afk -= 100
		global_afk = abs(global_afk)
		global_afk = round(global_afk / 100, 0.1)
		adjust_staleness(global_afk) // Staleness increases faster if more people are less active.

		if(world.time < next_action && prob(staleness * 2) )
			log_debug("Game Master going to start something.")
			start_action()

/datum/game_master/proc/assess_all_living_mobs()
	var/num = 0
	for(var/mob/living/L in player_list) // Ghosts being AFK isn't that much of a concern.
		. += assess_player_activity(L)
		num++
	if(num)
		. = round(. / num, 0.1)

// This is run before committing to an action/event.
/datum/game_master/proc/pre_action_checks()
	if(!ticker || ticker.current_state != GAME_STATE_PLAYING)
		log_debug("Game Master unable to start event: Ticker is nonexistant, or the game is not ongoing.")
		return FALSE
	// Last minute antagging is bad for humans to do, so the GM will respect the start and end of the round.
	var/mills = round_duration_in_ticks
	var/mins = round((mills % 36000) / 600)
	var/hours = round(mills / 36000)

	if(hours < 1 && mins <= 20) // Don't do anything for the first twenty minutes of the round.
		log_debug("Game Master unable to start event: It is too early.")
		return FALSE
	if(hours >= 2 && mins >= 40) // Don't do anything in the last twenty minutes of the round, as well.
		log_debug("Game Master unable to start event: It is too late.")
		return FALSE
	return TRUE

/datum/game_master/proc/start_action()
	if(!pre_action_checks()) // Make sure we're not doing last minute events, or early events.
		return
	log_debug("Game Master now starting action decision.")
	var/list/best_actions = assess_round() // Checks the whole round for active people, and returns a list of the most activie departments.
	if(best_actions && best_actions.len)
		var/datum/gm_action/choice = pick(best_actions)
		if(choice)
//			log_debug("[choice.name] was chosen by the Game Master, and is now being ran.")
//			choice.set_up()
//			choice.start()
//			choice.annnounce()
			next_action = world.time + rand(15 MINUTES, 30 MINUTES)

/datum/game_master/proc/assess_round()
	var/list/activity = list()
	for(var/department in departments)
		activity[department] = assess_department(department)
		log_debug("Assessing department [department].  They have activity of [activity[department]].")

	var/list/most_active_departments = list()	// List of winners.
	var/highest_activity = null 				// Department who is leading in activity, if one exists.
	var/highest_number = 0						// Activity score needed to beat to be the most active department.
	for(var/i = 1, i <= 3, i++)
		log_debug("Doing [i]\th round of counting.")
		for(var/department in activity)
			if(activity[department] > highest_number && activity[department] > 0) // More active than the current highest department?
				highest_activity = department
				highest_number = activity[department]

		if(highest_activity) // Someone's a winner.
			most_active_departments.Add(highest_activity)	// Add to the list of most active.
			activity.Remove(highest_activity) 				// Remove them from the other list so they don't win more than once.
			log_debug("[highest_activity] has won the [i]\th round of activity counting.")
			highest_activity = null // Now reset for the next round.
			highest_number = 0
		//todo: finish
	var/list/best_actions = decide_best_action(most_active_departments)
	return best_actions

	// By now, we should have a list of departments populated.  The GM will prefer events tailored to these departments.




/datum/game_master/proc/decide_best_action(var/list/most_active_departments)
	if(!most_active_departments.len) // Server's empty?
		log_debug("Game Master failed to find any active departments.")
		return list()

	var/list/best_actions = list() // List of actions which involve the most active departments.
	if(most_active_departments.len >= 2)
		for(var/datum/gm_action/action in available_actions)
			if(!action.enabled)
				continue
			// Try to incorporate an action with the top two departments first.
			if(most_active_departments[1] in action.departments && most_active_departments[2] in action.departments)
				best_actions.Add(action)
				log_debug("[action.name] is being considered because both most active departments are involved.")

		if(best_actions.len) // We found something for those two, let's do it.
			return best_actions

	// Otherwise we probably couldn't find something for the second highest group, so let's ignore them.
	for(var/datum/gm_action/action in available_actions)
		if(!action.enabled)
			continue
		if(most_active_departments[1] in action.departments)
			best_actions.Add(action)
			log_debug("[action.name] is being considered because the most active department is involved.")

	if(best_actions.len) // Found something for the one guy.
		return best_actions

	// At this point we should expand our horizons.
	for(var/datum/gm_action/action in available_actions)
		if(!action.enabled)
			continue
		if(ROLE_EVERYONE in action.departments)
			best_actions.Add(action)
			log_debug("[action.name] is being considered because it involves everyone.")

	if(best_actions.len) // Finally, perhaps?
		return best_actions

	// Just give a random event if for some reason it still can't make up its mind.
	for(var/datum/gm_action/action in available_actions)
		if(!action.enabled)
			continue
		best_actions.Add(action)
		log_debug("[action.name] is being considered because everything else failed.")

	if(best_actions.len) // Finally, perhaps?
		return best_actions
	else
		log_debug("Game Master failed to find a suitable event, something very wrong is going on.")

// This checks a whole department's viability to receive an event.
/datum/game_master/proc/assess_department(var/department)
	if(!department)
		return
	var/departmental_activitiy = 0
	for(var/mob/M in player_list)
		if(guess_department(M) != department) // Ignore people outside the department we're assessing.
			continue
		departmental_activitiy += assess_player_activity(M)
	return departmental_activitiy

// This checks an individual player's activity level.  People who have been afk for a few minutes aren't punished as much as those
// who were afk for hours, as they're most likely gone for good.
/datum/game_master/proc/assess_player_activity(var/mob/M)
	. = 100
	if(!M)
		. = 0
		return

	if(!M.mind || !M.client) // Logged out.  They might come back but we can't do any meaningful assessments for now.
		. = 0
		return

	var/afk = M.client.is_afk(1 MINUTE)
	if(afk) // Deduct points based on length of AFK-ness.
		switch(afk) // One minute is equal to 600, for reference.
			if(1 MINUTE to 10 MINUTES) // People gone for this emough of time hopefully will come back soon.
				. -= round( (afk / 200), 1)
			//	. -= 30
			if(10 MINUTES to 30 MINUTES)
				. -= round( (afk / 150), 1)
			//	. -= 70
			if(30 MINUTES to INFINITY) // They're probably not coming back if it's been 30 minutes.
				. -= 100
	. = max(. , 0) // No negative numbers, or else people could drag other, non-afk players down.

