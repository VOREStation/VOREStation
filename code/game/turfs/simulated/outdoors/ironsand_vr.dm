/turf/simulated/floor/outdoors/ironsand
	name = "iron sand"
	desc = "Red and gritty."
	icon = 'icons/turf/flooring/ironsand_vr.dmi'
	icon_state = "ironsand1"
	edge_blending_priority = 1
	initial_flooring = /decl/flooring/outdoors/ironsand

/decl/flooring/outdoors/ironsand
	name = "iron sand"
	desc = "Red and gritty."
	icon = 'icons/turf/flooring/ironsand_vr.dmi'
	icon_base = "ironsand1"

/turf/simulated/floor/outdoors/ironsand/Initialize(mapload)
	var/possiblesands = list(
		"ironsand1" = 50,
		"ironsand2" = 1,
		"ironsand3" = 1,
		"ironsand4" = 1,
		"ironsand5" = 1,
		"ironsand6" = 1,
		"ironsand7" = 1,
		"ironsand8" = 1,
		"ironsand9" = 1,
		"ironsand10" = 1,
		"ironsand11" = 1,
		"ironsand12" = 1,
		"ironsand13" = 1,
		"ironsand14" = 1,
		"ironsand15" = 1

	)
	flooring_override = pickweight(possiblesands)
	return ..()
