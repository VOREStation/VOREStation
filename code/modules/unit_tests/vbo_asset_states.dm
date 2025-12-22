/// Tests that all mobs with assigned bellies use valid datums
/datum/unit_test/vbo_has_state

/datum/unit_test/vbo_has_state/Run()
	for(var/datum/belly_overlays/test_path as anything in subtypesof(/datum/belly_overlays))
		var/icon_name = icon_states_fast(initial(test_path.belly_icon))[1]
		if(!(icon_exists('icons/mob/vore_fullscreens/ui_lists/screen_full_vore_list_base.dmi', icon_name)))
			TEST_FAIL("[test_path] is missing inside the screen_full_vore_list_base list dmi file.")
