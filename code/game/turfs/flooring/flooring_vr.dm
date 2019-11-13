/turf/simulated/floor/flesh
	name = "flesh"
	desc = "This slick flesh ripples and squishes under your touch"
	icon = 'icons/turf/stomach_vr.dmi'
	icon_state = "flesh_floor"
	initial_flooring = /decl/flooring/flesh

/turf/simulated/floor/flesh/colour
	icon_state = "c_flesh_floor"
	initial_flooring = /decl/flooring/flesh

/turf/simulated/floor/flesh/attackby()
	return

/decl/flooring/flesh
	name = "flesh"
	desc = "This slick flesh ripples and squishes under your touch"
	icon = 'icons/turf/stomach_vr.dmi'
	icon_base = "flesh_floor"

/turf/simulated/floor/airless/derelict 
	name = "derelict tiles" 
	oxygen = 0 
	nitrogen = 0 
	temperature = TCMB 
 
/turf/simulated/floor/airless/derelict/techfloor 
	name = "abandoned techfloor" 
	desc = "Abandoned, without even dust in the void of space, for untold ages." 
	icon = 'icons/turf/flooring/techfloor_vr.dmi' 
	icon_state = "techfloor_gray" 
	initial_flooring = /decl/flooring/airless 
 
/decl/flooring/airless/tech 
	desc = "Abandoned, without even dust in the void of space, for untold ages." 
	icon = 'icons/turf/flooring/techfloor_vr.dmi' 
	icon_base = "techfloor_gray" 
	build_type = null 
	can_paint = null 
 
