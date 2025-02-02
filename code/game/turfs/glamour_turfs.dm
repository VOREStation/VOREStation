/turf/unsimulated/wall/glamour
	name = "glamour"
	desc = "A blindingly white light that appears to cast your reflection."
	icon = 'icons/turf/flooring/glamour.dmi'
	icon_state = "glamour"

/turf/simulated/floor/glamour
	name = "glamour"
	desc = "A blindingly white light that appears to cast your reflection."
	icon = 'icons/turf/flooring/glamour.dmi'
	icon_state = "glamour"
	light_range = 7
	light_power = 1
	light_color = "#ffffff"
	light_on = TRUE

/turf/simulated/floor/wood/glamour
	name = "wooden floor"
	icon = 'icons/turf/flooring/glamour.dmi'
	icon_state = "wood"
	initial_flooring = /decl/flooring/wood/glamour

/decl/flooring/wood/glamour
	name = "wooden glamour"
	desc = "Polished glamourwood planks."
	icon = 'icons/turf/flooring/glamour.dmi'
	icon_base = "wood"
	descriptor = "planks"
	build_type = null
	flags = TURF_CAN_BREAK

/turf/simulated/wall/glamourbrick
	icon_state = "glamourbrick"
	icon = 'icons/turf/flooring/glamour.dmi'

/turf/simulated/wall/glamourbrick/Initialize(mapload)
		. = ..(mapload, MAT_GLAMOUR)

/turf/simulated/mineral/glamour
	icon = 'icons/turf/flooring/glamour.dmi'
	sand_icon_path = 'icons/turf/flooring/glamour.dmi'
	rock_icon_path = 'icons/turf/flooring/glamour.dmi'
	icon_state = "rock-light"
	rock_side_icon_state = "rock_side-light"
	sand_icon_state = "glamour"
	rock_icon_state = "rock-light"
	random_icon = 1
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD
	temperature	= T20C
