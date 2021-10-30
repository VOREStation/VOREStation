/*
Add fingerprints to items when we put them in our hands.
This saves us from having to call add_fingerprint() any time something is put in a human's hands programmatically.
*/

/mob/living/carbon/human
	var/list/worn_clothing = list()	//Contains all CLOTHING items worn

/mob/living/carbon/human/verb/quick_equip()
	set name = "quick-equip"
	set hidden = 1

	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		var/obj/item/I = H.get_active_hand()
		if(!I)
			to_chat(H, "<span class='notice'>You are not holding anything to equip.</span>")
			return
		
		var/moved = FALSE
		
		// Try an equipment slot
		if(H.equip_to_appropriate_slot(I))
			moved = TRUE
		
		// No? Try a storage item.
		else if(H.equip_to_storage(I, TRUE))
			moved = TRUE
		
		// No?! Well, give up.
		if(!moved)
			to_chat(H, "<span class='warning'>You are unable to equip that.</span>")

		// Update hand icons
		else
			if(hand)
				update_inv_l_hand(0)
			else
				update_inv_r_hand(0)

/mob/living/carbon/human/equip_to_storage(obj/item/newitem, user_initiated = FALSE)
	// Try put it in their belt first
	if(istype(src.belt,/obj/item/weapon/storage))
		var/obj/item/weapon/storage/wornbelt = src.belt
		if(wornbelt.can_be_inserted(newitem, 1))
			if(user_initiated)
				wornbelt.handle_item_insertion(newitem)
			else
				newitem.forceMove(wornbelt)
			return wornbelt

	return ..()

/mob/living/carbon/human/proc/equip_in_one_of_slots(obj/item/W, list/slots, del_on_fail = 1)
	for (var/slot in slots)
		if (equip_to_slot_if_possible(W, slots[slot], del_on_fail = 0))
			return slot
	if (del_on_fail)
		qdel(W)
	return null

/mob/living/carbon/human/proc/has_organ(name)
	var/obj/item/organ/external/O = organs_by_name[name]
	return (O && !O.is_stump())

/mob/living/carbon/human/proc/has_organ_for_slot(slot)
	switch(slot)
		if(slot_back)
			return has_organ(BP_TORSO)
		if(slot_wear_mask)
			return has_organ(BP_HEAD)
		if(slot_handcuffed)
			return has_organ(BP_L_HAND) && has_organ(BP_R_HAND)
		if(slot_legcuffed)
			return has_organ(BP_L_FOOT) && has_organ(BP_R_FOOT)
		if(slot_l_hand)
			return has_organ(BP_L_HAND)
		if(slot_r_hand)
			return has_organ(BP_R_HAND)
		if(slot_belt)
			return has_organ(BP_TORSO)
		if(slot_wear_id)
			// the only relevant check for this is the uniform check
			return 1
		if(slot_l_ear)
			return has_organ(BP_HEAD)
		if(slot_r_ear)
			return has_organ(BP_HEAD)
		if(slot_glasses)
			return has_organ(BP_HEAD)
		if(slot_gloves)
			return has_organ(BP_L_HAND) || has_organ(BP_R_HAND)
		if(slot_head)
			return has_organ(BP_HEAD)
		if(slot_shoes)
			return has_organ(BP_L_FOOT) || has_organ(BP_R_FOOT)
		if(slot_wear_suit)
			return has_organ(BP_TORSO)
		if(slot_w_uniform)
			return has_organ(BP_TORSO)
		if(slot_l_store)
			return has_organ(BP_TORSO)
		if(slot_r_store)
			return has_organ(BP_TORSO)
		if(slot_s_store)
			return has_organ(BP_TORSO)
		if(slot_in_backpack)
			return 1
		if(slot_tie)
			return 1

/obj/item/var/suitlink = 1 //makes belt items require a jumpsuit- set individual items to suitlink = 0 to allow wearing on belt slot without suit

