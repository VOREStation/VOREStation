<<<<<<< HEAD
var/list/flooring_types

/proc/populate_flooring_types()
	flooring_types = list()
	for (var/flooring_path in typesof(/decl/flooring))
		flooring_types["[flooring_path]"] = new flooring_path

/proc/get_flooring_data(var/flooring_path)
	if(!flooring_types)
		flooring_types = list()
	if(!flooring_types["[flooring_path]"])
		flooring_types["[flooring_path]"] = new flooring_path
	return flooring_types["[flooring_path]"]

=======
>>>>>>> 8edc31867e3... Merge pull request #8989 from MistakeNot4892/flooring
// State values:
// [icon_base]: initial base icon_state without edges or corners.
// if has_base_range is set, append 0-has_base_range ie.
//   [icon_base][has_base_range]
// [icon_base]_broken: damaged overlay.
// if has_damage_range is set, append 0-damage_range for state ie.
//   [icon_base]_broken[has_damage_range]
// [icon_base]_edges: directional overlays for edges.
// [icon_base]_corners: directional overlays for non-edge corners.

/decl/flooring
	var/name = "floor"
	var/desc
	var/icon
	var/icon_base // initial base icon_state without edges or corners.

	var/has_base_range // This will pick between a range of 0 - x. Number icon_states accordingly.
					   // Note that this will append a 0 - x number automatically to icon_base, but NOT the dmi. Do icon_base = "grass", but name grass0 inside the dmi. etc etc.
	var/has_damage_range
	var/has_burn_range
	var/damage_temperature
	var/apply_thermal_conductivity
	var/apply_heat_capacity

	var/build_type      // Unbuildable if not set. Must be /obj/item/stack.
	var/build_cost = 1  // Stack units.
	var/build_time = 0  // BYOND ticks.

	var/descriptor = "tiles"
	var/flags
	var/can_paint
	var/can_engrave = FALSE
	var/list/footstep_sounds = list() // key=species name, value = list of sounds,
									  // For instance, footstep_sounds = list("key" = list(sound.ogg))
	var/is_plating = FALSE
	var/list/flooring_cache = list() // Cached overlays for our edges and corners and junk

	//Plating types, can be overridden
	var/plating_type = null

	//Resistance is subtracted from all incoming damage
	//var/resistance = RESISTANCE_FRAGILE

	//Damage the floor can take before being destroyed
	//var/health = 50

	//var/removal_time = WORKTIME_FAST * 0.75

	//Flooring Icon vars
	var/smooth_nothing = FALSE //True/false only, optimisation
	//If true, all smoothing logic is entirely skipped

	//The rest of these x_smooth vars use one of the following options
	//SMOOTH_NONE: Ignore all of type
	//SMOOTH_ALL: Smooth with all of type
	//SMOOTH_WHITELIST: Ignore all except types on this list
	//SMOOTH_BLACKLIST: Smooth with all except types on this list
	//SMOOTH_GREYLIST: Objects only: Use both lists

	//How we smooth with other flooring
	var/floor_smooth = SMOOTH_NONE
	var/list/flooring_whitelist = list() //Smooth with nothing except the contents of this list
	var/list/flooring_blacklist = list() //Smooth with everything except the contents of this list

	//How we smooth with walls
	var/wall_smooth = SMOOTH_NONE
	//There are no lists for walls at this time

	//How we smooth with space and openspace tiles
	var/space_smooth = SMOOTH_NONE
	//There are no lists for spaces

	/*
	How we smooth with movable atoms
	These are checked after the above turf based smoothing has been handled
	SMOOTH_ALL or SMOOTH_NONE are treated the same here. Both of those will just ignore atoms
	Using the white/blacklists will override what the turfs concluded, to force or deny smoothing

	Movable atom lists are much more complex, to account for many possibilities
	Each entry in a list, is itself a list consisting of three items:
		Type: The typepath to allow/deny. This will be checked against istype, so all subtypes are included
		Priority: Used when items in two opposite lists conflict. The one with the highest priority wins out.
		Vars: An associative list of variables (varnames in text) and desired values
			Code will look for the desired vars on the target item and only call it a match if all desired values match
			This can be used, for example, to check that objects are dense and anchored
			there are no safety checks on this, it will probably throw runtimes if you make typos

	Common example:
	Don't smooth with dense anchored objects except airlocks

	smooth_movable_atom = SMOOTH_GREYLIST
	movable_atom_blacklist = list(
		list(/obj, list("density" = TRUE, "anchored" = TRUE), 1)
		)
	movable_atom_whitelist = list(
	list(/obj/machinery/door/airlock, list(), 2)
	)

	*/
	var/smooth_movable_atom = SMOOTH_NONE
	var/list/movable_atom_whitelist = list()
	var/list/movable_atom_blacklist = list()

	var/check_season = FALSE	//VOREStation Addition

