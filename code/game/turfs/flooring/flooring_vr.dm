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

/decl/flooring/grass/outdoors
	flags = NONE
	build_type = null

/decl/flooring/grass/outdoors/forest
	icon = 'icons/turf/outdoors.dmi'
	icon_base = "grass-dark"

/turf/simulated/floor/tiled/freezer/cold
	temperature = T0C - 5

/turf/simulated/floor/redgrid
	name = "processing strata"
	icon = 'icons/turf/flooring/circuit_vr.dmi'
	icon_state = "rcircuit"
	initial_flooring = /decl/flooring/reinforced/circuit/red

/decl/flooring/reinforced/circuit/red
	name = "processing strata"
	icon = 'icons/turf/flooring/circuit_vr.dmi'
	icon_base = "rcircuit"

/turf/simulated/floor/redgrid/animated
	name = "pulsing pattern"
	icon = 'icons/turf/flooring/circuit_vr.dmi'
	icon_state = "rcircuitanim"
	initial_flooring = /decl/flooring/reinforced/circuit/red/animated

/decl/flooring/reinforced/circuit/red/animated
	name = "pulsing pattern"
	icon = 'icons/turf/flooring/circuit_vr.dmi'
	icon_base = "rcircuitanim"

/turf/simulated/floor/redgrid/off
	name = "dark pattern"
	icon = 'icons/turf/flooring/circuit_vr.dmi'
	icon_state = "rcircuitanim_broken"
	initial_flooring = /decl/flooring/reinforced/circuit/red/off

/decl/flooring/reinforced/circuit/red/off
	name = "dark pattern"
	icon = 'icons/turf/flooring/circuit_vr.dmi'
	icon_base = "rcircuitanim_broken"

/decl/flooring/tiling/milspec
	name = "milspec floor"
	desc = "Scuffed from the passage of countless ground pounders."
	icon = 'icons/turf/flooring/tiles_vr.dmi'
	icon_base = "milspec"
	has_damage_range = 2
	damage_temperature = T0C+1400
	flags = TURF_REMOVE_CROWBAR | TURF_CAN_BREAK | TURF_CAN_BURN
	build_type = /obj/item/stack/tile/floor/milspec
	plating_type = /decl/flooring/eris_plating/under
	can_paint = 1
	can_engrave = TRUE

/turf/simulated/floor/tiled/milspec
	name = "milspec floor"
	desc = "Scuffed from the passage of countless ground pounders."
	icon = 'icons/turf/flooring/tiles_vr.dmi'
	icon_state = "milspec"
	initial_flooring = /decl/flooring/tiling/milspec

/obj/item/stack/tile/floor/milspec
	name = "milspec floor tile"

/decl/flooring/tiling/milspec/sterile
	name = "sterile milspec floor"
	icon_base = "dark_sterile"
	build_type = /obj/item/stack/tile/floor/milspec/sterile

/turf/simulated/floor/tiled/milspec/sterile
	name = "sterile milspec floor"
	icon_state = "dark_sterile"
	initial_flooring = /decl/flooring/tiling/milspec/sterile

/obj/item/stack/tile/floor/milspec/sterile
	name = "sterile milspec floor tile"

/decl/flooring/tiling/milspec/raised
	name = "raised milspec floor"
	icon_base = "milspec_tcomms"
	build_type = /obj/item/stack/tile/floor/milspec/raised

/turf/simulated/floor/tiled/milspec/raised
	name = "raised milspec floor"
	icon_state = "milspec_tcomms"
	initial_flooring = /decl/flooring/tiling/milspec/raised

/obj/item/stack/tile/floor/milspec/raised
	name = "raised milspec floor tile"

