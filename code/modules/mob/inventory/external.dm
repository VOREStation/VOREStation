//The list of slots by priority. equip_to_appropriate_slot() uses this list. Doesn't matter if a mob type doesn't have a slot.
var/list/slot_equipment_priority = list( \
		slot_back,\
		slot_wear_id,\
		slot_w_uniform,\
		slot_wear_suit,\
		slot_wear_mask,\
		slot_head,\
		slot_shoes,\
		slot_gloves,\
		slot_l_ear,\
		slot_r_ear,\
		slot_glasses,\
		slot_belt,\
		slot_s_store,\
		slot_tie,\
		slot_l_store,\
		slot_r_store\
	)

//This proc is called whenever someone clicks an inventory ui slot.
/mob/proc/attack_ui(var/slot)
	var/obj/item/W = get_active_hand()

	var/obj/item/E = get_equipped_item(slot)
	if (istype(E))
		if(istype(W))
			E.attackby(W,src)
		else
			E.attack_hand(src)
	else
		equip_to_slot_if_possible(W, slot)

//There has to be a better way to define this shit. ~ Z
//can't equip anything
/mob/living/carbon/alien/attack_ui(slot_id)
	return

/* Inventory manipulation */
/mob/proc/put_in_any_hand_if_possible(obj/item/W, del_on_fail = 0, disable_warning = 1, redraw_mob = 1)
	if(equip_to_slot_if_possible(W, slot_l_hand, del_on_fail, disable_warning, redraw_mob))
		return TRUE
	else if(equip_to_slot_if_possible(W, slot_r_hand, del_on_fail, disable_warning, redraw_mob))
		return TRUE
	return FALSE

//This is a SAFE proc. Use this instead of equip_to_slot()!
//set del_on_fail to have it delete W if it fails to equip
//set disable_warning to disable the 'you are unable to equip that' warning.
//unset redraw_mob to prevent the mob from being redrawn at the end.
/mob/proc/equip_to_slot_if_possible(obj/item/W, slot, del_on_fail = 0, disable_warning = 0, redraw_mob = 1, ignore_obstructions = 1)
	if(!W)
		return FALSE
	if(!W.mob_can_equip(src, slot, disable_warning, ignore_obstructions))
		if(del_on_fail)
			qdel(W)

		else
			if(!disable_warning)
				to_chat(src, span_red("You are unable to equip that.")) //Only print if del_on_fail is false
		return FALSE

	equip_to_slot(W, slot, redraw_mob) //This proc should not ever fail.
	return TRUE

//This is an UNSAFE proc. It merely handles the actual job of equipping. All the checks on whether you can or can't eqip need to be done before! Use mob_can_equip() for that task.
//In most cases you will want to use equip_to_slot_if_possible()
/mob/proc/equip_to_slot(obj/item/W, slot)
	return

