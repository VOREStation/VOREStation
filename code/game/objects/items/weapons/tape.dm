/obj/item/tape_roll
	name = "tape roll"
	desc = "A roll of sticky tape. Possibly for taping ducks... or was that ducts?"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "taperoll"
	w_class = ITEMSIZE_TINY
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'

	toolspeed = 2 //It is now used in surgery as a not awful, but probably dangerous option, due to speed.

/obj/item/tape_roll/proc/can_place(var/mob/living/carbon/human/H, var/mob/user)
	if(isrobot(user) || user == H)
		return TRUE

	for (var/obj/item/grab/G in H.grabbed_by)
		if (G.loc == user && G.state >= GRAB_AGGRESSIVE)
			return TRUE

	return FALSE

/obj/item/tape_roll/attack(var/mob/living/carbon/human/H, var/mob/user)
	if(istype(H))
		if(user.a_intent == I_HELP)
			return
		if(!can_place(H, user))
			to_chat(user, span_danger("You need to have a firm grip on [H] before you can use \the [src]!"))
			return
		else
			if(user.zone_sel.selecting == O_EYES)

				if(!H.organs_by_name[BP_HEAD])
					to_chat(user, span_warning("\The [H] doesn't have a head."))
					return
				if(!H.has_eyes())
					to_chat(user, span_warning("\The [H] doesn't have any eyes."))
					return
				if(H.glasses)
					to_chat(user, span_warning("\The [H] is already wearing something on their eyes."))
					return
				if(H.head && (H.head.body_parts_covered & FACE))
					to_chat(user, span_warning("Remove their [H.head] first."))
					return
				user.visible_message(span_danger("\The [user] begins taping over \the [H]'s eyes!"))

				if(!do_after(user, 30))
					return

				if(!can_place(H, user))
					return

				if(!H || !src || !H.organs_by_name[BP_HEAD] || !H.has_eyes() || H.glasses || (H.head && (H.head.body_parts_covered & FACE)))
					return

				user.visible_message(span_danger("\The [user] has taped up \the [H]'s eyes!"))
				H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/blindfold/tape(H), slot_glasses, ignore_obstructions = FALSE)
				H.update_inv_glasses()
				playsound(src, 'sound/effects/tape.ogg',25)

			else if(user.zone_sel.selecting == O_MOUTH || user.zone_sel.selecting == BP_HEAD)
				if(!H.organs_by_name[BP_HEAD])
					to_chat(user, span_warning("\The [H] doesn't have a head."))
					return
				if(!H.check_has_mouth())
					to_chat(user, span_warning("\The [H] doesn't have a mouth."))
					return
				if(H.wear_mask)
					to_chat(user, span_warning("\The [H] is already wearing a mask."))
					return
				if(H.head && (H.head.body_parts_covered & FACE))
					to_chat(user, span_warning("Remove their [H.head] first."))
					return
				user.visible_message(span_danger("\The [user] begins taping up \the [H]'s mouth!"))

				if(!do_after(user, 30))
					return

				if(!can_place(H, user))
					return

				if(!H || !src || !H.organs_by_name[BP_HEAD] || !H.check_has_mouth() || (H.head && (H.head.body_parts_covered & FACE)))
					return

				user.visible_message(span_danger("\The [user] has taped up \the [H]'s mouth!"))

				H.equip_to_slot_or_del(new /obj/item/clothing/mask/muzzle/tape(H), slot_wear_mask, ignore_obstructions = FALSE)
				H.update_inv_wear_mask()
				playsound(src, 'sound/effects/tape.ogg',25)

			else if(user.zone_sel.selecting == BP_R_HAND || user.zone_sel.selecting == BP_L_HAND)
				if(!can_place(H, user))
					return

				var/obj/item/handcuffs/cable/tape/T = new(user)
				playsound(src, 'sound/effects/tape.ogg',25)

				if(!T.place_handcuffs(H, user))
					user.unEquip(T)
					qdel(T)
			else
				return ..()
			return 1

/obj/item/tape_roll/proc/stick(var/obj/item/W, mob/user)
	if(!istype(W, /obj/item/paper) || istype(W, /obj/item/paper/sticky) || !user.unEquip(W))
		return
	user.drop_from_inventory(W)
	var/obj/item/ducttape/tape = new(get_turf(src))
	tape.attach(W)
	user.put_in_hands(tape)
	playsound(src, 'sound/effects/tape.ogg',25)

/obj/item/ducttape
	name = "tape"
	desc = "A piece of sticky tape."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "tape"
	w_class = ITEMSIZE_TINY
	plane = MOB_PLANE
	anchored = FALSE
	drop_sound = null
	flags = NOBLUDGEON

	var/obj/item/stuck = null

/obj/item/ducttape/examine(mob/user)
	SHOULD_CALL_PARENT(FALSE)
	return stuck.examine(user)

/obj/item/ducttape/proc/attach(var/obj/item/W)
	stuck = W
	W.forceMove(src)
	icon_state = W.icon_state + "_taped"
	name = W.name + " (taped)"
	overlays = W.overlays

/obj/item/ducttape/attack_self(mob/user)
	if(!stuck)
		return

	to_chat(user, "You remove \the [initial(name)] from [stuck].")

	user.drop_from_inventory(src)
	stuck.forceMove(get_turf(src))
	user.put_in_hands(stuck)
	stuck = null
	overlays = null
	qdel(src)

/obj/item/ducttape/attackby(var/obj/item/I, var/mob/user)
	if(!(istype(src, /obj/item/handcuffs/cable/tape) || istype(src, /obj/item/clothing/mask/muzzle/tape)))
		return ..()
	else
		user.drop_from_inventory(I)
		I.loc = src
		qdel(I)
		to_chat(user, span_notice("You place \the [I] back into \the [src]."))

/obj/item/ducttape/attack_hand(mob/living/L)
	anchored = FALSE
	return ..() // Pick it up now that it's unanchored.

/obj/item/ducttape/afterattack(var/A, mob/user, flag, params)

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
