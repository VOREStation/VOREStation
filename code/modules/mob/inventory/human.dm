/*
Add fingerprints to items when we put them in our hands.
This saves us from having to call add_fingerprint() any time something is put in a human's hands programmatically.
*/

/mob/living/carbon/human/verb/quick_equip()
	set name = "quick-equip"
	set hidden = 1

	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		var/obj/item/I = H.get_active_hand()
		if(!I)
			to_chat(H, span_notice("You are not holding anything to equip."))
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
			to_chat(H, span_warning("You are unable to equip that."))

		// Update hand icons
		else
			if(hand)
				update_inv_l_hand(0)
			else
				update_inv_r_hand(0)


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
