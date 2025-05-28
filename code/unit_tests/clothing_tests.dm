/datum/unit_test/all_clothing_shall_be_valid
	name = "CLOTHING: All clothing shall be valid"
	var/signal_failed = FALSE

/datum/unit_test/all_clothing_shall_be_valid/start_test()
	var/failed = 0
	var/obj/storage = new()

	var/list/scan = subtypesof(/obj/item/clothing)
	scan -= typesof(/obj/item/clothing/head/hood) // These are part of clothing, need to be tested uniquely
	// Remove material armors, as dev_warning cannot be used to set their name
	scan -= /obj/item/clothing/suit/armor/material
	scan -= /obj/item/clothing/head/helmet/material
	scan -= /obj/item/clothing/ears/offear // This is used for equip logic, not ingame
	scan -= /obj/item/clothing/mask/ai // Breaks unit test entirely TODO

	var/i = 0
	var/tenths = 1
	var/a_tenth = scan.len / 10
	for(var/path as anything in scan)
		var/obj/item/clothing/C = new path(storage)
		failed += test_clothing(C)

		if(i > tenths * a_tenth)
			log_unit_test("Clothing - Progress [tenths * 10]% - [i]/[scan.len]")
			log_unit_test("---------------------------------------------------")
			tenths++

		if(istype(C,/obj/item/clothing/suit/storage/hooded))
			var/obj/item/clothing/suit/storage/hooded/H = C
			if(H.hood) // Testing hoods when they init
				failed += test_clothing(H.hood,storage)

		i++
		qdel(C)
	qdel(storage)

	if(failed)
		fail("One or more /obj/item/clothing items had invalid flags or icons")
	else
		pass("All /obj/item/clothing are valid.")
	return 1

/datum/unit_test/all_clothing_shall_be_valid/proc/test_clothing(var/obj/item/clothing/C,var/obj/storage)
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

	// Disabled, as currently not working in a presentable way, spams the CI hard, do not enable unless fixed
	#ifdef UNIT_TEST
	// Time for the most brutal part. Dressing up some mobs with set species, and checking they have art
	// An entire signal just for unittests had to be made for this!
	var/list/body_types = list(SPECIES_HUMAN,SPECIES_VOX,SPECIES_TESHARI) // Otherwise we would be here for centuries
	// **************************************************************************************************************************
	body_types = list() // 	DISABLED FOR NOW, No single person can resolve how many sprites are missing.
	// **************************************************************************************************************************
	if(body_types.len)
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
		// Get actual species that can use this, based on the mess of restricted/excluded logic above
		var/obj/mob_storage = new()
		var/mob/living/carbon/human/H = new(mob_storage)
		RegisterSignal(H, COMSIG_UNITTEST_DATA, PROC_REF(get_signal_data))
		for(var/B in body_types)
			H.set_species(B)
			// spawn the mob, signalize it, and then give it the item to see what it gets.
			H.put_in_active_hand(C)
			H.equip_to_appropriate_slot(C)
			H.drop_from_inventory(C, storage)
		UnregisterSignal(H, COMSIG_UNITTEST_DATA)
		qdel(H)
		qdel(mob_storage)
		// We failed the mob check
		if(signal_failed)
			failed = TRUE
	#endif

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

/datum/unit_test/all_clothing_shall_be_valid/get_signal_data(atom/source, list/data = list())
	SIGNAL_HANDLER
	switch(data[1])
		if("set_slot")
			var/slot_name 	= data[2]
			var/set_icon 	= data[3]
			var/set_state 	= data[4]
			//var/in_hands 	= data[5]
			var/item_path 	= data[6]
			var/species 	= data[7]
			if(!species)
				return
			if(!set_icon)
				return
			if(!set_state)
				return

			// Ignore storage
			if(slot_name == slot_l_hand_str)
				return
			if(slot_name == slot_r_hand_str)
				return

			// All that matters
			if(!("[set_state]" in cached_icon_states(set_icon)))
				log_unit_test("[item_path]: Clothing - Testing \"[species]\" state \"[set_state]\" for slot \"[slot_name]\", but it was not in dmi \"[set_icon]\"")
				signal_failed = TRUE
				return
