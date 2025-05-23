
////////////////////////////
/// ERIS FLOOR DECLS ///////
////////////////////////////

/decl/flooring/tiling/eris
	name = "floor"
	desc = "Scuffed from the passage of countless greyshirts."
	icon = 'icons/turf/flooring/eris/tiles.dmi'
	icon_base = "tiles"
	has_damage_range = 2
	damage_temperature = T0C+1400
	flags = TURF_HAS_EDGES | TURF_HAS_CORNERS | TURF_REMOVE_CROWBAR | TURF_CAN_BREAK
	build_type = /obj/item/stack/tile/floor/eris
	can_paint = 1

	plating_type = /decl/flooring/eris_plating/under

	floor_smooth = SMOOTH_WHITELIST
	flooring_whitelist = list(
		/decl/flooring/eris_plating/under
	)

	smooth_movable_atom = SMOOTH_GREYLIST
	movable_atom_whitelist = list(
		list(/obj/machinery/door/airlock, list(), 1) // Smooth Eris floors with airlocks
	)
	movable_atom_blacklist = list(
		list(/obj/machinery/door/airlock/maintenance, list(), 2), // But not maintenance airlocks
		list(/obj/structure/window, list("anchored" = TRUE, "fulltile" = TRUE), 2) // Don't blend under full windows
	)

/decl/flooring/tiling/eris/steel
	name = "steel floor"
	icon_base = "tiles"
	icon = 'icons/turf/flooring/eris/tiles_steel.dmi'
	build_type = /obj/item/stack/tile/floor/eris/steel

/decl/flooring/tiling/eris/steel/panels
	icon_base = "panels"
	build_type = /obj/item/stack/tile/floor/eris/steel/panels

/decl/flooring/tiling/eris/steel/techfloor
	icon_base = "techfloor"
	build_type = /obj/item/stack/tile/floor/eris/steel/techfloor

/decl/flooring/tiling/eris/steel/techfloor_grid
	icon_base = "techfloor_grid"
	build_type = /obj/item/stack/tile/floor/eris/steel/techfloor_grid

/decl/flooring/tiling/eris/steel/brown_perforated
	icon_base = "brown_perforated"
	build_type = /obj/item/stack/tile/floor/eris/steel/brown_perforated

/decl/flooring/tiling/eris/steel/gray_perforated
	icon_base = "gray_perforated"
	build_type = /obj/item/stack/tile/floor/eris/steel/gray_perforated

/decl/flooring/tiling/eris/steel/cargo
	icon_base = "cargo"
	build_type = /obj/item/stack/tile/floor/eris/steel/cargo

/decl/flooring/tiling/eris/steel/brown_platform
	icon_base = "brown_platform"
	build_type = /obj/item/stack/tile/floor/eris/steel/brown_platform

/decl/flooring/tiling/eris/steel/gray_platform
	icon_base = "gray_platform"
	build_type = /obj/item/stack/tile/floor/eris/steel/gray_platform

/decl/flooring/tiling/eris/steel/danger
	icon_base = "danger"
	build_type = /obj/item/stack/tile/floor/eris/steel/danger

/decl/flooring/tiling/eris/steel/golden
	icon_base = "golden"
	build_type = /obj/item/stack/tile/floor/eris/steel/golden

/decl/flooring/tiling/eris/steel/bluecorner
	icon_base = "bluecorner"
	build_type = /obj/item/stack/tile/floor/eris/steel/bluecorner

/decl/flooring/tiling/eris/steel/orangecorner
	icon_base = "orangecorner"
	build_type = /obj/item/stack/tile/floor/eris/steel/orangecorner

/decl/flooring/tiling/eris/steel/cyancorner
	icon_base = "cyancorner"
	build_type = /obj/item/stack/tile/floor/eris/steel/cyancorner

/decl/flooring/tiling/eris/steel/violetcorener
	icon_base = "violetcorener"
	build_type = /obj/item/stack/tile/floor/eris/steel/violetcorener

/decl/flooring/tiling/eris/steel/monofloor
	icon_base = "monofloor"
	build_type = /obj/item/stack/tile/floor/eris/steel/monofloor
	has_base_range = 15

/decl/flooring/tiling/eris/steel/bar_flat
	name = "flat bar floor"
	icon_base = "bar_flat"
	build_type = /obj/item/stack/tile/floor/eris/steel/bar_flat
	floor_smooth = SMOOTH_NONE
	smooth_movable_atom = SMOOTH_NONE

/decl/flooring/tiling/eris/steel/bar_dance
	name = "dancefloor"
	icon_base = "bar_dance"
	build_type = /obj/item/stack/tile/floor/eris/steel/bar_dance
	floor_smooth = SMOOTH_NONE
	smooth_movable_atom = SMOOTH_NONE

/decl/flooring/tiling/eris/steel/bar_light
	name = "lit bar floor"
	icon_base = "bar_light"
	build_type = /obj/item/stack/tile/floor/eris/steel/bar_light
	floor_smooth = SMOOTH_NONE
	smooth_movable_atom = SMOOTH_NONE

/decl/flooring/tiling/eris/white
	name = "white floor"
	icon_base = "tiles"
	icon = 'icons/turf/flooring/eris/tiles_white.dmi'
	build_type = /obj/item/stack/tile/floor/eris/white

/decl/flooring/tiling/eris/white/panels
	icon_base = "panels"
	build_type = /obj/item/stack/tile/floor/eris/white/panels

/decl/flooring/tiling/eris/white/techfloor
	icon_base = "techfloor"
	build_type = /obj/item/stack/tile/floor/eris/white/techfloor

