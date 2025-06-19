//This is a generic proc that should be called by other ling armor procs to equip them.
/mob/proc/changeling_generic_armor(var/armor_type, var/helmet_type, var/boot_type, var/chem_cost)

	if(!ishuman(src))
		return 0

	var/mob/living/carbon/human/M = src
	var/obj/item/wear_suit = M.inventory.get_item_in_slot(slot_wear_suit_str)

	if(istype(wear_suit, armor_type) || istype(M.head, helmet_type) || istype(M.shoes, boot_type))
		chem_cost = 0

	var/datum/changeling/changeling = changeling_power(chem_cost, 1, 100, CONSCIOUS)

	if(!changeling)
		return

	//First, check if we're already wearing the armor, and if so, take it off.
	if(istype(wear_suit, armor_type) || istype(M.head, helmet_type) || istype(M.shoes, boot_type))
		M.visible_message(span_warning("[M] casts off their [wear_suit.name]!"),
		span_warning("We cast off our [wear_suit.name]"),
		span_warningplain("You hear the organic matter ripping and tearing!"))
		if(istype(wear_suit, armor_type))
			qdel(wear_suit)
		if(istype(M.head, helmet_type))
			qdel(M.head)
		if(istype(M.shoes, boot_type))
			qdel(M.shoes)
		M.update_inv_wear_suit()
		M.update_inv_head()
		M.update_hair()
		M.update_inv_shoes()
		return 1

	if(M.head || wear_suit) //Make sure our slots aren't full
		to_chat(src, span_warning("We require nothing to be on our head, and we cannot wear any external suits, or shoes."))
		return 0

	var/obj/item/clothing/suit/A = new armor_type(src)
	src.equip_to_slot_or_del(A, slot_wear_suit)

	var/obj/item/clothing/suit/H = new helmet_type(src)
	src.equip_to_slot_or_del(H, slot_head)

	var/obj/item/clothing/shoes/B = new boot_type(src)
	src.equip_to_slot_or_del(B, slot_shoes)

	src.mind.changeling.chem_charges -= chem_cost
	playsound(src, 'sound/effects/blobattack.ogg', 30, 1)
	M.update_inv_wear_suit()
	M.update_inv_head()
	M.update_hair()
	M.update_inv_shoes()
	return 1