//This is an UNSAFE proc. Use mob_can_equip() before calling this one! Or rather use equip_to_slot_if_possible() or advanced_equip_to_slot_if_possible()
/mob/living/carbon/human/equip_to_slot(obj/item/W, slot)

	if(!slot)
		return
	if(!istype(W))
		return
	if(!has_organ_for_slot(slot))
		return
	if(!species || !species.hud || !(slot in species.hud.equip_slots))
		return

	// Need to clear out hands
	var/atom/movable/l_hand = get_left_hand()
	var/atom/movable/r_hand = get_right_hand()

	// TODO: Make hands dynamic
	if((W == l_hand) && (slot != slot_l_hand))
		inventory.put_item_in_slot(slot_l_hand_str, null)
		update_inv_l_hand() //So items actually disappear from hands.
	else if((W == r_hand) && (slot != slot_r_hand))
		inventory.put_item_in_slot(slot_r_hand_str, null)
		update_inv_r_hand()

	if(inventory.equip_to_slot(slot, W))
		return TRUE

	W.forceMove(src)
	switch(slot)
		// if(slot_back)
		// 	src.back = W
		// 	W.equipped(src, slot)
		// 	worn_clothing += back
		// 	update_inv_back()
		// if(slot_wear_mask)
		// 	src.wear_mask = W
		// 	if(wear_mask.flags_inv & (BLOCKHAIR|BLOCKHEADHAIR))
		// 		update_hair()	//rebuild hair
		// 		update_inv_ears()
		// 	W.equipped(src, slot)
		// 	worn_clothing += wear_mask
		// 	update_inv_wear_mask()
		if(slot_handcuffed)
			src.handcuffed = W
			update_inv_handcuffed()
		if(slot_legcuffed)
			src.legcuffed = W
			W.equipped(src, slot)
			update_inv_legcuffed()
		// if(slot_l_hand)
		// 	src.l_hand = W
		// 	W.equipped(src, slot)
		// 	update_inv_l_hand()
		// if(slot_r_hand)
		// 	src.r_hand = W
		// 	W.equipped(src, slot)
		// 	update_inv_r_hand()
		// if(slot_belt)
		// 	src.belt = W
		// 	W.equipped(src, slot)
		// 	worn_clothing += belt
		// 	update_inv_belt()
		// if(slot_wear_id)
		// 	src.wear_id = W
		// 	W.equipped(src, slot)
		// 	update_inv_wear_id()
		// 	BITSET(hud_updateflag, ID_HUD)
		// 	BITSET(hud_updateflag, WANTED_HUD)
		// if(slot_l_ear)
		// 	src.l_ear = W
		// 	if(l_ear.slot_flags & SLOT_TWOEARS)
		// 		var/obj/item/clothing/ears/offear/O = new(W)
		// 		O.loc = src
		// 		src.r_ear = O
		// 		O.hud_layerise()
		// 	W.equipped(src, slot)
		// 	update_inv_ears()
		// if(slot_r_ear)
		// 	src.r_ear = W
		// 	if(r_ear.slot_flags & SLOT_TWOEARS)
		// 		var/obj/item/clothing/ears/offear/O = new(W)
		// 		O.loc = src
		// 		src.l_ear = O
		// 		O.hud_layerise()
		// 	W.equipped(src, slot)
		// 	update_inv_ears()
		// if(slot_glasses)
		// 	src.glasses = W
		// 	W.equipped(src, slot)
		// 	worn_clothing += glasses
		// 	update_inv_glasses()
		if(slot_gloves)
			src.gloves = W
			W.equipped(src, slot)
			worn_clothing += gloves
			update_inv_gloves()
		// if(slot_head)
		// 	src.head = W
		// 	if(head.flags_inv & (BLOCKHAIR|BLOCKHEADHAIR|HIDEMASK))
		// 		update_hair()	//rebuild hair
		// 		update_inv_ears(0)
		// 		update_inv_wear_mask(0)
		// 	if(istype(W,/obj/item/clothing/head/kitty))
		// 		W.update_icon(src)
		// 	W.equipped(src, slot)
		// 	worn_clothing += head
		// 	update_inv_head()
		// if(slot_shoes)
		// 	src.shoes = W
		// 	W.equipped(src, slot)
		// 	worn_clothing += shoes
		// 	update_inv_shoes()
		// if(slot_wear_suit)
		// 	src.wear_suit = W
		// 	W.equipped(src, slot)
		// 	worn_clothing += wear_suit
		// 	update_inv_wear_suit()
		// if(slot_w_uniform)
		// 	src.w_uniform = W
		// 	W.equipped(src, slot)
		// 	worn_clothing += w_uniform
		// 	update_inv_w_uniform()
		// if(slot_s_store)
		// 	src.s_store = W
		// 	W.equipped(src, slot)
		// 	update_inv_s_store()
		if(slot_in_backpack)
			if(src.get_active_hand() == W)
				src.remove_from_mob(W)
			W.forceMove(inventory.get_item_in_slot(slot_back_str))
		if(slot_tie)
			for(var/obj/item/clothing/C in worn_clothing)
				if(istype(W, /obj/item/clothing/accessory))
					var/obj/item/clothing/accessory/A = W
					if(C.attempt_attach_accessory(A, src))
						return
		else
			to_chat(src, span_red("You are trying to equip this item to an unsupported inventory slot. How the heck did you manage that? Stop it..."))
			return

	W.hud_layerise()

	if(W.zoom)
		W.zoom()

	W.in_inactive_hand(src)

	//VOREStation Addition Start
	if(istype(W, /obj/item))
		var/obj/item/I = W
		I.equip_special()
	//VOREStation Addition End

	return 1

//This is just a commonly used configuration for the equip_to_slot_if_possible() proc, used to equip people when the rounds tarts and when events happen and such.
/mob/proc/equip_to_slot_or_del(obj/item/W, slot, ignore_obstructions = 1)
	return equip_to_slot_if_possible(W, slot, 1, 1, 0, ignore_obstructions)

