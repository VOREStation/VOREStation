// Internal bapi-dmm helpers
/datum/bapi_parsed_map/proc/_bapi_add_warning(warning)
	loaded_warnings += list(warning)

/datum/bapi_parsed_map/proc/_bapi_expand_map(x, y, z, new_z, z_offset)
	if(x > world.maxx)
		expanded_x = TRUE
		world.maxx = x
		// if(new_z)
		// 	world.increase_max_x(x, map_load_z_cutoff = z_offset - 1)
		// else
		// 	world.increase_max_x(x)
	if(y > world.maxy)
		expanded_y = TRUE
		world.maxy = y
		// if(new_z)
		// 	world.increase_max_y(y, map_load_z_cutoff = z_offset - 1)
		// else
		// 	world.increase_max_y(y)
	if(z > world.maxz)
		while(world.maxz < z)
			world.increment_max_z()

/proc/_bapi_helper_get_world_bounds()
	. = list(world.maxx, world.maxy, world.maxz)

/proc/_bapi_helper_text2path(text)
	. = text2path(text)

/proc/_bapi_helper_text2file(text)
	. = file(text)

/proc/_bapi_create_atom(path, crds)
	set waitfor = FALSE
	. = new path (crds)

/proc/_bapi_setup_preloader(list/attributes, path)
	world.preloader_setup(attributes, path)

/proc/_bapi_apply_preloader(atom/A)
	if(GLOB.use_preloader)
		world.preloader_load(A)

/proc/_bapi_new_atom(text_path, turf/crds, list/attributes)
	var/path = text2path(text_path)
	if(!path)
		CRASH("Bad atom path [text_path]")

	if(attributes != null)
		world.preloader_setup(attributes, path)

	var/atom/instance = _bapi_create_atom(path, crds) // first preloader pass

	if(GLOB.use_preloader && instance) // second preloader pass for atoms that don't ..() in New()
		world.preloader_load(instance)

/proc/_bapi_create_or_get_area(text_path)
	var/path = text2path(text_path)
	if(!path)
		CRASH("Bad area path [text_path]")

	var/area/area_instance = GLOB.areas_by_type[path]
	if(!area_instance)
		area_instance = new path(null)
		if(!area_instance)
			CRASH("[path] failed to be new'd, what'd you do?")

	return area_instance

/proc/_bapi_handle_area_contain(turf/T, area/A)
	// var/area/old_area = T.loc
	// if(old_area == A)
	// 	return // no changing areas that already contain this turf, it'll confuse them
	// LISTASSERTLEN(old_area.turfs_to_uncontain_by_zlevel, T.z, list())
	// LISTASSERTLEN(A.turfs_by_zlevel, T.z, list())
	// old_area.turfs_to_uncontain_by_zlevel[T.z] += T
	// A.turfs_by_zlevel[T.z] += T

/proc/_bapi_create_turf(turf/crds, text_path, list/attributes, place_on_top, no_changeturf)
	var/path = text2path(text_path)
	if(!path)
		CRASH("Bad turf path [text_path]")

	if(attributes != null)
		world.preloader_setup(attributes, path)

	var/atom/instance
	if(no_changeturf)
		instance = _bapi_create_atom(path, crds)
	else
		instance = crds.ChangeTurf(path, FALSE, TRUE)

	if(GLOB.use_preloader && instance) // second preloader pass for atoms that don't ..() in New()
		world.preloader_load(instance)

/proc/_bapi_add_turf_to_area(area/A, turf/T)
	if(!A || !T)
		return
	A.contents.Add(T)

/proc/_bapi_helper_get_world_type_turf()
	return "[world.turf]"

/proc/_bapi_helper_get_world_type_area()
	return "[world.area]"

/// Implement this to have bapi-dmm sleep occasionally
/// by returning true
/proc/_bapi_helper_tick_check()
	return TICK_CHECK