/decl/flooring/proc/get_plating_type(var/turf/T)
	return plating_type

/decl/flooring/proc/get_flooring_overlay(var/cache_key, var/icon_base, var/icon_dir = 0, var/layer = BUILTIN_DECAL_LAYER)
	if(!flooring_cache[cache_key])
		var/image/I = image(icon = icon, icon_state = icon_base, dir = icon_dir)
		I.layer = layer
		flooring_cache[cache_key] = I
	return flooring_cache[cache_key]

/decl/flooring/grass
	name = "grass"
	desc = "Do they smoke grass out in space, Bowie? Or do they smoke AstroTurf?"
	icon = 'icons/turf/flooring/grass.dmi'
	icon_base = "grass"
	has_base_range = 1
	damage_temperature = T0C+80
	flags = TURF_HAS_EDGES | TURF_HAS_CORNERS | TURF_REMOVE_SHOVEL
	build_type = /obj/item/stack/tile/grass
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/grass1.ogg',
		'sound/effects/footstep/grass2.ogg',
		'sound/effects/footstep/grass3.ogg',
		'sound/effects/footstep/grass4.ogg'))

/decl/flooring/grass/sif // Subtype for Sif's grass.
	name = "growth"
	desc = "A natural moss that has adapted to the sheer cold climate."
	flags = 0
	icon = 'icons/turf/outdoors.dmi'
	icon_base = "grass_sif"
	build_type = null
	has_base_range = 1

/decl/flooring/grass/sif/forest
	name = "thick growth"
	desc = "A natural moss that has adapted to the sheer cold climate."
	flags = 0
	icon = 'icons/turf/outdoors.dmi'
	icon_base = "grass_sif_dark"
	has_base_range = 1

/decl/flooring/water
	name = "water"
	desc = "Water is wet, gosh, who knew!"
	icon = 'icons/turf/outdoors.dmi'
	icon_base = "seashallow"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/water1.ogg',
		'sound/effects/footstep/water2.ogg',
		'sound/effects/footstep/water3.ogg',
		'sound/effects/footstep/water4.ogg'))

/decl/flooring/sand
	name = "sand"
	desc = "I don't like sand. It's coarse and rough and irritating and it gets everywhere."
	icon = 'icons/misc/beach.dmi'
	icon_base = "sand"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/HeavySand1.ogg',
		'sound/effects/footstep/HeavySand2.ogg',
		'sound/effects/footstep/HeavySand3.ogg',
		'sound/effects/footstep/HeavySand4.ogg'))

/decl/flooring/sand/desert // Subtype of sand, desert.
	name = "desert"
	desc = "I don't like sand. It's coarse and rough and irritating and it gets everywhere."
	icon = 'icons/turf/desert.dmi'
	icon_base = "desert"

/decl/flooring/mud
	name = "mud"
	desc = "STICKY AND WET!"
	icon = 'icons/turf/outdoors.dmi'
	icon_base = "mud_dark"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/mud1.ogg',
		'sound/effects/footstep/mud2.ogg',
		'sound/effects/footstep/mud3.ogg',
		'sound/effects/footstep/mud4.ogg'))

