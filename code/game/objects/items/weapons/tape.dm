/obj/item/weapon/tape_roll
	name = "tape roll"
	desc = "A roll of sticky tape. Possibly for taping ducks... or was that ducts?"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "taperoll"
	w_class = ITEMSIZE_TINY
	drop_sound = 'sound/items/drop/box.ogg'

	toolspeed = 2 //It is now used in surgery as a not awful, but probably dangerous option, due to speed.

/obj/item/weapon/tape_roll/attack(var/mob/living/carbon/human/H, var/mob/user)
	if(istype(H))
		if(user.a_intent == I_HELP)
			return
		var/can_place = 0
		if(istype(user, /mob/living/silicon/robot))
			can_place = 1
		else
			for (var/obj/item/weapon/grab/G in H.grabbed_by)
				if (G.loc == user && G.state >= GRAB_AGGRESSIVE)
					can_place = 1
					break
		if(!can_place)
			to_chat(user, "<span class='danger'>You need to have a firm grip on [H] before you can use \the [src]!</span>")
			return
		else
			if(user.zone_sel.selecting == O_EYES)

				if(!H.organs_by_name[BP_HEAD])
					to_chat(user, "<span class='warning'>\The [H] doesn't have a head.</span>")
					return
				if(!H.has_eyes())
					to_chat(user, "<span class='warning'>\The [H] doesn't have any eyes.</span>")
					return
				if(H.glasses)
					to_chat(user, "<span class='warning'>\The [H] is already wearing somethign on their eyes.</span>")
					return
				if(H.head && (H.head.body_parts_covered & FACE))
					to_chat(user, "<span class='warning'>Remove their [H.head] first.</span>")
					return
				user.visible_message("<span class='danger'>\The [user] begins taping over \the [H]'s eyes!</span>")

				if(!do_after(user, 30))
					return

				can_place = 0

				if(istype(user, /mob/living/silicon/robot))
					can_place = 1
				else
					for (var/obj/item/weapon/grab/G in H.grabbed_by)
						if (G.loc == user && G.state >= GRAB_AGGRESSIVE)
							can_place = 1

				if(!can_place)
					return

				if(!H || !src || !H.organs_by_name[BP_HEAD] || !H.has_eyes() || H.glasses || (H.head && (H.head.body_parts_covered & FACE)))
					return

				user.visible_message("<span class='danger'>\The [user] has taped up \the [H]'s eyes!</span>")
				H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/blindfold/tape(H), slot_glasses)
				H.update_inv_glasses()
				playsound(src, 'sound/effects/tape.ogg',25)

			else if(user.zone_sel.selecting == O_MOUTH || user.zone_sel.selecting == BP_HEAD)
				if(!H.organs_by_name[BP_HEAD])
					to_chat(user, "<span class='warning'>\The [H] doesn't have a head.</span>")
					return
				if(!H.check_has_mouth())
					to_chat(user, "<span class='warning'>\The [H] doesn't have a mouth.</span>")
					return
				if(H.wear_mask)
					to_chat(user, "<span class='warning'>\The [H] is already wearing a mask.</span>")
					return
				if(H.head && (H.head.body_parts_covered & FACE))
					to_chat(user, "<span class='warning'>Remove their [H.head] first.</span>")
					return
				user.visible_message("<span class='danger'>\The [user] begins taping up \the [H]'s mouth!</span>")

				if(!do_after(user, 30))
					return

				can_place = 0

				if(istype(user, /mob/living/silicon/robot))
					can_place = 1
				else
					for (var/obj/item/weapon/grab/G in H.grabbed_by)
						if (G.loc == user && G.state >= GRAB_AGGRESSIVE)
							can_place = 1

				if(!can_place)
					return

				if(!H || !src || !H.organs_by_name[BP_HEAD] || !H.check_has_mouth() || (H.head && (H.head.body_parts_covered & FACE)))
					return

				user.visible_message("<span class='danger'>\The [user] has taped up \the [H]'s mouth!</span>")

				H.equip_to_slot_or_del(new /obj/item/clothing/mask/muzzle/tape(H), slot_wear_mask)
				H.update_inv_wear_mask()
				playsound(src, 'sound/effects/tape.ogg',25)

			else if(user.zone_sel.selecting == "r_hand" || user.zone_sel.selecting == "l_hand")
				can_place = 0

				if(istype(user, /mob/living/silicon/robot))
					can_place = 1
				else
					for (var/obj/item/weapon/grab/G in H.grabbed_by)
						if (G.loc == user && G.state >= GRAB_AGGRESSIVE)
							can_place = 1

				if(!can_place)
					return

				var/obj/item/weapon/handcuffs/cable/tape/T = new(user)
				playsound(src, 'sound/effects/tape.ogg',25)

				if(!T.place_handcuffs(H, user))
					user.unEquip(T)
					qdel(T)
			else
				return ..()
			return 1

