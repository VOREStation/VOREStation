/datum/event2/meta/wallrot
	name = "wall-rot"
	departments = list(DEPARTMENT_ENGINEERING)
	reusable = TRUE
	event_type = /datum/event2/event/wallrot

/datum/event2/meta/wallrot/get_weight()
	return (10 + metric.count_people_in_department(DEPARTMENT_ENGINEERING) * 10) / (times_ran + 1)




/datum/event2/event/wallrot
	var/turf/simulated/wall/origin = null

/datum/event2/event/wallrot/set_up()
	for(var/i = 1 to 100)
		var/turf/candidate = locate(rand(1, world.maxx), rand(1, world.maxy), pick(get_location_z_levels()) )
		if(istype(candidate, /turf/simulated/wall))
			origin = candidate
			log_debug("Wall-rot event has chosen \the [origin] ([origin.loc]) as the origin for the wallrot infestation.")
			return

	log_debug("Wall-rot event failed to find a valid wall after one hundred tries. Aborting.")
	abort()

/datum/event2/event/wallrot/announce()
	if(origin && prob(80))
		command_announcement.Announce("Harmful fungi detected on \the [location_name()], near \the [origin.loc]. \
		Station structural integrity may be compromised.", "Biohazard Alert")

/datum/event2/event/wallrot/start()
	if(origin)
		origin.rot()

		var/rot_count = 0
		var/target_rot = rand(5, 20)
		for(var/turf/simulated/wall/W in range(7, origin))
			if(prob(50))
				if(W.rot())
					rot_count++
			if(rot_count >= target_rot)
				break
