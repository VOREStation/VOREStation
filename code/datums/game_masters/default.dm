// The default game master tries to choose events with these goals in mind.
// * Don't choose an event if the crew can't take it. E.g. no meteors after half of the crew died.
// * Try to involve lots of people, particuarly in active departments.
// * Avoid giving events to the same department multiple times in a row.
/datum/game_master/default
	// If an event was done for a specific department, it is written here, so it doesn't do it again.
	var/last_department_used = null


/datum/game_master/default/choose_event()
	log_game_master("Now starting event decision.")

	var/list/regions = metric.assess_player_regions()
	if(!LAZYLEN(regions))
		regions = list(EVENT_REGION_UNIVERSAL = 100)

	var/list/most_active_departments = metric.assess_all_departments(3, list(last_department_used))
	var/list/best_events = decide_best_events(most_active_departments, regions)

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

/datum/game_master/default/proc/decide_best_events(list/most_active_departments, var/list/regions)
	if(!LAZYLEN(most_active_departments)) // Server's empty?
		log_game_master("Game Master failed to find any active departments.")
		return list()

	// Filter by generic factors
	var/list/available_events = filter_events_generic()

	// Filter by player regions. Lots of people in the mines = favor subterranean events
	var/list/best_events = filter_events_by_region(available_events, pickweight(regions))
	if(!LAZYLEN(best_events))
		best_events = filter_events_by_region(available_events, EVENT_REGION_UNIVERSAL)
		if(!LAZYLEN(best_events))
			log_game_master("Game Master failed to find a suitable event, something very wrong is going on.")
			return list()
	available_events = best_events

	// Filter events by department. Lots of engineering = break things on the station
	if(most_active_departments.len >= 2)
		var/list/top_two = list(most_active_departments[1], most_active_departments[2])
		best_events = filter_events_by_departments(available_events, top_two)

		if(LAZYLEN(best_events)) // We found something for those two, let's do it.
			return best_events

	// Otherwise we probably couldn't find something for the second highest group, so let's ignore them.
	best_events = filter_events_by_departments(available_events, list(most_active_departments[1]))

	if(LAZYLEN(best_events))
		return best_events

	// At this point we should expand our horizons.
	best_events = filter_events_by_departments(available_events, list(DEPARTMENT_EVERYONE))

	if(LAZYLEN(best_events))
		return best_events

	// Just give a random event if for some reason it still can't make up its mind.
	best_events = filter_events_by_departments(available_events)

	if(LAZYLEN(best_events))
		return best_events

	log_game_master("Game Master failed to find a suitable event, something very wrong is going on.")
	return list()

// Filters events by availability, enable, and chaos
/datum/game_master/default/proc/filter_events_generic()
	. = list()
	for(var/datum/event2/meta/event as anything in SSgame_master.available_events)
		if(!event.enabled)
			continue
		if(event.chaotic_threshold && !ignore_round_chaos)
			if(SSgame_master.danger > event.chaotic_threshold)
				continue
		. += event

// Filters the available events down to events for specific departments.
// Pass DEPARTMENT_EVERYONE if you want events that target the general population, like gravity failure.
// If no list is passed, all the events will be returned.
/datum/game_master/default/proc/filter_events_by_departments(list/available_events, list/departments)
	. = list()
	for(var/datum/event2/meta/event in available_events)
		// An event has to involve all of these departments to pass.
		if(!LAZYLEN(departments) || (departments ~= (event.departments & departments)))
			. += event

// Filters the available events by the region those events target.
/datum/game_master/default/proc/filter_events_by_region(list/available_events, var/target_region)
	. = list()
	for(var/datum/event2/meta/event in available_events)
		if(target_region in event.regions)
			. += event