/datum/map_template/proc/on_map_loaded(z)
	for(var/Trf in block(locate(1,1,z), locate(world.maxx, world.maxy, z)))
		var/turf/T = Trf //faster than implicit istype with typed for loop
		T.lighting_build_overlay()
	return