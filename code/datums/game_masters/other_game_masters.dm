// The `classic` game master tries to act like the old system, choosing events without any specific goals.
// * Has no goals, and instead operates purely off of the weights of the events it has.
// * Does not react to danger at all.
/datum/game_master/classic/choose_event()
	var/list/weighted_events = list()
	for(var/datum/event2/meta/event as anything in SSgame_master.available_events)
		if(!event.enabled)
			continue
		weighted_events[event] = event.get_weight()

	var/datum/event2/meta/choice = pickweight(weighted_events)

	if(choice)
		log_game_master("[choice.name] was chosen, and is now being ran.")
		return choice


// The `super_random` game master chooses events purely at random, ignoring weights entirely.
// * Has no goals, and instead chooses randomly, ignoring weights.
// * Does not react to danger at all.
/datum/game_master/super_random/choose_event()
	return pick(SSgame_master.available_events)


// The `brutal` game master tries to run dangerous events frequently.
// * Chaotic events have their weights artifically boosted.
// * Ignores accumulated danger.
/datum/game_master/brutal
	ignore_round_chaos = TRUE

/datum/game_master/brutal/choose_event()
	var/list/weighted_events = list()
	for(var/datum/event2/meta/event as anything in SSgame_master.available_events)
		if(!event.enabled)
			continue
		weighted_events[event] = event.get_weight() + (event.chaos * 2)

	var/datum/event2/meta/choice = pickweight(weighted_events)

	if(choice)
		log_game_master("[choice.name] was chosen, and is now being ran.")
		return choice
