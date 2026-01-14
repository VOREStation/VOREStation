GLOBAL_LIST_BOILERPLATE(all_mops, /obj/item/mop)

/*
 * Mop
 */
/obj/item/mop
	name = "mop"
	desc = "The world of janitalia wouldn't be complete without a mop."
	icon = 'icons/obj/janitor.dmi'
	icon_state = "mop"
	force = 3.0
	throwforce = 10.0
	throw_speed = 5
	throw_range = 10
	w_class = ITEMSIZE_NORMAL
	flags = NOCONDUCT
	attack_verb = list("mopped", "bashed", "bludgeoned", "whacked")
	///How long it takes to mop a tile.
	var/mop_time = 4 SECONDS

/obj/item/mop/Initialize(mapload)
	. = ..()
	create_reagents(30)

/obj/item/mop/afterattack(atom/A, mob/user, proximity)
	if(!proximity) return
	if(istype(A, /turf) || istype(A, /obj/effect/decal/cleanable) || istype(A, /obj/effect/overlay) || istype(A, /obj/effect/rune))
		if(reagents.total_volume < 1)
			user.balloon_alert(user, "your mop is dry!")
			return

		user.visible_message(span_warning("[user] begins to clean \the [get_turf(A)]."))

		if(do_after(user, mop_time, target = src, max_interact_count = 9))
			var/turf/T = get_turf(A)
			if(T)
				T.wash(CLEAN_SCRUB)
				reagents.trans_to_turf(T, 1, 10)
			user.balloon_alert(user, "you have finished mopping!")


/obj/effect/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/mop) || istype(I, /obj/item/soap))
		return
	..()

/*
 * Advanced Mop
 */
/obj/item/mop/advanced
	name = "advanced mop"
	desc = "No stain will go unclean."
	icon = 'icons/obj/janitor.dmi'
	icon_state = "adv_mop"
	force = 3.5
	throwforce = 10.5
	throw_speed = 4
	throw_range = 10
	w_class = ITEMSIZE_NORMAL
	flags = NOCONDUCT
	attack_verb = list("mopped", "bashed", "bludgeoned", "whacked")
	mop_time = 2 SECONDS
