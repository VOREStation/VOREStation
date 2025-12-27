/// Tests that all mobs with assigned bellies use valid datums
/datum/unit_test/vbo_has_state

/datum/unit_test/vbo_has_state/Run()
	for(var/datum/belly_overlays/test_path as anything in subtypesof(/datum/belly_overlays))
		var/icon_name = icon_states_fast(initial(test_path.belly_icon))[1]
		if(!(icon_exists('icons/mob/vore_fullscreens/ui_lists/screen_full_vore_list_base.dmi', icon_name)))
			TEST_FAIL("[test_path] is missing inside the screen_full_vore_list_base list dmi file.")

/// Tests that all mobs with assigned bellies use valid datums
/datum/unit_test/mobs_use_valid_belly_overlays

/datum/unit_test/mobs_use_valid_belly_overlays/Run()
	for(var/mob/living/simple_mob/test_path as anything in typesof(/mob/living/simple_mob))
		if(!initial(test_path.vore_active))
			continue
		var/mob/living/simple_mob/test_mob = new test_path()
		test_mob.init_vore(TRUE)
		for(var/obj/belly/mob_belly in test_mob.vore_organs)
			var/test_fullscreen = mob_belly.belly_fullscreen
			if(!length(test_fullscreen))
				continue
			var/datum/belly_overlays/test_overlay = text2path("/datum/belly_overlays/[lowertext(test_fullscreen)]")
			if(test_overlay)
				continue
			TEST_FAIL("[test_mob] uses a non existing belly_fullscreen [test_fullscreen].")
		qdel(test_mob)