/decl/flooring/tiling/eris/white/techfloor_grid
	icon_base = "techfloor_grid"
	build_type = /obj/item/stack/tile/floor/eris/white/techfloor_grid

/decl/flooring/tiling/eris/white/brown_perforated
	icon_base = "brown_perforated"
	build_type = /obj/item/stack/tile/floor/eris/white/brown_perforated

/decl/flooring/tiling/eris/white/gray_perforated
	icon_base = "gray_perforated"
	build_type = /obj/item/stack/tile/floor/eris/white/gray_perforated

/decl/flooring/tiling/eris/white/cargo
	icon_base = "cargo"
	build_type = /obj/item/stack/tile/floor/eris/white/cargo

/decl/flooring/tiling/eris/white/brown_platform
	icon_base = "brown_platform"
	build_type = /obj/item/stack/tile/floor/eris/white/brown_platform

/decl/flooring/tiling/eris/white/gray_platform
	icon_base = "gray_platform"
	build_type = /obj/item/stack/tile/floor/eris/white/gray_platform

/decl/flooring/tiling/eris/white/danger
	icon_base = "danger"
	build_type = /obj/item/stack/tile/floor/eris/white/danger

/decl/flooring/tiling/eris/white/golden
	icon_base = "golden"
	build_type = /obj/item/stack/tile/floor/eris/white/golden

/decl/flooring/tiling/eris/white/bluecorner
	icon_base = "bluecorner"
	build_type = /obj/item/stack/tile/floor/eris/white/bluecorner

/decl/flooring/tiling/eris/white/orangecorner
	icon_base = "orangecorner"
	build_type = /obj/item/stack/tile/floor/eris/white/orangecorner

/decl/flooring/tiling/eris/white/cyancorner
	icon_base = "cyancorner"
	build_type = /obj/item/stack/tile/floor/eris/white/cyancorner

/decl/flooring/tiling/eris/white/violetcorener
	icon_base = "violetcorener"
	build_type = /obj/item/stack/tile/floor/eris/white/violetcorener

/decl/flooring/tiling/eris/white/monofloor
	icon_base = "monofloor"
	build_type = /obj/item/stack/tile/floor/eris/white/monofloor
	has_base_range = 15

/decl/flooring/tiling/eris/dark
	name = "dark floor"
	icon_base = "tiles"
	icon = 'icons/turf/flooring/eris/tiles_dark.dmi'
	build_type = /obj/item/stack/tile/floor/eris/dark

/decl/flooring/tiling/eris/dark/panels
	icon_base = "panels"
	build_type = /obj/item/stack/tile/floor/eris/dark/panels

/decl/flooring/tiling/eris/dark/techfloor
	icon_base = "techfloor"
	build_type = /obj/item/stack/tile/floor/eris/dark/techfloor

/decl/flooring/tiling/eris/dark/techfloor_grid
	icon_base = "techfloor_grid"
	build_type = /obj/item/stack/tile/floor/eris/dark/techfloor_grid

/decl/flooring/tiling/eris/dark/brown_perforated
	icon_base = "brown_perforated"
	build_type = /obj/item/stack/tile/floor/eris/dark/brown_perforated

/decl/flooring/tiling/eris/dark/gray_perforated
	icon_base = "gray_perforated"
	build_type = /obj/item/stack/tile/floor/eris/dark/gray_perforated

/decl/flooring/tiling/eris/dark/cargo
	icon_base = "cargo"
	build_type = /obj/item/stack/tile/floor/eris/dark/cargo

/decl/flooring/tiling/eris/dark/brown_platform
	icon_base = "brown_platform"
	build_type = /obj/item/stack/tile/floor/eris/dark/brown_platform

/decl/flooring/tiling/eris/dark/gray_platform
	icon_base = "gray_platform"
	build_type = /obj/item/stack/tile/floor/eris/dark/gray_platform

/decl/flooring/tiling/eris/dark/danger
	icon_base = "danger"
	build_type = /obj/item/stack/tile/floor/eris/dark/danger

/decl/flooring/tiling/eris/dark/golden
	icon_base = "golden"
	build_type = /obj/item/stack/tile/floor/eris/dark/golden

/decl/flooring/tiling/eris/dark/bluecorner
	icon_base = "bluecorner"
	build_type = /obj/item/stack/tile/floor/eris/dark/bluecorner

/decl/flooring/tiling/eris/dark/orangecorner
	icon_base = "orangecorner"
	build_type = /obj/item/stack/tile/floor/eris/dark/orangecorner

/decl/flooring/tiling/eris/dark/cyancorner
	icon_base = "cyancorner"
	build_type = /obj/item/stack/tile/floor/eris/dark/cyancorner

/decl/flooring/tiling/eris/dark/violetcorener
	icon_base = "violetcorener"
	build_type = /obj/item/stack/tile/floor/eris/dark/violetcorener

/decl/flooring/tiling/eris/dark/monofloor
	icon_base = "monofloor"
	build_type = /obj/item/stack/tile/floor/eris/dark/monofloor
	has_base_range = 15

/decl/flooring/tiling/eris/cafe
	name = "linoleum floor"
	icon_base = "cafe"
	icon = 'icons/turf/flooring/eris/tiles.dmi'
	build_type = /obj/item/stack/tile/floor/eris/cafe
	floor_smooth = SMOOTH_NONE
	smooth_movable_atom = SMOOTH_NONE

/decl/flooring/tiling/eris/bcircuit
	name = "circuit substrate"
	icon_base = "bcircuit"
	icon = 'icons/turf/flooring/eris/circuit.dmi'
	build_type = /obj/item/stack/tile/floor/eris/bcircuit
	floor_smooth = SMOOTH_NONE
	smooth_movable_atom = SMOOTH_NONE
	flags = TURF_HAS_EDGES | TURF_HAS_CORNERS | TURF_CAN_BREAK

