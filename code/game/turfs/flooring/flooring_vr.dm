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
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/mud1.ogg',
		'sound/effects/footstep/mud2.ogg',
		'sound/effects/footstep/mud3.ogg',
		'sound/effects/footstep/mud4.ogg'
		))

/decl/flooring/grass/outdoors
	flags = 0
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
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/floor1.ogg',
		'sound/effects/footstep/floor2.ogg',
		'sound/effects/footstep/floor3.ogg',
		'sound/effects/footstep/floor4.ogg',
		'sound/effects/footstep/floor5.ogg'))

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
