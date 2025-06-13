/datum/event/roaming_wildlife
	announceWhen = 10

	var/threat_level
	var/spawn_count
	var/location_amount

/datum/event/roaming_wildlife/start()
	var/list/possible_spawns = list()
	for(var/obj/effect/landmark/C in landmarks_list)
		if(istype(C, /obj/effect/landmark/wildlife))
			var/obj/effect/landmark/wildlife/WLLM = C
			if(GLOB.world_time_season == "winter" && WLLM.wildlife_type == 1)		//fish forbidden in winter because ice now aparently
				continue
			possible_spawns.Add(C)

	if(!(possible_spawns.len))
		return

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
	var/gamount_message
	var/amount_message
	var/threat_message

	switch(threat_level)
		if(1)
			threat_message = "completely harmless"
		if(2)
			threat_message = "docile but easily agitated"
		if(3)
			threat_message = "hostile"
		if(4)
			threat_message = "highly hostile and dangerous"
	switch(spawn_count)
		if(1)
			amount_message = "singular straggler[location_amount == 1 ? "" : "s"]"
		if(2 to 4)
			amount_message = "small grouping[location_amount == 1 ? "" : "s"]"
		if(5 to 8)
			amount_message = "moderate pack[location_amount == 1 ? "" : "s"]"
		else
			amount_message = "large swarm[location_amount == 1 ? "" : "s"]"
	switch(location_amount)
		if(1)
			gamount_message = "a single"
		if(2 to 4)
			gamount_message = "a few"
		if(5 to 9)
			gamount_message = "several"
		else
			gamount_message = "numerous"

	var/message = "Movements of [gamount_message] group[location_amount == 1 ? "" : "s"] of wildlife have been detected in regions surrounding [using_map.full_name]. The wildlife group[location_amount == 1 ? "" : "s"] [location_amount == 1 ? "is" : "are"] [threat_message] and \
				[location_amount == 1 ? "is" : "are"] comprised of [amount_message].[threat_level > 2 ? " Take caution." : ""]"

	command_announcement.Announce(message, "Wildlife Monitoring")
