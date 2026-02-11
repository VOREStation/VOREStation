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
	for(var/datum/pai_sprite/sprite in SSpai.get_chassis_list())
		if(sprite.sprite_icon == null)
			continue

		if(sprite.name in used_names)
			TEST_NOTICE(src, "[sprite.type] - Pai sprite name is not unique: \"[sprite.name]\"")
			failed = TRUE
		used_names.Add(sprite.name)

		if(!sprite.name || sprite.name == DEVELOPER_WARNING_NAME)
			TEST_NOTICE(src, "[sprite.type] - Pai sprite had invalid name: \"[sprite.name]\"")
			failed = TRUE


		if(!sprite.holo_projector)
			// check if we have valid icons
			if(!sprite.sprite_icon_state)
				TEST_NOTICE(src, "[sprite.type] - Pai sprite had no iconstate assigned")
				failed = TRUE
			if(!icon_exists(sprite.sprite_icon, sprite.sprite_icon_state))
				TEST_NOTICE(src, "[sprite.type] - Pai sprite state \"[sprite.sprite_icon_state]\" did not exist in the dmi set \"[sprite.sprite_icon]\"")
				failed = TRUE
			// Resting sprites must exist
			if(!icon_exists(sprite.sprite_icon, "[sprite.sprite_icon_state]_rest"))
				TEST_NOTICE(src, "[sprite.type] - Pai sprite state \"[sprite.sprite_icon_state]_rest\" did not exist in the dmi set \"[sprite.sprite_icon]\"")
				failed = TRUE
			// Check for vore stuff
			if(sprite.belly_states > 0)
				for(var/i = 1 to sprite.belly_states)
					var/fullness_extension = ""
					if(i > 1)
						fullness_extension = "_[i]"
					// standing bellies
					if(!icon_exists(sprite.sprite_icon, "[sprite.sprite_icon_state]_full[fullness_extension]"))
						TEST_NOTICE(src, "[sprite.type] - Pai sprite state \"[sprite.sprite_icon_state]_full[fullness_extension]\" did not exist in the dmi set \"[sprite.sprite_icon]\"")
						failed = TRUE
					// resting bellies
					if(!icon_exists(sprite.sprite_icon, "[sprite.sprite_icon_state]_rest_full[fullness_extension]"))
						TEST_NOTICE(src, "[sprite.type] - Pai sprite state \"[sprite.sprite_icon_state]_rest_full[fullness_extension]\" did not exist in the dmi set \"[sprite.sprite_icon]\"")
						failed = TRUE
			// Does it have colorable eyes?
			if(sprite.has_eye_color)
				if(!icon_exists(sprite.sprite_icon, "[sprite.sprite_icon_state]-eyes"))
					TEST_NOTICE(src, "[sprite.type] - Pai sprite state \"[sprite.sprite_icon_state]-eyes\" did not exist in the dmi set \"[sprite.sprite_icon]\"")
					failed = TRUE


		else // Holoprojector uses ai holo instead of a sprite
			if(!sprite.holo_eyes_icon_state)
				TEST_NOTICE(src, "[sprite.type] - Pai holoprojection eye state not set")
				failed = TRUE
			else
				// Holoprojectil eyes need to exist at all sizes for the state provided
				if(!icon_exists('icons/mob/pai_vr.dmi', sprite.holo_eyes_icon_state))
					TEST_NOTICE(src, "[sprite.type] - Pai holoprojection eyes state \"[sprite.holo_eyes_icon_state]\" did not exist in the dmi set \"['icons/mob/pai_vr.dmi']\"")
					failed = TRUE
				if(!icon_exists('icons/mob/pai_vr32x64.dmi', sprite.holo_eyes_icon_state))
					TEST_NOTICE(src, "[sprite.type] - Pai holoprojection eyes state \"[sprite.holo_eyes_icon_state]\" did not exist in the dmi set \"['icons/mob/pai_vr32x64.dmi']\"")
					failed = TRUE
				if(!icon_exists('icons/mob/pai_vr64x32.dmi', sprite.holo_eyes_icon_state))
					TEST_NOTICE(src, "[sprite.type] - Pai holoprojection eyes state \"[sprite.holo_eyes_icon_state]\" did not exist in the dmi set \"['icons/mob/pai_vr64x32.dmi']\"")
					failed = TRUE
				if(!icon_exists('icons/mob/pai_vr64x64.dmi', sprite.holo_eyes_icon_state))
					TEST_NOTICE(src, "[sprite.type] - Pai holoprojection eyes state \"[sprite.holo_eyes_icon_state]\" did not exist in the dmi set \"['icons/mob/pai_vr64x64.dmi']\"")
					failed = TRUE

	if(failed)
		TEST_FAIL("PAI sprites had invalid entries.")
