/decl/flooring/grass/sif // Subtype for Sif's grass.
	desc = "A natural moss that has adapted to the sheer cold climate."
	icon_base = "grass"
	build_type = /obj/item/stack/tile/grass

var/list/tree_types = list()
var/list/animal_types = list()

/turf/simulated/floor/outdoors/grass/sif
	name = "growth"
	icon_state = "grass0"
	initial_flooring = /decl/flooring/grass/sif
	grass_chance = 20
	tree_chance = 0
	var/tree_chance_better = 1

	var/tree_types = list(
		/obj/structure/flora/tree/jungle_small = 5,
		/obj/structure/flora/tree/jungle = 2
		)

	var/animal_chance = 0.25

	var/list/animal_types = list(
		/mob/living/simple_mob/vore/rabbit/v3b = 15,
		/mob/living/simple_mob/vore/redpanda/v3b = 15,
		/mob/living/simple_mob/vore/redpanda/fae/v3b = 1,
		/mob/living/simple_mob/vore/fennec/v3b = 15,
		/mob/living/simple_mob/animal/passive/cow/v3b = 5,
		/mob/living/simple_mob/animal/passive/chicken/v3b = 5,
		/mob/living/simple_mob/vore/horse/v3b = 10,
		/mob/living/simple_mob/vore/hippo/v3b = 5,
		/mob/living/simple_mob/animal/passive/snake/v3b = 5,
		/mob/living/simple_mob/vore/bee/v3b = 10,
		/mob/living/simple_mob/animal/passive/gaslamp/gay = 5
		)
	grass_types = list(
		/obj/structure/flora/ausbushes = 5,
		/obj/structure/flora/ausbushes/reedbush = 1,
		/obj/structure/flora/ausbushes/leafybush = 1,
		/obj/structure/flora/ausbushes/palebush = 1,
		/obj/structure/flora/ausbushes/stalkybush = 1,
		/obj/structure/flora/ausbushes/grassybush = 1,
		/obj/structure/flora/ausbushes/fernybush = 1,
		/obj/structure/flora/ausbushes/sunnybush = 1,
		/obj/structure/flora/ausbushes/genericbush = 1,
		/obj/structure/flora/ausbushes/pointybush = 1,
		/obj/structure/flora/ausbushes/lavendergrass = 1,
		/obj/structure/flora/ausbushes/ywflowers = 5,
		/obj/structure/flora/ausbushes/brflowers = 5,
		/obj/structure/flora/ausbushes/ppflowers = 5,
		/obj/structure/flora/ausbushes/sparsegrass = 1,
		/obj/structure/flora/ausbushes/fullgrass = 3
		)

	catalogue_data = list(/datum/category_item/catalogue/flora/sif_grass)
	catalogue_delay = 2 SECONDS

/turf/simulated/floor/outdoors/grass/sif/Initialize()
	if(animal_chance && prob(animal_chance) && !check_density())
		var/animal_type = pickweight(animal_types)
		new animal_type(src)
	if(tree_chance_better && prob(tree_chance_better) && !check_density())
		var/tree_type = pickweight(tree_types)
		new tree_type(src)
	. = ..()

//Simulated
VIRGO3BB_TURF_CREATE(/turf/simulated/open)
/turf/simulated/open/virgo3b_better
	edge_blending_priority = 0.5 //Turfs which also have e_b_p and higher than this will plop decorative edges onto this turf
/turf/simulated/open/virgo3b_better/New()
	..()
	if(outdoors)
		SSplanets.addTurf(src)

VIRGO3BB_TURF_CREATE(/turf/simulated/floor)

/turf/simulated/floor/virgo3b_better_indoors
	VIRGO3B_SET_ATMOS
/turf/simulated/floor/virgo3b_better_indoors/update_graphic(list/graphic_add = null, list/graphic_remove = null)
	return 0

VIRGO3BB_TURF_CREATE(/turf/simulated/floor/reinforced)

VIRGO3BB_TURF_CREATE(/turf/simulated/floor/tiled/steel_dirty)

VIRGO3BB_TURF_CREATE(/turf/simulated/floor/outdoors/dirt)
/turf/simulated/floor/outdoors/dirt/virgo3b_better
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_state = "asteroid"

VIRGO3BB_TURF_CREATE(/turf/simulated/floor/outdoors/rocks)

VIRGO3BB_TURF_CREATE(/turf/simulated/floor/outdoors/grass/sif)
/turf/simulated/floor/outdoors/grass/sif
	turf_layers = list(
		/turf/simulated/floor/outdoors/rocks/virgo3b_better,
		/turf/simulated/floor/outdoors/dirt/virgo3b_better
		)

// Overriding these for the sake of submaps that use them on other planets.
// This means that mining on tether base and space is oxygen-generating, but solars and mining should use the virgo3b_better subtype
/turf/simulated/mineral
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD
	temperature	= T20C
/turf/simulated/floor/outdoors
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD
	temperature	= T20C
/turf/simulated/floor/water
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD
	temperature	= T20C

/turf/simulated/mineral/vacuum
	oxygen = 0
	nitrogen = 0
	temperature	= TCMB
