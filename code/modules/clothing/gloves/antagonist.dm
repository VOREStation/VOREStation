/*
 * Antagonist-specific gloves, such as traitor or ling-only types.
 */

// Thief - Traitor / Merc
/obj/item/clothing/gloves/sterile/thieves
	name = "sterile gloves"
	desc = "Sterile gloves."
	description_antag = "These gloves are uniquely suited for stealing, as well as breaking and entering. They have minor insulation.\
	Attempting to 'help' someone will open their backpack, if it exists, or their belt if they have no backpack, allowing you to deposit\
	items into the inventories. Be careful about making too much noise.\
	Disarm intent will swap the items in your LEFT pockets. Grab will swap RIGHT pockets."
	icon_state = "latex"
	item_state_slots = list(slot_r_hand_str = "white", slot_l_hand_str = "white")
	siemens_coefficient = 0.5 // Not perfect, but slightly more protective than nothing.
	permeability_coefficient = 0.01
	germ_level = 0
	fingerprint_chance = 10 // They're thieves' gloves. What do you think?

/obj/item/clothing/gloves/sterile/thieves/proc/pickpocket(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/proximity)
	if(!proximity || !user || !target)
		return 0

	if(!istype(target))
		return 0

	if(user.a_intent != I_HURT && (turn(target.dir, 180) == get_dir(user, target)))
		to_chat(target, span_warning("[user] rifles in your pockets!"))

	if(user.a_intent == I_HELP)
		if(istype(target.inventory.get_item_in_slot(slot_back_str),/obj/item/storage) && do_after(user, 3 SECONDS, target))
			var/obj/item/storage/Backpack = target.inventory.get_item_in_slot(slot_back_str)
			Backpack.open(user)
		else if(istype(target.belt, /obj/item/storage) && do_after(user, 5 SECONDS, target))
			var/obj/item/storage/Belt = target.belt
			Belt.open(user)
		return 1

	if(user.a_intent == I_DISARM)
		var/obj/item/LTarg = target.inventory.get_item_in_slot(slot_l_store_str)
		var/obj/item/LUser = user.inventory.get_item_in_slot(slot_l_store_str)

		if(do_after(user, 1 SECOND, target))
			if(istype(LTarg) && do_after(user, 1 SECOND, target))
				target.drop_from_inventory(LTarg)
				target.inventory.put_item_in_slot(slot_l_store_str, null)
				user.inventory.put_item_in_slot(slot_l_store_str, LTarg)
				LTarg.forceMove(user)
				LTarg.equipped(user, slot_l_store)
			else
				target.drop_from_inventory(LTarg)

			if(istype(LUser) && do_after(user, 1 SECOND, target))
				user.drop_from_inventory(LUser)
				target.inventory.put_item_in_slot(slot_l_store_str, LUser)
				LUser.forceMove(target)
				LUser.equipped(target, slot_l_store)
			else if(istype(LUser) && LUser != user.inventory.get_item_in_slot(slot_l_store_str)) // We've taken something, so drop the one that's in bluespace.
				user.drop_from_inventory(LUser)

		return 1

	if(user.a_intent == I_GRAB)
		var/obj/item/RTarg = target.inventory.get_item_in_slot(slot_r_store_str)
		var/obj/item/RUser = user.inventory.get_item_in_slot(slot_r_store_str)

		if(do_after(user, 1 SECOND, target))
			if(istype(RTarg) && do_after(user, 1 SECOND, target))
				target.drop_from_inventory(RTarg)
				target.inventory.put_item_in_slot(slot_r_store_str, null)
				user.inventory.put_item_in_slot(slot_r_store_str, RTarg)
				RTarg.forceMove(user)
				RTarg.equipped(user, slot_r_store)
			else
				target.drop_from_inventory(RTarg)

			if(istype(RUser) && do_after(user, 1 SECOND, target))
				user.drop_from_inventory(RUser)
				target.inventory.put_item_in_slot(slot_r_store_str, RUser)
				RUser.forceMove(target)
				RUser.equipped(target, slot_r_store)
			else if(istype(RUser) && RUser != user.inventory.get_item_in_slot(slot_r_store_str)) // We've taken something, so drop the one that's in bluespace.
				user.drop_from_inventory(RUser)

		return 1

/obj/item/clothing/gloves/sterile/thieves/Touch(var/atom/A, var/proximity)
	if(proximity && ishuman(usr) && do_after(usr, 1 SECOND, A))
		return pickpocket(usr, A, proximity)
	return 0
