// This handles the drag-open inventory panel.
/mob/living/MouseDrop(atom/over_object)
	var/mob/living/L = over_object
	if(L.is_incorporeal())
		return
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
		"item" = host.inventory.get_item_in_slot(slot_back_str),
		"act" = "back",
	)))
	slots.Add(list(list(
		"name" = "Pockets",
		"item" = "Empty Pockets",
		"act" = "pockets",
	)))
	data["slots"] = slots

	data["internals"] = host.internals
	data["internalsValid"] = istype(host.wear_mask, /obj/item/clothing/mask) && istype(host.inventory.get_item_in_slot(slot_back_str), /obj/item/tank)

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
			H.handle_strip(params["slot"], ui.user)
			return TRUE


/datum/inventory_panel/human/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/simple/inventory)
	)

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
		UNTYPED_LIST_ADD(slots, list(
			"name" = slot_ref["name"],
			"item" = thing_in_slot,
			"icon" = thing_in_slot ? icon2base64(icon(thing_in_slot.icon, thing_in_slot.icon_state, frame = 1)) : null,
			"act" = "targetSlot",
			"params" = list("slot" = slot_ref["slot"]),
		))
	data["slots"] = slots

	var/list/specialSlots = list()
	if(H.species.hud.has_hands)
		UNTYPED_LIST_ADD(specialSlots, list(
			"name" = "Left Hand",
			"item" = H.l_hand,
			"icon" = H.l_hand ? icon2base64(icon(H.l_hand.icon, H.l_hand.icon_state, frame = 1)) : null,
			"act" = "targetSlot",
			"params" = list("slot" = slot_l_hand),
		))
		UNTYPED_LIST_ADD(specialSlots, list(
			"name" = "Right Hand",
			"item" = H.r_hand,
			"icon" = H.r_hand ? icon2base64(icon(H.r_hand.icon, H.r_hand.icon_state, frame = 1)) : null,
			"act" = "targetSlot",
			"params" = list("slot" = slot_r_hand),
		))
	data["specialSlots"] = specialSlots

	data["internals"] = H.internals
	data["internalsValid"] = (istype(H.wear_mask, /obj/item/clothing/mask) || istype(H.head, /obj/item/clothing/head/helmet/space)) && (istype(H.inventory.get_item_in_slot(slot_back_str), /obj/item/tank) || istype(H.belt, /obj/item/tank) || istype(H.s_store, /obj/item/tank))

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