/decl/flooring/asteroid
	name = "coarse sand"
	desc = "Gritty and unpleasant."
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_base = "asteroid"
	flags = TURF_REMOVE_SHOVEL | TURF_ACID_IMMUNE
	build_type = null
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/asteroid1.ogg',
		'sound/effects/footstep/asteroid2.ogg',
		'sound/effects/footstep/asteroid3.ogg',
		'sound/effects/footstep/asteroid4.ogg',
		'sound/effects/footstep/asteroid5.ogg'))

/decl/flooring/dirt
	name = "dirt"
	desc = "Gritty and unpleasant, just like dirt."
	icon = 'icons/turf/outdoors.dmi'
	icon_base = "dirt-dark"
	flags = TURF_REMOVE_SHOVEL
	build_type = null
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/asteroid1.ogg',
		'sound/effects/footstep/asteroid2.ogg',
		'sound/effects/footstep/asteroid3.ogg',
		'sound/effects/footstep/asteroid4.ogg',
		'sound/effects/footstep/asteroid5.ogg',
		'sound/effects/footstep/MedDirt1.ogg',
		'sound/effects/footstep/MedDirt2.ogg',
		'sound/effects/footstep/MedDirt3.ogg',
		'sound/effects/footstep/MedDirt4.ogg',))

/decl/flooring/snow
	name = "snow"
	desc = "A layer of many tiny bits of frozen water. It's hard to tell how deep it is."
	icon = 'icons/turf/outdoors.dmi'
	icon_base = "snow"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/snow1.ogg',
		'sound/effects/footstep/snow2.ogg',
		'sound/effects/footstep/snow3.ogg',
		'sound/effects/footstep/snow4.ogg',
		'sound/effects/footstep/snow5.ogg'))

/decl/flooring/snow/fake
		desc = "A coating of fake snow, looks surprisingly realistic, though not as cold as the real thing."
		icon = 'icons/turf/flooring/fakesnow.dmi'
		icon_base = "snow"
		flags = TURF_HAS_EDGES | TURF_HAS_CORNERS | TURF_REMOVE_SHOVEL

/decl/flooring/snow/snow2
	name = "snow"
	desc = "A layer of many tiny bits of frozen water. It's hard to tell how deep it is."
	icon = 'icons/turf/snow.dmi'
	icon_base = "snow"
	flags = TURF_HAS_EDGES

/decl/flooring/snow/gravsnow
	name = "snow"
	icon_base = "gravsnow"

/decl/flooring/snow/plating
	name = "snowy plating"
	desc = "Steel plating coated with a light layer of snow."
	icon_base = "snowyplating"
	flags = null

/decl/flooring/snow/ice
	name = "ice"
	desc = "Looks slippery."
	icon_base = "ice"

/decl/flooring/snow/plating/drift
	icon_base = "snowyplayingdrift"

/decl/flooring/carpet
	name = "carpet"
	desc = "Imported and comfy."
	icon = 'icons/turf/flooring/carpet.dmi'
	icon_base = "carpet"
	build_type = /obj/item/stack/tile/carpet
	damage_temperature = T0C+200
	flags = TURF_HAS_EDGES | TURF_HAS_CORNERS | TURF_REMOVE_CROWBAR | TURF_CAN_BURN
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/carpet1.ogg',
		'sound/effects/footstep/carpet2.ogg',
		'sound/effects/footstep/carpet3.ogg',
		'sound/effects/footstep/carpet4.ogg',
		'sound/effects/footstep/carpet5.ogg'))

/decl/flooring/carpet/bcarpet
	name = "black carpet"
	icon_base = "bcarpet"
	build_type = /obj/item/stack/tile/carpet/bcarpet

/decl/flooring/carpet/blucarpet
	name = "blue carpet"
	icon_base = "blucarpet"
	build_type = /obj/item/stack/tile/carpet/blucarpet

/decl/flooring/carpet/turcarpet
	name = "tur carpet"
	icon_base = "turcarpet"
	build_type = /obj/item/stack/tile/carpet/turcarpet

/decl/flooring/carpet/sblucarpet
	name = "silver blue carpet"
	icon_base = "sblucarpet"
	build_type = /obj/item/stack/tile/carpet/sblucarpet