/decl/flooring/tiling/eris/derelict1
	name = "derelict floor"
	icon_base = "derelict1"
	icon = 'icons/turf/flooring/eris/derelict.dmi'
	build_type = /obj/item/stack/tile/floor/eris/derelict1
	floor_smooth = SMOOTH_NONE
	smooth_movable_atom = SMOOTH_NONE
	flags = TURF_HAS_EDGES | TURF_REMOVE_CROWBAR | TURF_CAN_BREAK

/decl/flooring/tiling/eris/derelict2
	name = "derelict floor"
	icon_base = "derelict2"
	icon = 'icons/turf/flooring/eris/derelict.dmi'
	build_type = /obj/item/stack/tile/floor/eris/derelict2
	floor_smooth = SMOOTH_NONE
	smooth_movable_atom = SMOOTH_NONE
	flags = TURF_HAS_EDGES | TURF_REMOVE_CROWBAR | TURF_CAN_BREAK

/decl/flooring/tiling/eris/derelict3
	name = "derelict floor"
	icon_base = "derelict3"
	icon = 'icons/turf/flooring/eris/derelict.dmi'
	build_type = /obj/item/stack/tile/floor/eris/derelict3
	floor_smooth = SMOOTH_NONE
	smooth_movable_atom = SMOOTH_NONE
	flags = TURF_HAS_EDGES | TURF_REMOVE_CROWBAR | TURF_CAN_BREAK

/decl/flooring/tiling/eris/derelict4
	name = "derelict floor"
	icon_base = "derelict4"
	icon = 'icons/turf/flooring/eris/derelict.dmi'
	build_type = /obj/item/stack/tile/floor/eris/derelict4
	floor_smooth = SMOOTH_NONE
	smooth_movable_atom = SMOOTH_NONE
	flags = TURF_HAS_EDGES | TURF_REMOVE_CROWBAR | TURF_CAN_BREAK

/decl/flooring/tiling/eris/techmaint
	name = "techmaint floor"
	icon_base = "techmaint"
	icon = 'icons/turf/flooring/eris/tiles_maint.dmi'
	build_type = /obj/item/stack/tile/floor/eris/techmaint
	floor_smooth = SMOOTH_NONE
	smooth_movable_atom = SMOOTH_NONE

/decl/flooring/tiling/eris/techmaint_perforated
	name = "techmaint floor"
	icon_base = "techmaint_perforated"
	icon = 'icons/turf/flooring/eris/tiles_maint.dmi'
	build_type = /obj/item/stack/tile/floor/eris/techmaint/perforated
	floor_smooth = SMOOTH_NONE
	smooth_movable_atom = SMOOTH_NONE

/decl/flooring/tiling/eris/techmaint_panels
	name = "techmaint floor"
	icon_base = "techmaint_panels"
	icon = 'icons/turf/flooring/eris/tiles_maint.dmi'
	build_type = /obj/item/stack/tile/floor/eris/techmaint/panels
	floor_smooth = SMOOTH_NONE
	smooth_movable_atom = SMOOTH_NONE

/decl/flooring/tiling/eris/techmaint_cargo
	name = "techmaint floor"
	icon_base = "techmaint_cargo"
	icon = 'icons/turf/flooring/eris/tiles_maint.dmi'
	build_type = /obj/item/stack/tile/floor/eris/techmaint/cargo
	floor_smooth = SMOOTH_NONE
	smooth_movable_atom = SMOOTH_NONE

///////////////////////
/// TILE OBJS   ///////
///////////////////////
/obj/item/stack/tile/floor/eris
	icon = 'icons/turf/flooring/eris/tilestack.dmi'

// Cafe
/obj/item/stack/tile/floor/eris/cafe
	name = "cafe floor tile"
	singular_name = "cafe floor tile"
	desc = "A chekered pattern, an ancient style for a familiar feeling."
	icon_state = "tile_cafe"
	matter = list(MAT_PLASTIC = 1)

// Circuit
/obj/item/stack/tile/floor/eris/bcircuit
	name = "circuit floor tile"
	singular_name = "circuit floor tile"
	icon_state = "tile_techmaint" // No sprite for this...
	matter = list(MAT_STEEL = 1)

// Derelict
/obj/item/stack/tile/floor/eris/derelict1
	name = "derelict floor tile"
	singular_name = "derelict floor tile"
	icon_state = "tile_techmaint" // No sprite for this...
	matter = list(MAT_STEEL = 1)

/obj/item/stack/tile/floor/eris/derelict2
	name = "derelict floor tile"
	singular_name = "derelict floor tile"
	icon_state = "tile_techmaint" // No sprite for this...
	matter = list(MAT_STEEL = 1)

/obj/item/stack/tile/floor/eris/derelict3
	name = "derelict floor tile"
	singular_name = "derelict floor tile"
	icon_state = "tile_techmaint" // No sprite for this...
	matter = list(MAT_STEEL = 1)

/obj/item/stack/tile/floor/eris/derelict4
	name = "derelict floor tile"
	singular_name = "derelict floor tile"
	icon_state = "tile_techmaint" // No sprite for this...
	matter = list(MAT_STEEL = 1)

// Techmaint
/obj/item/stack/tile/floor/eris/techmaint
	name = "maint floor tile"
	singular_name = "maint floor tile"
	icon_state = "tile_techmaint"
	matter = list(MAT_STEEL = 1)

/obj/item/stack/tile/floor/eris/techmaint/perforated
	name = "perforated maint floor tile"
	singular_name = "perforated maint floor tile"
	icon_state = "tile_techmaint_perforated"

