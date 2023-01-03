/datum/event/roaming_wildlife
	announceWhen = 10

/datum/event/roaming_wildlife/start()
	var/list/possible_spawns = list()
	for(var/obj/effect/landmark/C in landmarks_list)
		if(istype(C, /obj/effect/landmark/wildlife))
			possible_spawns.Add(C)

	if(!(possible_spawns.len))
		return

	var/threat_level
	var/spawn_count
	var/location_amount

	var/points_to_spend

	switch(severity)
		if(EVENT_LEVEL_MUNDANE)
			points_to_spend = 6
		if(EVENT_LEVEL_MODERATE)
			points_to_spend = 10
		if(EVENT_LEVEL_MAJOR)
			points_to_spend = 14

	if(!points_to_spend)
		return

	threat_level = rand(1,4)
	points_to_spend -= threat_level
	spawn_count = rand(1, min(points_to_spend-1, 9))
	points_to_spend -= spawn_count
	location_amount = points_to_spend

	for(var/i = 1, i <= location_amount, i++)
		if(!(possible_spawns.len))
			break
		var/obj/effect/landmark/wildlife/WL = pick(possible_spawns)
		possible_spawns -= WL
		var/list/spawn_list
		switch(WL.wildlife_type)
			if(1)
				spawn_list = event_wildlife_aquatic
			if(2)
				spawn_list = event_wildlife_roaming
		if(!spawn_list)
			continue

		spawn_list = pick(spawn_list[threat_level])
		var/spawn_type
		var/spawn_pos = get_turf(WL)

		for(var/j = 1, j <= spawn_count, j++)
			spawn_type = pickweight(spawn_list)
			var/mob/living/L = new spawn_type(spawn_pos)
			step_away(L, WL)

/datum/event/roaming_wildlife/announce()
	var/message
	switch(severity)
		if(EVENT_LEVEL_MUNDANE)
			message = "Minor movements of local wildlife have been detected within proximity of the facility."
		if(EVENT_LEVEL_MODERATE)
			message = "Notable amount of local wildlife has been detected entering area surrounding the facility. Take caution."
		if(EVENT_LEVEL_MAJOR)
			message = "A particularly large shift within wildlife movement has been detected. Take caution."
	command_announcement.Announce(message, "Wildlife Monitoring")
