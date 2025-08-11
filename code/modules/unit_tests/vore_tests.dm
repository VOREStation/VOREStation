/// converted unit test, maybe should be fully refactored

// FIXME: THIS SHOULD BE REPLACED WITH ALLOCATE IN THE END
// SEE unit_test.dm NEW() WHY THIS ISNT IMPLEMENTED YET
/datum/unit_test
	var/static/default_mobloc = null

// FIXME: THIS SHOULD BE REPLACED WITH ALLOCATE IN THE END
// SEE unit_test.dm NEW() WHY THIS ISNT IMPLEMENTED YET
/datum/unit_test/proc/create_test_mob(var/turf/mobloc = null, var/mobtype = /mob/living/carbon/human, var/with_mind = FALSE)
	if(isnull(mobloc))
		if(!default_mobloc)
			for(var/turf/simulated/floor/tiled/T in world)
				var/pressure = T.zone.air.return_pressure()
				if(90 < pressure && pressure < 120) // Find a turf between 90 and 120
					default_mobloc = T
					break
		mobloc = default_mobloc
	if(!mobloc)
		fail("Unable to find a location to create test mob")
		return 0

	var/mob/living/carbon/human/H = new mobtype(mobloc)

	if(with_mind)
		H.mind_initialize("TestKey[rand(0,10000)]")

	return H

/// Test that a human mob does not suffocate in a belly
/datum/unit_test/belly_nonsuffocation
	var/startLifeTick
	var/startOxyloss
	var/endOxyloss
	var/mob/living/carbon/human/pred
	var/mob/living/carbon/human/prey

/datum/unit_test/belly_nonsuffocation/Run()
	pred = create_test_mob()
	if(!istype(pred))
		return 0
	prey = create_test_mob(pred.loc)
	if(!istype(prey))
		return 0

	return 1

/datum/unit_test/belly_nonsuffocation/check_result()
	// Unfortuantely we need to wait for the pred's belly to initialize. (Currently after a spawn())
	if(!pred.vore_organs || !pred.vore_organs.len)
		return 0

	// Now that pred belly exists, we can eat the prey.
	if(!pred.vore_selected)
		fail("[pred] has no vore_selected.")
		return 1

	// Attempt to eat the prey
	if(prey.loc != pred.vore_selected)
		pred.vore_selected.nom_mob(prey)

		if(prey.loc != pred.vore_selected)
			fail("[pred.vore_selected].nom_mob([prey]) did not put prey inside [pred]")
			return 1

		// Okay, we succeeded in eating them, now lets wait a bit
		startLifeTick = pred.life_tick
		startOxyloss = prey.getOxyLoss()
		return 0

	if(pred.life_tick < (startLifeTick + 10))
		return 0 // Wait for them to breathe a few times

	// Alright lets check it!
	endOxyloss = prey.getOxyLoss()
	if(startOxyloss < endOxyloss)
		fail("Prey takes oxygen damage in a pred's belly! (Before: [startOxyloss]; after: [endOxyloss])")
	else
		pass("Prey is not taking oxygen damage in pred's belly. (Before: [startOxyloss]; after: [endOxyloss])")

	qdel(prey)
	qdel(pred)
	return 1
////////////////////////////////////////////////////////////////
/datum/unit_test/belly_spacesafe
	name = "MOB: human mob protected from space in a belly"
	var/startLifeTick
	var/startOxyloss
	var/endOxyloss
	var/mob/living/carbon/human/pred
	var/mob/living/carbon/human/prey
	async = 1

/datum/unit_test/belly_spacesafe/start_test()
	pred = create_test_mob()
	if(!istype(pred))
		return 0
	prey = create_test_mob(pred.loc)
	if(!istype(prey))
		return 0

	return 1

/datum/unit_test/belly_spacesafe/check_result()
	// Unfortuantely we need to wait for the pred's belly to initialize. (Currently after a spawn())
	if(!pred.vore_organs || !pred.vore_organs.len)
		return 0

	// Now that pred belly exists, we can eat the prey.
	if(!pred.vore_selected)
		fail("[pred] has no vore_selected.")
		return 1

	// Attempt to eat the prey
	if(prey.loc != pred.vore_selected)
		pred.vore_selected.nom_mob(prey)

		if(prey.loc != pred.vore_selected)
			fail("[pred.vore_selected].nom_mob([prey]) did not put prey inside [pred]")
			return 1
		else
			// Get an empty space level instead of just picking a random space turf
			var/empty_z = using_map.get_empty_zlevel()
			if(!empty_z)
				fail("Unable to get empty z-level for vore space protection test!")
				return 1

			// Away from map edges so they don't transit while we're testing
			var/mid_w = round(world.maxx*0.5)
			var/mid_h = round(world.maxy*0.5)

			var/turf/T = locate(mid_w, mid_h, empty_z)

			if(!T)
				fail("Unable to get turf for vore space protection test!")
				return 1
			else
				pred.forceMove(T)

		// Okay, we succeeded in eating them, now lets wait a bit
		startLifeTick = pred.life_tick
		startOxyloss = prey.getOxyLoss()
		return 0

	if(pred.life_tick < (startLifeTick + 10))
		return 0 // Wait for them to breathe a few times

	// Alright lets check it!
	endOxyloss = prey.getOxyLoss()
	if(startOxyloss < endOxyloss)
		fail("Prey takes oxygen damage in space! (Before: [startOxyloss]; after: [endOxyloss])")
	else
		pass("Prey is not taking oxygen damage in space. (Before: [startOxyloss]; after: [endOxyloss])")

	qdel(prey)
	qdel(pred)
	return 1
////////////////////////////////////////////////////////////////
/datum/unit_test/belly_damage
	name = "MOB: human mob takes damage from digestion"
	var/startLifeTick
	var/startBruteBurn
	var/endBruteBurn
	var/mob/living/carbon/human/pred
	var/mob/living/carbon/human/prey
	async = 1

/datum/unit_test/belly_damage/start_test()
	pred = create_test_mob()
	if(!istype(pred))
		return 0
	prey = create_test_mob(pred.loc)
	if(!istype(prey))
		return 0

	return 1

/datum/unit_test/belly_damage/check_result()
	// Unfortuantely we need to wait for the pred's belly to initialize. (Currently after a spawn())
	if(!pred.vore_organs || !pred.vore_organs.len)
		return 0

	// Now that pred belly exists, we can eat the prey.
	if(!pred.vore_selected)
		fail("[pred] has no vore_selected.")
		return 1

	// Attempt to eat the prey
	if(prey.loc != pred.vore_selected)
		pred.vore_selected.nom_mob(prey)

		if(prey.loc != pred.vore_selected)
			fail("[pred.vore_selected].nom_mob([prey]) did not put prey inside [pred]")
			return 1

		// Okay, we succeeded in eating them, now lets wait a bit
		pred.vore_selected.digest_mode = DM_DIGEST
		startLifeTick = pred.life_tick
		startBruteBurn = prey.getBruteLoss() + prey.getFireLoss()
		return 0

	if(pred.life_tick < (startLifeTick + 10))
		return 0 // Wait a few ticks for damage to happen

	// Alright lets check it!
	endBruteBurn = prey.getBruteLoss() + prey.getFireLoss()
	if(startBruteBurn >= endBruteBurn)
		fail("Prey doesn't take damage in digesting belly! (Before: [startBruteBurn]; after: [endBruteBurn])")
	else
		pass("Prey is taking damage in pred's belly. (Before: [startBruteBurn]; after: [endBruteBurn])")

	qdel(prey)
	qdel(pred)
	return 1
