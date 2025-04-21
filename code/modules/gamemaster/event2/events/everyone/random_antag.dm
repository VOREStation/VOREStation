// No idea if this is needed for autotraitor or not.
// If it is, it shouldn't depend on the event system, but fixing that would be it's own project.
// If not, it can stay off until an admin wants to play with it.

/datum/event2/meta/random_antagonist
	name = "random antagonist"
	enabled = FALSE
	reusable = TRUE
	chaos = 0 // This is zero due to the event system not being able to know if an antag actually got spawned or not.
	departments = list(DEPARTMENT_EVERYONE)
	chaotic_threshold = EVENT_CHAOS_THRESHOLD_MEDIUM_IMPACT
	event_type = /datum/event2/event/random_antagonist

// This has an abnormally high weight due to antags being very important for the round,
// however the weight will decay with more antags, and more attempts to add antags.
/datum/event2/meta/random_antagonist/get_weight()
	var/antags = GLOB.metric.count_all_antags()
	return 200 / (antags + times_ran + 1)



// The random spawn proc on the antag datum will handle announcing the spawn and whatnot, in theory.
/datum/event2/event/random_antagonist/start()
	var/list/valid_types = list()
	for(var/antag_type in GLOB.all_antag_types)
		var/datum/antagonist/antag = GLOB.all_antag_types[antag_type]
		if(antag.flags & ANTAG_RANDSPAWN)
			valid_types |= antag
	if(valid_types.len)
		var/datum/antagonist/antag = pick(valid_types)
		antag.attempt_random_spawn()