//hurgh. these feel hacky, but they're the only way I could get the damn thing to work. I guess they could be handy for antag spawners too?
/mob/proc/equip_voidsuit_to_slot_or_del_with_refit(obj/item/clothing/suit/space/void/W, slot, species = SPECIES_HUMAN)
	W.refit_for_species(species)
	return equip_to_slot_if_possible(W, slot, 1, 1, 0)

/mob/proc/equip_voidhelm_to_slot_or_del_with_refit(obj/item/clothing/head/helmet/space/void/W, slot, species = SPECIES_HUMAN)
	W.refit_for_species(species)
	return equip_to_slot_if_possible(W, slot, 1, 1, 0)

//Checks if a given slot can be accessed at this time, either to equip or unequip I
/mob/proc/slot_is_accessible(var/slot, var/obj/item/I, mob/user=null)
	return TRUE

//Checks if a given slot can be accessed at this time, either to equip or unequip I
/mob/living/carbon/human/slot_is_accessible(var/slot, var/obj/item/I, mob/user=null)
	var/obj/item/covering = null
	var/check_flags = 0

	switch(slot)
		if(slot_wear_mask)
			covering = inventory.get_item_in_slot(slot_head_str)
			check_flags = FACE
		if(slot_glasses)
			covering = inventory.get_item_in_slot(slot_head_str)
			check_flags = EYES
		if(slot_gloves, slot_w_uniform)
			covering = inventory.get_item_in_slot(slot_wear_suit_str)

	if(covering && (covering.body_parts_covered & (I.body_parts_covered|check_flags)))
		to_chat(user, span_warning("\The [covering] is in the way."))
		return 0
	return 1

//puts the item "W" into an appropriate slot in a human's inventory
//returns 0 if it cannot, 1 if successful
/mob/proc/equip_to_appropriate_slot(obj/item/W)
	for(var/slot in slot_equipment_priority)
		if(equip_to_slot_if_possible(W, slot, del_on_fail=0, disable_warning=1, redraw_mob=1))
			return TRUE

	return FALSE

/mob/proc/equip_to_storage(obj/item/newitem, user_initiated = FALSE)
	return FALSE

/mob/living/equip_to_storage(obj/item/newitem, user_initiated = FALSE)
	var/back = inventory.get_item_in_slot(slot_back_str)

	// Try put it in their backpack
	if(istype(back,/obj/item/storage))
		var/obj/item/storage/backpack = back
		if(backpack.can_be_inserted(newitem, 1))
			if(user_initiated)
				backpack.handle_item_insertion(newitem)
			else
				newitem.forceMove(back)
			return back

	// Try to place it in any item that can store stuff, on the mob.
	for(var/obj/item/storage/S in src.contents)
		if (S.can_be_inserted(newitem, 1))
			if(user_initiated)
				S.handle_item_insertion(newitem)
			else
				newitem.forceMove(S)
			return S

	if(istype(back,/obj/item/rig))	//This would be much cooler if we had componentized storage datums
		var/obj/item/rig/R = back
		if(R.rig_storage)
			var/obj/item/storage/backpack = R.rig_storage
			if(backpack.can_be_inserted(newitem, 1))
				if(user_initiated)
					backpack.handle_item_insertion(newitem)
				else
					newitem.forceMove(back)
				return backpack
	return 0

/mob/living/carbon/human/equip_to_storage(obj/item/newitem, user_initiated = FALSE)
	// Try put it in their belt first
	if(istype(inventory.get_item_in_slot(slot_belt_str),/obj/item/storage))
		var/obj/item/storage/wornbelt = inventory.get_item_in_slot(slot_belt_str)
		if(wornbelt.can_be_inserted(newitem, 1))
			if(user_initiated)
				wornbelt.handle_item_insertion(newitem)
			else
				newitem.forceMove(wornbelt)
			return wornbelt

	return ..()
/* Hands */

//Returns the thing in our active hand
/mob/proc/get_active_hand()

//Returns the thing in our active hand
/mob/living/get_active_hand()
	if(hand)	return get_left_hand()
	else		return get_right_hand()

//Returns the thing in our active hand (whatever is in our active module-slot, in this case)
/mob/living/silicon/robot/get_active_hand()
	return module_active

