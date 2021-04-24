//Simulated
AMITA_TURF_CREATE(/turf/simulated/open)
/turf/simulated/open/amita
	edge_blending_priority = 0.5 //Turfs which also have e_b_p and higher than this will plop decorative edges onto this turf

/turf/simulated/open/amita/New()
	..()
	if(outdoors)
		SSplanets.addTurf(src)

AMITA_TURF_CREATE(/turf/simulated/floor)

/turf/simulated/floor/amita_indoors
	AMITA_SET_ATMOS
/turf/simulated/floor/amita_indoors/update_graphic(list/graphic_add = null, list/graphic_remove = null)
	return 0

AMITA_TURF_CREATE(/turf/simulated/floor/reinforced)

AMITA_TURF_CREATE(/turf/simulated/floor/tiled/steel_dirty)

AMITA_TURF_CREATE(/turf/simulated/floor/outdoors/dirt)
/turf/simulated/floor/outdoors/dirt/amita
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_state = "asteroid"

AMITA_TURF_CREATE(/turf/simulated/floor/outdoors/rocks)

AMITA_TURF_CREATE(/turf/simulated/floor/outdoors/grass/sif)

/turf/simulated/floor/outdoors/grass/amita
	name = "thick growth"
	icon = 'icons/turf/floors_vr.dmi'
	icon_state = "grass_amita"
	initial_flooring = /decl/flooring/grass/amita
	edge_blending_priority = 5
	tree_chance = 10
	grass_chance = 1

	grass_types = list(
		/obj/structure/flora/tree/jungle_small = 1,
		/obj/structure/flora/smallbould = 5,
		/obj/structure/flora/bboulder1 = 1,
		/obj/structure/flora/sif/tendrils = 30
		)

/turf/simulated/floor/outdoors/grass/amita/lighter
	name = "thick growth"
	icon = 'icons/turf/floors_vr.dmi'
	icon_state = "grass_amita_light1"

/turf/simulated/floor/outdoors/grass/amita/lighter/New()
	..()
	icon_state = "grass_amita_light[rand(1,5)]"

/turf/simulated/floor/tiled/concrete
	name = "conrete floor"
	icon = 'icons/turf/floors_vr.dmi'
	icon_state = "concrete_1pane"

/turf/simulated/floor/tiled/concrete/fourpane
	name = "conrete floor"
	icon = 'icons/turf/floors_vr.dmi'
	icon_state = "concrete_4pane"

/turf/simulated/outdoors/grass/amita
	name = "grass"
	icon = 'icons/turf/floors_vr.dmi'
	icon_state = "concrete_4pane"

//Sky stuff!
// A simple turf to fake the appearance of flying.
/turf/simulated/sky/amita
	color = "#bbffdf"

/turf/simulated/sky/amita/Initialize()
	SSplanets.addTurf(src)
	set_light(2, 2, "#bbffdf")

/turf/simulated/sky/amita/north
	dir = NORTH
/turf/simulated/sky/amita/south
	dir = SOUTH
/turf/simulated/sky/amita/east
	dir = EAST
/turf/simulated/sky/amita/west
	dir = WEST

/turf/simulated/sky/amita/moving
	icon_state = "sky_fast"
/turf/simulated/sky/amita/moving/north
	dir = NORTH
/turf/simulated/sky/amita/moving/south
	dir = SOUTH
/turf/simulated/sky/amita/moving/east
	dir = EAST
/turf/simulated/sky/amita/moving/west
	dir = WEST