/mob/living/carbon/human/u_equip(obj/W as obj)
	if(!W)	return 0

	if (W == wear_suit)
		if(s_store)
			drop_from_inventory(s_store)
		worn_clothing -= wear_suit
		wear_suit = null
		update_inv_wear_suit()
	else if (W == w_uniform)
		if (r_store)
			drop_from_inventory(r_store)
		if (l_store)
			drop_from_inventory(l_store)
		if (wear_id)
			drop_from_inventory(wear_id)
		if (belt && belt.suitlink == 1)
			worn_clothing -= belt
			drop_from_inventory(belt)
		worn_clothing -= w_uniform
		w_uniform = null
		update_inv_w_uniform()
	else if (W == gloves)
		worn_clothing -= gloves
		gloves = null
		update_inv_gloves()
	else if (W == glasses)
		worn_clothing -= glasses
		glasses = null
		update_inv_glasses()
	else if (W == head)
		worn_clothing -= head
		head = null
		if(istype(W, /obj/item))
			var/obj/item/I = W
			if(I.flags_inv & (HIDEMASK|BLOCKHAIR|BLOCKHEADHAIR))
				update_hair(0)	//rebuild hair
				update_inv_ears(0)
				update_inv_wear_mask(0)
		update_inv_head()
	else if (W == l_ear)
		l_ear = null
		update_inv_ears()
	else if (W == r_ear)
		r_ear = null
		update_inv_ears()
	else if (W == shoes)
		worn_clothing -= shoes
		shoes = null
		update_inv_shoes()
	else if (W == belt)
		worn_clothing -= belt
		belt = null
		update_inv_belt()
	else if (W == wear_mask)
		worn_clothing -= wear_mask
		wear_mask = null
		if(istype(W, /obj/item))
			var/obj/item/I = W
			if(I.flags_inv & (BLOCKHAIR|BLOCKHEADHAIR))
				update_hair(0)	//rebuild hair
				update_inv_ears(0)
		// If this is how the internals are connected, disable them
		if(internal && !(head?.item_flags & AIRTIGHT))
			if(internals)
				internals.icon_state = "internal0"
			internal = null
		update_inv_wear_mask()
	else if (W == wear_id)
		wear_id = null
		update_inv_wear_id()
		BITSET(hud_updateflag, ID_HUD)
		BITSET(hud_updateflag, WANTED_HUD)
	else if (W == r_store)
		r_store = null
		//update_inv_pockets() //Doesn't do anything.
	else if (W == l_store)
		l_store = null
		//update_inv_pockets() //Doesn't do anything.
	else if (W == s_store)
		s_store = null
		update_inv_s_store()
	else if (W == back)
		worn_clothing -= back
		back = null
		update_inv_back()
	else if (W == handcuffed)
		handcuffed = null
		if(buckled && buckled.buckle_require_restraints)
			buckled.unbuckle_mob()
		update_handcuffed()
	else if (W == legcuffed)
		legcuffed = null
		update_inv_legcuffed()
	else if (W == r_hand)
		r_hand = null
		if(l_hand)
			l_hand.update_twohanding()
			l_hand.update_held_icon()
			update_inv_l_hand()
		update_inv_r_hand()
	else if (W == l_hand)
		l_hand = null
		if(r_hand)
			r_hand.update_twohanding()
			r_hand.update_held_icon()
			update_inv_l_hand()
		update_inv_l_hand()
	else
		return 0

	update_action_buttons()
	return 1



