/datum/unit_test/proc/create_test_human(turf/loc = null)
	if(!loc)
		for(var/turf/simulated/floor/tiled/T in world)
			var/pressure = T.zone.air.return_pressure()
			if(90 < pressure && pressure < 120) // Find a turf between 90 and 120
				loc = T
				break

	TEST_ASSERT(loc, "No valid turf available for test mob")

	var/mob/living/carbon/human/test_human = allocate(/mob/living/carbon/human, loc)

	return test_human

/datum/unit_test/belly_nonsuffocation

/datum/unit_test/belly_nonsuffocation/Run()
	var/mob/living/carbon/human/pred = create_test_human()
	var/mob/living/carbon/human/prey = create_test_human()

	TEST_ASSERT(pred && prey, "Failed to create test mobs")

	pred.init_vore(TRUE)
	TEST_ASSERT(pred.vore_selected, "[pred] has no vore_selected")

	pred.vore_selected.nom_mob(prey)

	TEST_ASSERT(prey.loc == pred.vore_selected, "Prey not inside predator belly")

	var/start_oxy = prey.getOxyLoss()
	var/end_tick = pred.life_tick + 10

	while(pred.life_tick < end_tick)
		sleep(1)

	var/end_oxy = prey.getOxyLoss()
	if(end_oxy > start_oxy)
		TEST_FAIL("Prey took oxygen damage in belly (before: [start_oxy], after: [end_oxy])")

/datum/unit_test/belly_spacesafe

/datum/unit_test/belly_spacesafe/Run()
	var/mob/living/carbon/human/pred = create_test_human()
	var/mob/living/carbon/human/prey = create_test_human()

	TEST_ASSERT(pred && prey, "Failed to create test mobs")

	pred.init_vore(TRUE)
	TEST_ASSERT(pred.vore_selected, "[pred] has no vore_selected")

	pred.vore_selected.nom_mob(prey)

	TEST_ASSERT(prey.loc == pred.vore_selected, "Prey not inside predator belly")

	var/empty_z = using_map.get_empty_zlevel()
	TEST_ASSERT(empty_z, "Failed to get empty z-level")

	var/turf/space_turf = locate(
		round(world.maxx * 0.5),
		round(world.maxy * 0.5),
		empty_z
	)

	TEST_ASSERT(space_turf, "Failed to locate space turf")

	pred.forceMove(space_turf)

	var/start_oxy = prey.getOxyLoss()
	var/end_tick = pred.life_tick + 10

	while(pred.life_tick < end_tick)
		sleep(1)

	var/end_oxy = prey.getOxyLoss()
	if(end_oxy > start_oxy)
		TEST_FAIL("Prey took oxygen damage in space belly (before: [start_oxy], after: [end_oxy])")

/datum/unit_test/belly_damage

/datum/unit_test/belly_damage/Run()
	var/mob/living/carbon/human/pred = create_test_human()
	var/mob/living/carbon/human/prey = create_test_human()

	TEST_ASSERT(pred && prey, "Failed to create test mobs")

	pred.init_vore(TRUE)
	TEST_ASSERT(pred.vore_selected, "[pred] has no vore_selected")

	pred.vore_selected.nom_mob(prey)

	TEST_ASSERT(prey.loc == pred.vore_selected, "Prey not inside predator belly")

	pred.vore_selected.digest_mode = DM_DIGEST

	var/start_damage = prey.getBruteLoss() + prey.getFireLoss()
	var/end_tick = pred.life_tick + 10

	while(pred.life_tick < end_tick)
		sleep(1)

	var/end_damage = prey.getBruteLoss() + prey.getFireLoss()
	if(end_damage <= start_damage)
		TEST_FAIL("Prey took no digestion damage (before: [start_damage], after: [end_damage])")
