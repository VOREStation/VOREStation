/turf/simulated/floor/tiled/asteroid_steel/outdoors
	name = "weathered tiles"
	desc = "Old tiles left out in the elements."
	outdoors = OUTDOORS_YES
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
		"dirt3" = 25,
		"dirt4" = 25,
		"dirt5" = 10,
		"dirt6" = 10,
		"dirt7" = 3,
		"dirt8" = 3,
		"dirt9" = 1
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
	icon_state = "sidewalk"
	edge_blending_priority = 1
	movement_cost = -0.5
	initial_flooring = /decl/flooring/outdoors/sidewalk
	can_dirty = TRUE

/decl/flooring/outdoors/sidewalk
	name = "sidewalk"
	desc = "Concrete shaped into a path!"
	icon = 'icons/turf/outdoors_vr.dmi'
	icon_base = "sidewalk"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/LightStone1.ogg',
		'sound/effects/footstep/LightStone2.ogg',
		'sound/effects/footstep/LightStone3.ogg',
		'sound/effects/footstep/LightStone4.ogg',))

/turf/simulated/floor/outdoors/sidewalk/Initialize(mapload)
	var/possibledirts = list(
		"[initial(icon_state)]" = 150,
		"[initial(icon_state)]1" = 3,
		"[initial(icon_state)]2" = 3,
		"[initial(icon_state)]3" = 3,
		"[initial(icon_state)]4" = 3,
		"[initial(icon_state)]5" = 3,
		"[initial(icon_state)]6" = 2,
		"[initial(icon_state)]7" = 2,
		"[initial(icon_state)]8" = 2,
		"[initial(icon_state)]9" = 2,
		"[initial(icon_state)]10" = 2		
	)
	flooring_override = pickweight(possibledirts)
	return ..()	

/turf/simulated/floor/outdoors/sidewalk/side
	icon_state = "side-walk"

/turf/simulated/floor/outdoors/sidewalk/slab
	icon_state = "slab"
