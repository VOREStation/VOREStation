/datum/event/gravity
	announceWhen = 5
	var/list/zLevels

/datum/event/gravity/setup()
	endWhen = rand(15, 60)
	// Setup which levels we will disrupt gravit on.
	zLevels = using_map.station_levels.Copy()
	if (planet_controller)
		for(var/datum/planet/P in planet_controller.planets)
			zLevels -= P.expected_z_levels

/datum/event/gravity/announce()
	command_announcement.Announce("Feedback surge detected in mass-distributions systems. Artificial gravity has been disabled whilst the system \
	reinitializes. Please stand by while the gravity system reinitializes.", "Gravity Failure")

/datum/event/gravity/start()
	gravity_is_on = 0
	for(var/area/A in world)
		if(A.z in zLevels)
			A.gravitychange(gravity_is_on, A)

/datum/event/gravity/end()
	if(!gravity_is_on)
		gravity_is_on = 1

		for(var/area/A in world)
			if(A.z in zLevels)
				A.gravitychange(gravity_is_on, A)

		command_announcement.Announce("Gravity generators are again functioning within normal parameters. Sorry for any inconvenience.", "Gravity Restored")
