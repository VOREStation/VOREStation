//Fire aberration
/obj/effect/abstract/aberration/spawner/glass
	name = "Glass aberration"
	effect_to_spawn = /obj/item/material/barbedwire/glass/start_active
	start_active = TRUE
	delete_after_placement = FALSE

/obj/effect/abstract/aberration/spawner/glass/small
	range = 2
	percent_drop = 30

/obj/effect/abstract/aberration/spawner/glass/perform_pulse()
	place_effects()
	return
