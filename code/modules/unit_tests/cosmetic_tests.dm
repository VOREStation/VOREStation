/// converted unit test, maybe should be fully refactored
/// MIGHT REQUIRE BIGGER REWORK

/// Test that tests that all cosmetics have unique name entries
/datum/unit_test/sprite_accessories_shall_be_unique

/datum/unit_test/sprite_accessories_shall_be_unique/Run()
	validate_accessory_list(/datum/sprite_accessory/ears)
	validate_accessory_list(/datum/sprite_accessory/facial_hair)
	validate_accessory_list(/datum/sprite_accessory/hair)
	validate_accessory_list(/datum/sprite_accessory/hair_accessory)
	validate_accessory_list(/datum/sprite_accessory/marking)
	validate_accessory_list(/datum/sprite_accessory/tail)
	validate_accessory_list(/datum/sprite_accessory/wing)

/datum/unit_test/sprite_accessories_shall_be_unique/proc/validate_accessory_list(var/path)
	var/list/collection = list()
	for(var/SP in subtypesof(path))
		var/datum/sprite_accessory/A = new SP()
		TEST_ASSERT(A, "[SP]: Cosmetic - Path resolved to null in list.")
		if(!A)
			continue

		TEST_ASSERT(A.name, "[A] - [A.type]: Cosmetic - Missing name.")

		if(A.name == DEVELOPER_WARNING_NAME)
			continue

		TEST_ASSERT(!collection[A.name], "[A] - [A.type]: Cosmetic - Name defined twice. Original def [collection[A.name]]")
		if(!collection[A.name])
			collection[A.name] = A.type

		if(istype(A,text2path("[path]/invisible")))
			TEST_ASSERT(!A.icon_state, "[A] - [A.type]: Cosmetic - Invisible subtype has icon_state.")
		else if(!A.icon_state)
			TEST_ASSERT(A.icon_state, "[A] - [A.type]: Cosmetic - Has no icon_state.")
		else
			// Check if valid icon
			validate_icons(A)

		qdel(A)

/datum/unit_test/sprite_accessories_shall_be_unique/proc/validate_icons(datum/sprite_accessory/A)
	var/actual_icon_state = A.icon_state

	if(istype(A,/datum/sprite_accessory/hair))
		actual_icon_state = "[A.icon_state]_s"
		TEST_ASSERT(icon_exists(actual_icon_state, A.icon), "[A] - [A.type]: Cosmetic - Icon_state \"[actual_icon_state]\" is not present in [A.icon].")
		//TEST_ASSERT(actual_icon_state in cached_icon_states(A.icon), "[A] - [A.type]: Cosmetic - Icon_state \"[actual_icon_state]\" is not present in [A.icon].")

	if(istype(A,/datum/sprite_accessory/facial_hair))
		actual_icon_state = "[A.icon_state]_s"
		TEST_ASSERT(icon_exists(actual_icon_state, A.icon), "[A] - [A.type]: Cosmetic - Icon_state \"[actual_icon_state]\" is not present in [A.icon].")
		//TEST_ASSERT(actual_icon_state in cached_icon_states(A.icon), "[A] - [A.type]: Cosmetic - Icon_state \"[actual_icon_state]\" is not present in [A.icon].")

	if(istype(A,/datum/sprite_accessory/marking))
		var/datum/sprite_accessory/marking/MA = A
		for(var/BP in MA.body_parts)
			TEST_ASSERT(BP in BP_ALL, "[A] - [A.type]: Cosmetic - Has an illegal bodypart \"[BP]\". ONLY use parts listed in BP_ALL.")

			actual_icon_state = "[A.icon_state]-[BP]"
			TEST_ASSERT(icon_exists(actual_icon_state, A.icon), "[A] - [A.type]: Cosmetic - Icon_state \"[actual_icon_state]\" is not present in [A.icon].")
			//TEST_ASSERT(actual_icon_state in cached_icon_states(A.icon), "[A] - [A.type]: Cosmetic - Icon_state \"[actual_icon_state]\" is not present in [A.icon].")