/obj/item/stack/tile/floor/eris/techmaint/panels
	name = "panel maint floor tile"
	singular_name = "panel maint floor tile"
	icon_state = "tile_techmaint_panels"

/obj/item/stack/tile/floor/eris/techmaint/cargo
	name = "cargo maint floor tile"
	singular_name = "cargo maint floor tile"
	icon_state = "tile_techmaint_cargo"

/*
 * Steel
 */
/obj/item/stack/tile/floor/eris/steel
	name = "steel floor tile"
	singular_name = "steel floor tile"
	icon_state = "tile_steel"
	matter = list(MAT_STEEL = 1)

/obj/item/stack/tile/floor/eris/steel/panels
	name = "steel panel tile"
	singular_name = "steel panel tile"
	icon_state = "tile_steel_panels"

/obj/item/stack/tile/floor/eris/steel/techfloor
	name = "steel techfloor tile"
	singular_name = "steel techfloor tile"
	icon_state = "tile_steel_techfloor"

/obj/item/stack/tile/floor/eris/steel/techfloor_grid
	name = "steel techfloor tile with vents"
	singular_name = "steel techfloor tile with vents"
	icon_state = "tile_steel_techfloor_grid"

/obj/item/stack/tile/floor/eris/steel/brown_perforated
	name = "steel brown perforated tile"
	singular_name = "steel brown perforated tile"
	icon_state = "tile_steel_brownperforated"

/obj/item/stack/tile/floor/eris/steel/gray_perforated
	name = "steel gray perforated tile"
	singular_name = "steel gray perforated tile"
	icon_state = "tile_steel_grayperforated"

/obj/item/stack/tile/floor/eris/steel/cargo
	name = "steel cargo tile"
	singular_name = "steel cargo tile"
	icon_state = "tile_steel_cargo"

/obj/item/stack/tile/floor/eris/steel/brown_platform
	name = "steel brown platform tile"
	singular_name = "steel brown platform tile"
	icon_state = "tile_steel_brownplatform"

/obj/item/stack/tile/floor/eris/steel/gray_platform
	name = "steel gray platform tile"
	singular_name = "steel gray platform tile"
	icon_state = "tile_steel_grayplatform"

/obj/item/stack/tile/floor/eris/steel/danger
	name = "steel danger tile"
	singular_name = "steel danger tile"
	icon_state = "tile_steel_danger"

/obj/item/stack/tile/floor/eris/steel/golden
	name = "steel golden tile"
	singular_name = "steel golden tile"
	icon_state = "tile_steel_golden"

/obj/item/stack/tile/floor/eris/steel/bluecorner
	name = "steel blue corner tile"
	singular_name = "steel blue corner tile"
	icon_state = "tile_steel_bluecorner"

/obj/item/stack/tile/floor/eris/steel/orangecorner
	name = "steel orange corner tile"
	singular_name = "steel orange corner tilee"
	icon_state = "tile_steel_orangecorner"

/obj/item/stack/tile/floor/eris/steel/cyancorner
	name = "steel cyan corner tile"
	singular_name = "steel cyan corner tile"
	icon_state = "tile_steel_cyancorner"

/obj/item/stack/tile/floor/eris/steel/violetcorener
	name = "steel violet corener tile"
	singular_name = "steel violet corener tile"
	icon_state = "tile_steel_violetcorener"

/obj/item/stack/tile/floor/eris/steel/monofloor
	name = "steel monofloor tile"
	singular_name = "steel monofloor tile"
	icon_state = "tile_steel_monofloor"

/obj/item/stack/tile/floor/eris/steel/bar_flat
	name = "steel bar flat tile"
	singular_name = "steel bar flat tile"
	icon_state = "tile_steel_bar_flat"

/obj/item/stack/tile/floor/eris/steel/bar_dance
	name = "steel bar dance tile"
	singular_name = "steel bar dance tile"
	icon_state = "tile_steel_bar_dance"

/obj/item/stack/tile/floor/eris/steel/bar_light
	name = "steel bar light tile"
	singular_name = "steel bar light tile"
	icon_state = "tile_steel_bar_light"

/*
 * Plastic
 */
/obj/item/stack/tile/floor/eris/white
	name = "white floor tile"
	singular_name = "white floor tile"
	desc = "Appears to be made out of a lighter mat."
	icon_state = "tile_white"
	matter = list(MAT_PLASTIC = 1)

/obj/item/stack/tile/floor/eris/white/panels
	name = "white panel tile"
	singular_name = "white panel tile"
	icon_state = "tile_white_panels"

/obj/item/stack/tile/floor/eris/white/techfloor
	name = "white techfloor tile"
	singular_name = "white techfloor tile"
	icon_state = "tile_white_techfloor"

/obj/item/stack/tile/floor/eris/white/techfloor_grid
	name = "white techfloor tile with vents"
	singular_name = "white techfloor tile with vents"
	icon_state = "tile_white_techfloor_grid"

/obj/item/stack/tile/floor/eris/white/brown_perforated
	name = "white brown perforated tile"
	singular_name = "white brown perforated tile"
	icon_state = "tile_white_brownperforated"

/obj/item/stack/tile/floor/eris/white/gray_perforated
	name = "white gray perforated tile"
	singular_name = "white gray perforated tile"
	icon_state = "tile-white-grayperforated"

/obj/item/stack/tile/floor/eris/white/cargo
	name = "white cargo tile"
	singular_name = "white cargo tile"
	icon_state = "tile_white_cargo"

/obj/item/stack/tile/floor/eris/white/brown_platform
	name = "white brown platform tile"
	singular_name = "white brown platform tile"
	icon_state = "tile_white_brownplatform"

