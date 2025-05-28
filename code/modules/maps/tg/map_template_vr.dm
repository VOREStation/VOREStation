/// An asslist of name=z for map_templates that have been loaded
GLOBAL_LIST_EMPTY(map_templates_loaded)

/// Registers the map into GLOB.map_templates_loaded
/datum/map_template/proc/on_map_preload(z)
	if(name_alias)
		GLOB.map_templates_loaded[name_alias] = z
	else
		GLOB.map_templates_loaded[name] = z

/datum/map_template/proc/on_map_loaded(z)
	//We missed air init!
	if(SSair.subsystem_initialized)
		for(var/turf/simulated/T in block(locate(1,1,z), locate(world.maxx, world.maxy, z)))
			T.update_air_properties()
	//We missed sslighting init!
	if(SSlighting.subsystem_initialized)
		for(var/Trf in block(locate(1,1,z), locate(world.maxx, world.maxy, z)))
			var/turf/T = Trf //faster than implicit istype with typed for loop
			T.lighting_build_overlay()

	return
