/mob/living
	var/hand = null
	var/obj/item/l_hand = null
	var/obj/item/r_hand = null
	var/obj/item/back = null//Human/Monkey
	var/obj/item/tank/internal = null//Human/Monkey
	var/obj/item/clothing/mask/wear_mask = null//Carbon

/mob/living/equip_to_storage(obj/item/newitem, user_initiated = FALSE)
	// Try put it in their backpack
	if(istype(src.back,/obj/item/storage))
		var/obj/item/storage/backpack = src.back
		if(backpack.can_be_inserted(newitem, 1))
			if(user_initiated)
				backpack.handle_item_insertion(newitem)
			else
				newitem.forceMove(src.back)
			return src.back

	// Try to place it in any item that can store stuff, on the mob.
	for(var/obj/item/storage/S in src.contents)
		if (S.can_be_inserted(newitem, 1))
			if(user_initiated)
				S.handle_item_insertion(newitem)
			else
				newitem.forceMove(S)
			return S
	return 0

//Returns the thing in our active hand
/mob/living/get_active_hand()
	if(hand)	return l_hand
	else		return r_hand

//Returns the thing in our inactive hand
/mob/living/get_inactive_hand()
	if(hand)	return r_hand
	else		return l_hand

//Drops the item in our active hand. TODO: rename this to drop_active_hand or something
/mob/living/drop_item(var/atom/Target)
	var/obj/item/item_dropped = null

	if (hand)
		item_dropped = l_hand
		. = drop_l_hand(Target)
	else
		item_dropped = r_hand
		. = drop_r_hand(Target)

	if (istype(item_dropped) && !QDELETED(item_dropped) && check_sound_preference(/datum/preference/toggle/drop_sounds))
		addtimer(CALLBACK(src, PROC_REF(make_item_drop_sound), item_dropped), 1)

/mob/proc/make_item_drop_sound(obj/item/I)
	if(QDELETED(I))
		return

	if(I.drop_sound)
		playsound(I, I.drop_sound, 25, 0, preference = /datum/preference/toggle/drop_sounds)


//Drops the item in our left hand
/mob/living/drop_l_hand(var/atom/Target)
	return drop_from_inventory(l_hand, Target)

//Drops the item in our right hand
/mob/living/drop_r_hand(var/atom/Target)
	return drop_from_inventory(r_hand, Target)

/mob/living/proc/hands_are_full()
	return (r_hand && l_hand)

/mob/living/proc/item_is_in_hands(var/obj/item/I)
	return (I == r_hand || I == l_hand)

/mob/living/proc/update_held_icons()
	if(l_hand)
		l_hand.update_held_icon()
	if(r_hand)
		r_hand.update_held_icon()

/mob/living/proc/get_type_in_hands(var/T)
	if(istype(l_hand, T))
		return l_hand
	if(istype(r_hand, T))
		return r_hand
	return null

/mob/living/proc/get_left_hand()
	return l_hand

/mob/living/proc/get_right_hand()
	return r_hand

/mob/living/u_equip(obj/W as obj)
	if (W == r_hand)
		r_hand = null
		update_inv_r_hand()
	else if (W == l_hand)
		l_hand = null
		update_inv_l_hand()
	else if (W == back)
		back = null
		update_inv_back()
	else if (W == wear_mask)
		wear_mask = null
		update_inv_wear_mask()
	return

/mob/living/get_equipped_item(var/slot)
	switch(slot)
		if(slot_l_hand) return l_hand
		if(slot_r_hand) return r_hand
		if(slot_back) return back
		if(slot_wear_mask) return wear_mask
	return null

/mob/living/ret_grab(var/list/L, var/mobchain_limit = 5)
	// We're the first!
	if(!L)
		L = list()

	// Lefty grab!
	if (istype(l_hand, /obj/item/grab))
		var/obj/item/grab/G = l_hand
		L |= G.affecting
		if(mobchain_limit-- > 0)
			G.affecting?.ret_grab(L, mobchain_limit) // Recurse! They can update the list. It's the same instance as ours.

	// Righty grab!
	if (istype(r_hand, /obj/item/grab))
		var/obj/item/grab/G = r_hand
		L |= G.affecting
		if(mobchain_limit-- > 0)
			G.affecting?.ret_grab(L, mobchain_limit) // Same as lefty!

	// On all but the one not called by us, this will just be ignored. Oh well!
	return L

/mob/living/mode()
	set name = "Activate Held Object"
	set category = "Object"
	set src = usr

	if(!checkClickCooldown())
		return

	setClickCooldown(1)

	if(istype(loc,/obj/mecha)) return

	if(hand)
		var/obj/item/W = l_hand
		if (W)
			W.attack_self(src)
			update_inv_l_hand()
	else
		var/obj/item/W = r_hand
		if (W)
			W.attack_self(src)
			update_inv_r_hand()
	return

/mob/living/abiotic(var/full_body = 0)
	if(full_body && ((src.l_hand && !( src.l_hand.abstract )) || (src.r_hand && !( src.r_hand.abstract )) || (src.back || src.wear_mask)))
		return 1

	if((src.l_hand && !( src.l_hand.abstract )) || (src.r_hand && !( src.r_hand.abstract )))
		return 1
	return 0

// This handles the drag-open inventory panel.
/mob/living/MouseDrop(atom/over_object)
	var/mob/living/L = over_object
	if(istype(L) && L != src && L == usr && Adjacent(L))
		show_inventory_panel(L)
	. = ..()

