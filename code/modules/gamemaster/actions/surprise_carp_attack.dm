// This event sends a few carp after someone in space.

/datum/gm_action/surprise_carp_attack
	name = "surprise carp attack"
	departments = list(DEPARTMENT_EVERYONE)
	reusable = TRUE
	chaotic = 10
	var/mob/living/victim = null

/datum/gm_action/surprise_carp_attack/get_weight()
	return metric.count_all_space_mobs() * 50

/datum/gm_action/surprise_carp_attack/set_up()
	var/list/potential_victims = list()
	victim = null
	for(var/mob/living/L in player_list)
		if(!(L.z in using_map.station_levels))
			continue // Not on the right z-level.
		if(L.stat)
			continue // Don't want dead people.
		var/turf/T = get_turf(L)
		if(istype(T, /turf/space) && istype(T.loc,/area/space))
			potential_victims.Add(L)
	if(potential_victims.len)
		victim = pick(potential_victims)


/datum/gm_action/surprise_carp_attack/start()
	..()
	if(!victim)
		message_admins("Surprise carp attack failed to find a target.")
		return
	var/number_of_carp = rand(1, 2)
	message_admins("Sending [number_of_carp] carp\s after [victim].")
	while(number_of_carp)
		var/turf/spawning_turf = null
		var/list/nearby_things = oview(10, victim)
		for(var/turf/space/space in nearby_things)
			if(get_dist(space, victim) <= 7)
				continue
			spawning_turf = space
			break
		if(spawning_turf)
			new /mob/living/simple_mob/animal/space/carp(spawning_turf)
		number_of_carp--