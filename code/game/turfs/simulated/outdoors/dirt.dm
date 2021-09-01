<<<<<<< HEAD
/turf/simulated/floor/outdoors/dirt
	name = "dirt"
	desc = "Quite dirty!"
	icon_state = "dirt-dark"
	edge_blending_priority = 2
	turf_layers = list(/turf/simulated/floor/outdoors/rocks)
	initial_flooring = /decl/flooring/dirt
=======
/turf/simulated/floor/outdoors/dirt
	name = "dirt"
	desc = "Quite dirty!"
	icon_state = "dirt-dark"
	edge_blending_priority = 2
	turf_layers = list(/turf/simulated/floor/outdoors/rocks)
	initial_flooring = /decl/flooring/dirt
	can_dig = TRUE

/turf/simulated/floor/outdoors/newdirt
	name = "dirt"
	desc = "Looks dirty."
	icon = 'icons/turf/outdoors.dmi'
	icon_state = "dirt0"
	edge_blending_priority = 2
	initial_flooring = /decl/flooring/outdoors/newdirt
	can_dig = TRUE
	var/static/possibledirts = list(
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

/decl/flooring/outdoors/newdirt
	name = "dirt"
	desc = "Looks dirty."
	icon = 'icons/turf/outdoors.dmi'
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
	flooring_override = pickweight(possibledirts)
	return ..()


/turf/simulated/floor/outdoors/newdirt_nograss
	name = "dirt"
	desc = "Looks dirty."
	icon = 'icons/turf/outdoors.dmi'
	icon_state = "dirt0"
	edge_blending_priority = 2
	initial_flooring = /decl/flooring/outdoors/newdirt
	var/static/possibledirts = list(
		"dirt0" = 200,
		"dirt3" = 20,
		"dirt4" = 3,
		"dirt5" = 3,
		"dirt6" = 1
	)

/turf/simulated/floor/outdoors/newdirt_nograss/Initialize(mapload)
	flooring_override = pickweight(possibledirts)
	return ..()
>>>>>>> 80cce5e84ce... Merge pull request #8245 from Cerebulon/outdoorsprites
