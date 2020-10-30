/datum/map_template/proc/on_map_loaded(z)
	//We missed air init!
	if(SSair.subsystem_initialized)
		for(var/turf/simulated/T in block(locate(1,1,z), locate(world.maxx, world.maxy, z)))
			T.update_air_properties()
	//We missed sslighting init!
	if(lighting_overlays_initialised)
		for(var/Trf in block(locate(1,1,z), locate(world.maxx, world.maxy, z)))
			var/turf/T = Trf //faster than implicit istype with typed for loop
			T.lighting_build_overlay()

	return