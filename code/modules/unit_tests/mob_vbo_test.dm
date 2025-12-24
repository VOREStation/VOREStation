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
