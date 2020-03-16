// This is a sort of successor to the various event systems created over the years.  It is designed to be just a tad smarter than the
// previous ones, checking various things like player count, department size and composition, individual player activity,
// individual player (IC) skill, and such, in order to try to choose the best actions to take in order to add spice or variety to
// the round.

/datum/game_master
	var/suspended = TRUE 				// If true, it will not do anything.
	var/ignore_time_restrictions = FALSE// Useful for debugging without needing to wait 20 minutes each time.
	var/list/available_actions = list()	// A list of 'actions' that the GM has access to, to spice up a round, such as events.
	var/danger = 0						// The GM's best guess at how chaotic the round is.  High danger makes it hold back.
	var/staleness = -20					// Determines liklihood of the GM doing something, increases over time.
	var/danger_modifier = 1				// Multiplier for how much 'danger' is accumulated.
	var/staleness_modifier = 1			// Ditto.  Higher numbers generally result in more events occuring in a round.
	var/ticks_completed = 0				// Counts amount of ticks completed.  Note that this ticks once a minute.
	var/next_action = 0					// Minimum amount of time of nothingness until the GM can pick something again.
	var/last_department_used = null		// If an event was done for a specific department, it is written here, so it doesn't do it again.

/datum/game_master/New()
	..()
	available_actions = init_subtypes(/datum/gm_action)
	for(var/datum/gm_action/action in available_actions)
		action.gm = src

	var/config_setup_delay = TRUE
	spawn(0)
		while(config_setup_delay)
			if(config)
				config_setup_delay = FALSE
				if(config.enable_game_master)
					suspended = FALSE
					next_action = world.time + rand(15 MINUTES, 25 MINUTES)
			else
				sleep(30 SECONDS)

/datum/game_master/process()
	if(ticker && ticker.current_state == GAME_STATE_PLAYING && !suspended)
		adjust_staleness(1)
		adjust_danger(-1)
		ticks_completed++

		var/global_afk = metric.assess_all_living_mobs()
		global_afk -= 100
		global_afk = abs(global_afk)
		global_afk = round(global_afk / 100, 0.1)
		adjust_staleness(global_afk) // Staleness increases faster if more people are less active.

		if(world.time < next_action && prob(staleness * 2) )
			log_debug("Game Master going to start something.")
			start_action()

// This is run before committing to an action/event.
/datum/game_master/proc/pre_action_checks()
	if(!ticker || ticker.current_state != GAME_STATE_PLAYING)
		log_debug("Game Master unable to start event: Ticker is nonexistant, or the game is not ongoing.")
		return FALSE
	if(suspended)
		return FALSE
	if(ignore_time_restrictions)
		return TRUE
	if(world.time < next_action) // Sanity.
		log_debug("Game Master unable to start event: Time until next action is approximately [round((next_action - world.time) / (1 MINUTE))] minute(s)")
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
	var/list/most_active_departments = metric.assess_all_departments(3, list(last_department_used))
	var/list/best_actions = decide_best_action(most_active_departments)

	if(best_actions && best_actions.len)
		var/list/weighted_actions = list()
		for(var/datum/gm_action/action in best_actions)
			if(action.chaotic > danger)
				continue // We skip dangerous events when bad stuff is already occuring.
			weighted_actions[action] = action.get_weight()

		var/datum/gm_action/choice = pickweight(weighted_actions)
		if(choice)
			log_debug("[choice.name] was chosen by the Game Master, and is now being ran.")
			run_action(choice)

/datum/game_master/proc/run_action(var/datum/gm_action/action)
	action.set_up()
	action.start()
	action.announce()
	if(action.chaotic)
		danger += action.chaotic
	if(action.length)
		spawn(action.length)
			action.end()
	next_action = world.time + rand(5 MINUTES, 20 MINUTES)
	last_department_used = action.departments[1]


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
		if(DEPARTMENT_EVERYONE in action.departments)
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


