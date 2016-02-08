/datum/turf_initializer/proc/initialize(var/turf/T)
	return

/area
	var/datum/turf_initializer/turf_initializer = null

/area/initialize()
	..()
	var/list/minerals = list()
	for(var/turf/simulated/T in src)
		if(T.initialize())
			minerals += T
		if(turf_initializer)
			turf_initializer.initialize(T)
	for(var/turf/simulated/mineral/M in minerals)
		M.MineralSpread()
