var/list/turf_edge_cache = list()
var/list/outdoor_turfs = list()

/turf/
	// If greater than 0, this turf will apply edge overlays on top of other turfs cardinally adjacent to it, if those adjacent turfs are of a different icon_state,
	// and if those adjacent turfs have a lower edge_blending_priority.
	// TODO: Place on base /turf/ ?
	var/edge_blending_priority = 0
	var/outdoors = FALSE

/turf/simulated/floor/outdoors
	name = "dirt"
	desc = "Quite dirty."
	icon = 'icons/turf/outdoors.dmi'
	icon_state = "dirt-dark"
	edge_blending_priority = 1
	outdoors = TRUE
	var/demote_turf = /turf/simulated/floor/outdoors			// If something destructive happens, the turf gets replaced by this one.

/turf/simulated/floor/outdoors/initialize()
	update_icon()
	..()

/turf/simulated/floor/New()
	if(outdoors)
		outdoor_turfs.Add(src)
	//set_light(2, 0.06, "#FFFFFF")
	..()

/turf/simulated/floor/Destroy()
	if(outdoors)
		outdoor_turfs.Remove(src)
	..()

/turf/simulated/floor/outdoors/ex_act(severity)
	switch(severity)
		if(2)
			if(prob(33))
				return
		if(3)
			if(prob(66))
				return
	if(demote_turf && src.type != demote_turf)
		ChangeTurf(demote_turf)
	else
		ChangeTurf(get_base_turf_by_area(src))