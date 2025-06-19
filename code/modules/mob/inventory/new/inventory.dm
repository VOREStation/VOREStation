/proc/slot_num_to_str(slot_num)
	switch(slot_num)
		if(slot_l_hand)
			return slot_l_hand_str
		if(slot_r_hand)
			return slot_r_hand_str
		if(slot_back)
			return slot_back_str
		if(slot_belt)
			return slot_belt_str
		if(slot_wear_id)
			return slot_wear_id_str
		if(slot_s_store)
			return slot_s_store_str
		if(slot_l_store)
			return slot_l_store_str
		if(slot_r_store)
			return slot_r_store_str
		if(slot_glasses)
			return slot_glasses_str
		if(slot_wear_mask)
			return slot_wear_mask_str
		if(slot_gloves)
			return slot_gloves_str
		if(slot_head)
			return slot_head_str
		if(slot_shoes)
			return slot_shoes_str
		if(slot_wear_suit)
			return slot_wear_suit_str
		if(slot_w_uniform)
			return slot_w_uniform_str
		if(slot_l_ear)
			return slot_l_ear_str
		if(slot_r_ear)
			return slot_r_ear_str
		if(slot_tie)
			return slot_tie_str
		if(slot_handcuffed)
			return slot_handcuffed_str
		if(slot_legcuffed)
			return slot_legcuffed_str

/datum/inventory
	var/mob/mymob = null
	var/list/datum/inventory_slot/slots = list()
	var/list/datum/inventory_slot/slots_by_str = list()
	var/list/slot_types = list()

	var/list/slot_to_item = list()

/datum/inventory/New(new_mob)
	. = ..()
	mymob = new_mob
	for(var/type in slot_types)
		var/datum/inventory_slot/slot = new type(src)
		slot_to_item[slot.slot_id_str] = null
		slots_by_str[slot.slot_id_str] = slot
		slots += slot

/datum/inventory/Destroy(force)
	. = ..()
	mymob = null
	QDEL_LIST(slots)
	slots_by_str = null
	// TODO: Does this need to delete all the items in the inventory?
	slot_to_item = null

/datum/inventory/proc/build_hud(datum/hud/HUD)
	if(!HUD)
		return

	var/list/adding = list()
	var/list/other = list()

	for(var/datum/inventory_slot/slot as anything in slots)
		var/obj/screen/hud_item = slot.build_hud(HUD)
		if(slot.hideable)
			other += hud_item
		else
			adding += hud_item

	LAZYADD(HUD.adding, adding)
	LAZYADD(HUD.other, other)

	if(mymob.client)
		// don't add other, it's hidden by default
		mymob.client.screen |= adding

/datum/inventory/proc/get_item_in_slot(slot_id)
	return LAZYACCESS(slot_to_item, slot_id)

/datum/inventory/proc/put_item_in_slot(slot_id, atom/movable/AM)
	LAZYSET(slot_to_item, slot_id, AM)

/datum/inventory/proc/equip_to_slot(slot_id, atom/movable/AM)
	if(!(slot_id in slots_by_str))
		slot_id = slot_num_to_str(slot_id)
		if(!(slot_id in slots_by_str))
			return FALSE
	if(!istype(AM))
		return FALSE

	AM.forceMove(mymob)
	put_item_in_slot(slot_id, AM)

	var/datum/inventory_slot/slot = slots_by_str[slot_id]
	slot.equipped(AM)
	slot.update_icon(AM)

	AM.hud_layerise()
	if(isitem(AM))
		var/obj/item/I = AM
		I.equipped(mymob, slot.slot_id)

		if(I.zoom)
			I.zoom()

		I.in_inactive_hand(mymob)
		I.equip_special()

	return TRUE

/datum/inventory/proc/u_equip(atom/movable/AM)
	for(var/slot in slot_to_item)
		if(slot_to_item[slot] == AM)
			put_item_in_slot(slot, null)

			var/datum/inventory_slot/slot_datum = slots_by_str[slot]
			slot_datum.unequipped(AM)
			slot_datum.update_icon(AM)

			return slot
	return FALSE

// Types
/datum/inventory/human
	slot_types = list(
		/datum/inventory_slot/l_hand,
		/datum/inventory_slot/r_hand,
		/datum/inventory_slot/l_store,
		/datum/inventory_slot/r_store,
		/datum/inventory_slot/s_store,
		/datum/inventory_slot/l_ear,
		/datum/inventory_slot/r_ear,
		/datum/inventory_slot/back,
		/datum/inventory_slot/uniform,
		/datum/inventory_slot/suit,
		/datum/inventory_slot/belt,
		/datum/inventory_slot/mask,
		/datum/inventory_slot/id,
		/datum/inventory_slot/glasses,
	)