//New Wood
/decl/flooring/wood/acacia
	name = "wooden floor"
	desc = "Polished acacia planks."
	icon = 'icons/turf/flooring/wood_greyscale.dmi'
	icon_base = "wood"
	has_damage_range = 6
	damage_temperature = T0C+200
	descriptor = "planks"
	build_type = /obj/item/stack/tile/wood/acacia
	flags = TURF_CAN_BREAK | TURF_REMOVE_CROWBAR | TURF_REMOVE_SCREWDRIVER

/decl/flooring/wood/acacia/panel
	desc = "Polished acacia panels."
	icon = 'icons/turf/flooring/wood_greyscale.dmi'
	icon_base = "wood_panel"
	has_damage_range = 2
	build_type = /obj/item/stack/tile/wood/acacia/panel

/decl/flooring/wood/acacia/parquet
	desc = "Polished acacia tiles."
	icon = 'icons/turf/flooring/wood_greyscale.dmi'
	icon_base = "wood_parquet"
	build_type = /obj/item/stack/tile/wood/acacia/parquet

/decl/flooring/wood/acacia/tile
	desc = "Polished acacia tiles."
	icon = 'icons/turf/flooring/wood_greyscale.dmi'
	icon_base = "wood_tile"
	has_damage_range = 2
	build_type = /obj/item/stack/tile/wood/acacia/tile

/decl/flooring/wood/birch
	name = "wooden floor"
	desc = "Polished birch planks."
	icon = 'icons/turf/flooring/wood_greyscale.dmi'
	icon_base = "wood"
	has_damage_range = 6
	damage_temperature = T0C+200
	descriptor = "planks"
	build_type = /obj/item/stack/tile/wood/birch
	flags = TURF_CAN_BREAK | TURF_REMOVE_CROWBAR | TURF_REMOVE_SCREWDRIVER

/decl/flooring/wood/birch/panel
	desc = "Polished birch panels."
	icon = 'icons/turf/flooring/wood_greyscale.dmi'
	icon_base = "wood_panel"
	has_damage_range = 2
	build_type = /obj/item/stack/tile/wood/birch/panel

/decl/flooring/wood/birch/parquet
	desc = "Polished birch tiles."
	icon = 'icons/turf/flooring/wood_greyscale.dmi'
	icon_base = "wood_parquet"
	build_type = /obj/item/stack/tile/wood/birch/parquet

/decl/flooring/wood/birch/tile
	desc = "Polished birch tiles."
	icon = 'icons/turf/flooring/wood_greyscale.dmi'
	icon_base = "wood_tile"
	has_damage_range = 2
	build_type = /obj/item/stack/tile/wood/birch/tile

/decl/flooring/wood/hardwood
	name = "wooden floor"
	desc = "Polished hardwood planks."
	icon = 'icons/turf/flooring/wood_greyscale.dmi'
	icon_base = "wood"
	has_damage_range = 6
	damage_temperature = T0C+200
	descriptor = "planks"
	build_type = /obj/item/stack/tile/wood/hardwood
	flags = TURF_CAN_BREAK | TURF_REMOVE_CROWBAR | TURF_REMOVE_SCREWDRIVER

/decl/flooring/wood/hardwood/panel
	desc = "Polished hardwood panels."
	icon = 'icons/turf/flooring/wood_greyscale.dmi'
	icon_base = "wood_panel"
	has_damage_range = 2
	build_type = /obj/item/stack/tile/wood/hardwood/panel

/decl/flooring/wood/hardwood/parquet
	desc = "Polished hardwood tiles."
	icon = 'icons/turf/flooring/wood_greyscale.dmi'
	icon_base = "wood_parquet"
	build_type = /obj/item/stack/tile/wood/hardwood/parquet

/decl/flooring/wood/hardwood/tile
	desc = "Polished hardwood tiles."
	icon = 'icons/turf/flooring/wood_greyscale.dmi'
	icon_base = "wood_tile"
	has_damage_range = 2
	build_type = /obj/item/stack/tile/wood/hardwood/tile

