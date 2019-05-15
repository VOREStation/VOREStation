// Micro Holders - Extends /obj/item/weapon/holder

/obj/item/weapon/holder/micro
	name = "micro"
	desc = "Another crewmember, small enough to fit in your hand."
	icon_state = "micro"
	slot_flags = SLOT_FEET | SLOT_HEAD | SLOT_ID
	w_class = ITEMSIZE_SMALL
	item_icons = list() // No in-hand sprites (for now, anyway, we could totally add some)
	pixel_y = 0			// Override value from parent.

/obj/item/weapon/holder/micro/examine(var/mob/user)
	for(var/mob/living/M in contents)
		M.examine(user)

/obj/item/weapon/holder/MouseDrop(mob/M as mob)
	..()
	if(M != usr) return
	if(usr == src) return
	if(!Adjacent(usr)) return
	if(istype(M,/mob/living/silicon/ai)) return
	for(var/mob/living/carbon/human/O in contents)
		O.show_inv(usr)

/obj/item/weapon/holder/micro/attack_self(var/mob/living/user)
	for(var/mob/living/carbon/human/M in contents)
		M.help_shake_act(user)

/obj/item/weapon/holder/micro/update_state()
	if(istype(loc,/turf) || !(held_mob) || !(held_mob.loc == src))
		qdel(src)

/obj/item/weapon/holder/micro/Destroy()
	var/turf/here = get_turf(src)
	for(var/atom/movable/A in src)
		A.forceMove(here)
	return ..()



/obj/item/weapon/holder/structure
	w_class = ITEMSIZE_HUGE
	slot_flags = null
	item_icons = list()
	pixel_y = 0
	var/mob/living/grabber


/obj/item/weapon/holder/structure/sync(obj/M)
	dir = 2
	overlays.Cut()
	icon = M.icon
	icon_state = M.icon_state
	item_state = M.item_state
	color = M.color
	name = M.name
	desc = M.desc
	overlays |= M.overlays
	var/mob/living/carbon/human/H = loc
	if(istype(H))
		if(H.l_hand == src)
			H.update_inv_l_hand()
		else if(H.r_hand == src)
			H.update_inv_r_hand()

/obj/item/weapon/holder/structure/process()
	if(grabber.size_multiplier < RESIZE_BIG)
		grabber.drop_from_inventory(src)
	update_state()

/obj/item/weapon/holder/structure/update_state()
	if(istype(loc,/turf))
		qdel(src)

/obj/item/weapon/holder/structure/Destroy()
	for(var/atom/movable/A in src)
		A.forceMove(get_turf(src))
	return ..()

/obj/structure/AltClick(mob/living/carbon/human/H)			// I use AltClick because attack_hand is used by many objects and may result in unpredictable fun
	if(istype(H) && Adjacent(H) && H.a_intent != I_HELP && !anchored && !H.lying)		//Intent is for the case we want to use original AltClick function (if any), not pick object up
		if(H.size_multiplier  >= RESIZE_BIG)
			get_picked_up(H)
			return
	return ..()

/obj/machinery/AltClick(mob/living/carbon/human/H)
	if(istype(H) && Adjacent(H) && H.a_intent != I_HELP && !anchored && !H.lying)
		if(H.size_multiplier  >= RESIZE_BIG)
			get_picked_up(H)
			return
	return ..()


/obj/structure/proc/get_picked_up(var/mob/living/carbon/human/grabber)
	if(grabber.incapacitated())
		return

	var/obj/item/weapon/holder/structure/H = new /obj/item/weapon/holder/structure(get_turf(src))
	H.grabber = grabber
	src.forceMove(H)
	grabber.put_in_hands(H)

	grabber.visible_message("<span class='warning'>[grabber] lifts up [src]!</span>")

	H.sync(src)
	return H

/obj/machinery/proc/get_picked_up(var/mob/living/carbon/human/grabber)
	if(grabber.incapacitated())
		return

	var/obj/item/weapon/holder/structure/H = new /obj/item/weapon/holder/structure(get_turf(src))
	H.grabber = grabber
	src.forceMove(H)
	grabber.put_in_hands(H)

	grabber.visible_message("<span class='warning'>[grabber] lifts up [src]!</span>")

	H.sync(src)
	return H

//You can't resist out of closet if said closet was picked up. Feature? Like, you holding the door, not allowing people to break outside