//Returns the thing in our inactive hand
/mob/proc/get_inactive_hand()

//Returns the thing in our inactive hand
/mob/living/get_inactive_hand()
	if(hand)	return get_right_hand()
	else		return get_left_hand()

// Override for your specific mob's hands or lack thereof.
/mob/proc/is_holding_item_of_type(typepath)
	return FALSE

/mob/living/silicon/robot/is_holding_item_of_type(typepath)
	for(var/obj/item/I in list(module_state_1, module_state_2, module_state_3))
		if(istype(I, typepath))
			return I
	return FALSE

/mob/living/simple_mob/is_holding_item_of_type(typepath)
	for(var/obj/item/I in list(get_left_hand(), get_right_hand()))
		if(istype(I, typepath))
			return I
	return FALSE

/mob/living/carbon/human/is_holding_item_of_type(typepath)
	for(var/obj/item/I in list(get_left_hand(), get_right_hand()))
		if(istype(I, typepath))
			return I
	return FALSE

// Override for your specific mob's hands or lack thereof.
/mob/proc/get_all_held_items()
	return list()

/mob/living/simple_mob/get_all_held_items()
	. = list()
	if(get_left_hand())
		. += get_left_hand()
	if(get_right_hand())
		. += get_right_hand()

// Returns a list of items held in both hands.
/mob/living/carbon/human/get_all_held_items()
	. = list()
	if(get_left_hand())
		. += get_left_hand()
	if(get_right_hand())
		. += get_right_hand()

// Returns a list of all held items in a borg's 'hands'.
/mob/living/silicon/robot/get_all_held_items()
	. = list()
	if(module_state_1)
		. += module_state_1
	if(module_state_2)
		. += module_state_2
	if(module_state_3)
		. += module_state_3

//Puts the item into your l_hand if possible and calls all necessary triggers/updates. returns 1 on success.
/mob/proc/put_in_l_hand(var/obj/item/W)
	if(!istype(W))
		return FALSE
	return TRUE

//Puts the item into your r_hand if possible and calls all necessary triggers/updates. returns 1 on success.
/mob/proc/put_in_r_hand(var/obj/item/W)
	if(!istype(W))
		return FALSE
	return TRUE

//Puts the item into our active hand if possible. returns 1 on success.
/mob/proc/put_in_active_hand(var/obj/item/W)
	return FALSE // Moved to human procs because only they need to use hands.

//Puts the item into our inactive hand if possible. returns 1 on success.
/mob/proc/put_in_inactive_hand(var/obj/item/W)
	return FALSE // As above.

//Puts the item into our active hand if possible. returns 1 on success.
/mob/living/carbon/human/put_in_active_hand(var/obj/item/W)
	return (hand ? put_in_l_hand(W) : put_in_r_hand(W))

//Puts the item into our inactive hand if possible. returns 1 on success.
/mob/living/carbon/human/put_in_inactive_hand(var/obj/item/W)
	return (hand ? put_in_r_hand(W) : put_in_l_hand(W))

/mob/living/carbon/human/put_in_l_hand(var/obj/item/W)
	if(!..() || get_left_hand())
		return 0
	W.forceMove(src)
	inventory.put_item_in_slot(slot_l_hand_str, W)
	W.equipped(src,slot_l_hand)
	W.add_fingerprint(src)
	update_inv_l_hand()
	return 1

/mob/living/carbon/human/put_in_r_hand(var/obj/item/W)
	if(!..() || get_right_hand())
		return 0
	W.forceMove(src)
	inventory.put_item_in_slot(slot_r_hand_str, W)
	W.equipped(src,slot_r_hand)
	W.add_fingerprint(src)
	update_inv_r_hand()
	return 1

//Puts the item our active hand if possible. Failing that it tries our inactive hand. Returns 1 on success.
//If both fail it drops it on the floor and returns 0.
//This is probably the main one you need to know :)
/mob/proc/put_in_hands(var/obj/item/W)
	if(!W)
		return FALSE
	W.forceMove(drop_location())
	W.reset_plane_and_layer()
	W.dropped(src)
	return FALSE

/mob/living/carbon/alien/diona/put_in_hands(var/obj/item/W) // No hands.
	W.loc = get_turf(src)
	return 1

