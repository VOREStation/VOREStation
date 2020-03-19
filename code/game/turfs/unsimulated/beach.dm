/turf/unsimulated/beach
	name = "Beach"
	icon = 'icons/misc/beach.dmi'

/turf/unsimulated/beach/sand
	name = "Sand"
	icon_state = "sand"

/turf/unsimulated/beach/coastline
	name = "Coastline"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "sandwater"

/turf/unsimulated/beach/water
	name = "Water"
	icon_state = "water"
	initialized = FALSE

/turf/unsimulated/beach/water/Initialize()
	. = ..()
	add_overlay(image("icon"='icons/misc/beach.dmi',"icon_state"="water2","layer"=MOB_LAYER+0.1))

/turf/simulated/floor/beach
	name = "Beach"
	icon = 'icons/misc/beach.dmi'
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/carpet1.ogg',
		'sound/effects/footstep/carpet2.ogg',
		'sound/effects/footstep/carpet3.ogg',
		'sound/effects/footstep/carpet4.ogg',
		'sound/effects/footstep/carpet5.ogg'))

/turf/simulated/floor/beach/sand
	name = "Sand"
	icon_state = "sand"

/turf/simulated/floor/beach/sand/desert
	icon = 'icons/turf/desert.dmi'
	icon_state = "desert"

/turf/simulated/floor/beach/sand/desert/Initialize()
	. = ..()
	if(prob(5))
		icon_state = "desert[rand(0,4)]"

/turf/simulated/floor/beach/coastline
	name = "Coastline"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "sandwater"

/turf/simulated/floor/beach/water
	name = "Water"
	icon_state = "water"

/turf/simulated/floor/beach/water/ocean
	icon_state = "seadeep"

/turf/simulated/floor/beach/water/Initialize()
	. = ..()
	add_overlay(image("icon"='icons/misc/beach.dmi',"icon_state"="water5","layer"=MOB_LAYER+0.1))
