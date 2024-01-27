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

/mob
	var/obj/item/weapon/storage/s_active = null // Even ghosts can/should be able to peek into boxes on the ground

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

/* Inventory manipulation */

/mob/proc/put_in_any_hand_if_possible(obj/item/W as obj, del_on_fail = 0, disable_warning = 1, redraw_mob = 1)
	if(equip_to_slot_if_possible(W, slot_l_hand, del_on_fail, disable_warning, redraw_mob))
		return 1
	else if(equip_to_slot_if_possible(W, slot_r_hand, del_on_fail, disable_warning, redraw_mob))
		return 1
	return 0

//This is a SAFE proc. Use this instead of equip_to_slot()!
//set del_on_fail to have it delete W if it fails to equip
//set disable_warning to disable the 'you are unable to equip that' warning.
//unset redraw_mob to prevent the mob from being redrawn at the end.
/mob/proc/equip_to_slot_if_possible(obj/item/W as obj, slot, del_on_fail = 0, disable_warning = 0, redraw_mob = 1, ignore_obstructions = 1)
	if(!W)
		return 0
	if(!W.mob_can_equip(src, slot, disable_warning, ignore_obstructions))
		if(del_on_fail)
			qdel(W)

		else
			if(!disable_warning)
				to_chat(src, span_red("You are unable to equip that.")) //Only print if del_on_fail is false
		return 0

	equip_to_slot(W, slot, redraw_mob) //This proc should not ever fail.
	return 1

//This is an UNSAFE proc. It merely handles the actual job of equipping. All the checks on whether you can or can't eqip need to be done before! Use mob_can_equip() for that task.
//In most cases you will want to use equip_to_slot_if_possible()
/mob/proc/equip_to_slot(obj/item/W as obj, slot)
	return

//This is just a commonly used configuration for the equip_to_slot_if_possible() proc, used to equip people when the rounds tarts and when events happen and such.
/mob/proc/equip_to_slot_or_del(obj/item/W as obj, slot, ignore_obstructions = 1)
	return equip_to_slot_if_possible(W, slot, 1, 1, 0, ignore_obstructions)

//hurgh. these feel hacky, but they're the only way I could get the damn thing to work. I guess they could be handy for antag spawners too?
/mob/proc/equip_voidsuit_to_slot_or_del_with_refit(obj/item/clothing/suit/space/void/W as obj, slot, species = SPECIES_HUMAN)
	W.refit_for_species(species)
	return equip_to_slot_if_possible(W, slot, 1, 1, 0)

/mob/proc/equip_voidhelm_to_slot_or_del_with_refit(obj/item/clothing/head/helmet/space/void/W as obj, slot, species = SPECIES_HUMAN)
	W.refit_for_species(species)
	return equip_to_slot_if_possible(W, slot, 1, 1, 0)

//Checks if a given slot can be accessed at this time, either to equip or unequip I
/mob/proc/slot_is_accessible(var/slot, var/obj/item/I, mob/user=null)
	return 1

//puts the item "W" into an appropriate slot in a human's inventory
//returns 0 if it cannot, 1 if successful
/mob/proc/equip_to_appropriate_slot(obj/item/W)
	for(var/slot in slot_equipment_priority)
		if(equip_to_slot_if_possible(W, slot, del_on_fail=0, disable_warning=1, redraw_mob=1))
			return 1

	return 0

/mob/proc/equip_to_storage(obj/item/newitem, user_initiated = FALSE)
	return 0

/* Hands */

//Returns the thing in our active hand
/mob/proc/get_active_hand()

//Returns the thing in our inactive hand
/mob/proc/get_inactive_hand()

// Override for your specific mob's hands or lack thereof.
/mob/proc/is_holding_item_of_type(typepath)
	return FALSE

// Override for your specific mob's hands or lack thereof.
/mob/proc/get_all_held_items()
	return list()

//Puts the item into your l_hand if possible and calls all necessary triggers/updates. returns 1 on success.
/mob/proc/put_in_l_hand(var/obj/item/W)
	if(lying || !istype(W))
		return 0
	return 1

//Puts the item into your r_hand if possible and calls all necessary triggers/updates. returns 1 on success.
/mob/proc/put_in_r_hand(var/obj/item/W)
	if(lying || !istype(W))
		return 0
	return 1