/decl/flooring/carpet/gaycarpet
	name = "clown carpet"
	icon_base = "gaycarpet"
	build_type = /obj/item/stack/tile/carpet/gaycarpet

/decl/flooring/carpet/purcarpet
	name = "purple carpet"
	icon_base = "purcarpet"
	build_type = /obj/item/stack/tile/carpet/purcarpet

/decl/flooring/carpet/oracarpet
	name = "orange carpet"
	icon_base = "oracarpet"
	build_type = /obj/item/stack/tile/carpet/oracarpet

/decl/flooring/carpet/tealcarpet
	name = "teal carpet"
	icon_base = "tealcarpet"
	build_type = /obj/item/stack/tile/carpet/teal

/decl/flooring/carpet/browncarpet
	name = "brown carpet"
	icon_base = "brncarpet"
	build_type = /obj/item/stack/tile/carpet/brncarpet

/decl/flooring/carpet/blucarpet2
	name = "blue carpet"
	icon_base = "blue1"
	build_type = /obj/item/stack/tile/carpet/blucarpet2

/decl/flooring/carpet/greencarpet
	name = "green carpet"
	icon_base = "green"
	build_type = /obj/item/stack/tile/carpet/greencarpet

/decl/flooring/carpet/purplecarpet
	name = "purple carpet"
	icon_base = "purple"
	build_type = /obj/item/stack/tile/carpet/purplecarpet

/decl/flooring/carpet/geo
	name = "geometric carpet"
	icon_base = "geocarpet"
	build_type = /obj/item/stack/tile/carpet/geo
	flags = TURF_REMOVE_CROWBAR | TURF_CAN_BURN

/decl/flooring/carpet/retro
	name = "blue retro carpet"
	icon_base = "retrocarpet"
	build_type = /obj/item/stack/tile/carpet/retro
	flags = TURF_REMOVE_CROWBAR | TURF_CAN_BURN

/decl/flooring/carpet/retro_red
	name = "red retro carpet"
	icon_base = "retrocarpet_red"
	build_type = /obj/item/stack/tile/carpet/retro_red
	flags = TURF_REMOVE_CROWBAR | TURF_CAN_BURN

/decl/flooring/carpet/happy
	name = "happy carpet"
	icon_base = "happycarpet"
	build_type = /obj/item/stack/tile/carpet/happy
	flags = TURF_REMOVE_CROWBAR | TURF_CAN_BURN

/decl/flooring/tiling
	name = "floor"
	desc = "Scuffed from the passage of countless greyshirts."
	icon = 'icons/turf/flooring/tiles_vr.dmi' // VOREStation Edit - Eris floors. Polaris still hasn't added all of them properly. See: steel_ridged
	icon_base = "tiled"
	has_damage_range = 2
	damage_temperature = T0C+1400
	flags = TURF_REMOVE_CROWBAR | TURF_CAN_BREAK | TURF_CAN_BURN
	build_type = /obj/item/stack/tile/floor
	can_paint = 1
	can_engrave = TRUE
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/floor1.ogg',
		'sound/effects/footstep/floor2.ogg',
		'sound/effects/footstep/floor3.ogg',
		'sound/effects/footstep/floor4.ogg',
		'sound/effects/footstep/floor5.ogg'))

/decl/flooring/tiling/tech
	desc = "Scuffed from the passage of countless greyshirts."
	icon = 'icons/turf/flooring/techfloor.dmi'
	icon_base = "techfloor_gray"
	build_type = /obj/item/stack/tile/floor/techgrey
	can_paint = null

/decl/flooring/tiling/tech/grid
	icon_base = "techfloor_grid"
	build_type = /obj/item/stack/tile/floor/techgrid

/decl/flooring/tiling/new_tile
	name = "floor"
	icon_base = "tile_full"
	flags = TURF_CAN_BREAK | TURF_CAN_BURN | TURF_IS_FRAGILE
	build_type = null

/decl/flooring/tiling/new_tile/cargo_one
	icon_base = "cargo_one_full"

/decl/flooring/tiling/new_tile/kafel
	icon_base = "kafel_full"

