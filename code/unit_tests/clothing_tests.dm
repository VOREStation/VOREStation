/datum/unit_test/all_clothing_shall_be_valid
	name = "CLOTHING: All clothing shall be valid"

/datum/unit_test/loadout_test_shall_have_name_cost_path/start_test()
	var/failed = 0
	var/obj/storage = new()

	for(var/path as anything in subtypesof(/obj/item/clothing))
		var/obj/item/clothing/C = new path(storage)

		// ID
		if(!C.name)
			log_unit_test("[path]: Clothing - Missing name.")
			failed = 1

		if(C.name == "")
			log_unit_test("[path]: Clothing - Empty name.")
			failed = 1

		// Icons
		var/actual_icon_state = "[C.icon_state]"
		if(!(actual_icon_state in cached_icon_states(A.icon)))
			if(C.icon == initial(C.icon) && actual_icon_state == initial(C.icon_state))
				log_unit_test("[path]: Clothing - Icon_state \"[actual_icon_state]\" is not present in [C.icon].")
			else
				log_unit_test("[path]: Clothing - Icon_state \"[actual_icon_state]\" is not present in [C.icon]. This icon/state was changed by init. Initial icon \"[initial(C.icon)]\". initial icon_state \"[initial(C.icon_state)]\". Check code.")
			failed = 1

		// Species icons (disabled for now, requires ALL clothing to have icons for different species)

		// Temps
		if(C.min_cold_protection_temperature < 0)
			log_unit_test("[path]: Clothing - Cold protection was lower than 0.")
			failed = 1

		if(max_heat_protection_temperature && min_cold_protection_temperature && max_heat_protection_temperature < min_cold_protection_temperature)
			log_unit_test("[path]: Clothing - Maximum heat protection was greater than minimum cold protection.")
			failed = 1

		if(C.cold_protection)
			if(islist(C.cold_protection))
				log_unit_test("[path]: Clothing - cold_protection was defined as a list, when it is a bigflag.")
				failed = 1
			else if(!isnum(C.cold_protection))
				log_unit_test("[path]: Clothing - cold_protection was defined as something other than a number, when it is a bigflag.")
				failed = 1
			else
				var/valid_range = HEAD|UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
				if(C.cold_protection && C.cold_protection != FULL_BODY)
					// Check flags that should be unused
					if(check & FACE)
						log_unit_test("[path]: Clothing - cold_protection uses FACE bitflag, this provides no protection, use HEAD.")
						failed = 1
					if(check & EYES)
						log_unit_test("[path]: Clothing - cold_protection uses EYES bitflag, this provides no protection, use HEAD.")
						failed = 1

		if(C.heat_protection)
			if(islist(C.heat_protection))
				log_unit_test("[path]: Clothing - heat_protection was defined as a list, when it is a bigflag.")
				failed = 1
			else if(!isnum(C.heat_protection))
				log_unit_test("[path]: Clothing - heat_protection was defined as something other than a number, when it is a bigflag.")
				failed = 1
			else
				var/valid_range = HEAD|UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
				if(C.heat_protection && C.heat_protection != FULL_BODY)
					// Check flags that should be unused
					if(check & FACE)
						log_unit_test("[path]: Clothing - heat_protection uses FACE bitflag, this provides no protection, use HEAD.")
						failed = 1
					if(check & EYES)
						log_unit_test("[path]: Clothing - heat_protection uses EYES bitflag, this provides no protection, use HEAD.")
						failed = 1
		qdel(C)
	qdel(storage)

	if(failed)
		fail("One or more /obj/item/clothing items had invalid flags or icons")
	else
		pass("All /obj/item/clothing are valid.")
	return 1