//Puts the item into our active hand if possible. returns 1 on success.
/mob/proc/put_in_active_hand(var/obj/item/W)
	return 0 // Moved to human procs because only they need to use hands.

//Puts the item into our inactive hand if possible. returns 1 on success.
/mob/proc/put_in_inactive_hand(var/obj/item/W)
	return 0 // As above.

//Puts the item our active hand if possible. Failing that it tries our inactive hand. Returns 1 on success.
//If both fail it drops it on the floor and returns 0.
//This is probably the main one you need to know :)
/mob/proc/put_in_hands(var/obj/item/W)
	if(!W)
		return 0
	W.forceMove(drop_location())
	W.reset_plane_and_layer()
	W.dropped()
	return 0

// Removes an item from inventory and places it in the target atom.
// If canremove or other conditions need to be checked then use unEquip instead.

/mob/proc/drop_from_inventory(var/obj/item/W, var/atom/target)
	if(W)
		remove_from_mob(W, target)
		return TRUE
	return FALSE

//Drops the item in our left hand
/mob/proc/drop_l_hand(var/atom/Target)
	return 0

//Drops the item in our right hand
/mob/proc/drop_r_hand(var/atom/Target)
	return 0

//Drops the item in our active hand. TODO: rename this to drop_active_hand or something
/mob/proc/drop_item(var/atom/Target)
	return
/*
	Removes the object from any slots the mob might have, calling the appropriate icon update proc.
	Does nothing else.

	DO NOT CALL THIS PROC DIRECTLY. It is meant to be called only by other inventory procs.
	It's probably okay to use it if you are transferring the item between slots on the same mob,
	but chances are you're safer calling remove_from_mob() or drop_from_inventory() anyways.

	As far as I can tell the proc exists so that mobs with different inventory slots can override
	the search through all the slots, without having to duplicate the rest of the item dropping.
*/
/mob/proc/u_equip(obj/W as obj)

/mob/proc/isEquipped(obj/item/I)
	if(!I)
		return 0
	return get_inventory_slot(I) != 0

/mob/proc/canUnEquip(obj/item/I)
	if(!I) //If there's nothing to drop, the drop is automatically successful.
		return 1
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

///sometimes we only want to grant the item's action if it's equipped in a specific slot.
/obj/item/proc/item_action_slot_check(slot, mob/user)
	if(slot == SLOT_BACK || slot == LEGS) //these aren't true slots, so avoid granting actions there
		return FALSE
	return TRUE

///Get the item on the mob in the storage slot identified by the id passed in
/mob/proc/get_item_by_slot(slot_id)
	return null

/mob/proc/getBackSlot()
	return SLOT_BACK

//Attemps to remove an object on a mob.
/mob/proc/remove_from_mob(var/obj/O, var/atom/target)
	if(!O) // Nothing to remove, so we succeed.
		return 1
	src.u_equip(O)
	if (src.client)
		src.client.screen -= O
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
/mob/proc/get_equipped_item(var/slot)
	return null

//Outdated but still in use apparently. This should at least be a human proc.
/mob/proc/get_equipped_items()
	var/list/items = new/list()

	if(hasvar(src,"back")) if(src:back) items += src:back
	if(hasvar(src,"belt")) if(src:belt) items += src:belt
	if(hasvar(src,"l_ear")) if(src:l_ear) items += src:l_ear
	if(hasvar(src,"r_ear")) if(src:r_ear) items += src:r_ear
	if(hasvar(src,"glasses")) if(src:glasses) items += src:glasses
	if(hasvar(src,"gloves")) if(src:gloves) items += src:gloves
	if(hasvar(src,"head")) if(src:head) items += src:head
	if(hasvar(src,"shoes")) if(src:shoes) items += src:shoes
	if(hasvar(src,"wear_id")) if(src:wear_id) items += src:wear_id
	if(hasvar(src,"wear_mask")) if(src:wear_mask) items += src:wear_mask
	if(hasvar(src,"wear_suit")) if(src:wear_suit) items += src:wear_suit
	if(hasvar(src,"w_uniform")) if(src:w_uniform) items += src:w_uniform

	if(hasvar(src,"l_hand")) if(src:l_hand) items += src:l_hand
	if(hasvar(src,"r_hand")) if(src:r_hand) items += src:r_hand

	return items

/mob/proc/delete_inventory()
	for(var/entry in get_equipped_items())
		drop_from_inventory(entry)
		qdel(entry)
