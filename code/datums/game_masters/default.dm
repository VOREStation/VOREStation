// The default game master tries to choose events with these goals in mind.
// * Don't choose an event if the crew can't take it. E.g. no meteors after half of the crew died.
// * Try to involve lots of people, particuarly in active departments.
// * Avoid giving events to the same department multiple times in a row.
/datum/game_master/default
	// If an event was done for a specific department, it is written here, so it doesn't do it again.
	var/last_department_used = null


/datum/game_master/default/choose_event()
	log_game_master("Now starting event decision.")

	var/list/most_active_departments = metric.assess_all_departments(3, list(last_department_used))
	var/list/best_events = decide_best_events(most_active_departments)

	if(LAZYLEN(best_events))
		log_game_master("Got [best_events.len] choice\s for the next event.")
		var/list/weighted_events = list()

		for(var/datum/event2/meta/event as anything in best_events)
			var/weight = event.get_weight()
			if(weight <= 0)
				continue
			weighted_events[event] = weight
		log_game_master("Filtered down to [weighted_events.len] choice\s.")

		var/datum/event2/meta/choice = pickweight(weighted_events)

		if(choice)
			log_game_master("[choice.name] was chosen, and is now being ran.")
			last_department_used = LAZYACCESS(choice.departments, 1)
			return choice

/datum/game_master/default/proc/decide_best_events(list/most_active_departments)
	if(!LAZYLEN(most_active_departments)) // Server's empty?
		log_game_master("Game Master failed to find any active departments.")
		return list()

	var/list/best_events = list()
	if(most_active_departments.len >= 2)
		var/list/top_two = list(most_active_departments[1], most_active_departments[2])
		best_events = filter_events_by_departments(top_two)

		if(LAZYLEN(best_events)) // We found something for those two, let's do it.
			return best_events

	// Otherwise we probably couldn't find something for the second highest group, so let's ignore them.
	best_events = filter_events_by_departments(most_active_departments[1])

	if(LAZYLEN(best_events))
		return best_events

	// At this point we should expand our horizons.
	best_events = filter_events_by_departments(list(DEPARTMENT_EVERYONE))

	if(LAZYLEN(best_events))
		return best_events

	// Just give a random event if for some reason it still can't make up its mind.
	best_events = filter_events_by_departments()

	if(LAZYLEN(best_events))
		return best_events

	log_game_master("Game Master failed to find a suitable event, something very wrong is going on.")
	return list()

// Filters the available events down to events for specific departments.
// Pass DEPARTMENT_EVERYONE if you want events that target the general population, like gravity failure.
// If no list is passed, all the events will be returned.
/datum/game_master/default/proc/filter_events_by_departments(list/departments)
	. = list()
	for(var/datum/event2/meta/event as anything in SSgame_master.available_events)
		if(!event.enabled)
			continue
		if(event.chaotic_threshold && !ignore_round_chaos)
			if(SSgame_master.danger > event.chaotic_threshold)
				continue
		// An event has to involve all of these departments to pass.
		var/viable = TRUE
		if(LAZYLEN(departments))
			for(var/department in departments)
				if(!LAZYFIND(departments, department))
					viable = FALSE
					break
		if(viable)
			. += event