/obj/item/stack/tile/floor/eris/white/gray_platform
	name = "white gray platform tile"
	singular_name = "white gray platform tile"
	icon_state = "tile_white_grayplatform"

/obj/item/stack/tile/floor/eris/white/danger
	name = "white danger tile"
	singular_name = "white danger tile"
	icon_state = "tile_white_danger"

/obj/item/stack/tile/floor/eris/white/golden
	name = "white golden tile"
	singular_name = "white golden tile"
	icon_state = "tile_white_golden"

/obj/item/stack/tile/floor/eris/white/bluecorner
	name = "white blue corner tile"
	singular_name = "white blue corner tile"
	icon_state = "tile_white_bluecorner"

/obj/item/stack/tile/floor/eris/white/orangecorner
	name = "white orange corner tile"
	singular_name = "white orange corner tilee"
	icon_state = "tile_white_orangecorner"

/obj/item/stack/tile/floor/eris/white/cyancorner
	name = "white cyan corner tile"
	singular_name = "white cyan corner tile"
	icon_state = "tile_white_cyancorner"

/obj/item/stack/tile/floor/eris/white/violetcorener
	name = "white violet corener tile"
	singular_name = "white violet corener tile"
	icon_state = "tile_white_violetcorener"

/obj/item/stack/tile/floor/eris/white/monofloor
	name = "white monofloor tile"
	singular_name = "white monofloor tile"
	icon_state = "tile_white_monofloor"

/*
 * Steel
 */
/obj/item/stack/tile/floor/eris/dark
	name = "dark floor tile"
	singular_name = "dark floor tile"
	icon_state = "tile_dark"
	matter = list(MAT_STEEL = 1)

/obj/item/stack/tile/floor/eris/dark/panels
	name = "dark panel tile"
	singular_name = "dark panel tile"
	icon_state = "tile_dark_panels"

/obj/item/stack/tile/floor/eris/dark/techfloor
	name = "dark techfloor tile"
	singular_name = "dark techfloor tile"
	icon_state = "tile_dark_techfloor"

/obj/item/stack/tile/floor/eris/dark/techfloor_grid
	name = "dark techfloor tile with vents"
	singular_name = "dark techfloor tile with vents"
	icon_state = "tile_dark_techfloor_grid"

/obj/item/stack/tile/floor/eris/dark/brown_perforated
	name = "dark brown perforated tile"
	singular_name = "dark brown perforated tile"
	icon_state = "tile_dark_brownperforated"

/obj/item/stack/tile/floor/eris/dark/gray_perforated
	name = "dark gray perforated tile"
	singular_name = "dark gray perforated tile"
	icon_state = "tile_dark_grayperforated"

/obj/item/stack/tile/floor/eris/dark/cargo
	name = "dark cargo tile"
	singular_name = "dark cargo tile"
	icon_state = "tile_dark_cargo"

/obj/item/stack/tile/floor/eris/dark/brown_platform
	name = "dark brown platform tile"
	singular_name = "dark brown platform tile"
	icon_state = "tile_dark_brownplatform"

/obj/item/stack/tile/floor/eris/dark/gray_platform
	name = "dark gray platform tile"
	singular_name = "dark gray platform tile"
	icon_state = "tile_dark_grayplatform"

/obj/item/stack/tile/floor/eris/dark/danger
	name = "dark danger tile"
	singular_name = "dark danger tile"
	icon_state = "tile_dark_danger"

/obj/item/stack/tile/floor/eris/dark/golden
	name = "dark golden tile"
	singular_name = "dark golden tile"
	icon_state = "tile_dark_golden"

/obj/item/stack/tile/floor/eris/dark/bluecorner
	name = "dark blue corner tile"
	singular_name = "dark blue corner tile"
	icon_state = "tile_dark_bluecorner"

/obj/item/stack/tile/floor/eris/dark/orangecorner
	name = "dark orange corner tile"
	singular_name = "dark orange corner tilee"
	icon_state = "tile_dark_orangecorner"

/obj/item/stack/tile/floor/eris/dark/cyancorner
	name = "dark cyan corner tile"
	singular_name = "dark cyan corner tile"
	icon_state = "tile_dark_cyancorner"

/obj/item/stack/tile/floor/eris/dark/violetcorener
	name = "dark violet corener tile"
	singular_name = "dark violet corener tile"
	icon_state = "tile_dark_violetcorener"

/obj/item/stack/tile/floor/eris/dark/monofloor
	name = "dark monofloor tile"
	singular_name = "dark monofloor tile"
	icon_state = "tile_dark_monofloor"


///////////////////////
/// PREMADE TURFS /////
///////////////////////
/turf/simulated/floor/tiled/eris
	name = "floor"
	icon = 'icons/turf/flooring/eris/tiles.dmi'
	icon_state = "tiles"
	initial_flooring = /decl/flooring/tiling/eris



//Steel tiles
/turf/simulated/floor/tiled/eris/steel
	name = "floor"
	icon = 'icons/turf/flooring/eris/tiles_steel.dmi'
	icon_state = "tiles"
	initial_flooring = /decl/flooring/tiling/eris/steel

/turf/simulated/floor/tiled/eris/steel/panels
	icon_state = "panels"
	initial_flooring = /decl/flooring/tiling/eris/steel/panels

/turf/simulated/floor/tiled/eris/steel/techfloor
	icon_state = "techfloor"
	initial_flooring = /decl/flooring/tiling/eris/steel/techfloor

/turf/simulated/floor/tiled/eris/steel/techfloor_grid
	icon_state = "techfloor_grid"
	initial_flooring = /decl/flooring/tiling/eris/steel/techfloor_grid

