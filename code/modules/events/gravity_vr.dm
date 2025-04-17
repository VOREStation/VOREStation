/datum/event/gravity
	announceWhen = 5
	var/list/zLevels
	var/list/generators = list()

/datum/event/gravity/setup()
	endWhen = rand(5 MINUTES, 20 MINUTES)
	// Setup which levels we will disrupt gravit on.
	zLevels = using_map.station_levels.Copy()
	for(var/datum/planet/P in SSplanets.planets)
		zLevels -= P.expected_z_levels

/datum/event/gravity/announce()
	command_announcement.Announce("Feedback surge detected in mass-distributions systems. Artificial gravity has been disabled. Please wait for the system to reinitialize, or contact your engineering department.", "Gravity Failure")

/datum/event/gravity/start()
	GLOB.gravity_is_on = FALSE

	for(var/obj/machinery/gravity_generator/main/GG in GLOB.machines)
		if((GG.z in zLevels) && GG.on)
			generators += GG
			GG.breaker = FALSE
			GG.set_power()
			GG.charge_count = 10

/datum/event/gravity/end()
	GLOB.gravity_is_on = TRUE

	var/did_anything = FALSE
	for(var/obj/machinery/gravity_generator/main/GG in generators)
		if(!GG.on)
			GG.breaker = TRUE
			GG.set_power()
			GG.charge_count = 90
			did_anything = TRUE

	if(did_anything)
		command_announcement.Announce("Gravity generators are again functioning within normal parameters. Sorry for any inconvenience.", "Gravity Restored")
