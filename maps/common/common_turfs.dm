//Unsimulated

/turf/unsimulated/mineral/virgo3b
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

VIRGO3B_TURF_CREATE(/turf/simulated/floor/outdoors/dirt)
/turf/simulated/floor/outdoors/dirt/virgo3b
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_state = "asteroid"

VIRGO3B_TURF_CREATE(/turf/simulated/floor/outdoors/grass/sif)
/turf/simulated/floor/outdoors/grass/sif
	turf_layers = list(
		/turf/simulated/floor/outdoors/rocks/virgo3b,
		/turf/simulated/floor/outdoors/dirt/virgo3b
		)

VIRGO3B_TURF_CREATE(/turf/simulated/floor/outdoors/rocks)
VIRGO3B_TURF_CREATE(/turf/simulated/floor/tiled/steel_dirty)
VIRGO3B_TURF_CREATE(/turf/simulated/floor/water/indoors)
VIRGO3B_TURF_CREATE(/turf/simulated/open)
VIRGO3B_TURF_CREATE(/turf/simulated/floor)
VIRGO3B_TURF_CREATE(/turf/simulated/mineral)
VIRGO3B_TURF_CREATE(/turf/simulated/mineral/floor)
VIRGO3B_TURF_CREATE(/turf/simulated/floor/plating/external)
VIRGO3B_TURF_CREATE(/turf/simulated/floor/reinforced)

// Bluespace jump turf!
/turf/space/bluespace
	name = "bluespace"
	icon = 'icons/turf/space_vr.dmi'
	icon_state = "bluespace"

// Desert jump turf!
/turf/space/sandyscroll
	name = "sand transit"
	icon = 'icons/turf/transit_vr.dmi'
	icon_state = "desert_ns"

//Sky stuff!
// A simple turf to fake the appearance of flying.
/turf/simulated/sky/virgo3b
	color = "#FFBBBB"

/turf/simulated/sky/virgo3b/Initialize()
	SSplanets.addTurf(src)
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

/turf/simulated/floor/midpoint_glass
	name = "glass floor"
	desc = "Dont jump on it, or do, I'm not your mom."
	icon = 'icons/turf/flooring/glass.dmi'
	icon_state = "glass-0"
	base_icon_state = "glass"

/turf/simulated/floor/midpoint_glass/reinf
	name = "reinforced glass floor"
	desc = "Do jump on it, it can take it."
	icon = 'icons/turf/flooring/reinf_glass.dmi'
	icon_state = "reinf_glass-0"
	base_icon_state = "reinf_glass"

/turf/simulated/floor/midpoint_glass/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/turf/simulated/floor/midpoint_glass/LateInitialize()
	do_icons()

/turf/simulated/floor/midpoint_glass/proc/do_icons()
	var/new_junction = NONE

	for(var/direction in cardinal) //Cardinal case first.
		var/turf/T = get_step(src, direction)
		if(istype(T, type))
			new_junction |= direction

	if(!(new_junction & (NORTH|SOUTH)) || !(new_junction & (EAST|WEST)))
		icon_state = "[base_icon_state]-[new_junction]"
		return

	if(new_junction & NORTH)
		if(new_junction & WEST)
			var/turf/T = get_step(src, NORTHWEST)
			if(istype(T, type))
				new_junction |= (1<<7)

		if(new_junction & EAST)
			var/turf/T = get_step(src, NORTHEAST)
			if(istype(T, type))
				new_junction |= (1<<4)

	if(new_junction & SOUTH)
		if(new_junction & WEST)
			var/turf/T = get_step(src, SOUTHWEST)
			if(istype(T, type))
				new_junction |= (1<<6)

		if(new_junction & EAST)
			var/turf/T = get_step(src, SOUTHEAST)
			if(istype(T, type))
				new_junction |= (1<<5)

	icon_state = "[base_icon_state]-[new_junction]"

	add_vis_overlay('icons/effects/effects.dmi', "white", plane = SPACE_PLANE, add_vis_flags = VIS_INHERIT_ID|VIS_UNDERLAY)

/turf/space/v3b_midpoint

// Tram transit floor
/turf/simulated/floor/tiled/techfloor/grid/transit
	icon = 'icons/turf/transit_vr.dmi'
	initial_flooring = null

/turf/unsimulated/floor/sky/virgo2_sky
	name = "virgo 2 atmosphere"
	desc = "Be careful where you step!"
	color = "#eacd7c"
	VIRGO2_SET_ATMOS

/turf/simulated/shuttle/wall/voidcraft/green/virgo2
	VIRGO2_SET_ATMOS
	color = "#eacd7c"

/turf/simulated/shuttle/wall/voidcraft/green/virgo2/nocol
	color = null

VIRGO2_TURF_CREATE(/turf/unsimulated/wall/planetary)

VIRGO2_TURF_CREATE(/turf/simulated/wall)
VIRGO2_TURF_CREATE(/turf/simulated/floor/plating)
VIRGO2_TURF_CREATE(/turf/simulated/floor/bluegrid)
VIRGO2_TURF_CREATE(/turf/simulated/floor/tiled/techfloor)

VIRGO2_TURF_CREATE(/turf/simulated/mineral)

VIRGO2_TURF_CREATE(/turf/simulated/mineral/ignore_mapgen)
VIRGO2_TURF_CREATE(/turf/simulated/mineral/floor)
VIRGO2_TURF_CREATE(/turf/simulated/mineral/floor/ignore_mapgen)

VIRGO2_TURF_CREATE(/turf/simulated/floor/hull)

/turf/simulated/mineral/vacuum/gb_mine

/turf/simulated/floor/virgo3b_indoors
	VIRGO3B_SET_ATMOS
/turf/simulated/floor/virgo3b_indoors/update_graphic(list/graphic_add = null, list/graphic_remove = null)
	return 0
