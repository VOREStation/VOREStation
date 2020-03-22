/turf/simulated/shuttle/wall/alien/blue
	name = "hybrid wall"
	desc = "Seems slightly more friendly than if the wall were ominous purple."
	icon = 'icons/turf/shuttle_alien_blue.dmi'
	light_color = "#1fdbf4" // Cyan-ish

/turf/simulated/shuttle/wall/alien/blue/hard_corner
	name = "hybrid wall"
	icon_state = "alien-hc"
	hard_corner = 1

/turf/simulated/shuttle/wall/alien/blue/no_join
	name = "hybrid wall"
	icon_state = "alien-nj"
	join_group = null

/turf/simulated/flesh
	name = "flesh wall"
	desc = "The fleshy surface of this wall squishes nicely under your touch but looks and feels extremly strong"
	icon = 'icons/turf/stomach_vr.dmi'
	icon_state = "flesh"
	opacity = 1
	density = 1
	blocks_air = 1

/turf/simulated/flesh/colour
	name = "flesh wall"
	desc = "The fleshy surface of this wall squishes nicely under your touch but looks and feels extremly strong"
	icon = 'icons/turf/stomach_vr.dmi'
	icon_state = "colorable-wall"
	opacity = 1
	density = 1
	blocks_air = 1

/turf/simulated/flesh/attackby()
	return

/turf/simulated/flesh/Initialize(mapload)
	. = ..()
	update_icon(1)

var/list/flesh_overlay_cache = list()

/turf/simulated/flesh/update_icon(var/update_neighbors)
	cut_overlays()

	if(density)
		icon = 'icons/turf/stomach_vr.dmi'
		icon_state = "flesh"
		for(var/direction in cardinal)
			var/turf/T = get_step(src,direction)
			if(istype(T) && !T.density)
				var/place_dir = turn(direction, 180)
				if(!flesh_overlay_cache["flesh_side_[place_dir]"])
					flesh_overlay_cache["flesh_side_[place_dir]"] = image('icons/turf/stomach_vr.dmi', "flesh_side", dir = place_dir)
				add_overlay(flesh_overlay_cache["flesh_side_[place_dir]"])

	if(update_neighbors)
		for(var/direction in alldirs)
			if(istype(get_step(src, direction), /turf/simulated/flesh))
				var/turf/simulated/flesh/F = get_step(src, direction)
				F.update_icon()

/turf/simulated/shuttle/wall/flock
	icon = 'icons/goonstation/featherzone.dmi'
	icon_state = "flockwall0"
	base_state = "flockwall"
	hard_corner = 1 //They're all HC
	true_name = "wall"

/turf/simulated/shuttle/wall/flock/Initialize()
	. = ..()
	set_light(3,3,"#26c5a9")
