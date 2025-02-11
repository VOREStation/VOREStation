/datum/unit_test/all_clothing_shall_be_valid
	name = "CLOTHING: All clothing shall be valid"

/datum/unit_test/all_clothing_shall_be_valid/start_test()
	var/failed = 0
	var/obj/storage = new()

	var/list/scan = subtypesof(/obj/item/clothing)
	scan -= typesof(/obj/item/clothing/head/hood) // These are part of clothing, need to be tested uniquely
	// Remove material armors, as dev_warning cannot be used to set their name
	scan -= /obj/item/clothing/suit/armor/material
	scan -= /obj/item/clothing/head/helmet/material
	scan -= /obj/item/clothing/ears/offear // This is used for equip logic, not ingame

	for(var/path as anything in scan)
		var/obj/item/clothing/C = new path(storage)
		failed += test_clothing(C)

		if(istype(C,/obj/item/clothing/suit/storage/hooded))
			var/obj/item/clothing/suit/storage/hooded/H = C
			if(H.hood) // Testing hoods when they init
				failed += test_clothing(H.hood)

		qdel(C)
	qdel(storage)

	if(failed)
		fail("One or more /obj/item/clothing items had invalid flags or icons")
	else
		pass("All /obj/item/clothing are valid.")
	return 1

/datum/unit_test/all_clothing_shall_be_valid/proc/test_clothing(var/obj/item/clothing/C)
	var/failed = FALSE

	// Do not test base-types
	if(C.name == DEVELOPER_WARNING_NAME)
		return FALSE

	// ID
	if(!C.name)
		log_unit_test("[C.type]: Clothing - Missing name.")
		failed = TRUE

	if(C.name == "")
		log_unit_test("[C.type]: Clothing - Empty name.")
		failed = TRUE

	// Icons
	if(!("[C.icon_state]" in cached_icon_states(C.icon)))
		if(C.icon == initial(C.icon) && C.icon_state == initial(C.icon_state))
			log_unit_test("[C.type]: Clothing - Icon_state \"[C.icon_state]\" is not present in [C.icon].")
		else
			log_unit_test("[C.type]: Clothing - Icon_state \"[C.icon_state]\" is not present in [C.icon]. This icon/state was changed by init. Initial icon \"[initial(C.icon)]\". initial icon_state \"[initial(C.icon_state)]\". Check code.")
		failed = TRUE

	/* Disabled, as currently not working in a presentable way, spams the CI hard, do not enable unless fixed
	// held icons
	var/list/slot_to_default = list(
		slot_l_hand_str = INV_L_HAND_DEF_ICON,
		slot_r_hand_str = INV_R_HAND_DEF_ICON,
		slot_wear_id_str = INV_WEAR_ID_DEF_ICON,
		slot_head_str = INV_HEAD_DEF_ICON,
		slot_back_str = INV_BACK_DEF_ICON,
		slot_wear_suit_str = INV_SUIT_DEF_ICON,
		slot_gloves_str = INV_GLOVES_DEF_ICON,
		slot_gloves_str = INV_EYES_DEF_ICON,
		slot_l_ear_str = INV_EARS_DEF_ICON,
		slot_r_ear_str = INV_EARS_DEF_ICON,
		slot_shoes_str = INV_FEET_DEF_ICON,
		slot_belt_str = INV_BELT_DEF_ICON,
		slot_wear_mask_str = INV_MASK_DEF_ICON
	)
	var/list/slotlist = list(slot_back_str,
							slot_l_hand_str,
							slot_r_hand_str,
							slot_w_uniform_str,
							slot_head_str,
							slot_wear_suit_str,
							slot_l_ear_str,
							slot_r_ear_str,
							slot_belt_str,
							slot_shoes_str,
							slot_wear_mask_str,
							slot_handcuffed_str,
							slot_legcuffed_str,
							slot_wear_id_str,
							slot_gloves_str,
							slot_glasses_str,
							slot_s_store_str,
							slot_tie_str)
	var/list/body_types = list(SPECIES_HUMAN,SPECIES_VOX,SPECIES_TESHARI) // Otherwise we would be here for centuries
	if(C.species_restricted && C.species_restricted.len)
		if(C.species_restricted[1] == "exclude")
			for(var/B in body_types)
				if(B in C.species_restricted)
					body_types -= B
		else
			var/list/new_list = list()
			for(var/B in body_types)
				if(B in C.species_restricted)
					new_list += B
			body_types = new_list

	for(var/B in body_types)
		for(var/slot in slotlist)
			var/dmi = C.get_worn_icon_file(B, slot, slot_to_default[slot], FALSE)
			var/state = C.get_worn_icon_state(slot)
			if(dmi && !("[state]" in cached_icon_states(dmi)))
				log_unit_test("[C.type]: Clothing - While being wearable by the species \"[B]\". A dmi \"[dmi]\" in the slot of \"[slot]\" was defined, but no item_state \"[state]\" was found inside of it.")
				failed = TRUE
	*/

	// Temps
	if(C.min_cold_protection_temperature < 0)
		log_unit_test("[C.type]: Clothing - Cold protection was lower than 0.")
		failed = TRUE

	if(C.max_heat_protection_temperature && C.min_cold_protection_temperature && C.max_heat_protection_temperature < C.min_cold_protection_temperature)
		log_unit_test("[C.type]: Clothing - Maximum heat protection was greater than minimum cold protection.")
		failed = TRUE

	//var/valid_range = HEAD|UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	if(C.cold_protection)
		if(islist(C.cold_protection))
			log_unit_test("[C.type]: Clothing - cold_protection was defined as a list, when it is a bitflag.")
			failed = TRUE
		else if(!isnum(C.cold_protection))
			log_unit_test("[C.type]: Clothing - cold_protection was defined as something other than a number, when it is a bitflag.")
			failed = TRUE
		else
			if(C.cold_protection && C.cold_protection != FULL_BODY)
				// Check flags that should be unused
				if(C.cold_protection & FACE)
					log_unit_test("[C.type]: Clothing - cold_protection uses FACE bitflag, this provides no protection, use HEAD.")
					failed = TRUE
				if(C.cold_protection & EYES)
					log_unit_test("[C.type]: Clothing - cold_protection uses EYES bitflag, this provides no protection, use HEAD.")
					failed = TRUE

	if(C.heat_protection)
		if(islist(C.heat_protection))
			log_unit_test("[C.type]: Clothing - heat_protection was defined as a list, when it is a bitflag.")
			failed = TRUE
		else if(!isnum(C.heat_protection))
			log_unit_test("[C.type]: Clothing - heat_protection was defined as something other than a number, when it is a bitflag.")
			failed = TRUE
		else
			if(C.heat_protection && C.heat_protection != FULL_BODY)
				// Check flags that should be unused
				if(C.heat_protection & FACE)
					log_unit_test("[C.type]: Clothing - heat_protection uses FACE bitflag, this provides no protection, use HEAD.")
					failed = TRUE
				if(C.heat_protection & EYES)
					log_unit_test("[C.type]: Clothing - heat_protection uses EYES bitflag, this provides no protection, use HEAD.")
					failed = TRUE
	return failed
