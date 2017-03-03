var/list/turf_edge_cache = list()
var/list/outdoor_turfs = list()

/turf/
	// If greater than 0, this turf will apply edge overlays on top of other turfs cardinally adjacent to it, if those adjacent turfs are of a different icon_state,
	// and if those adjacent turfs have a lower edge_blending_priority.
	var/edge_blending_priority = 0
	// Outdoors var determines if the game should consider the turf to be 'outdoors', which controls certain things such as weather effects.
	var/outdoors = FALSE
	// This holds the image for the current weather effect.
	var/image/weather_overlay = null

/turf/simulated/floor/outdoors
	name = "generic ground"
	desc = "Rather boring."
	icon = 'icons/turf/outdoors.dmi'
	icon_state = null
	edge_blending_priority = 1
	outdoors = TRUE					// This variable is used for weather effects.
	// When a turf gets demoted or promoted, this list gets adjusted.  The top-most layer is the layer on the bottom of the list, due to how pop() works.
	var/list/turf_layers = list(/turf/simulated/floor/outdoors/rocks)

/turf/simulated/floor/outdoors/initialize()
	update_icon()
	..()

/turf/simulated/floor/New()
	if(outdoors)
		outdoor_turfs.Add(src)
	..()

/turf/simulated/floor/Destroy()
	if(outdoors)
		outdoor_turfs.Remove(src)
	..()

/turf/simulated/floor/proc/update_icon_edge()
	if(edge_blending_priority)
		for(var/checkdir in cardinal)
			var/turf/simulated/T = get_step(src, checkdir)
			if(istype(T) && T.edge_blending_priority && edge_blending_priority < T.edge_blending_priority && icon_state != T.icon_state)
				var/cache_key = "[T.get_edge_icon_state()]-[checkdir]"
				if(!turf_edge_cache[cache_key])
					turf_edge_cache[cache_key] = image(icon = 'icons/turf/outdoors_edge.dmi', icon_state = "[T.get_edge_icon_state()]-edge", dir = checkdir)
				overlays += turf_edge_cache[cache_key]

/turf/simulated/proc/get_edge_icon_state()
	return icon_state

/turf/simulated/floor/outdoors/update_icon()
	overlays.Cut()
	update_icon_edge()
	..()

/turf/simulated/floor/outdoors/mud
	name = "grass"
	icon_state = "mud_dark"
	edge_blending_priority = 2

/turf/simulated/floor/outdoors/rocks
	name = "rocks"
	desc = "Hard as a rock."
	icon_state = "rock"
	edge_blending_priority = 1


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
		if(2)
			if(prob(33))
				return
		if(3)
			if(prob(66))
				return
	demote()