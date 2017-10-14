// Create lighting overlays on all turfs with dynamic lighting in areas with dynamic lighting.
/proc/create_all_lighting_overlays()
	for(var/area/A in world)
		if(!A.dynamic_lighting)
			continue
		for(var/turf/T in A)
			if(!T.dynamic_lighting)
				continue
			new /atom/movable/lighting_overlay(T, TRUE)
			CHECK_TICK
		CHECK_TICK

/proc/create_lighting_overlays_zlevel(var/zlevel)
	ASSERT(zlevel)

	for(var/turf/T in block(locate(1, 1, zlevel), locate(world.maxx, world.maxy, zlevel)))
		if(!T.dynamic_lighting)
			continue

		var/area/A = T.loc
		if(!A.dynamic_lighting)
			continue

		new /atom/movable/lighting_overlay(T, TRUE)