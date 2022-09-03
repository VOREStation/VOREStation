/mob/living/simple_mob/animal/passive/fennec
	name = "fennec"
	desc = "A fox preferring arid climates, also known as a dingler, or a goob."
	tt_desc = "Vulpes Zerda"
	icon_state = "fennec"
	item_state = "fennec"

	movement_cooldown = 0.5 SECONDS

	see_in_dark = 6
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"

	holder_type = /obj/item/weapon/holder/fennec
	mob_size = MOB_SMALL

	has_langs = list(LANGUAGE_ANIMAL)

/mob/living/simple_mob/animal/passive/fennec/faux
	name = "faux"
	desc = "Domesticated fennec. Seems to like screaming just as much though."

/mob/living/simple_mob/animal/passive/fennec/Initialize()
	icon_living = "[initial(icon_state)]"
	icon_dead = "[initial(icon_state)]_dead"
	icon_rest = "[initial(icon_state)]_rest"
	update_icon()
	return ..()