/decl/flooring/tiling/new_tile/techmaint
	icon_base = "techmaint"
	build_type = /obj/item/stack/tile/floor/techmaint

/decl/flooring/tiling/new_tile/monofloor
	icon_base = "monofloor"

/decl/flooring/tiling/new_tile/monotile
	icon_base = "monotile"

/decl/flooring/tiling/new_tile/steel_grid
	icon_base = "steel_grid"

/decl/flooring/tiling/new_tile/steel_ridged
	icon_base = "steel_ridged"

/decl/flooring/linoleum
	name = "linoleum"
	desc = "It's like the 2090's all over again."		// VOREStation Lore Edit - we're not past 2390's yet
	icon = 'icons/turf/flooring/linoleum.dmi'
	icon_base = "lino"
	can_paint = 1
	build_type = /obj/item/stack/tile/linoleum
	flags = TURF_REMOVE_SCREWDRIVER | TURF_CAN_BREAK | TURF_CAN_BURN

/decl/flooring/tiling/red
	name = "floor"
	icon_base = "white"
	has_damage_range = null
	flags = TURF_REMOVE_CROWBAR
	build_type = /obj/item/stack/tile/floor/red

/decl/flooring/tiling/steel
	name = "floor"
	icon_base = "steel"
	build_type = /obj/item/stack/tile/floor/steel

/decl/flooring/tiling/steel_dirty
	name = "floor"
	icon_base = "steel_dirty"
	build_type = /obj/item/stack/tile/floor/steel_dirty

/decl/flooring/tiling/asteroidfloor
	name = "floor"
	icon_base = "asteroidfloor"
	has_damage_range = null
	build_type = /obj/item/stack/tile/floor/steel

/decl/flooring/tiling/white
	name = "floor"
	desc = "How sterile."
	icon_base = "white"
	build_type = /obj/item/stack/tile/floor/white

/decl/flooring/tiling/yellow
	name = "floor"
	icon_base = "white"
	has_damage_range = null
	build_type = /obj/item/stack/tile/floor/yellow

/decl/flooring/tiling/dark
	name = "floor"
	desc = "How ominous."
	icon_base = "dark"
	has_damage_range = null
	build_type = /obj/item/stack/tile/floor/dark

/decl/flooring/tiling/hydro
	name = "floor"
	icon_base = "hydrofloor"
	build_type = /obj/item/stack/tile/floor/steel

/decl/flooring/tiling/neutral
	name = "floor"
	icon_base = "neutral"
	build_type = /obj/item/stack/tile/floor/steel

/decl/flooring/tiling/freezer
	name = "floor"
	desc = "Don't slip."
	icon_base = "freezer"
	build_type = /obj/item/stack/tile/floor/freezer

/decl/flooring/wmarble
	name = "marble floor"
	desc = "Very regal white marble flooring."
	icon = 'icons/turf/flooring/misc.dmi'
	icon_base = "lightmarble"
	build_type = /obj/item/stack/tile/wmarble
	flags = TURF_REMOVE_CROWBAR

/decl/flooring/bmarble
	name = "marble floor"
	desc = "Very regal black marble flooring."
	icon = 'icons/turf/flooring/misc.dmi'
	icon_base = "darkmarble"
	build_type = /obj/item/stack/tile/bmarble
	flags = TURF_REMOVE_CROWBAR

/decl/flooring/wood
	name = "wooden floor"
	desc = "Polished redwood planks."
	icon = 'icons/turf/flooring/wood_vr.dmi'
	icon_base = "wood"
	has_damage_range = 6
	damage_temperature = T0C+200
	descriptor = "planks"
	build_type = /obj/item/stack/tile/wood
	flags = TURF_CAN_BREAK | TURF_REMOVE_CROWBAR | TURF_REMOVE_SCREWDRIVER
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/wood1.ogg',
		'sound/effects/footstep/wood2.ogg',
		'sound/effects/footstep/wood3.ogg',
		'sound/effects/footstep/wood4.ogg',
		'sound/effects/footstep/wood5.ogg'))

