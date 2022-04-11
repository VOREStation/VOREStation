/datum/event/wallrot
	var/turf/simulated/wall/center

/datum/event/wallrot/setup()
	announceWhen = rand(0, 300)
	endWhen = announceWhen + 1

	// 100 attempts
	for(var/i=0, i<100, i++)
		var/z_level = pick(using_map.station_levels)
		var/turf/candidate = locate(rand(1, world.maxx), rand(1, world.maxy), z_level)
		if(istype(candidate, /turf/simulated/wall))
			center = candidate
			var/area/A = get_area(candidate)
			if(!A.forbid_events)
				return 1
	return 0

/datum/event/wallrot/announce()
	if(center)
		command_announcement.Announce("Harmful fungi detected on \the [station_name()] and [using_map.facility_type] structures nearby [center.loc.name] may be contaminated.", "Biohazard Alert")

/datum/event/wallrot/start()
	spawn()
		if(center)
			// Make sure at least one piece of wall rots!
			center.rot()

			// Have a chance to rot lots of other walls.
			var/rotcount = 0
			var/actual_severity = severity * rand(5, 10)
			for(var/turf/simulated/wall/W in range(5, center)) if(prob(50))
				W.rot()
				rotcount++

				// Only rot up to severity walls
				if(rotcount >= actual_severity)
					break