/decl/flooring/wood/oak
	name = "wooden floor"
	desc = "Polished oak planks."
	icon = 'icons/turf/flooring/wood_greyscale.dmi'
	icon_base = "wood"
	has_damage_range = 6
	damage_temperature = T0C+200
	descriptor = "planks"
	build_type = /obj/item/stack/tile/wood/oak
	flags = TURF_CAN_BREAK | TURF_REMOVE_CROWBAR | TURF_REMOVE_SCREWDRIVER

/decl/flooring/wood/oak/panel
	desc = "Polished oak panels."
	icon = 'icons/turf/flooring/wood_greyscale.dmi'
	icon_base = "wood_panel"
	has_damage_range = 2
	build_type = /obj/item/stack/tile/wood/oak/panel

/decl/flooring/wood/oak/parquet
	desc = "Polished oak tiles."
	icon = 'icons/turf/flooring/wood_greyscale.dmi'
	icon_base = "wood_parquet"
	build_type = /obj/item/stack/tile/wood/oak/parquet

/decl/flooring/wood/oak/tile
	desc = "Polished oak tiles."
	icon = 'icons/turf/flooring/wood_greyscale.dmi'
	icon_base = "wood_tile"
	has_damage_range = 2
	build_type = /obj/item/stack/tile/wood/oak/tile

/decl/flooring/wood/pine
	name = "wooden floor"
	desc = "Polished pine planks."
	icon = 'icons/turf/flooring/wood_greyscale.dmi'
	icon_base = "wood"
	has_damage_range = 6
	damage_temperature = T0C+200
	descriptor = "planks"
	build_type = /obj/item/stack/tile/wood/pine
	flags = TURF_CAN_BREAK | TURF_REMOVE_CROWBAR | TURF_REMOVE_SCREWDRIVER

/decl/flooring/wood/pine/panel
	desc = "Polished pine panels."
	icon = 'icons/turf/flooring/wood_greyscale.dmi'
	icon_base = "wood_panel"
	has_damage_range = 2
	build_type = /obj/item/stack/tile/wood/pine/panel

/decl/flooring/wood/pine/parquet
	desc = "Polished pine tiles."
	icon = 'icons/turf/flooring/wood_greyscale.dmi'
	icon_base = "wood_parquet"
	build_type = /obj/item/stack/tile/wood/pine/parquet

/decl/flooring/wood/pine/tile
	desc = "Polished pine tiles."
	icon = 'icons/turf/flooring/wood_greyscale.dmi'
	icon_base = "wood_tile"
	has_damage_range = 2
	build_type = /obj/item/stack/tile/wood/pine/tile

/decl/flooring/wood/redwood
	name = "wooden floor"
	desc = "Polished redwood planks."
	icon = 'icons/turf/flooring/wood_greyscale.dmi'
	icon_base = "wood"
	has_damage_range = 6
	damage_temperature = T0C+200
	descriptor = "planks"
	build_type = /obj/item/stack/tile/wood/redwood
	flags = TURF_CAN_BREAK | TURF_REMOVE_CROWBAR | TURF_REMOVE_SCREWDRIVER

/decl/flooring/wood/redwood/panel
	desc = "Polished redwood panels."
	icon = 'icons/turf/flooring/wood_greyscale.dmi'
	icon_base = "wood_panel"
	has_damage_range = 2
	build_type = /obj/item/stack/tile/wood/redwood/panel

/decl/flooring/wood/redwood/parquet
	desc = "Polished redwood tiles."
	icon = 'icons/turf/flooring/wood_greyscale.dmi'
	icon_base = "wood_parquet"
	build_type = /obj/item/stack/tile/wood/redwood/parquet

/decl/flooring/wood/redwood/tile
	desc = "Polished redwood tiles."
	icon = 'icons/turf/flooring/wood_greyscale.dmi'
	icon_base = "wood_tile"
	has_damage_range = 2
	build_type = /obj/item/stack/tile/wood/redwood/tile
