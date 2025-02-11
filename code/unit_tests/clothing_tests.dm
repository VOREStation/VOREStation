/datum/unit_test/all_clothing_shall_be_valid
	name = "CLOTHING: All clothing shall be valid"

/datum/unit_test/all_clothing_shall_be_valid/start_test()
	var/failed = 0
	var/turf/storage = new /turf/unsimulated/floor()

	var/list/scan = subtypesof(/obj/item/clothing)
	scan -= typesof(/obj/item/clothing/head/hood) // These are part of clothing, need to be tested uniquely

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
	// ID
	if(!C.name)
		log_unit_test("[C.type]: Clothing - Missing name.")
		failed = TRUE

	if(C.name == "")
		log_unit_test("[C.type]: Clothing - Empty name.")
		failed = TRUE

	// Icons
	var/actual_icon_state = "[C.icon_state]"
	if(!(actual_icon_state in cached_icon_states(C.icon)))
		if(C.icon == initial(C.icon) && actual_icon_state == initial(C.icon_state))
			log_unit_test("[C.type]: Clothing - Icon_state \"[actual_icon_state]\" is not present in [C.icon].")
		else
			log_unit_test("[C.type]: Clothing - Icon_state \"[actual_icon_state]\" is not present in [C.icon]. This icon/state was changed by init. Initial icon \"[initial(C.icon)]\". initial icon_state \"[initial(C.icon_state)]\". Check code.")
		failed = TRUE

	// Species icons (disabled for now, requires ALL clothing to have icons for different species)

	// Temps
	if(C.min_cold_protection_temperature < 0)
		log_unit_test("[C.type]: Clothing - Cold protection was lower than 0.")
		failed = TRUE

	if(C.max_heat_protection_temperature && C.min_cold_protection_temperature && C.max_heat_protection_temperature < C.min_cold_protection_temperature)
		log_unit_test("[C.type]: Clothing - Maximum heat protection was greater than minimum cold protection.")
		failed = TRUE

	if(C.cold_protection)
		if(islist(C.cold_protection))
			log_unit_test("[C.type]: Clothing - cold_protection was defined as a list, when it is a bitflag.")
			failed = TRUE
		else if(!isnum(C.cold_protection))
			log_unit_test("[C.type]: Clothing - cold_protection was defined as something other than a number, when it is a bitflag.")
			failed = TRUE
		else
			var/valid_range = HEAD|UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
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
			var/valid_range = HEAD|UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
			if(C.heat_protection && C.heat_protection != FULL_BODY)
				// Check flags that should be unused
				if(C.heat_protection & FACE)
					log_unit_test("[C.type]: Clothing - heat_protection uses FACE bitflag, this provides no protection, use HEAD.")
					failed = TRUE
				if(C.heat_protection & EYES)
					log_unit_test("[C.type]: Clothing - heat_protection uses EYES bitflag, this provides no protection, use HEAD.")
					failed = TRUE
	return failed
