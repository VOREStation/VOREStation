/datum/unit_test/sprite_accessories_shall_be_unique
	name = "COSMETICS: Entries shall have unique name."

/datum/unit_test/sprite_accessories_shall_be_unique/start_test()
	var/failed = 0

	failed += validate_accessory_list(hair_styles_list)
	failed += validate_accessory_list(hair_styles_male_list)
	failed += validate_accessory_list(hair_styles_female_list)
	failed += validate_accessory_list(facial_hair_styles_list)
	failed += validate_accessory_list(facial_hair_styles_male_list)
	failed += validate_accessory_list(facial_hair_styles_female_list)
	failed += validate_accessory_list(skin_styles_female_list) //unused
	failed += validate_accessory_list(body_marking_styles_list)
	failed += validate_accessory_list(body_marking_nopersist_list)
	failed += validate_accessory_list(ear_styles_list)
	failed += validate_accessory_list(tail_styles_list)
	failed += validate_accessory_list(wing_styles_list)

	if(failed)
		fail("One or more /datum/sprite_accessory definitions had invalid names, icon_states, or names were reused definitions")
	else
		pass("All /datum/sprite_accessory definitions had correct settings.")
	return 1

/datum/unit_test/sprite_accessories_shall_be_unique/proc/validate_accessory_list(var/list/L)
	var/failed = 0

	var/list/collection = list()
	for(var/SP in L)
		var/datum/sprite_accessory/A = L[SP]
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
		if(!A.icon_state)
			log_unit_test("[A] - [A.type]: Cosmetic - Has no icon_state.")
			failed = 1

	return failed