/obj/item/weapon/tape_roll/proc/stick(var/obj/item/weapon/W, mob/user)
	if(!istype(W, /obj/item/weapon/paper))
		return
	user.drop_from_inventory(W)
	var/obj/item/weapon/ducttape/tape = new(get_turf(src))
	tape.attach(W)
	user.put_in_hands(tape)
	playsound(src, 'sound/effects/tape.ogg',25)

/obj/item/weapon/ducttape
	name = "tape"
	desc = "A piece of sticky tape."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "tape"
	w_class = ITEMSIZE_TINY
	plane = MOB_PLANE
	anchored = FALSE
	drop_sound = null

	var/obj/item/weapon/stuck = null

/obj/item/weapon/ducttape/New()
	..()
	flags |= NOBLUDGEON

/obj/item/weapon/ducttape/examine(mob/user)
	return stuck.examine(user)

/obj/item/weapon/ducttape/proc/attach(var/obj/item/weapon/W)
	stuck = W
	W.forceMove(src)
	icon_state = W.icon_state + "_taped"
	name = W.name + " (taped)"
	overlays = W.overlays

/obj/item/weapon/ducttape/attack_self(mob/user)
	if(!stuck)
		return

	to_chat(user, "You remove \the [initial(name)] from [stuck].")

	user.drop_from_inventory(src)
	stuck.forceMove(get_turf(src))
	user.put_in_hands(stuck)
	stuck = null
	overlays = null
	qdel(src)

/obj/item/weapon/ducttape/attackby(var/obj/item/I, var/mob/user)
	if(!(istype(src, /obj/item/weapon/handcuffs/cable/tape) || istype(src, /obj/item/clothing/mask/muzzle/tape)))
		return ..()
	else
		user.drop_from_inventory(I)
		I.loc = src
		qdel(I)
		to_chat(user, "<span-class='notice'>You place \the [I] back into \the [src].</span>")

/obj/item/weapon/ducttape/attack_hand(mob/living/L)
	anchored = FALSE
	return ..() // Pick it up now that it's unanchored.

/obj/item/weapon/ducttape/afterattack(var/A, mob/user, flag, params)

	if(!in_range(user, A) || istype(A, /obj/machinery/door) || !stuck)
		return

	var/turf/target_turf = get_turf(A)
	var/turf/source_turf = get_turf(user)

	var/dir_offset = 0
	if(target_turf != source_turf)
		dir_offset = get_dir(source_turf, target_turf)
		if(!(dir_offset in cardinal))
			to_chat(user, "You cannot reach that from here.")		// can only place stuck papers in cardinal directions, to
			return											// reduce papers around corners issue.

	user.drop_from_inventory(src)
	playsound(src, 'sound/effects/tape.ogg',25)
	forceMove(source_turf)
	anchored = TRUE

	if(params)
		var/list/mouse_control = params2list(params)
		if(mouse_control["icon-x"])
			pixel_x = text2num(mouse_control["icon-x"]) - 16
			if(dir_offset & EAST)
				pixel_x += 32
			else if(dir_offset & WEST)
				pixel_x -= 32
		if(mouse_control["icon-y"])
			pixel_y = text2num(mouse_control["icon-y"]) - 16
			if(dir_offset & NORTH)
				pixel_y += 32
			else if(dir_offset & SOUTH)
				pixel_y -= 32