/turf/simulated/floor/tiled/eris/steel/brown_perforated
	icon_state = "brown_perforated"
	initial_flooring = /decl/flooring/tiling/eris/steel/brown_perforated

/turf/simulated/floor/tiled/eris/steel/gray_perforated
	icon_state = "gray_perforated"
	initial_flooring = /decl/flooring/tiling/eris/steel/gray_perforated

/turf/simulated/floor/tiled/eris/steel/cargo
	icon_state = "cargo"
	initial_flooring = /decl/flooring/tiling/eris/steel/cargo

/turf/simulated/floor/tiled/eris/steel/brown_platform
	icon_state = "brown_platform"
	initial_flooring = /decl/flooring/tiling/eris/steel/brown_platform

/turf/simulated/floor/tiled/eris/steel/gray_platform
	icon_state = "gray_platform"
	initial_flooring = /decl/flooring/tiling/eris/steel/gray_platform

/turf/simulated/floor/tiled/eris/steel/danger
	icon_state = "danger"
	initial_flooring = /decl/flooring/tiling/eris/steel/danger

/turf/simulated/floor/tiled/eris/steel/golden
	icon_state = "golden"
	initial_flooring = /decl/flooring/tiling/eris/steel/golden

/turf/simulated/floor/tiled/eris/steel/bluecorner
	icon_state = "bluecorner"
	initial_flooring = /decl/flooring/tiling/eris/steel/bluecorner

/turf/simulated/floor/tiled/eris/steel/orangecorner
	icon_state = "orangecorner"
	initial_flooring = /decl/flooring/tiling/eris/steel/orangecorner

/turf/simulated/floor/tiled/eris/steel/cyancorner
	icon_state = "cyancorner"
	initial_flooring = /decl/flooring/tiling/eris/steel/cyancorner

/turf/simulated/floor/tiled/eris/steel/violetcorener
	icon_state = "violetcorener"
	initial_flooring = /decl/flooring/tiling/eris/steel/violetcorener

/turf/simulated/floor/tiled/eris/steel/monofloor
	icon_state = "monofloor"
	initial_flooring = /decl/flooring/tiling/eris/steel/monofloor

/turf/simulated/floor/tiled/eris/steel/bar_flat
	icon_state = "bar_flat"
	initial_flooring = /decl/flooring/tiling/eris/steel/bar_flat

/turf/simulated/floor/tiled/eris/steel/bar_dance
	icon_state = "bar_dance"
	initial_flooring = /decl/flooring/tiling/eris/steel/bar_dance

/turf/simulated/floor/tiled/eris/steel/bar_light
	icon_state = "bar_light"
	initial_flooring = /decl/flooring/tiling/eris/steel/bar_light

/turf/simulated/floor/tiled/eris/steel/bar_light/Initialize(mapload)
	. = ..()
	set_light(3,4,"#00AAFF")



//White Tiles
/turf/simulated/floor/tiled/eris/white
	name = "floor"
	icon = 'icons/turf/flooring/eris/tiles_white.dmi'
	icon_state = "tiles"
	initial_flooring = /decl/flooring/tiling/eris/white

/turf/simulated/floor/tiled/eris/white/panels
	icon_state = "panels"
	initial_flooring = /decl/flooring/tiling/eris/white/panels

/turf/simulated/floor/tiled/eris/white/techfloor
	icon_state = "techfloor"
	initial_flooring = /decl/flooring/tiling/eris/white/techfloor

/turf/simulated/floor/tiled/eris/white/techfloor_grid
	icon_state = "techfloor_grid"
	initial_flooring = /decl/flooring/tiling/eris/white/techfloor_grid

/turf/simulated/floor/tiled/eris/white/brown_perforated
	icon_state = "brown_perforated"
	initial_flooring = /decl/flooring/tiling/eris/white/brown_perforated

/turf/simulated/floor/tiled/eris/white/gray_perforated
	icon_state = "gray_perforated"
	initial_flooring = /decl/flooring/tiling/eris/white/gray_perforated

/turf/simulated/floor/tiled/eris/white/cargo
	icon_state = "cargo"
	initial_flooring = /decl/flooring/tiling/eris/white/cargo

/turf/simulated/floor/tiled/eris/white/brown_platform
	icon_state = "brown_platform"
	initial_flooring = /decl/flooring/tiling/eris/white/brown_platform

/turf/simulated/floor/tiled/eris/white/gray_platform
	icon_state = "gray_platform"
	initial_flooring = /decl/flooring/tiling/eris/white/gray_platform

/turf/simulated/floor/tiled/eris/white/danger
	icon_state = "danger"
	initial_flooring = /decl/flooring/tiling/eris/white/danger

/turf/simulated/floor/tiled/eris/white/golden
	icon_state = "golden"
	initial_flooring = /decl/flooring/tiling/eris/white/golden

/turf/simulated/floor/tiled/eris/white/bluecorner
	icon_state = "bluecorner"
	initial_flooring = /decl/flooring/tiling/eris/white/bluecorner

/turf/simulated/floor/tiled/eris/white/orangecorner
	icon_state = "orangecorner"
	initial_flooring = /decl/flooring/tiling/eris/white/orangecorner

/turf/simulated/floor/tiled/eris/white/cyancorner
	icon_state = "cyancorner"
	initial_flooring = /decl/flooring/tiling/eris/white/cyancorner

/turf/simulated/floor/tiled/eris/white/violetcorener
	icon_state = "violetcorener"
	initial_flooring = /decl/flooring/tiling/eris/white/violetcorener

/turf/simulated/floor/tiled/eris/white/monofloor
	icon_state = "monofloor"
	initial_flooring = /decl/flooring/tiling/eris/white/monofloor