/mob/proc/changeling_generic_equip_all_slots(var/list/stuff_to_equip, var/cost)
	var/datum/changeling/changeling = changeling_power(cost,1,100,CONSCIOUS)
	if(!changeling)
		return

	if(!ishuman(src))
		return 0

	var/mob/living/carbon/human/M = src

	var/success = 0

	//First, check if we're already wearing the armor, and if so, take it off.

	if(M.mind.changeling.armor_deployed)
		if(M.head && stuff_to_equip["head"])
			if(istype(M.head, stuff_to_equip["head"]))
				qdel(M.head)
				success = 1

		if(stuff_to_equip["wear_id"])
			if(istype(M.inventory.get_item_in_slot(slot_wear_id_str), stuff_to_equip["wear_id"]))
				qdel(M.inventory.get_item_in_slot(slot_wear_id_str))
				success = 1

		if(stuff_to_equip["wear_suit"])
			if(istype(M.inventory.get_item_in_slot(slot_wear_suit_str), stuff_to_equip["wear_suit"]))
				qdel(M.inventory.get_item_in_slot(slot_wear_suit_str))
				success = 1

		if(M.gloves && stuff_to_equip["gloves"])
			if(istype(M.gloves, stuff_to_equip["gloves"]))
				qdel(M.gloves)
				success = 1
		if(M.shoes && stuff_to_equip["shoes"])
			if(istype(M.shoes, stuff_to_equip["shoes"]))
				qdel(M.shoes)
				success = 1

		if(stuff_to_equip["belt"])
			if(istype(M.inventory.get_item_in_slot(slot_belt_str), stuff_to_equip["belt"]))
				qdel(M.inventory.get_item_in_slot(slot_belt_str))
				success = 1


		if(stuff_to_equip["glasses"])
			if(istype(M.inventory.get_item_in_slot(slot_glasses_str), stuff_to_equip["glasses"]))
				qdel(M.inventory.get_item_in_slot(slot_glasses_str))
				success = 1

		if(stuff_to_equip["wear_mask"])
			if(istype(M.inventory.get_item_in_slot(slot_wear_mask_str), stuff_to_equip["wear_mask"]))
				qdel(M.inventory.get_item_in_slot(slot_wear_mask_str))
				success = 1

		var/atom/movable/back = inventory.get_item_in_slot(slot_back_str)
		if(back && stuff_to_equip["back"])
			if(istype(back, stuff_to_equip["back"]))
				for(var/atom/movable/AM in back.contents) //Dump whatever's in the bag before deleting.
					AM.forceMove(src.loc)
				qdel(back)
				success = 1

		var/atom/movable/w_uniform = inventory.get_item_in_slot(slot_w_uniform_str)
		if(w_uniform && stuff_to_equip["w_uniform"])
			if(istype(w_uniform, stuff_to_equip["w_uniform"]))
				qdel(w_uniform)
				success = 1

		if(success)
			playsound(src, 'sound/effects/splat.ogg', 30, 1)
			visible_message(span_warning("[src] pulls on their clothes, peeling it off along with parts of their skin attached!"),
			span_notice("We remove and deform our equipment."))
		M.mind.changeling.armor_deployed = 0
		return success

	else

		to_chat(M, span_notice("We begin growing our new equipment..."))

		var/list/grown_items_list = list()

		var/t = stuff_to_equip["head"]
		if(!M.head && t)
			var/I = new t
			M.equip_to_slot_or_del(I, slot_head)
			grown_items_list.Add("a helmet")
			playsound(src, 'sound/effects/blobattack.ogg', 30, 1)
			success = 1
			sleep(1 SECOND)

		t = stuff_to_equip["w_uniform"]
		if(!M.inventory.get_item_in_slot(slot_w_uniform_str) && t)
			var/I = new t
			M.equip_to_slot_or_del(I, slot_w_uniform)
			grown_items_list.Add("a uniform")
			playsound(src, 'sound/effects/blobattack.ogg', 30, 1)
			success = 1
			sleep(1 SECOND)

		t = stuff_to_equip["gloves"]
		if(!M.gloves && t)
			var/I = new t
			M.equip_to_slot_or_del(I, slot_gloves)
			grown_items_list.Add("some gloves")
			playsound(src, 'sound/effects/splat.ogg', 30, 1)
			success = 1
			sleep(1 SECOND)

		t = stuff_to_equip["shoes"]
		if(!M.shoes && t)
			var/I = new t
			M.equip_to_slot_or_del(I, slot_shoes)
			grown_items_list.Add("shoes")
			playsound(src, 'sound/effects/splat.ogg', 30, 1)
			success = 1
			sleep(1 SECOND)

		t = stuff_to_equip["belt"]
		if(!M.inventory.get_item_in_slot(slot_belt_str) && t)
			var/I = new t
			M.equip_to_slot_or_del(I, slot_belt)
			grown_items_list.Add("a belt")
			playsound(src, 'sound/effects/splat.ogg', 30, 1)
			success = 1
			sleep(1 SECOND)

		t = stuff_to_equip["glasses"]
		if(!M.inventory.get_item_in_slot(slot_glasses_str) && t)
			var/I = new t
			M.equip_to_slot_or_del(I, slot_glasses)
			grown_items_list.Add("some glasses")
			playsound(src, 'sound/effects/splat.ogg', 30, 1)
			success = 1
			sleep(1 SECOND)

		t = stuff_to_equip["wear_mask"]
		if(!M.inventory.get_item_in_slot(slot_wear_mask_str) && t)
			var/I = new t
			M.equip_to_slot_or_del(I, slot_wear_mask)
			grown_items_list.Add("a mask")
			playsound(src, 'sound/effects/splat.ogg', 30, 1)
			success = 1
			sleep(1 SECOND)

		t = stuff_to_equip["back"]
		if(!M.inventory.get_item_in_slot(slot_back_str) && t)
			var/I = new t
			M.equip_to_slot_or_del(I, slot_back)
			grown_items_list.Add("a backpack")
			playsound(src, 'sound/effects/blobattack.ogg', 30, 1)
			success = 1
			sleep(1 SECOND)

		t = stuff_to_equip["wear_suit"]
		if(!M.inventory.get_item_in_slot(slot_wear_suit_str) && t)
			var/I = new t
			M.equip_to_slot_or_del(I, slot_wear_suit)
			grown_items_list.Add("an exosuit")
			playsound(src, 'sound/effects/blobattack.ogg', 30, 1)
			success = 1
			sleep(1 SECOND)

		t = stuff_to_equip["wear_id"]
		if(!M.inventory.get_item_in_slot(slot_wear_id_str) && t)
			var/I = new t
			M.equip_to_slot_or_del(I, slot_wear_id)
			grown_items_list.Add("an ID card")
			playsound(src, 'sound/effects/splat.ogg', 30, 1)
			success = 1
			sleep(1 SECOND)

		var/feedback = english_list(grown_items_list, nothing_text = "nothing", and_text = " and ", comma_text = ", ", final_comma_text = "" )

		to_chat(M, span_notice("We have grown [feedback]."))

		if(success)
			M.mind.changeling.armor_deployed = 1
			M.mind.changeling.chem_charges -= 10
		return success

//This is a generic proc that should be called by other ling weapon procs to equip them.
/mob/proc/changeling_generic_weapon(var/weapon_type, var/make_sound = 1, var/cost = 20)
	var/datum/changeling/changeling = changeling_power(cost,1,100,CONSCIOUS)
	if(!changeling)
		return

	if(!ishuman(src))
		return 0

	var/mob/living/carbon/human/M = src

	if(M.hands_are_full()) //Make sure our hands aren't full.
		to_chat(src, span_warning("Our hands are full.  Drop something first."))
		return 0

	var/obj/item/W = new weapon_type(src)
	src.put_in_hands(W)

	src.mind.changeling.chem_charges -= cost
	if(make_sound)
		playsound(src, 'sound/effects/blobattack.ogg', 30, 1)
	return 1
