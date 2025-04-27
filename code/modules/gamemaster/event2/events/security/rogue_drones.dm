/datum/event2/meta/rogue_drones
	name = "rogue drones"
	departments = list(DEPARTMENT_SECURITY, DEPARTMENT_EVERYONE)
	chaos = 40
	chaotic_threshold = EVENT_CHAOS_THRESHOLD_MEDIUM_IMPACT
	event_type = /datum/event2/event/mob_spawning/rogue_drones

/datum/event2/meta/rogue_drones/get_weight()
	. = 10 // Start with a base weight, since this event does provide some value even if no sec is around.
	. += GLOB.metric.count_people_in_department(DEPARTMENT_SECURITY) * 20
	. += GLOB.metric.count_all_space_mobs() * 40


/datum/event2/event/mob_spawning/rogue_drones
	length_lower_bound = 15 MINUTES
	length_upper_bound = 20 MINUTES
	var/drones_to_spawn = 6

/datum/event2/event/mob_spawning/rogue_drones/set_up()
	if(prob(10)) // Small chance for a false alarm.
		drones_to_spawn = 0

/datum/event2/event/mob_spawning/rogue_drones/announce()
	var/msg = null
	var/rng = rand(1,5)
	switch(rng)
		if(1)
			msg = "A combat drone wing operating in close orbit above Sif has failed to return from a anti-piracy sweep. \
			If any are sighted, approach with caution."
		if(2)
			msg = "Contact has been lost with a combat drone wing in Sif orbit. \
			If any are sighted in the area, approach with caution."
		if(3)
			msg = "Unidentified hackers have targeted a combat drone wing deployed around Sif. \
			If any are sighted in the area, approach with caution."
		if(4)
			msg = "A passing derelict ship's drone defense systems have just activated. \
			If any are sighted in the area, use caution."
		if(5)
			msg = "We're detecting a swarm of small objects approaching your station. \
			Most likely a bunch of drones. Please exercise caution if you see any."

	command_announcement.Announce(msg, "Rogue drone alert")

/datum/event2/event/mob_spawning/rogue_drones/start()
	for(var/i = 1 to drones_to_spawn)
		spawn_mobs_in_space(
			mob_type = /mob/living/simple_mob/mechanical/combat_drone/event,
			number_of_groups = 1,
			min_size_of_group = 1,
			max_size_of_group = 1
		)

/datum/event2/event/mob_spawning/rogue_drones/end()
	if(drones_to_spawn)
		var/number_recovered = 0
		for(var/mob/living/simple_mob/mechanical/combat_drone/D in spawned_mobs)
			var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
			sparks.set_up(3, 0, D.loc)
			sparks.start()
			D.z = using_map.admin_levels[1]
			D.loot_list = list()

			qdel(D)
			number_recovered++

		if(number_recovered > spawned_mobs.len * 0.75)
			command_announcement.Announce("The drones that were malfunctioning have been recovered safely.", "Rogue drone alert")
		else
			command_announcement.Announce("We're disappointed at the loss of the drones, but the survivors have been recovered.", "Rogue drone alert")