/mob/living/carbon/human/put_in_hands(var/obj/item/W)
	if(!W)
		return 0
	if(put_in_active_hand(W))
		update_inv_l_hand()
		update_inv_r_hand()
		return 1
	else if(put_in_inactive_hand(W))
		update_inv_l_hand()
		update_inv_r_hand()
		return 1
	else
		return ..()

/mob/living/silicon/robot/put_in_hands(var/obj/item/W) // No hands.
	W.forceMove(get_turf(src))
	return 1

/mob/living/simple_mob/put_in_hands(var/obj/item/W) // No hands.
	if(has_hands)
		put_in_active_hand(W)
		return 1
	W.forceMove(get_turf(src))
	return 1

// Removes an item from inventory and places it in the target atom.
// If canremove or other conditions need to be checked then use unEquip instead.

/mob/proc/drop_from_inventory(var/obj/item/W, var/atom/target)
	if(!W)
		return FALSE
	return remove_from_mob(W, target)

/mob/living/carbon/drop_from_inventory(var/obj/item/W, var/atom/target = null)
	return !(W in internal_organs) && ..()

/mob/living/carbon/human/drop_from_inventory(var/obj/item/W, var/atom/target = null)
	if(W in organs)
		return FALSE
	if(isnull(target) && istype( src.loc,/obj/structure/disposalholder))
		return remove_from_mob(W, src.loc)
	return ..()

//Drops the item in our left hand
/mob/proc/drop_l_hand(var/atom/Target)
	return FALSE

//Drops the item in our left hand
/mob/living/drop_l_hand(var/atom/Target)
	return drop_from_inventory(get_left_hand(), Target)

//Drops the item in our right hand
/mob/proc/drop_r_hand(var/atom/Target)
	return FALSE

//Drops the item in our right hand
/mob/living/drop_r_hand(var/atom/Target)
	return drop_from_inventory(get_right_hand(), Target)

//Drops the item in our active hand. TODO: rename this to drop_active_hand or something
/mob/proc/drop_item(var/atom/Target)
	return

/mob/proc/make_item_drop_sound(obj/item/I)
	if(QDELETED(I))
		return

	if(I.drop_sound)
		playsound(I, I.drop_sound, 25, 0, preference = /datum/preference/toggle/drop_sounds)

//Drops the item in our active hand. TODO: rename this to drop_active_hand or something
/mob/living/drop_item(var/atom/Target)
	var/obj/item/item_dropped = null

	if (hand)
		item_dropped = get_left_hand()
		. = drop_l_hand(Target)
	else
		item_dropped = get_right_hand()
		. = drop_r_hand(Target)

	if (istype(item_dropped) && !QDELETED(item_dropped) && check_sound_preference(/datum/preference/toggle/drop_sounds))
		addtimer(CALLBACK(src, PROC_REF(make_item_drop_sound), item_dropped), 1)

/mob/living/silicon/drop_item()
	return

/mob/living/silicon/robot/drop_item()
	if(module_active && istype(module_active,/obj/item/gripper))
		var/obj/item/gripper/G = module_active
		G.drop_item_nm()

/*
	Removes the object from any slots the mob might have, calling the appropriate icon update proc.
	Does nothing else.

	DO NOT CALL THIS PROC DIRECTLY. It is meant to be called only by other inventory procs.
	It's probably okay to use it if you are transferring the item between slots on the same mob,
	but chances are you're safer calling remove_from_mob() or drop_from_inventory() anyways.

	As far as I can tell the proc exists so that mobs with different inventory slots can override
	the search through all the slots, without having to duplicate the rest of the item dropping.
*/
/mob/proc/u_equip(obj/W)
	if(inventory.u_equip(W))
		return TRUE
	return FALSE

/mob/living/u_equip(obj/W)
	if(inventory.u_equip(W))
		. = TRUE // TODO: become return TRUE when we've ported everything

	// if (W == r_hand)
	// 	r_hand = null
	// 	update_inv_r_hand()
	// else if (W == l_hand)
	// 	l_hand = null
	// 	update_inv_l_hand()
	// else if (W == back)
	// 	back = null
	// 	update_inv_back()
	// else if (W == wear_mask)
	// 	wear_mask = null
	// 	update_inv_wear_mask()
	return

/mob/living/carbon/u_equip(obj/item/W)
	if(!W)	return 0

	if(inventory.u_equip(W))
		. = TRUE // TODO: become return TRUE when we've ported everything

	if (W == handcuffed)
		handcuffed = null
		update_handcuffed()
		if(buckled && buckled.buckle_require_restraints)
			buckled.unbuckle_mob()
	else if (W == legcuffed)
		legcuffed = null
		update_inv_legcuffed()
	else
		..()