/mob/living/proc/show_inventory_panel(mob/user, datum/tgui_state/state)
	if(!inventory_panel_type)
		return FALSE

	if(!inventory_panel)
		inventory_panel = new inventory_panel_type(src)
	inventory_panel.tgui_interact(user, null, state)

	return TRUE

// TGUITODO: Don't forget to Destroy() these properly!
/datum/inventory_panel
	var/mob/living/host
	var/tgui_id = "InventoryPanel"

/datum/inventory_panel/New(mob/living/new_host)
	if(!istype(new_host))
		qdel(src)
		return
	host = new_host
	. = ..()

/datum/inventory_panel/Destroy()
	host = null
	. = ..()

/datum/inventory_panel/tgui_host(mob/user)
	return host.tgui_host()

/datum/inventory_panel/tgui_state(mob/user)
	return GLOB.tgui_physical_state

/datum/inventory_panel/tgui_status(mob/user, datum/tgui_state/state)
	if(!host)
		return STATUS_CLOSE
	if(isAI(user))
		return STATUS_CLOSE
	return ..()

/datum/inventory_panel/tgui_interact(mob/user, datum/tgui/ui, datum/tgui_state/custom_state)
	if(!host)
		qdel(src)
		return
	// This looks kinda complicated, but it's just making sure that the correct state is definitely set
	// before calling open(), so that there isn't any accidental UI closes
	var/open = FALSE
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, tgui_id, host.name)
		open = TRUE
	if(custom_state)
		ui.set_state(custom_state)
	if(open)
		ui.open()
	return ui

/datum/inventory_panel/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	var/list/slots = list()
	slots.Add(list(list(
		"name" = "Head (Mask)",
		"item" = host.wear_mask,
		"act" = "mask",
	)))
	slots.Add(list(list(
		"name" = "Left Hand",
		"item" = host.l_hand,
		"act" = "l_hand",
	)))
	slots.Add(list(list(
		"name" = "Right Hand",
		"item" = host.r_hand,
		"act" = "r_hand",
	)))
	slots.Add(list(list(
		"name" = "Back",
		"item" = host.back,
		"act" = "back",
	)))
	slots.Add(list(list(
		"name" = "Pockets",
		"item" = "Empty Pockets",
		"act" = "pockets",
	)))
	data["slots"] = slots

	data["internals"] = host.internals
	data["internalsValid"] = istype(host.wear_mask, /obj/item/clothing/mask) && istype(host.back, /obj/item/tank)

	return data

/datum/inventory_panel/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	// If anyone wants the inventory panel to actually work,
	// add code to handle actions "mask", "l_hand", "r_hand", "back", "pockets", and "internals" here
	// No mobs other than humans actually supported stripping or putting stuff on before the /datum/inventory_panel was
	// created, so feature parity demands not adding that and risking breaking stuff

/datum/inventory_panel/human
	tgui_id = "InventoryPanelHuman"

/datum/inventory_panel/human/New(mob/living/carbon/human/new_host)
	if(!istype(new_host))
		qdel(src)
		return
	return ..() // Let our parent assign the host.

/datum/inventory_panel/human/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	var/mob/living/carbon/human/H = host

	switch(action)
		if("targetSlot")
			H.handle_strip(params["slot"], usr)
			return TRUE


/datum/inventory_panel/human/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = list() // We don't inherit TGUI data because humans are soooo different.

	var/mob/living/carbon/human/H = host // Not my fault if this runtimes, a human inventory panel should never be created without a human attached.

	var/obj/item/clothing/under/suit = null
	if(istype(H.w_uniform, /obj/item/clothing/under))
		suit = H.w_uniform


	var/list/slots = list()
	for(var/entry in H.species.hud.gear)
		var/list/slot_ref = H.species.hud.gear[entry]
		if((slot_ref["slot"] in list(slot_l_store, slot_r_store)))
			continue
		var/obj/item/thing_in_slot = H.get_equipped_item(slot_ref["slot"])
		slots.Add(list(list(
			"name" = slot_ref["name"],
			"item" = thing_in_slot,
			"act" = "targetSlot",
			"params" = list("slot" = slot_ref["slot"]),
		)))
	data["slots"] = slots


	var/list/specialSlots = list()
	if(H.species.hud.has_hands)
		specialSlots.Add(list(list(
			"name" = "Left Hand",
			"item" = H.l_hand,
			"act" = "targetSlot",
			"params" = list("slot" = slot_l_hand),
		)))
		specialSlots.Add(list(list(
			"name" = "Right Hand",
			"item" = H.r_hand,
			"act" = "targetSlot",
			"params" = list("slot" = slot_r_hand),
		)))
	data["specialSlots"] = specialSlots

	data["internals"] = H.internals
	data["internalsValid"] = (istype(H.wear_mask, /obj/item/clothing/mask) || istype(H.head, /obj/item/clothing/head/helmet/space)) && (istype(H.back, /obj/item/tank) || istype(H.belt, /obj/item/tank) || istype(H.s_store, /obj/item/tank))

	data["sensors"] = FALSE
	if(istype(suit) && suit.has_sensor == 1)
		data["sensors"] = TRUE

	data["handcuffed"] = FALSE
	if(H.handcuffed)
		data["handcuffed"] = TRUE
		data["handcuffedParams"] = list("slot" = slot_handcuffed)

	data["legcuffed"] = FALSE
	if(H.legcuffed)
		data["legcuffed"] = TRUE
		data["legcuffedParams"] = list("slot" = slot_legcuffed)

	data["accessory"] = FALSE
	if(suit && LAZYLEN(suit.accessories))
		data["accessory"] = TRUE

	return data
