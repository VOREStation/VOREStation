/datum/turf_initializer/proc/InitializeTurf(var/turf/T)
	return

/area
	var/datum/turf_initializer/turf_initializer = null

/area/LateInitialize()
	. = ..()
	if(turf_initializer)
		for(var/turf/simulated/T in src)
			turf_initializer.InitializeTurf(T)
