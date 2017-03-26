/turf/simulated/floor/diona
	name = "biomass flooring"
	icon_state = "diona"

/turf/simulated/floor/diona/attackby()
	return

/turf/simulated/shuttle
	name = "shuttle"
	icon = 'icons/turf/shuttle.dmi'
	thermal_conductivity = 0.05
	heat_capacity = 0
	layer = 2

/turf/simulated/shuttle/wall
	name = "wall"
	icon_state = "wall1"
	opacity = 1
	density = 1
	blocks_air = 1

/turf/simulated/shuttle/wall/voidcraft
	name = "voidcraft wall"
	icon = 'icons/turf/voidcraft_walls.dmi'
	icon_state = "voidcraft_wall_alone"
	var/stripe_color = null // If set, generates a colored stripe overlay.  Accepts #XXXXXX as input.

/turf/simulated/shuttle/wall/voidcraft/red
	stripe_color = "#FF0000"

/turf/simulated/shuttle/wall/voidcraft/blue
	stripe_color = "#0000FF"

/turf/simulated/shuttle/wall/voidcraft/green
	stripe_color = "#00FF00"

/turf/simulated/shuttle/wall/voidcraft/New()
	..()
	update_icon()

/turf/simulated/shuttle/wall/voidcraft/update_icon()
	var/list/icon_states = icon_states(src.icon)
	if(("[icon_state]_stripe" in icon_states) && stripe_color)
		overlays.Cut()
		var/image/I = image(icon = src.icon, dir = src.dir, icon_state = "[icon_state]_stripe")
		if(stripe_color)
			I.color = stripe_color
		overlays.Add(I)

/turf/simulated/shuttle/floor
	name = "floor"
	icon_state = "floor"

/turf/simulated/shuttle/plating
	name = "plating"
	icon = 'icons/turf/floors.dmi'
	icon_state = "plating"

/turf/simulated/shuttle/plating/skipjack //Skipjack plating
	oxygen = 0
	nitrogen = MOLES_N2STANDARD + MOLES_O2STANDARD

/turf/simulated/shuttle/floor4 // Added this floor tile so that I have a seperate turf to check in the shuttle -- Polymorph
	name = "Brig floor"        // Also added it into the 2x3 brig area of the shuttle.
	icon_state = "floor4"

/turf/simulated/shuttle/floor4/skipjack //skipjack floors
	name = "skipjack floor"
	oxygen = 0
	nitrogen = MOLES_N2STANDARD + MOLES_O2STANDARD

/turf/simulated/shuttle/floor/voidcraft
	name = "voidcraft tiles"
	icon_state = "voidcraft_floor"

/turf/simulated/shuttle/floor/voidcraft/dark
	name = "voidcraft tiles"
	icon_state = "voidcraft_floor_dark"

/turf/simulated/shuttle/floor/voidcraft/light
	name = "voidcraft tiles"
	icon_state = "voidcraft_floor_light"