// Dark Tiles
/turf/simulated/floor/tiled/eris/dark
	name = "floor"
	icon = 'icons/turf/flooring/eris/tiles_dark.dmi'
	icon_state = "tiles"
	initial_flooring = /decl/flooring/tiling/eris/dark

/turf/simulated/floor/tiled/eris/dark/panels
	icon_state = "panels"
	initial_flooring = /decl/flooring/tiling/eris/dark/panels

/turf/simulated/floor/tiled/eris/dark/techfloor
	icon_state = "techfloor"
	initial_flooring = /decl/flooring/tiling/eris/dark/techfloor

/turf/simulated/floor/tiled/eris/dark/techfloor_grid
	icon_state = "techfloor_grid"
	initial_flooring = /decl/flooring/tiling/eris/dark/techfloor_grid

/turf/simulated/floor/tiled/eris/dark/brown_perforated
	icon_state = "brown_perforated"
	initial_flooring = /decl/flooring/tiling/eris/dark/brown_perforated

/turf/simulated/floor/tiled/eris/dark/gray_perforated
	icon_state = "gray_perforated"
	initial_flooring = /decl/flooring/tiling/eris/dark/gray_perforated

/turf/simulated/floor/tiled/eris/dark/cargo
	icon_state = "cargo"
	initial_flooring = /decl/flooring/tiling/eris/dark/cargo

/turf/simulated/floor/tiled/eris/dark/brown_platform
	icon_state = "brown_platform"
	initial_flooring = /decl/flooring/tiling/eris/dark/brown_platform

/turf/simulated/floor/tiled/eris/dark/gray_platform
	icon_state = "gray_platform"
	initial_flooring = /decl/flooring/tiling/eris/dark/gray_platform

/turf/simulated/floor/tiled/eris/dark/danger
	icon_state = "danger"
	initial_flooring = /decl/flooring/tiling/eris/dark/danger

/turf/simulated/floor/tiled/eris/dark/golden
	icon_state = "golden"
	initial_flooring = /decl/flooring/tiling/eris/dark/golden

/turf/simulated/floor/tiled/eris/dark/bluecorner
	icon_state = "bluecorner"
	initial_flooring = /decl/flooring/tiling/eris/dark/bluecorner

/turf/simulated/floor/tiled/eris/dark/orangecorner
	icon_state = "orangecorner"
	initial_flooring = /decl/flooring/tiling/eris/dark/orangecorner

/turf/simulated/floor/tiled/eris/dark/cyancorner
	icon_state = "cyancorner"
	initial_flooring = /decl/flooring/tiling/eris/dark/cyancorner

/turf/simulated/floor/tiled/eris/dark/violetcorener
	icon_state = "violetcorener"
	initial_flooring = /decl/flooring/tiling/eris/dark/violetcorener

/turf/simulated/floor/tiled/eris/dark/monofloor
	icon_state = "monofloor"
	initial_flooring = /decl/flooring/tiling/eris/dark/monofloor




/turf/simulated/floor/tiled/eris/cafe
	name = "floor"
	icon = 'icons/turf/flooring/eris/tiles.dmi'
	icon_state = "cafe"
	initial_flooring = /decl/flooring/tiling/eris/cafe

/turf/simulated/floor/tiled/eris/bcircuit
	name = "substrate"
	icon = 'icons/turf/flooring/eris/circuit.dmi'
	icon_state = "bcircuit"
	initial_flooring = /decl/flooring/tiling/eris/bcircuit

/turf/simulated/floor/tiled/eris/derelict1
	name = "floor"
	icon = 'icons/turf/flooring/eris/derelict.dmi'
	icon_state = "derelict1"
	initial_flooring = /decl/flooring/tiling/eris/derelict1

/turf/simulated/floor/tiled/eris/derelict2
	name = "floor"
	icon = 'icons/turf/flooring/eris/derelict.dmi'
	icon_state = "derelict2"
	initial_flooring = /decl/flooring/tiling/eris/derelict2

/turf/simulated/floor/tiled/eris/derelict3
	name = "floor"
	icon = 'icons/turf/flooring/eris/derelict.dmi'
	icon_state = "derelict3"
	initial_flooring = /decl/flooring/tiling/eris/derelict3

/turf/simulated/floor/tiled/eris/derelict4
	name = "floor"
	icon = 'icons/turf/flooring/eris/derelict.dmi'
	icon_state = "derelict4"
	initial_flooring = /decl/flooring/tiling/eris/derelict4

/turf/simulated/floor/tiled/eris/techmaint
	name = "floor"
	icon = 'icons/turf/flooring/eris/tiles_maint.dmi'
	icon_state = "techmaint"
	initial_flooring = /decl/flooring/tiling/eris/techmaint

/turf/simulated/floor/tiled/eris/techmaint_perforated
	name = "floor"
	icon = 'icons/turf/flooring/eris/tiles_maint.dmi'
	icon_state = "techmaint_perforated"
	initial_flooring = /decl/flooring/tiling/eris/techmaint_perforated

/turf/simulated/floor/tiled/eris/techmaint_panels
	name = "floor"
	icon = 'icons/turf/flooring/eris/tiles_maint.dmi'
	icon_state = "techmaint_panels"
	initial_flooring = /decl/flooring/tiling/eris/techmaint_panels

/turf/simulated/floor/tiled/eris/techmaint_cargo
	name = "floor"
	icon = 'icons/turf/flooring/eris/tiles_maint.dmi'
	icon_state = "techmaint_cargo"
	initial_flooring = /decl/flooring/tiling/eris/techmaint_cargo

