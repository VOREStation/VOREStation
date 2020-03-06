/turf/simulated/shuttle/floor/alienplating/blue
	icon = 'icons/turf/shuttle_alien_blue.dmi'
	icon_state = "alienplating"

/turf/simulated/shuttle/floor/alienplating/blue/half
	icon_state = "alienplatinghalf"

/turf/simulated/shuttle/floor/alien/blue
	icon = 'icons/turf/shuttle_alien_blue.dmi'
	icon_state = "alienpod1"
	light_range = 4
	light_power = 0.8
	light_color = "#66ffff" // Bright cyan.

/turf/simulated/floor/flesh
	name = "flesh"
	desc = "This slick flesh ripples and squishes under your touch"
	icon_state = "flesh-floor"
	icon = 'icons/turf/stomach_vr.dmi'

/turf/simulated/floor/flesh/colour
	name = "flesh"
	desc = "This slick flesh ripples and squishes under your touch"
	icon_state = "colorable-floor"
	icon = 'icons/turf/stomach_vr.dmi'

/turf/simulated/floor/flesh/attackby()
	return

/turf/simulated/floor/flesh/ex_act(severity)
	return

/turf/simulated/floor/flock
	icon = 'icons/goonstation/featherzone.dmi'
	icon_state = "floor"

/turf/simulated/floor/flock/Crossed(var/atom/movable/AM)
	. = ..()
	if(isliving(AM))
		icon_state = "floor-on"
		set_light(3,3,"#26c5a9")
		spawn(5 SECONDS)
			icon_state = "floor"
			set_light(0,0,"#ffffff")