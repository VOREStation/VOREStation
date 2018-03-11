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

/turf/simulated/flesh/New()
	..()
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