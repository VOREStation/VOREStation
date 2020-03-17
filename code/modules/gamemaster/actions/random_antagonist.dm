// The random spawn proc on the antag datum will handle announcing the spawn and whatnot.
/datum/gm_action/random_antag
	name = "random antagonist"
	departments = list(DEPARTMENT_EVERYONE)
	chaotic = 30
	reusable = TRUE

/datum/gm_action/random_antag/start()
	..()
	var/list/valid_types = list()
	for(var/antag_type  in all_antag_types)
		var/datum/antagonist/antag = all_antag_types[antag_type]
		if(antag.flags & ANTAG_RANDSPAWN)
			valid_types |= antag
	if(valid_types.len)
		var/datum/antagonist/antag = pick(valid_types)
		antag.attempt_random_spawn()

/datum/gm_action/random_antag/get_weight()
	. = ..()
	if(gm)
		var/weight = max(0, (metric.count_people_in_department(DEPARTMENT_SECURITY) * 20) + (metric.count_people_in_department(DEPARTMENT_EVERYONE) * 5) + gm.staleness)
		return weight
