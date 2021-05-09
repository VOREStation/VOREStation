var/list/turf_edge_cache = list()

/turf/
	// If greater than 0, this turf will apply edge overlays on top of other turfs cardinally adjacent to it, if those adjacent turfs are of a different icon_state,
	// and if those adjacent turfs have a lower edge_blending_priority.
	var/edge_blending_priority = 0
	// Outdoors var determines if the game should consider the turf to be 'outdoors', which controls certain things such as weather effects.
	var/outdoors = FALSE

/turf/simulated/floor/outdoors
	name = "generic ground"
	desc = "Rather boring."
	icon = 'icons/turf/outdoors.dmi'
	icon_state = null
	edge_blending_priority = 1
	outdoors = TRUE					// This variable is used for weather effects.
	can_dirty = FALSE				// Looks hideous with dirt on it.
	can_build_into_floor = TRUE

	// When a turf gets demoted or promoted, this list gets adjusted.  The top-most layer is the layer on the bottom of the list, due to how pop() works.
	var/list/turf_layers = list(/turf/simulated/floor/outdoors/rocks)

/turf/simulated/floor/Initialize(mapload)
	if(outdoors)
		SSplanets.addTurf(src)
	. = ..()

/turf/simulated/floor/Destroy()
	if(outdoors)
		SSplanets.removeTurf(src)
	return ..()

/turf/simulated/proc/make_outdoors()
	if(outdoors)
		return
	outdoors = TRUE
	SSplanets.addTurf(src)

/turf/simulated/proc/make_indoors()
	if(!outdoors)
		return
	outdoors = FALSE
	SSplanets.removeTurf(src)

/turf/simulated/post_change()
	..()
	// If it was outdoors and still is, it will not get added twice when the planet controller gets around to putting it in.
	if(outdoors)
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
	outdoors = FALSE

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