/mob/living/carbon/alien/u_equip(obj/item/W)
	return

/mob/living/carbon/human/u_equip(obj/W)
	if(!W)	return 0

	if(inventory.u_equip(W))
		. = TRUE // TODO: become return TRUE when we've ported everything

	// if (W == wear_suit)
	// 	if(s_store)
	// 		drop_from_inventory(s_store)
	// 	worn_clothing -= wear_suit
	// 	wear_suit = null
	// 	update_inv_wear_suit()
	// else if (W == w_uniform)
	// 	if (inventory.get_item_in_slot(slot_r_store_str))
	// 		drop_from_inventory(inventory.get_item_in_slot(slot_r_store_str))
	// 	if (inventory.get_item_in_slot(slot_l_store_str))
	// 		drop_from_inventory(inventory.get_item_in_slot(slot_l_store_str))
	// 	if (wear_id)
	// 		drop_from_inventory(wear_id)
	// 	if (belt && belt.suitlink == 1)
	// 		worn_clothing -= belt
	// 		drop_from_inventory(belt)
	// 	worn_clothing -= w_uniform
	// 	w_uniform = null
	// 	update_inv_w_uniform()
	if (W == gloves)
		worn_clothing -= gloves
		gloves = null
		update_inv_gloves()
	// else if (W == glasses)
	// 	worn_clothing -= glasses
	// 	glasses = null
	// 	update_inv_glasses()
	// else if (W == head)
	// 	worn_clothing -= head
	// 	head = null
	// 	if(istype(W, /obj/item))
	// 		var/obj/item/I = W
	// 		if(I.flags_inv & (HIDEMASK|BLOCKHAIR|BLOCKHEADHAIR))
	// 			update_hair(0)	//rebuild hair
	// 			update_inv_ears(0)
	// 			update_inv_wear_mask(0)
	// 	update_inv_head()
	// else if (W == l_ear)
	// 	l_ear = null
	// 	update_inv_ears()
	// else if (W == r_ear)
	// 	r_ear = null
	// 	update_inv_ears()
	// else if (W == shoes)
	// 	worn_clothing -= shoes
	// 	shoes = null
	// 	update_inv_shoes()
	// else if (W == belt)
	// 	worn_clothing -= belt
	// 	belt = null
	// 	update_inv_belt()
	// else if (W == wear_mask)
	// 	worn_clothing -= wear_mask
	// 	wear_mask = null
	// 	if(istype(W, /obj/item))
	// 		var/obj/item/I = W
	// 		if(I.flags_inv & (BLOCKHAIR|BLOCKHEADHAIR))
	// 			update_hair(0)	//rebuild hair
	// 			update_inv_ears(0)
	// 	// If this is how the internals are connected, disable them
	// 	if(internal && !(head?.item_flags & AIRTIGHT))
	// 		if(internals)
	// 			internals.icon_state = "internal0"
	// 		internal = null
	// 	update_inv_wear_mask()
	// else if (W == wear_id)
	// 	wear_id = null
	// 	update_inv_wear_id()
	// 	BITSET(hud_updateflag, ID_HUD)
	// 	BITSET(hud_updateflag, WANTED_HUD)
	// else if (W == s_store)
	// 	s_store = null
	// 	update_inv_s_store()
	// else if (W == back)
	// 	worn_clothing -= back
	// 	back = null
	// 	update_inv_back()
	else if (W == handcuffed)
		handcuffed = null
		if(buckled && buckled.buckle_require_restraints)
			buckled.unbuckle_mob()
		update_handcuffed()
	else if (W == legcuffed)
		legcuffed = null
		update_inv_legcuffed()
	// else if (W == r_hand)
	// 	r_hand = null
	// 	if(l_hand)
	// 		l_hand.update_twohanding()
	// 		l_hand.update_held_icon()
	// 		update_inv_l_hand()
	// 	update_inv_r_hand()
	// else if (W == l_hand)
	// 	l_hand = null
	// 	if(r_hand)
	// 		r_hand.update_twohanding()
	// 		r_hand.update_held_icon()
	// 		update_inv_l_hand()
	// 	update_inv_l_hand()
	else
		return 0

	return 1

