/datum/element/turf_z_transparency
	var/show_bottom_level = FALSE

///This proc sets up the signals to handle updating viscontents when turfs above/below update. Handle plane and layer here too so that they don't cover other obs/turfs in Dream Maker
/datum/element/turf_z_transparency/Attach(datum/target, show_bottom_level = TRUE)
	. = ..()
	if(!isturf(target))
		return ELEMENT_INCOMPATIBLE

	var/turf/our_turf = target

	src.show_bottom_level = show_bottom_level

	our_turf.plane = OPENSPACE_PLANE
	our_turf.layer = OPENSPACE_LAYER

	RegisterSignal(target, COMSIG_TURF_MULTIZ_DEL, PROC_REF(on_multiz_turf_del), override = TRUE)
	RegisterSignal(target, COMSIG_TURF_MULTIZ_NEW, PROC_REF(on_multiz_turf_new), override = TRUE)

	update_multiz(our_turf, TRUE, TRUE)

/datum/element/turf_z_transparency/Detach(datum/source)
	. = ..()
	var/turf/our_turf = source
	our_turf.vis_contents.len = 0
	UnregisterSignal(our_turf, COMSIG_TURF_MULTIZ_DEL)
	UnregisterSignal(our_turf, COMSIG_TURF_MULTIZ_NEW)

///Updates the viscontents or underlays below this tile.
/datum/element/turf_z_transparency/proc/update_multiz(turf/our_turf, prune_on_fail = FALSE, init = FALSE)
	var/turf/below_turf = GetBelow(our_turf)
	if(!below_turf)
		our_turf.vis_contents.len = 0
		if(!show_bottom_level(our_turf) && prune_on_fail) //If we cant show whats below, and we prune on fail, change the turf to plating as a fallback
			our_turf.ChangeTurf(/turf/simulated/floor/plating)
			return FALSE
		else
			return TRUE
	if(init)
		below_turf?.update_icon() // So the 'ceiling-less' overlay gets added.
		our_turf.vis_contents += below_turf

	if(is_blocked_turf(our_turf)) //Show girders below closed turfs
		var/mutable_appearance/girder_underlay = mutable_appearance('icons/obj/structures.dmi', "girder", layer = TURF_LAYER-0.01)
		girder_underlay.appearance_flags = RESET_ALPHA | RESET_COLOR
		our_turf.underlays += girder_underlay
		var/mutable_appearance/plating_underlay = mutable_appearance('icons/turf/floors.dmi', "plating", layer = TURF_LAYER-0.02)
		plating_underlay = RESET_ALPHA | RESET_COLOR
		our_turf.underlays += plating_underlay
	return TRUE

/datum/element/turf_z_transparency/proc/on_multiz_turf_del(turf/our_turf, turf/below_turf, dir)
	SIGNAL_HANDLER

	if(dir != DOWN)
		return

	update_multiz(our_turf)

/datum/element/turf_z_transparency/proc/on_multiz_turf_new(turf/our_turf, turf/below_turf, dir)
	SIGNAL_HANDLER

	if(dir != DOWN)
		return

	update_multiz(our_turf)

///Called when there is no real turf below this turf
/datum/element/turf_z_transparency/proc/show_bottom_level(turf/our_turf)
	if(!show_bottom_level)
		return FALSE
	var/turf/path = get_base_turf_by_area(our_turf) || /turf/space
	if(!ispath(path))
		path = text2path(path)
		if(!ispath(path))
			warning("Z-level [our_turf] has invalid baseturf '[get_base_turf_by_area(our_turf)]' in area '[get_area(our_turf)]'")
			path = /turf/space

	var/do_plane = ispath(path, /turf/space) ? SPACE_PLANE : null
	var/do_state = ispath(path, /turf/space) ? "white" : initial(path.icon_state)

	var/mutable_appearance/underlay_appearance = mutable_appearance(initial(path.icon), do_state, layer = TURF_LAYER-0.02, plane = do_plane)
	underlay_appearance.appearance_flags = RESET_ALPHA | RESET_COLOR
	our_turf.underlays += underlay_appearance

	return TRUE