//This is an UNSAFE proc. Use mob_can_equip() before calling this one! Or rather use equip_to_slot_if_possible() or advanced_equip_to_slot_if_possible()
/mob/living/carbon/human/equip_to_slot(obj/item/W as obj, slot)

	if(!slot)
		return
	if(!istype(W))
		return
	if(!has_organ_for_slot(slot))
		return
	if(!species || !species.hud || !(slot in species.hud.equip_slots))
		return

	W.loc = src
	switch(slot)
		if(slot_back)
			src.back = W
			W.equipped(src, slot)
			worn_clothing += back
			update_inv_back()
		if(slot_wear_mask)
			src.wear_mask = W
			if(wear_mask.flags_inv & (BLOCKHAIR|BLOCKHEADHAIR))
				update_hair()	//rebuild hair
				update_inv_ears()
			W.equipped(src, slot)
			worn_clothing += wear_mask
			update_inv_wear_mask()
		if(slot_handcuffed)
			src.handcuffed = W
			update_inv_handcuffed()
		if(slot_legcuffed)
			src.legcuffed = W
			W.equipped(src, slot)
			update_inv_legcuffed()
		if(slot_l_hand)
			src.l_hand = W
			W.equipped(src, slot)
			update_inv_l_hand()
		if(slot_r_hand)
			src.r_hand = W
			W.equipped(src, slot)
			update_inv_r_hand()
		if(slot_belt)
			src.belt = W
			W.equipped(src, slot)
			worn_clothing += belt
			update_inv_belt()
		if(slot_wear_id)
			src.wear_id = W
			W.equipped(src, slot)
			update_inv_wear_id()
			BITSET(hud_updateflag, ID_HUD)
			BITSET(hud_updateflag, WANTED_HUD)
		if(slot_l_ear)
			src.l_ear = W
			if(l_ear.slot_flags & SLOT_TWOEARS)
				var/obj/item/clothing/ears/offear/O = new(W)
				O.loc = src
				src.r_ear = O
				O.hud_layerise()
			W.equipped(src, slot)
			update_inv_ears()
		if(slot_r_ear)
			src.r_ear = W
			if(r_ear.slot_flags & SLOT_TWOEARS)
				var/obj/item/clothing/ears/offear/O = new(W)
				O.loc = src
				src.l_ear = O
				O.hud_layerise()
			W.equipped(src, slot)
			update_inv_ears()
		if(slot_glasses)
			src.glasses = W
			W.equipped(src, slot)
			worn_clothing += glasses
			update_inv_glasses()
		if(slot_gloves)
			src.gloves = W
			W.equipped(src, slot)
			worn_clothing += gloves
			update_inv_gloves()
		if(slot_head)
			src.head = W
			if(head.flags_inv & (BLOCKHAIR|BLOCKHEADHAIR|HIDEMASK))
				update_hair()	//rebuild hair
				update_inv_ears(0)
				update_inv_wear_mask(0)
			if(istype(W,/obj/item/clothing/head/kitty))
				W.update_icon(src)
			W.equipped(src, slot)
			worn_clothing += head
			update_inv_head()
		if(slot_shoes)
			src.shoes = W
			W.equipped(src, slot)
			worn_clothing += shoes
			update_inv_shoes()
		if(slot_wear_suit)
			src.wear_suit = W
			W.equipped(src, slot)
			worn_clothing += wear_suit
			update_inv_wear_suit()
		if(slot_w_uniform)
			src.w_uniform = W
			W.equipped(src, slot)
			worn_clothing += w_uniform
			update_inv_w_uniform()
		if(slot_l_store)
			src.l_store = W
			W.equipped(src, slot)
			//update_inv_pockets() //Doesn't do anything
		if(slot_r_store)
			src.r_store = W
			W.equipped(src, slot)
			//update_inv_pockets() //Doesn't do anything
		if(slot_s_store)
			src.s_store = W
			W.equipped(src, slot)
			update_inv_s_store()
		if(slot_in_backpack)
			if(src.get_active_hand() == W)
				src.remove_from_mob(W)
			W.loc = src.back
		if(slot_tie)
			for(var/obj/item/clothing/C in worn_clothing)
				if(istype(W, /obj/item/clothing/accessory))
					var/obj/item/clothing/accessory/A = W
					if(C.attempt_attach_accessory(A, src))
						return
		else
			to_chat(src, "<font color='red'>You are trying to equip this item to an unsupported inventory slot. How the heck did you manage that? Stop it...</font>")
			return

	if((W == src.l_hand) && (slot != slot_l_hand))
		src.l_hand = null
		update_inv_l_hand() //So items actually disappear from hands.
	else if((W == src.r_hand) && (slot != slot_r_hand))
		src.r_hand = null
		update_inv_r_hand()

	W.hud_layerise()

	if(W.action_button_name)
		update_action_buttons()

	if(W.zoom)
		W.zoom()

	W.in_inactive_hand(src)

	return 1

//Checks if a given slot can be accessed at this time, either to equip or unequip I
/mob/living/carbon/human/slot_is_accessible(var/slot, var/obj/item/I, mob/user=null)
	var/obj/item/covering = null
	var/check_flags = 0

	switch(slot)
		if(slot_wear_mask)
			covering = src.head
			check_flags = FACE
		if(slot_glasses)
			covering = src.head
			check_flags = EYES
		if(slot_gloves, slot_w_uniform)
			covering = src.wear_suit

	if(covering && (covering.body_parts_covered & (I.body_parts_covered|check_flags)))
		to_chat(user, "<span class='warning'>\The [covering] is in the way.</span>")
		return 0
	return 1

/mob/living/carbon/human/get_equipped_item(var/slot)
	switch(slot)
		if(slot_back)       return back
		if(slot_legcuffed)  return legcuffed
		if(slot_handcuffed) return handcuffed
		if(slot_l_store)    return l_store
		if(slot_r_store)    return r_store
		if(slot_wear_mask)  return wear_mask
		if(slot_l_hand)     return l_hand
		if(slot_r_hand)     return r_hand
		if(slot_wear_id)    return wear_id
		if(slot_glasses)    return glasses
		if(slot_gloves)     return gloves
		if(slot_head)       return head
		if(slot_shoes)      return shoes
		if(slot_belt)       return belt
		if(slot_wear_suit)  return wear_suit
		if(slot_w_uniform)  return w_uniform
		if(slot_s_store)    return s_store
		if(slot_l_ear)      return l_ear
		if(slot_r_ear)      return r_ear
	return ..()


/mob/living/carbon/human/is_holding_item_of_type(typepath)
	for(var/obj/item/I in list(l_hand, r_hand))
		if(istype(I, typepath))
			return I
	return FALSE

// Returns a list of items held in both hands.
/mob/living/carbon/human/get_all_held_items()
	. = list()
	if(l_hand)
		. += l_hand
	if(r_hand)
		. += r_hand
