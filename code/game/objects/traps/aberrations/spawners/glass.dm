//Fire abberation
/obj/effect/abstract/abberation/spawner/glass
	name = "Glass Abberation"
	effect_to_spawn = /obj/item/material/barbedwire/glass/start_active
	start_active = TRUE
	delete_after_placement = FALSE

/obj/effect/abstract/abberation/spawner/glass/perform_pulse()
	place_effects()
	return
