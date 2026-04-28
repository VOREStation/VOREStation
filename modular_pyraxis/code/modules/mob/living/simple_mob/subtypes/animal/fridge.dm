/mob/living/simple_mob/fridge
	name = "fridge"
	desc = "Just a normal fridge! Looks like it's running."
	icon = 'icons/obj/closets/fridge.dmi'
	icon_state = "closed_locked"
	ai_holder_type = /datum/ai_holder/simple_mob/melee/hit_and_run/runner

/mob/living/simple_mob/fridge/death()
	. = ..()
	for(var/obj/structure/closet/freezer in contents)
		freezer.forceMove(get_turf(src))
	qdel(src)

/obj/structure/closet/secure_closet/freezer/meat/proc/make_alive()
	var/mob/living/simple_mob/fridge/alive_fridge = new(get_turf(src))
	forceMove(alive_fridge)
	return
