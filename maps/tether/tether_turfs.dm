//Simulated
VIRGO3B_TURF_CREATE(/turf/simulated/open)
/turf/simulated/open/virgo3b
	edge_blending_priority = 0.5 //Turfs which also have e_b_p and higher than this will plop decorative edges onto this turf
/turf/simulated/open/virgo3b/New()
	..()
	outdoor_turfs.Add(src)

VIRGO3B_TURF_CREATE(/turf/simulated/floor)
/turf/simulated/floor/virgo3b/New()
	..()
	outdoor_turfs.Add(src)

/turf/simulated/floor/virgo3b_indoors
	VIRGO3B_SET_ATMOS
/turf/simulated/floor/virgo3b_indoors/update_graphic(list/graphic_add = null, list/graphic_remove = null)
	return 0

VIRGO3B_TURF_CREATE(/turf/simulated/floor/outdoors/dirt)

VIRGO3B_TURF_CREATE(/turf/simulated/floor/outdoors/rocks)

VIRGO3B_TURF_CREATE(/turf/simulated/floor/outdoors/grass/sif)
/turf/simulated/floor/outdoors/grass/sif
	turf_layers = list(
		/turf/simulated/floor/outdoors/rocks/virgo3b,
		/turf/simulated/floor/outdoors/dirt/virgo3b
		)


VIRGO3B_TURF_CREATE(/turf/simulated/floor/reinforced)
/turf/simulated/floor/reinforced/virgo3b/New()
	..()
	outdoor_turfs.Add(src)

VIRGO3B_TURF_CREATE(/turf/simulated/floor/tiled/steel_dirty)
/turf/simulated/floor/tiled/steel_dirty/virgo3b/New()
	..()
	outdoor_turfs.Add(src)

// Overriding these for the sake of submaps that use them on other planets.
// This means that mining on tether base and space is oxygen-generating, but solars and mining should use the virgo3b subtype
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

VIRGO3B_TURF_CREATE(/turf/simulated/mineral)

VIRGO3B_TURF_CREATE(/turf/simulated/shuttle/wall/dark/hard_corner)
/turf/simulated/shuttle/wall/dark/hard_corner/virgo3b/New()
	..()
	outdoor_turfs.Add(src)

VIRGO3B_TURF_CREATE(/turf/simulated/shuttle/floor/black)
/turf/simulated/shuttle/floor/black/virgo3b/New()
	..()
	outdoor_turfs.Add(src)

//Unsimulated
/turf/unsimulated/wall/planetary/virgo3b
	name = "facility wall"
	desc = "An eight-meter tall carbyne wall. For when the wildlife on your planet is mostly militant megacorps."
	alpha = 0xFF
	VIRGO3B_SET_ATMOS

/turf/unsimulated/mineral/virgo3b
	blocks_air = TRUE

/turf/unsimulated/floor/steel
	icon = 'icons/turf/flooring/tiles_vr.dmi'
	icon_state = "steel"


/turf/unsimulated/wall
	blocks_air = 1

/turf/unsimulated/wall/planetary
	blocks_air = 0

// Some turfs to make floors look better in centcom tram station.



/turf/unsimulated/floor/techfloor_grid
	name = "floor"
	icon = 'icons/turf/flooring/techfloor_vr.dmi'
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
	icon_state = "bluespace"
/turf/space/bluespace/New()
	..()
	icon_state = "bluespace"

// Desert jump turf!
/turf/space/sandyscroll
	name = "sand transit"
	icon = 'icons/turf/transit_vr.dmi'
	icon_state = "desert_ns"
/turf/space/sandyscroll/New()
	..()
	icon_state = "desert_ns"

//Sky stuff!
// A simple turf to fake the appearance of flying.
/turf/simulated/sky/virgo3b
	color = "#FFBBBB"

/turf/simulated/sky/virgo3b/initialize()
	outdoor_turfs.Add(src)
	set_light(2, 2, "#FFBBBB")

/turf/simulated/sky/virgo3b/north
	dir = NORTH
/turf/simulated/sky/virgo3b/south
	dir = SOUTH
/turf/simulated/sky/virgo3b/east
	dir = EAST
/turf/simulated/sky/virgo3b/west
	dir = WEST

/turf/simulated/sky/virgo3b/moving
	icon_state = "sky_fast"
/turf/simulated/sky/virgo3b/moving/north
	dir = NORTH
/turf/simulated/sky/virgo3b/moving/south
	dir = SOUTH
/turf/simulated/sky/virgo3b/moving/east
	dir = EAST
/turf/simulated/sky/virgo3b/moving/west
	dir = WEST
