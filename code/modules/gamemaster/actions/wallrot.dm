/datum/gm_action/wallrot
	name = "wall rot"
	departments = list(DEPARTMENT_ENGINEERING)
	reusable = TRUE
	var/turf/simulated/wall/center
	severity = 1

/datum/gm_action/wallrot/set_up()
	severity = rand(1,3)
	center = null
	// 100 attempts
	for(var/i=0, i<100, i++)
		var/turf/candidate = locate(rand(1, world.maxx), rand(1, world.maxy), 1)
		if(istype(candidate, /turf/simulated/wall))
			center = candidate
			return 1
	return 0

/datum/gm_action/wallrot/announce()
	if(center && prob(min(90,40 * severity)))
		command_announcement.Announce("Harmful fungi detected on \the [station_name()] nearby [center.loc.name]. Station structures may be contaminated.", "Biohazard Alert")

/datum/gm_action/wallrot/start()
	..()
	spawn()
		if(center)
			// Make sure at least one piece of wall rots!
			center.rot()

			// Have a chance to rot lots of other walls.
			var/rotcount = 0
			var/actual_severity = severity * rand(5, 10)
			for(var/turf/simulated/wall/W in range(5, center))
				if(prob(50))
					W.rot()
					rotcount++

					// Only rot up to severity walls
					if(rotcount >= actual_severity)
						break

/datum/gm_action/wallrot/get_weight()
	return 60 + (metric.count_people_in_department(DEPARTMENT_ENGINEERING) * 35)
