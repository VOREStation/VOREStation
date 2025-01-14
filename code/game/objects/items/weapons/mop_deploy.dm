/obj/item/mop_deploy
	name = "mop"
	desc = "Deployable mop."
	icon = 'icons/obj/janitor.dmi'
	icon_state = "mop"
	force = 3
	anchored = TRUE    // Never spawned outside of inventory, should be fine.
	throwforce = 1  //Throwing or dropping the item deletes it.
	throw_speed = 1
	throw_range = 1
	w_class = ITEMSIZE_LARGE//So you can't hide it in your pocket or some such.
	attack_verb = list("mopped", "bashed", "bludgeoned", "whacked")
	var/mob/living/creator
	var/mopping = 0
	var/mopcount = 0


/obj/item/mop_deploy/New()
	create_reagents(5)
	START_PROCESSING(SSobj, src)

/turf/proc/clean_deploy(atom/source)
	if(source.reagents.has_reagent(REAGENT_ID_WATER, 1))
		clean_blood()
		if(istype(src, /turf/simulated))
			var/turf/simulated/T = src
			T.dirt = 0
		for(var/obj/effect/O in src)
			if(istype(O,/obj/effect/rune) || istype(O,/obj/effect/decal/cleanable) || istype(O,/obj/effect/overlay))
				qdel(O)
/*	//Reagent code changed at some point and the below doesn't work.  To be fixed later.
	source.reagents.reaction(src, TOUCH, 10)	//10 is the multiplier for the reaction effect. probably needed to wet the floor properly.
	source.reagents.remove_any(1)				//reaction() doesn't use up the reagents
*/
/obj/item/mop_deploy/afterattack(atom/A, mob/user, proximity)
	if(!proximity) return
	if(istype(A, /turf) || istype(A, /obj/effect/decal/cleanable) || istype(A, /obj/effect/overlay) || istype(A, /obj/effect/rune))
		user.visible_message(span_warning("[user] begins to clean \the [get_turf(A)]."))

		if(do_after(user, 40))
			var/turf/T = get_turf(A)
			if(T)
				T.clean_deploy(src)
			to_chat(user, span_notice("You have finished mopping!"))

/obj/effect/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/mop_deploy) || istype(I, /obj/item/soap))
		return
	..()

/obj/item/mop_deploy/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/mop_deploy/attack_self(mob/user as mob)
	user.drop_from_inventory(src)
	spawn(1) if(!QDELETED(src)) qdel(src)

/obj/item/mop_deploy/dropped(mob/user)
	..()
	spawn(1) if(!QDELETED(src)) qdel(src)

/obj/item/mop_deploy/process()
	if(!creator || loc != creator || !creator.item_is_in_hands(src))
		// Tidy up a bit.
		if(isliving(loc))
			var/mob/living/carbon/human/host = loc
			if(istype(host))
				for(var/obj/item/organ/external/organ in host.organs)
					for(var/obj/item/O in organ.implants)
						if(O == src)
							organ.implants -= src
			host.pinned -= src
			host.embedded -= src
			host.drop_from_inventory(src)
		spawn(1) if(!QDELETED(src)) qdel(src)
