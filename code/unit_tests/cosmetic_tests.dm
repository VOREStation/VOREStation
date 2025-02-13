/datum/unit_test/sprite_accessories_shall_be_unique
	name = "COSMETICS: Entries shall have unique name."

/datum/unit_test/sprite_accessories_shall_be_unique/start_test()
	var/failed = 0

	failed += validate_accessory_list( /datum/sprite_accessory/ears)
	failed += validate_accessory_list( /datum/sprite_accessory/facial_hair)
	failed += validate_accessory_list( /datum/sprite_accessory/hair)
	failed += validate_accessory_list( /datum/sprite_accessory/hair_accessory)
	failed += validate_accessory_list( /datum/sprite_accessory/marking)
	failed += validate_accessory_list( /datum/sprite_accessory/tail)
	failed += validate_accessory_list( /datum/sprite_accessory/wing)

	if(failed)
		fail("One or more /datum/sprite_accessory definitions had invalid names, icon_states, or names were reused definitions")
	else
		pass("All /datum/sprite_accessory definitions had correct settings.")
	return 1

/datum/unit_test/sprite_accessories_shall_be_unique/proc/validate_accessory_list(var/path)
	var/failed = 0
	var/total_good = 0
	var/total_all = 0

	var/list/collection = list()
	for(var/SP in subtypesof(path))
		total_all++
		var/datum/sprite_accessory/A = new SP()
		if(!A)
			log_unit_test("[SP]: Cosmetic - Path resolved to null in list.")
			continue

		if(!A.name)
			log_unit_test("[A] - [A.type]: Cosmetic - Missing name.")
			failed = 1

		if(A.name == DEVELOPER_WARNING_NAME)
			continue

		if(collection[A.name])
			log_unit_test("[A] - [A.type]: Cosmetic - Name defined twice. Original def [collection[A.name]]")
			failed = 1
		else
			collection[A.name] = A.type

		if(istype(A,text2path("[path]/invisible")))
			if(A.icon_state)
				log_unit_test("[A] - [A.type]: Cosmetic - Invisible subtype has icon_state.")
				failed = 1
		else if(!A.icon_state)
			log_unit_test("[A] - [A.type]: Cosmetic - Has no icon_state.")
			failed = 1
		else
			// Check if valid icon
			failed += validate_icons(A)

		total_good++
		qdel(A)

	log_unit_test("[path]: Cosmetic - Total valid count: [total_good]/[total_all].")
	return failed

/datum/unit_test/sprite_accessories_shall_be_unique/proc/validate_icons(var/datum/sprite_accessory/A)
	var/failed = 0
	var/actual_icon_state = A.icon_state
	if(istype(A,/datum/sprite_accessory/hair))
		actual_icon_state = "[A.icon_state]_s"
		if(!(actual_icon_state in cached_icon_states(A.icon)))
			log_unit_test("[A] - [A.type]: Cosmetic - Icon_state \"[actual_icon_state]\" is not present in [A.icon].")
			failed = 1

	if(istype(A,/datum/sprite_accessory/facial_hair))
		actual_icon_state = "[A.icon_state]_s"
		if(!(actual_icon_state in cached_icon_states(A.icon)))
			log_unit_test("[A] - [A.type]: Cosmetic - Icon_state \"[actual_icon_state]\" is not present in [A.icon].")
			failed = 1

	if(istype(A,/datum/sprite_accessory/marking))
		var/datum/sprite_accessory/marking/MA = A
		for(var/BP in MA.body_parts)
			if(!(BP in BP_ALL))
				log_unit_test("[A] - [A.type]: Cosmetic - Has an illegal bodypart \"[BP]\". ONLY use parts listed in BP_ALL.")
				failed = 1

			actual_icon_state = "[A.icon_state]-[BP]"
			if(!(actual_icon_state in cached_icon_states(A.icon)))
				log_unit_test("[A] - [A.type]: Cosmetic - Icon_state \"[actual_icon_state]\" is not present in [A.icon].")
				failed = 1

	return failed
