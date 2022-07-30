/datum/event/rogue_drone
	endWhen = 1000
	var/list/drones_list = list()

/datum/event/rogue_drone/start()
	//spawn them at the same place as carp
	var/list/possible_spawns = list()
	for(var/obj/effect/landmark/C in landmarks_list)
		if(C.name == "carpspawn")
			possible_spawns.Add(C)

	//25% chance for this to be a false alarm
	var/num
	if(prob(25))
		num = 0
	else
		num = rand(2,6)
	for(var/i=0, i<num, i++)
		var/mob/living/simple_mob/mechanical/combat_drone/event/D = new(get_turf(pick(possible_spawns)))
		drones_list.Add(D)

/datum/event/rogue_drone/announce()
	var/msg
	var/rng = rand(1,5)
	//VOREStation Edit Start
	switch(rng)
		if(1)
			msg = "A combat drone wing operating in close orbit above Virgo 3b has failed to return from a anti-piracy sweep.  If any are sighted, \
			approach with caution."
		if(2)
			msg = "Contact has been lost with a combat drone wing in Virgo 3b orbit.  If any are sighted in the area, approach with \
			caution."
		if(3)
			msg = "Unidentified hackers have targeted a combat drone wing deployed around Virgo 3b. If any are sighted in the area, approach with caution."
		if(4)
			msg = "A passing derelict ship's drone defense systems have just activated. If any are sighted in the area, use caution."
		if(5)
			msg = "We're detecting a swarm of small objects approaching your [using_map.facility_type].  Most likely a bunch of drones.  Please exercise caution if you see any."
	//VOREStation Edit End
	command_announcement.Announce(msg, "Rogue drone alert")

/datum/event/rogue_drone/end()
	var/num_recovered = 0
	for(var/mob/living/simple_mob/mechanical/combat_drone/D in drones_list)
		var/datum/effect_system/spark_spread/sparks = new /datum/effect_system/spark_spread()
		sparks.set_up(3, 0, D.loc)
		sparks.start()
		D.z = using_map.admin_levels[1]
		D.loot_list = list()

		qdel(D)
		num_recovered++

	if(num_recovered > drones_list.len * 0.75)
		command_announcement.Announce("The drones that were malfunctioning have been recovered safely.", "Rogue drone alert")
	else
		command_announcement.Announce("We're disappointed at the loss of the drones, but the survivors have been recovered.", "Rogue drone alert")
