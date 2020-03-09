/datum/gm_action/gravity
	name = "gravity failure"
	departments = list(DEPARTMENT_EVERYONE)
	length = 600
	var/list/zLevels

/datum/gm_action/gravity/set_up()
	length = rand(length, length * 5)
	// Setup which levels we will disrupt gravit on.
	zLevels = using_map.station_levels.Copy()
	for(var/datum/planet/P in SSplanets.planets)
		zLevels -= P.expected_z_levels

/datum/gm_action/gravity/announce()
	command_announcement.Announce("Feedback surge detected in mass-distributions systems. Artificial gravity has been disabled whilst the system \
	reinitializes. Please stand by while the gravity system reinitializes.", "Gravity Failure")

/datum/gm_action/gravity/start()
	..()
	gravity_is_on = 0
	for(var/area/A in all_areas)
		if(A.z in zLevels)
			A.gravitychange(gravity_is_on, A)

/datum/gm_action/gravity/end()
	if(!gravity_is_on)
		gravity_is_on = 1

		for(var/area/A in all_areas)
			if(A.z in zLevels)
				A.gravitychange(gravity_is_on, A)

		command_announcement.Announce("Gravity generators are again functioning within normal parameters. Sorry for any inconvenience.", "Gravity Restored")

/datum/gm_action/gravity/get_weight()
	return 30 + (metric.count_people_in_department(DEPARTMENT_EVERYONE) * 20)
