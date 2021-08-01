var/list/turf_edge_cache = list()

/turf
	// If greater than 0, this turf will apply edge overlays on top of other turfs cardinally adjacent to it, if those adjacent turfs are of a different icon_state,
	// and if those adjacent turfs have a lower edge_blending_priority.
	var/edge_blending_priority = 0
	// Outdoors var determines if the game should consider the turf to be 'outdoors', which controls certain things such as weather effects.
	var/outdoors = OUTDOORS_AREA

/area
	// If a turf's `outdoors` variable is set to `OUTDOORS_AREA`, 
	// it will decide if it's outdoors or not when being initialized based on this var.
	var/outdoors = OUTDOORS_NO

/turf/simulated/floor/outdoors
	name = "generic ground"
	desc = "Rather boring."
	icon = 'icons/turf/outdoors.dmi'
	icon_state = null
	edge_blending_priority = 1
	outdoors = OUTDOORS_YES			// This variable is used for weather effects.
	can_dirty = FALSE				// Looks hideous with dirt on it.
	can_build_into_floor = TRUE

	// When a turf gets demoted or promoted, this list gets adjusted.  The top-most layer is the layer on the bottom of the list, due to how pop() works.
	var/list/turf_layers = list(/turf/simulated/floor/outdoors/rocks)

/turf/simulated/floor/Initialize(mapload)
	if(is_outdoors())
		SSplanets.addTurf(src)
	. = ..()

/turf/simulated/floor/Destroy()
	if(is_outdoors())
		SSplanets.removeTurf(src)
	return ..()

// Turfs can decide if they should be indoors or outdoors.
// By default they choose based on their area's setting.
// This helps cut down on ten billion `/outdoors` subtypes being needed.
/turf/proc/is_outdoors()
	return FALSE

/turf/simulated/is_outdoors()
	switch(outdoors)
		if(OUTDOORS_YES)
			return TRUE
		if(OUTDOORS_NO)
			return FALSE
		if(OUTDOORS_AREA)
			var/area/A = loc
			if(A.outdoors == OUTDOORS_YES)
				return TRUE
	return FALSE

/// Makes the turf explicitly outdoors.
/turf/simulated/proc/make_outdoors()
	if(is_outdoors()) // Already outdoors.
		return
	outdoors = OUTDOORS_YES
	SSplanets.addTurf(src)

/// Makes the turf explicitly indoors.
/turf/simulated/proc/make_indoors()
	if(!is_outdoors()) // Already indoors.
		return
	outdoors = OUTDOORS_NO
	SSplanets.removeTurf(src)

/turf/simulated/post_change()
	..()
	// If it was outdoors and still is, it will not get added twice when the planet controller gets around to putting it in.
	if(is_outdoors())
		make_outdoors()
	else
		make_indoors()

/turf/simulated/floor/outdoors/mud
	name = "mud"
	icon_state = "mud_dark"
	edge_blending_priority = 3
	initial_flooring = /decl/flooring/mud

/turf/simulated/floor/outdoors/rocks
	name = "rocks"
	desc = "Hard as a rock."
	icon_state = "rock"
	edge_blending_priority = 1

/turf/simulated/floor/outdoors/rocks/caves
	outdoors = OUTDOORS_NO

// This proc adds a 'layer' on top of the turf.
/turf/simulated/floor/outdoors/proc/promote(var/new_turf_type)
	var/list/new_turf_layer_list = turf_layers.Copy()
	var/list/coords = list(x, y, z)

	new_turf_layer_list.Add(src.type)

	ChangeTurf(new_turf_type)
	var/turf/simulated/floor/outdoors/T = locate(coords[1], coords[2], coords[3])
	if(istype(T))
		T.turf_layers = new_turf_layer_list.Copy()

// This proc removes the topmost layer.
/turf/simulated/floor/outdoors/proc/demote()
	if(!turf_layers.len)
		return // Cannot demote further.
	var/list/new_turf_layer_list = turf_layers.Copy()
	var/list/coords = list(x, y, z)

	ChangeTurf(pop(new_turf_layer_list))
	var/turf/simulated/floor/outdoors/T = locate(coords[1], coords[2], coords[3])
	if(istype(T))
		T.turf_layers = new_turf_layer_list.Copy()

// Called by weather processes, and maybe technomancers in the future.
/turf/simulated/floor/proc/chill()
	return

/turf/simulated/floor/outdoors/chill()
	promote(/turf/simulated/floor/outdoors/snow)

/turf/simulated/floor/outdoors/snow/chill()
	return // Todo: Add heavy snow.

/turf/simulated/floor/outdoors/ex_act(severity)
	switch(severity)
		//VOREStation Edit - Outdoor turfs less explosion resistant
		if(1)
			if(prob(66))
				ChangeTurf(get_base_turf_by_area(src))
				return
			demote()
		if(2)
			if(prob(33))
				return
			else if(prob(33))
				demote()
		//VOREStation Edit End
		if(3)
			if(prob(66))
				return
	demote()
