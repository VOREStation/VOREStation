/*
 *	Absorbs /obj/item/weapon/secstorage.
 *	Reimplements it only slightly to use existing storage functionality.
 *
 *	Contains:
 *		Secure Briefcase
 *		Wall Safe
 */

// -----------------------------
//         Generic Item
// -----------------------------
/obj/item/weapon/storage/secure
	name = "secstorage"
	var/icon_locking = "secureb"
	var/icon_sparking = "securespark"
	var/icon_opened = "secure0"
	var/locked = 1
	var/code = ""
	var/l_code = null
	var/l_set = 0
	var/l_setshort = 0
	var/l_hacking = 0
	var/emagged = 0
	var/open = 0
	w_class = ITEMSIZE_NORMAL
	max_w_class = ITEMSIZE_SMALL
	max_storage_space = ITEMSIZE_SMALL * 7
	use_sound = 'sound/items/storage/briefcase.ogg'

/obj/item/weapon/storage/secure/examine(mob/user)
	. = ..()
	if(Adjacent(user))
		. += "The service panel is [src.open ? "open" : "closed"]."

/obj/item/weapon/storage/secure/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(locked)
		if (istype(W, /obj/item/weapon/melee/energy/blade) && emag_act(INFINITY, user, "You slice through the lock of \the [src]"))
			var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
			spark_system.set_up(5, 0, src.loc)
			spark_system.start()
			playsound(src, 'sound/weapons/blade1.ogg', 50, 1)
			playsound(src, "sparks", 50, 1)
			return

		if (W.has_tool_quality(TOOL_SCREWDRIVER))
			if (do_after(user, 20 * W.toolspeed))
				src.open =! src.open
				playsound(src, W.usesound, 50, 1)
				user.show_message(text("<span class='notice'>You [] the service panel.</span>", (src.open ? "open" : "close")))
			return
		if (istype(W, /obj/item/device/multitool) && (src.open == 1)&& (!src.l_hacking))
			user.show_message("<span class='notice'>Now attempting to reset internal memory, please hold.</span>", 1)
			src.l_hacking = 1
			if (do_after(usr, 100))
				if (prob(40))
					src.l_setshort = 1
					src.l_set = 0
					src.code = ""
					user.show_message("<span class='notice'>Internal memory reset. Please give it a few seconds to reinitialize.</span>", 1)
					sleep(80)
					src.l_setshort = 0
					src.l_hacking = 0
				else
					user.show_message("<span class='warning'>Unable to reset internal memory.</span>", 1)
					src.l_hacking = 0
			else	src.l_hacking = 0
			return
		//At this point you have exhausted all the special things to do when locked
		// ... but it's still locked.
		return

	// -> storage/attackby() what with handle insertion, etc
	..()


/obj/item/weapon/storage/secure/MouseDrop(over_object, src_location, over_location)
	if (locked)
		src.add_fingerprint(usr)
		return
	..()

/obj/item/weapon/storage/secure/AltClick(mob/user as mob)
	if (isliving(user) && Adjacent(user) && (src.locked == 1))
		to_chat(user, "<span class='warning'>[src] is locked and cannot be opened!</span>")
	else if (isliving(user) && Adjacent(user) && (!src.locked))
		src.open(usr)
	else
		for(var/mob/M in range(1))
			if (M.s_active == src)
				src.close(M)
	src.add_fingerprint(user)
	return

/obj/item/weapon/storage/secure/attack_self(mob/user as mob)
	tgui_interact(user)

/obj/item/weapon/storage/secure/tgui_interact(mob/user, datum/tgui/ui = null)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SecureSafe", name)
		ui.open()

/obj/item/weapon/storage/secure/tgui_data(mob/user)
	var/list/data = list()
	data["locked"] = locked
	data["code"] = code
	data["emagged"] = emagged
	data["l_setshort"] = l_setshort
	data["l_set"] = l_set
	return data

/obj/item/weapon/storage/secure/tgui_act(action, params)
	if(..())
		return TRUE
	switch (action)
		if("type")
			var/digit = params["digit"]
			if(digit == "E")
				if ((src.l_set == 0) && (length(src.code) == 5) && (!src.l_setshort) && (src.code != "ERROR"))
					src.l_code = src.code
					src.l_set = 1
				else if ((src.code == src.l_code) && (src.emagged == 0) && (src.l_set == 1))
					src.locked = 0
					cut_overlays()
					add_overlay(icon_opened)
					src.code = null
				else
					src.code = "ERROR"
			else
				if ((digit == "R") && (src.emagged == 0) && (!src.l_setshort))
					src.locked = 1
					cut_overlays()
					src.code = null
					src.close(usr)
				else
					src.code += text("[]", digit)
					if (length(src.code) > 5)
						src.code = "ERROR"
	src.add_fingerprint(usr)
	. = TRUE
	return

/obj/item/weapon/storage/secure/emag_act(var/remaining_charges, var/mob/user, var/feedback)
	if(!emagged)
		emagged = 1
		src.add_overlay(icon_sparking)
		sleep(6)
		cut_overlays()
		add_overlay(icon_locking)
		locked = 0
		to_chat(user, (feedback ? feedback : "You short out the lock of \the [src]."))
		return 1

// -----------------------------
//        Secure Briefcase
// -----------------------------
/obj/item/weapon/storage/secure/briefcase
	name = "secure briefcase"
	icon = 'icons/obj/storage.dmi'
	icon_state = "secure"
	item_state_slots = list(slot_r_hand_str = "case", slot_l_hand_str = "case")
	desc = "A large briefcase with a digital locking system."
	force = 8.0
	throw_speed = 1
	throw_range = 4
	max_w_class = ITEMSIZE_NORMAL
	w_class = ITEMSIZE_LARGE
	max_storage_space = ITEMSIZE_COST_NORMAL * 4

/obj/item/weapon/storage/secure/briefcase/attack_hand(mob/user as mob)
	if ((src.loc == user) && (src.locked == 1))
		to_chat(user, "<span class='warning'>[src] is locked and cannot be opened!</span>")
	else if ((src.loc == user) && (!src.locked))
		src.open(usr)
	else
		..()
		for(var/mob/M in range(1))
			if (M.s_active == src)
				src.close(M)
	src.add_fingerprint(user)
	return

// -----------------------------
//        Secure Safe
// -----------------------------

/obj/item/weapon/storage/secure/safe
	name = "secure safe"
	desc = "It doesn't seem all that secure. Oh well, it'll do."
	icon = 'icons/obj/storage.dmi'
	icon_state = "safe"
	layer = ABOVE_WINDOW_LAYER
	icon_opened = "safe0"
	icon_locking = "safeb"
	icon_sparking = "safespark"
	force = 8.0
	w_class = ITEMSIZE_NO_CONTAINER
	max_w_class = ITEMSIZE_LARGE // This was 8 previously...
	anchored = TRUE
	density = FALSE
	cant_hold = list(/obj/item/weapon/storage/secure/briefcase)
	starts_with = list(
		/obj/item/weapon/paper,
		/obj/item/weapon/pen
	)

/obj/item/weapon/storage/secure/safe/attack_hand(mob/user as mob)
	tgui_interact(user)