/mob/proc/isEquipped(obj/item/I)
	if(!I)
		return FALSE
	return get_inventory_slot(I) != 0

/mob/proc/canUnEquip(obj/item/I)
	if(!I) //If there's nothing to drop, the drop is automatically successful.
		return TRUE
	var/slot = get_inventory_slot(I)
	return I.mob_can_unequip(src, slot)

/mob/proc/get_inventory_slot(obj/item/I)
	var/slot = 0
	for(var/s in 1 to SLOT_TOTAL)
		if(get_equipped_item(s) == I)
			slot = s
			break
	return slot


//This differs from remove_from_mob() in that it checks if the item can be unequipped first.
/mob/proc/unEquip(obj/item/I, force = 0, var/atom/target) //Force overrides NODROP for things like wizarditis and admin undress.
	if(!(force || canUnEquip(I)))
		return FALSE
	drop_from_inventory(I, target)
	return TRUE

//visibly unequips I but it is NOT MOVED AND REMAINS IN SRC
//item MUST BE FORCEMOVE'D OR QDEL'D
/mob/proc/temporarilyRemoveItemFromInventory(obj/item/I, force = FALSE, idrop = TRUE)
	return u_equip(I, force, null, TRUE, idrop)

//Attemps to remove an object on a mob.
/mob/proc/remove_from_mob(obj/O, atom/target)
	if(!O) // Nothing to remove, so we succeed.
		return TRUE
	u_equip(O)
	if(client)
		client.screen -= O
	O.reset_plane_and_layer()
	O.screen_loc = null
	if(istype(O, /obj/item))
		var/obj/item/I = O
		if(target)
			I.forceMove(target)
		else
			I.dropInto(drop_location())
		I.dropped(src)
	return TRUE

//Returns the item equipped to the specified slot, if any.
/mob/proc/get_equipped_item(slot)
	return null

/mob/living/get_equipped_item(slot)
	switch(slot)
		if(slot_l_hand)        return get_left_hand()
		if(slot_l_hand_str)    return get_left_hand()
		if(slot_r_hand)        return get_right_hand()
		if(slot_r_hand_str)    return get_right_hand()
		if(slot_back)          return inventory.get_item_in_slot(slot_back_str)
		if(slot_back_str)      return inventory.get_item_in_slot(slot_back_str)
		if(slot_wear_mask)     return inventory.get_item_in_slot(slot_wear_mask_str)
		if(slot_wear_mask_str) return inventory.get_item_in_slot(slot_wear_mask_str)
	return null

/mob/living/carbon/human/get_equipped_item(slot)
	switch(slot)
		if(slot_back)           return inventory.get_item_in_slot(slot_back_str)
		if(slot_back_str)       return inventory.get_item_in_slot(slot_back_str)
		if(slot_legcuffed)      return legcuffed
		if(slot_legcuffed_str)  return legcuffed
		if(slot_handcuffed)     return handcuffed
		if(slot_handcuffed_str) return handcuffed
		if(slot_l_store)        return inventory.get_item_in_slot(slot_l_store_str)
		if(slot_l_store_str)    return inventory.get_item_in_slot(slot_l_store_str)
		if(slot_r_store)        return inventory.get_item_in_slot(slot_r_store_str)
		if(slot_r_store_str)    return inventory.get_item_in_slot(slot_r_store_str)
		if(slot_wear_mask)      return inventory.get_item_in_slot(slot_wear_mask_str)
		if(slot_wear_mask_str)  return inventory.get_item_in_slot(slot_wear_mask_str)
		if(slot_l_hand)         return get_left_hand()
		if(slot_l_hand_str)     return get_left_hand()
		if(slot_r_hand)         return get_right_hand()
		if(slot_r_hand_str)     return get_right_hand()
		if(slot_wear_id)        return inventory.get_item_in_slot(slot_wear_id_str)
		if(slot_wear_id_str)    return inventory.get_item_in_slot(slot_wear_id_str)
		if(slot_glasses)        return inventory.get_item_in_slot(slot_glasses_str)
		if(slot_glasses_str)    return inventory.get_item_in_slot(slot_glasses_str)
		if(slot_gloves)         return gloves
		if(slot_gloves_str)     return gloves
		if(slot_head)           return inventory.get_item_in_slot(slot_head_str)
		if(slot_head_str)       return inventory.get_item_in_slot(slot_head_str)
		if(slot_shoes)          return inventory.get_item_in_slot(slot_shoes_str)
		if(slot_shoes_str)      return inventory.get_item_in_slot(slot_shoes_str)
		if(slot_belt)           return inventory.get_item_in_slot(slot_belt_str)
		if(slot_belt_str)       return inventory.get_item_in_slot(slot_belt_str)
		if(slot_wear_suit)      return inventory.get_item_in_slot(slot_wear_suit_str)
		if(slot_wear_suit_str)  return inventory.get_item_in_slot(slot_wear_suit_str)
		if(slot_w_uniform)      return inventory.get_item_in_slot(slot_w_uniform_str)
		if(slot_w_uniform_str)  return inventory.get_item_in_slot(slot_w_uniform_str)
		if(slot_s_store)        return inventory.get_item_in_slot(slot_s_store_str)
		if(slot_s_store_str)    return inventory.get_item_in_slot(slot_s_store_str)
		if(slot_l_ear)          return inventory.get_item_in_slot(slot_l_ear_str)
		if(slot_l_ear_str)      return inventory.get_item_in_slot(slot_l_ear_str)
		if(slot_r_ear)          return inventory.get_item_in_slot(slot_r_ear_str)
		if(slot_r_ear_str)      return inventory.get_item_in_slot(slot_r_ear_str)
	return ..()

