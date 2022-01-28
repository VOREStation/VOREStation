/mob/living/simple_mob
	gib_on_butchery = TRUE
	butchery_drops_organs = FALSE

/mob/living/simple_mob/can_butcher(var/mob/user, var/obj/item/I)	// Override for special butchering checks.
	return ..() && I.sharp && I.edge