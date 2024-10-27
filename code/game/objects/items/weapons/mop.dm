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
	var/mopping = 0
	var/mopcount = 0

/obj/item/mop/New()
	create_reagents(30)
	..()

/obj/item/mop/afterattack(atom/A, mob/user, proximity)
	if(!proximity) return
	if(istype(A, /turf) || istype(A, /obj/effect/decal/cleanable) || istype(A, /obj/effect/overlay) || istype(A, /obj/effect/rune))
		if(reagents.total_volume < 1)
			to_chat(user, span_notice("Your mop is dry!"))
			return

		user.visible_message(span_warning("[user] begins to clean \the [get_turf(A)]."))

		if(do_after(user, 40))
			var/turf/T = get_turf(A)
			if(T)
				T.clean(src, user)
			to_chat(user, span_notice("You have finished mopping!"))


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

/obj/item/mop/advanced/New()
	create_reagents(30)
	..()

/obj/item/mop/advanced/afterattack(atom/A, mob/user, proximity)
	if(!proximity) return
	if(istype(A, /turf) || istype(A, /obj/effect/decal/cleanable) || istype(A, /obj/effect/overlay) || istype(A, /obj/effect/rune))
		if(reagents.total_volume < 1)
			to_chat(user, span_notice("Your mop is dry!"))
			return

		user.visible_message(span_warning("[user] begins to clean \the [get_turf(A)]."))

		if(do_after(user, 20))
			var/turf/T = get_turf(A)
			if(T)
				T.clean(src, user)
			to_chat(user, span_notice("You have finished mopping!"))
