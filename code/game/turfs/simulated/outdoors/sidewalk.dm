/turf/simulated/floor/outdoors/sidewalk
	name = "sidewalk"
	desc = "Concrete shaped into a path!"
	icon = 'icons/turf/outdoors.dmi'
	icon_state = "sidewalk"
	edge_blending_priority = 1
	movement_cost = -0.5
	initial_flooring = /decl/flooring/outdoors/sidewalk
	var/static/possibledirts = list(
		"" = 150,
		"1" = 3,
		"2" = 3,
		"3" = 3,
		"4" = 3,
		"5" = 3,
		"6" = 2,
		"7" = 2,
		"8" = 2,
		"9" = 2,
		"10" = 2
	)

/decl/flooring/outdoors/sidewalk
	name = "sidewalk"
	desc = "Concrete shaped into a path!"
	icon = 'icons/turf/outdoors.dmi'
	icon_base = "sidewalk"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/LightStone1.ogg',
		'sound/effects/footstep/LightStone2.ogg',
		'sound/effects/footstep/LightStone3.ogg',
		'sound/effects/footstep/LightStone4.ogg',))

/turf/simulated/floor/outdoors/sidewalk/Initialize(mapload)
	flooring_override = "[initial(icon_state)][pickweight(possibledirts)]"
	return ..()

/turf/simulated/floor/outdoors/sidewalk/side
	icon_state = "side-walk"

/turf/simulated/floor/outdoors/sidewalk/slab
	icon_state = "slab"