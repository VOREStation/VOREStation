/turf/simulated/floor/tiled/asteroid_steel/outdoors
	name = "weathered tiles"
	desc = "Old tiles left out in the elements."
	outdoors = 1
	edge_blending_priority = 1

/turf/simulated/floor/outdoors/newdirt
	name = "dirt"
	desc = "Looks dirty."
	icon = 'icons/turf/outdoors_vr.dmi'
	icon_state = "dirt0"
	edge_blending_priority = 2
	initial_flooring = /decl/flooring/outdoors/newdirt

/decl/flooring/outdoors/newdirt
	name = "dirt"
	desc = "Looks dirty."
	icon = 'icons/turf/outdoors_vr.dmi'
	icon_base = "dirt0"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/asteroid1.ogg',
		'sound/effects/footstep/asteroid2.ogg',
		'sound/effects/footstep/asteroid3.ogg',
		'sound/effects/footstep/asteroid4.ogg',
		'sound/effects/footstep/asteroid5.ogg',
		'sound/effects/footstep/MedDirt1.ogg',
		'sound/effects/footstep/MedDirt2.ogg',
		'sound/effects/footstep/MedDirt3.ogg',
		'sound/effects/footstep/MedDirt4.ogg'))

/turf/simulated/floor/outdoors/newdirt/Initialize(mapload)
	var/possibledirts = list(
		"dirt0" = 150,
		"dirt1" = 25,
		"dirt2" = 25,
		"dirt3" = 10,
		"dirt4" = 3,
		"dirt5" = 3,
		"dirt6" = 1,
		"dirt7" = 25,
		"dirt8" = 10,
		"dirt9" = 25
	)
	flooring_override = pickweight(possibledirts)
	return ..()	


/turf/simulated/floor/outdoors/newdirt_nograss
	name = "dirt"
	desc = "Looks dirty."
	icon = 'icons/turf/outdoors_vr.dmi'
	icon_state = "dirt0"
	edge_blending_priority = 2
	initial_flooring = /decl/flooring/outdoors/newdirt

/turf/simulated/floor/outdoors/newdirt_nograss/Initialize(mapload)
	var/possibledirts = list(
		"dirt0" = 200,
		"dirt3" = 20,
		"dirt4" = 3,
		"dirt5" = 3,
		"dirt6" = 1
	)
	flooring_override = pickweight(possibledirts)
	return ..()	

/turf/simulated/floor/outdoors/sidewalk
	name = "sidewalk"
	desc = "Concrete shaped into a path!"
	icon = 'icons/turf/outdoors_vr.dmi'
	icon_state = "sidewalk0"
	edge_blending_priority = 1
	movement_cost = -0.5
	initial_flooring = /decl/flooring/outdoors/sidewalk

/decl/flooring/outdoors/sidewalk
	name = "sidewalk"
	desc = "Concrete shaped into a path!"
	icon = 'icons/turf/outdoors_vr.dmi'
	icon_base = "sidewalk0"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/LightStone1.ogg',
		'sound/effects/footstep/LightStone2.ogg',
		'sound/effects/footstep/LightStone3.ogg',
		'sound/effects/footstep/LightStone4.ogg',))

/turf/simulated/floor/outdoors/sidewalk/Initialize(mapload)
	var/possibledirts = list(
		"sidewalk0" = 150,
		"sidewalk1" = 3,
		"sidewalk2" = 3,
		"sidewalk3" = 3,
		"sidewalk4" = 3,
		"sidewalk5" = 3,
		"sidewalk6" = 2,
		"sidewalk7" = 2,
		"sidewalk8" = 2,
		"sidewalk9" = 2,
		"sidewalk10" = 2		
	)
	flooring_override = pickweight(possibledirts)
	return ..()	
