//carp_migration
/datum/gm_action/carp_migration
	name = "carp migration"
	departments = list(ROLE_SECURITY, ROLE_EVERYONE)
	chaotic = 50
	var/list/spawned_carp = list()
	var/carp_amount = 0
	length = 20 MINUTES

/datum/gm_action/carp_migration/get_weight()
	var/people_in_space = 0
	for(var/mob/living/L in player_list)
		if(!(L.z in using_map.station_levels))
			continue // Not on the right z-level.
		var/turf/T = get_turf(L)
		if(istype(T, /turf/space) && istype(T.loc,/area/space))
			people_in_space++
	return 50 + (metric.count_people_in_department(ROLE_SECURITY) * 10) + (people_in_space * 20)

/datum/gm_action/carp_migration/announce()
	var/announcement = "Unknown biological entities have been detected near [station_name()], please stand-by."
	command_announcement.Announce(announcement, "Lifesign Alert")

/datum/gm_action/carp_migration/set_up()
	// Higher filled roles means more groups of fish.
	var/station_strength = 0
	station_strength += (metric.count_people_in_department(ROLE_SECURITY) * 3)
	station_strength += (metric.count_people_in_department(ROLE_ENGINEERING) * 2)
	station_strength += metric.count_people_in_department(ROLE_MEDICAL)

	// Less active emergency response departments tones the event down.
	var/activeness = ((metric.assess_department(ROLE_SECURITY) + metric.assess_department(ROLE_ENGINEERING) + metric.assess_department(ROLE_MEDICAL)) / 3)
	activeness = max(activeness, 20)

	carp_amount = Ceiling(station_strength * (activeness / 100) + 1)

/datum/gm_action/carp_migration/start()
	..()
	var/list/spawn_locations = list()

	var/group_size_min = 3
	var/group_size_max = 5

	for(var/obj/effect/landmark/C in landmarks_list)
		if(C.name == "carpspawn")
			spawn_locations.Add(C.loc)

	spawn_locations = shuffle(spawn_locations)
	carp_amount = min(carp_amount, spawn_locations.len)

	var/i = 1
	while (i <= carp_amount)
		var/group_size = rand(group_size_min, group_size_max)
		for (var/j = 1, j <= group_size, j++)
			spawned_carp.Add(new /mob/living/simple_animal/hostile/carp(spawn_locations[i]))
		i++
	message_admins("[spawned_carp.len] carp spawned by event.")

/datum/gm_action/carp_migration/end()
	for(var/mob/living/simple_animal/hostile/carp/C in spawned_carp)
		if(!C.stat)
			var/turf/T = get_turf(C)
			if(istype(T, /turf/space))
				if(!prob(25))
					qdel(C)