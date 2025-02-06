/datum/unit_test/sprite_accessories_shall_be_unique
	name = "COSMETICS: Entries shall have unique name."

/datum/unit_test/sprite_accessories_shall_be_unique/start_test()
	var/failed = 0

	var/list/collection = list()
	for(var/SP in subtypesof(/datum/sprite_accessory))
		var/datum/sprite_accessory/A = new SP()
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
		qdel(A)

	if(failed)
		fail("One or more /datum/sprite_accessory definitions had invalid names, icon_states, or names were reused definitions")
	else
		pass("All /datum/sprite_accessory definitions had correct settings.")
	return 1