/turf/simulated/mineral/floor/vacuum
	oxygen = 0
	nitrogen = 0
	temperature	= TCMB

VIRGO3BB_TURF_CREATE(/turf/simulated/mineral)
VIRGO3BB_TURF_CREATE(/turf/simulated/mineral/floor)
	//This proc is responsible for ore generation on surface turfs
/turf/simulated/mineral/virgo3b_better/make_ore(var/rare_ore)
	if(mineral || ignore_mapgen)
		return
	var/mineral_name
	if(rare_ore)
		mineral_name = pickweight(list(
			"marble" = 3,
			"uranium" = 10,
			"platinum" = 10,
			"hematite" = 20,
			"copper" = 8,
			"tin" = 4,
			"bauxite" = 4,
			"rutile" = 4,
			"carbon" = 20,
			"diamond" = 1,
			"gold" = 8,
			"silver" = 8,
			"phoron" = 18,
			"lead" = 2,
			"verdantium" = 1))
	else
		mineral_name = pickweight(list(
			"marble" = 2,
			"uranium" = 5,
			"platinum" = 5,
			"hematite" = 35,
			"copper" = 15,
			"tin" = 10,
			"bauxite" = 10,
			"rutile" = 10,
			"carbon" = 35,
			"gold" = 3,
			"silver" = 3,
			"phoron" = 25,
			"lead" = 1))
	if(mineral_name && (mineral_name in ore_data))
		mineral = ore_data[mineral_name]
		UpdateMineral()
	update_icon()

/turf/simulated/mineral/virgo3b_better/rich/make_ore(var/rare_ore)
	if(mineral || ignore_mapgen)
		return
	var/mineral_name
	if(rare_ore)
		mineral_name = pickweight(list(
			"marble" = 7,
			"uranium" = 10,
			"platinum" = 10,
			"hematite" = 10,
			"carbon" = 10,
			"diamond" = 4,
			"gold" = 15,
			"silver" = 15,
			"lead" = 5,
			"verdantium" = 2))
	else
		mineral_name = pickweight(list(
			"marble" = 5,
			"uranium" = 7,
			"platinum" = 7,
			"hematite" = 28,
			"carbon" = 28,
			"diamond" = 2,
			"gold" = 7,
			"silver" = 7,
			"lead" = 4,
			"verdantium" = 1))
	if(mineral_name && (mineral_name in ore_data))
		mineral = ore_data[mineral_name]
		UpdateMineral()
	update_icon()

//Unsimulated
/turf/unsimulated/mineral/virgo3b_better
	blocks_air = TRUE

/turf/unsimulated/floor/steel
	icon = 'icons/turf/flooring/tiles_vr.dmi'
	icon_state = "steel"

// Some turfs to make floors look better in centcom tram station.

/turf/unsimulated/floor/techfloor_grid
	name = "floor"
	icon = 'icons/turf/flooring/techfloor.dmi'
	icon_state = "techfloor_grid"

/turf/unsimulated/floor/maglev
	name = "maglev track"
	desc = "Magnetic levitation tram tracks. Caution! Electrified!"
	icon = 'icons/turf/flooring/maglevs.dmi'
	icon_state = "maglevup"

/turf/unsimulated/wall/transit
	icon = 'icons/turf/transit_vr.dmi'

/turf/unsimulated/floor/transit
	icon = 'icons/turf/transit_vr.dmi'

/obj/effect/floor_decal/transit/orange
	icon = 'icons/turf/transit_vr.dmi'
	icon_state = "transit_techfloororange_edges"

/obj/effect/transit/light
	icon = 'icons/turf/transit_128.dmi'
	icon_state = "tube1-2"

// Bluespace jump turf!
/turf/space/bluespace
	name = "bluespace"
	icon = 'icons/turf/space_vr.dmi'
	icon_state = "bluespace"
/turf/space/bluespace/Initialize()
	..()
	icon = 'icons/turf/space_vr.dmi'
	icon_state = "bluespace"

// Desert jump turf!
/turf/space/sandyscroll
	name = "sand transit"
	icon = 'icons/turf/transit_vr.dmi'
	icon_state = "desert_ns"
/turf/space/sandyscroll/Initialize()
	..()
	icon_state = "desert_ns"

//Sky stuff!
// A simple turf to fake the appearance of flying.
/turf/simulated/sky/virgo3b_better
	color = "#88FFFF"

/turf/simulated/sky/virgo3b_better/Initialize()
	SSplanets.addTurf(src)
	set_light(2, 2, "#88FFFF")

/turf/simulated/sky/virgo3b_better/north
	dir = NORTH
/turf/simulated/sky/virgo3b_better/south
	dir = SOUTH
/turf/simulated/sky/virgo3b_better/east
	dir = EAST
/turf/simulated/sky/virgo3b_better/west
	dir = WEST

/turf/simulated/sky/virgo3b_better/moving
	icon_state = "sky_fast"
/turf/simulated/sky/virgo3b_better/moving/north
	dir = NORTH
/turf/simulated/sky/virgo3b_better/moving/south
	dir = SOUTH
/turf/simulated/sky/virgo3b_better/moving/east
	dir = EAST
/turf/simulated/sky/virgo3b_better/moving/west
	dir = WEST
