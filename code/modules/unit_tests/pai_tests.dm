/datum/unit_test/pai_software_shall_have_unique_id

/datum/unit_test/pai_software_shall_have_unique_id/Run()
	for(var/datum/pai_software/P as anything in subtypesof(/datum/pai_software))
		// Compare against all other pai softwares
		for(var/datum/pai_software/O as anything in subtypesof(/datum/pai_software))
			if(P == O) // Don't test against ourselves
				continue
			if(initial(P.id) == initial(O.id))
				TEST_FAIL("pAI software module [P] has the same id as [O]!")

/datum/unit_test/pai_sprites_shall_be_valid

/datum/unit_test/pai_sprites_shall_be_valid/Run()
	var/failed = FALSE
	var/list/used_names = list()
	for(var/datum/pai_sprite/sprite as anything in subtypesof(/datum/pai_sprite))
		if(initial(sprite.sprite_icon) == null)
			continue

		if(initial(sprite.name) in used_names)
			TEST_NOTICE(src, "[sprite] - Pai sprite name is not unique: \"[initial(sprite.name)]\"")
			failed = TRUE
		used_names.Add(initial(sprite.name))

		if(!initial(sprite.name) || initial(sprite.name) == DEVELOPER_WARNING_NAME)
			TEST_NOTICE(src, "[sprite] - Pai sprite had invalid name: \"[initial(sprite.name)]\"")
			failed = TRUE


	if(failed)
		TEST_FAIL("PAI sprites had invalid entries.")