/decl/flooring/wood/sif
	name = "alien wooden floor"
	desc = "Polished alien wood planks."
	icon = 'icons/turf/flooring/wood.dmi'
	icon_base = "sifwood"
	build_type = /obj/item/stack/tile/wood/sif

/decl/flooring/wood/alt
	icon = 'icons/turf/flooring/wood.dmi'
	icon_base = "wood"
	build_type = /obj/item/stack/tile/wood/alt

/decl/flooring/wood/alt/panel
	desc = "Polished wooden panels."
	icon = 'icons/turf/flooring/wood.dmi'
	icon_base = "wood_panel"
	has_damage_range = 2
	build_type = /obj/item/stack/tile/wood/panel

/decl/flooring/wood/alt/parquet
	desc = "Polished wooden tiles."
	icon = 'icons/turf/flooring/wood.dmi'
	icon_base = "wood_parquet"
	build_type = /obj/item/stack/tile/wood/parquet

/decl/flooring/wood/alt/tile
	desc = "Polished wooden tiles."
	icon = 'icons/turf/flooring/wood.dmi'
	icon_base = "wood_tile"
	has_damage_range = 2
	build_type = /obj/item/stack/tile/wood/tile

/decl/flooring/reinforced
	name = "reinforced floor"
	desc = "Heavily reinforced with steel rods."
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_base = "reinforced"
	flags = TURF_REMOVE_WRENCH | TURF_ACID_IMMUNE | TURF_CAN_BURN | TURF_CAN_BREAK
	build_type = /obj/item/stack/rods
	build_cost = 2
	build_time = 30
	apply_thermal_conductivity = 0.025
	apply_heat_capacity = 325000
	can_paint = 1
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/hull1.ogg',
		'sound/effects/footstep/hull2.ogg',
		'sound/effects/footstep/hull3.ogg',
		'sound/effects/footstep/hull4.ogg',
		'sound/effects/footstep/hull5.ogg'))

/decl/flooring/reinforced/circuit
	name = "processing strata"
	icon = 'icons/turf/flooring/circuit.dmi'
	icon_base = "bcircuit"
	build_type = null
	flags = TURF_ACID_IMMUNE | TURF_CAN_BREAK | TURF_CAN_BURN | TURF_REMOVE_CROWBAR
	can_paint = 1

/decl/flooring/reinforced/circuit/green
	name = "processing strata"
	icon_base = "gcircuit"

/decl/flooring/reinforced/cult
	name = "engraved floor"
	desc = "Unsettling whispers waver from the surface..."
	icon = 'icons/turf/flooring/cult.dmi'
	icon_base = "cult"
	build_type = null
	has_damage_range = 6
	flags = TURF_ACID_IMMUNE | TURF_CAN_BREAK
	can_paint = null

/decl/flooring/lava // Defining this in case someone DOES step on lava and survive. Somehow.
	name = "lava"
	desc = "Lava. Y'know. Sets you on fire. AAAAAAAAAAA"
	icon = 'icons/turf/outdoors.dmi'
	icon_base = "lava"
	is_plating = TRUE
	flags = TURF_ACID_IMMUNE
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/lava1.ogg',
		'sound/effects/footstep/lava2.ogg',
		'sound/effects/footstep/lava3.ogg'))

/decl/flooring/concrete
	name = "concrete"
	desc = "A flat area of concrete flooring."
	icon = 'icons/turf/concrete.dmi'
	icon_base = "concrete"
	is_plating = FALSE 	//VOREStation edit. It's a lot cooler if it's actual tile.
	can_paint = 1		//VOREStation edit. Let's allow for some fun.
	can_engrave = 1		//VOREStation edit. Fun.
	flags = TURF_ACID_IMMUNE | TURF_CAN_BREAK | TURF_REMOVE_CROWBAR

///// Season Time! ///// VOREStation Addition Start
/decl/flooring/grass/seasonal_grass
	desc = "It's grass!"
	icon = 'icons/seasonal/turf.dmi'
	check_season = TRUE
	has_base_range = 11

/decl/flooring/grass/seasonal_grass/dark
	name = "grass"
	icon_base = "darkgrass"
