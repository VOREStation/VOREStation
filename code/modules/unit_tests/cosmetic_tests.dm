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

/datum/unit_test/sprite_accessories_shall_be_unique/proc/validate_accessory_list(path)
	var/list/collection = list()
	for(var/datum/sprite_accessory/accessory as anything in subtypesof(path))
		if(accessory::name == DEVELOPER_WARNING_NAME)
			continue

		TEST_ASSERT(accessory::name, "[accessory::name] - [accessory::type]: Cosmetic - Missing name.")

		TEST_ASSERT(!collection[accessory::name], "[accessory::name] - [accessory::type]: Cosmetic - Name defined twice. Original def [collection[accessory::name]]")
		if(!collection[accessory::name])
			collection[accessory::name] = accessory::type

		if(ispath(accessory, text2path("[path]/invisible")))
			TEST_ASSERT(!accessory::icon_state, "[accessory::name] - [accessory::type]: Cosmetic - Invisible subtype has icon_state.")
		else if(!accessory::icon_state)
			TEST_FAIL("[accessory::name] - [accessory::type]: Cosmetic - Has no icon_state.")
		else
			// Check if valid icon
			validate_icons(accessory)

/datum/unit_test/sprite_accessories_shall_be_unique/proc/validate_icons(datum/sprite_accessory/accessory)
	var/actual_icon_state = accessory::icon_state

	if(istype(accessory, /datum/sprite_accessory/hair))
		actual_icon_state += "_s"
		TEST_ASSERT(icon_exists(accessory::icon, actual_icon_state), "[accessory::name] - [accessory::type]: Cosmetic - Icon_state \"[actual_icon_state]\" is not present in [accessory::icon].")
		return

	if(istype(accessory, /datum/sprite_accessory/facial_hair))
		actual_icon_state += "_s"
		TEST_ASSERT(icon_exists(accessory::icon, actual_icon_state), "[accessory::name] - [accessory::type]: Cosmetic - Icon_state \"[actual_icon_state]\" is not present in [accessory::icon].")
		return

	if(istype(accessory, /datum/sprite_accessory/marking))
		var/datum/sprite_accessory/marking/marking = accessory
		for(var/body_part in marking.body_parts)
			TEST_ASSERT(body_part in BP_ALL, "[accessory::name] - [accessory::type]: Cosmetic - Has an illegal bodypart \"[body_part]\". ONLY use parts listed in BP_ALL.")

			actual_icon_state = "[accessory::icon_state]-[body_part]"
			TEST_ASSERT(icon_exists(accessory::icon, actual_icon_state), "[accessory::name] - [accessory::type]: Cosmetic - Icon_state \"[actual_icon_state]\" is not present in [accessory::icon].")
		return
