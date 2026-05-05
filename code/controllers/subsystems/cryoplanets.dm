SUBSYSTEM_DEF(cryoplanets)
	name = "Cryogenic Planets"
	wait =  10 SECOND
	runlevels = RUNLEVEL_GAME
	dependencies = list(
		/datum/controller/subsystem/planets,
		/datum/controller/subsystem/air
	)
	var/list/cryoplanets = list()
	var/list/current_run = list()

/datum/controller/subsystem/cryoplanets/Initialize()
	for(var/datum/planet/check in SSplanets.planets)
		if(!isnull(check.cryogenic_temp_goal))
			return SS_INIT_SUCCESS
	return SS_INIT_NO_NEED // No cryoplanets to deal with!

/datum/controller/subsystem/cryoplanets/fire(resumed)
	if(!resumed)
		for(var/datum/planet/check in SSplanets.planets)
			if(isnull(check.cryogenic_temp_goal))
				continue
			current_run += check

	while(length(current_run))
		var/datum/planet/check = current_run[current_run.len]
		current_run.len--
		// Drag the temp of the world toward the cryogenic_temp_goal
		if(MC_TICK_CHECK)
			return