//=========ERIS GRASS==========\\
/decl/flooring/grass/heavy
	name = "heavy grass"
	desc = "A dense ground coating of grass"
	flags = TURF_REMOVE_SHOVEL
	icon = 'icons/turf/outdoors.dmi'
	icon_base = "grass-heavy"
	has_base_range = 3

/turf/simulated/floor/outdoors/grass/heavy
	name = "heavy grass"
	icon_state = "grass-heavy0"
	edge_blending_priority = 4
	initial_flooring = /decl/flooring/grass/heavy
	turf_layers = list(
		/turf/simulated/floor/outdoors/rocks,
		/turf/simulated/floor/outdoors/dirt
		)
	grass_chance = 40

	grass_types = list(
		/obj/structure/flora/ausbushes/sparsegrass,
		/obj/structure/flora/ausbushes/fullgrass
		)

//=========Eris Plating==========\\
// This is the light grey tiles with random geometric shapes extruded
/decl/flooring/eris_plating
	name = "reinforced plating"
	descriptor = "reinforced plating"
	icon = 'icons/turf/flooring/eris/plating.dmi'
	icon_base = "plating"
	flags = TURF_REMOVE_WRENCH | TURF_HAS_CORNERS | TURF_HAS_EDGES | TURF_CAN_BURN | TURF_CAN_BREAK
	can_paint = 1
	has_base_range = 18
	is_plating = TRUE

	build_type = null

	plating_type = /decl/flooring/eris_plating/under

	/*
	footstep_sound = "plating"
	space_smooth = FALSE
	removal_time = 150
	health = 100

	floor_smooth = SMOOTH_BLACKLIST
	flooring_blacklist = list(/decl/flooring/reinforced/plating/under,/decl/flooring/reinforced/plating/hull) //Smooth with everything except the contents of this list
	smooth_movable_atom = SMOOTH_GREYLIST
	movable_atom_blacklist = list(list(/obj, list("density" = TRUE, "anchored" = TRUE), 1))
	movable_atom_whitelist = list(list(/obj/machinery/door/airlock, list(), 2))
	*/

/turf/simulated/floor/plating/eris
	name = "reinforced plating"
	icon = 'icons/turf/flooring/eris/plating.dmi'
	icon_state = "plating"
	initial_flooring = /decl/flooring/eris_plating

/turf/simulated/floor/plating/eris/airless
	oxygen = 0
	nitrogen = 0
	temperature = TCMB

//==========Eris Underplating==============\\
// This looks similar to normal plating, but with edges
/decl/flooring/eris_plating/under
	name = "underplating"
	icon = 'icons/turf/flooring/eris/plating.dmi'
	descriptor = "support beams"
	icon_base = "under"
	flags = TURF_HAS_CORNERS | TURF_HAS_EDGES | TURF_CAN_BURN | TURF_CAN_BREAK
	has_base_range = 0
	is_plating = TRUE

	floor_smooth = SMOOTH_WHITELIST
	flooring_whitelist = list(
		/decl/flooring/tiling/eris
	)

	plating_type = null

	//build_type = /obj/item/stack/material/underplating

	/* Eris features we lack on flooring decls
	removal_time = 250
	health = 200
	resistance = RESISTANCE_ARMOURED
	footstep_sound = "catwalk"
	space_smooth = SMOOTH_ALL
	floor_smooth = SMOOTH_NONE
	smooth_movable_atom = SMOOTH_NONE
	*/

/turf/simulated/floor/plating/eris/under
	name = "underplating"
	icon_state = "under"
	initial_flooring = /decl/flooring/eris_plating/under

/turf/simulated/floor/plating/eris/under/airless
	oxygen = 0
	nitrogen = 0
	temperature = TCMB

//============Eris Hull Plating=========\\
// This is 'spaceship outside' plating, black with random rounded rectangles.
/decl/flooring/eris_plating/hull
	name = "hull"
	descriptor = "outer hull"
	icon = 'icons/turf/flooring/eris/hull.dmi'
	icon_base = "hullcenter"
	flags = TURF_HAS_EDGES | TURF_HAS_CORNERS | TURF_REMOVE_WRENCH | TURF_CAN_BURN | TURF_CAN_BREAK
	has_base_range = 35
	is_plating = FALSE
	build_type = /obj/item/stack/material/plasteel

	/* Eris features we lack on flooring decls
	try_update_icon = 0
	plating_type = null
	health = 350
	resistance = RESISTANCE_HEAVILY_ARMOURED
	removal_time = 1 MINUTES //Cutting through the hull is very slow work
	footstep_sound = "hull"
	wall_smooth = SMOOTH_ALL
	space_smooth = SMOOTH_NONE
	smooth_movable_atom = SMOOTH_NONE
	*/

/* Eris features we lack on flooring decls
//Hull can upgrade to underplating
/decl/flooring/reinforced/plating/hull/can_build_floor(var/decl/flooring/newfloor)
	return FALSE //Not allowed to build directly on hull, you must first remove it and then build on the underplating

/decl/flooring/reinforced/plating/hull/get_plating_type(var/turf/location)
	if (turf_is_lower_hull(location)) //Hull plating is only on the lowest level of the ship
		return null
	else if (turf_is_upper_hull(location))
		return /decl/flooring/reinforced/plating/under
	else
		return null //This should never happen, hull plawell,ting should only be on the exterior
*/
/turf/simulated/floor/hull
	name = "hull"
	icon = 'icons/turf/flooring/eris/hull.dmi'
	icon_state = "hullcenter0"
	initial_flooring = /decl/flooring/eris_plating/hull

/turf/simulated/floor/hull/airless
	oxygen = 0
	nitrogen = 0
	temperature = TCMB
