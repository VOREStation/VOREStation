/turf/unsimulated
	name = "command"
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD
	initialized = TRUE // Don't call init on unsimulated turfs (at least not yet)

<<<<<<< HEAD
//VOREStation Add
/turf/unsimulated/fake_space
	name = "\proper space"
	icon = 'icons/turf/space.dmi'
	icon_state = "0"
	dynamic_lighting = FALSE

/turf/unsimulated/fake_space/New()
	..()
	icon_state = "[((x + y) ^ ~(x * y) + z) % 25]"
//VOREStation Add End

=======
>>>>>>> 1e492e8... Master to AI - Reloaded (#5710)
// Better nip this just in case.
/turf/unsimulated/rcd_values(mob/living/user, obj/item/weapon/rcd/the_rcd, passed_mode)
	return FALSE

/turf/unsimulated/rcd_act(mob/living/user, obj/item/weapon/rcd/the_rcd, passed_mode)
<<<<<<< HEAD
	return FALSE
=======
	return FALSE
>>>>>>> 1e492e8... Master to AI - Reloaded (#5710)
