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
	skip_init = FALSE
	movement_cost = 4 // Water should slow you down, just like simulated turf.

/turf/unsimulated/beach/water/Initialize()
	. = ..()
	add_overlay(image("icon"='icons/misc/beach.dmi',"icon_state"="water2","layer"=MOB_LAYER+0.1))

/turf/simulated/floor/beach
	name = "Beach"
	icon = 'icons/misc/beach.dmi'
	initial_flooring = /decl/flooring/sand

/turf/simulated/floor/beach/sand
	name = "Sand"
	icon_state = "sand"
	initial_flooring = /decl/flooring/sand

/turf/simulated/floor/beach/sand/desert
	icon = 'icons/turf/desert.dmi'
	icon_state = "desert"
	initial_flooring = /decl/flooring/sand/desert

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
	movement_cost = 4 // Water should slow you down, just like the original simulated turf.
	initial_flooring = /decl/flooring/water

/turf/simulated/floor/beach/water/ocean
	icon_state = "seadeep"
	movement_cost = 8 // Deep water should be difficult to wade through.
	initial_flooring = /decl/flooring/water/beach/deep

/turf/simulated/floor/beach/water/Initialize()
	. = ..()
	add_overlay(image("icon"='icons/misc/beach.dmi',"icon_state"="water5","layer"=MOB_LAYER+0.1))

/decl/flooring/water/beach/deep // We're custom-defining a 'deep' water turf for the beach.
	name = "deep water"
	desc = "Deep Ocean Water"
	icon = 'icons/misc/beach.dmi'
	icon_base = "seadeep"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/bubbles3.ogg', // No I don't get why it's named 3/4/5 either. Whatever.
		'sound/effects/footstep/bubbles4.ogg',
		'sound/effects/footstep/bubbles5.ogg'))