/mob/proc/get_equipped_items()
	. = list()

/mob/living/get_equipped_items()
	. = ..()
	. += get_left_hand()
	. += get_right_hand()
	. += inventory.get_item_in_slot(slot_back_str)
	. += inventory.get_item_in_slot(slot_wear_mask_str)

/mob/living/carbon/human/get_equipped_items()
	. = ..()
	. += inventory.get_item_in_slot(slot_belt_str)
	. += inventory.get_item_in_slot(slot_l_ear_str)
	. += inventory.get_item_in_slot(slot_r_ear_str)
	. += inventory.get_item_in_slot(slot_glasses_str)
	. += gloves
	. += inventory.get_item_in_slot(slot_head_str)
	. += inventory.get_item_in_slot(slot_shoes_str)
	. += inventory.get_item_in_slot(slot_wear_id_str)
	. += inventory.get_item_in_slot(slot_wear_suit_str)
	. += inventory.get_item_in_slot(slot_w_uniform_str)

/mob/proc/delete_inventory()
	for(var/entry in get_equipped_items())
		drop_from_inventory(entry)
		qdel(entry)

/mob/proc/abiotic(full_body = FALSE)
	return FALSE

/mob/living/abiotic(full_body = FALSE)
	var/obj/item/l_hand = get_left_hand()
	var/obj/item/r_hand = get_right_hand()
	if(full_body)
		if((istype(l_hand) && !l_hand.abstract) || (istype(r_hand) && !r_hand.abstract))
			return TRUE
		if(inventory.get_item_in_slot(slot_back_str) || inventory.get_item_in_slot(slot_wear_mask_str))
			return TRUE

	return (istype(l_hand) && !l_hand.abstract) || (istype(r_hand) && !r_hand.abstract)

/mob/living/carbon/human/abiotic(full_body = FALSE)
	var/obj/item/l_hand = get_left_hand()
	var/obj/item/r_hand = get_right_hand()
	if(full_body)
		if((istype(l_hand) && !l_hand.abstract) || (istype(r_hand) && !r_hand.abstract))
			return TRUE
		if(inventory.get_item_in_slot(slot_back_str) || inventory.get_item_in_slot(slot_wear_mask_str) || inventory.get_item_in_slot(slot_head_str) || inventory.get_item_in_slot(slot_shoes_str) || inventory.get_item_in_slot(slot_w_uniform_str) || inventory.get_item_in_slot(slot_wear_suit_str) || inventory.get_item_in_slot(slot_glasses_str) || inventory.get_item_in_slot(slot_l_ear_str) || inventory.get_item_in_slot(slot_r_ear_str) || gloves)
			return TRUE

	return (istype(l_hand) && !l_hand.abstract) || (istype(r_hand) && !r_hand.abstract)

// TODO: multihand
/mob/proc/get_left_hand()
	return inventory.get_item_in_slot(slot_l_hand_str)

/mob/proc/get_right_hand()
	return inventory.get_item_in_slot(slot_r_hand_str)
