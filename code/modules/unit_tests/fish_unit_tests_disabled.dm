
/// Checks that we are able to fish people out of chasms with priority and that they end up in the right location
/datum/unit_test/fish_rescue_hook
	priority = TEST_LONGER
	var/original_turf_type
	var/original_turf_baseturfs
	var/list/mobs_spawned

/datum/unit_test/fish_rescue_hook/Run()
	// create our human dummies to be dropped into the chasm
	var/mob/living/carbon/human/get_in_the_hole = allocate(/mob/living/carbon/human)
	var/mob/living/basic/mining/lobstrosity/you_too = allocate(/mob/living/basic/mining/lobstrosity)
	var/mob/living/carbon/human/mindless = allocate(/mob/living/carbon/human)
	var/mob/living/carbon/human/no_brain = allocate(/mob/living/carbon/human)
	var/mob/living/carbon/human/empty = allocate(/mob/living/carbon/human)
	var/mob/living/carbon/human/dummy = allocate(/mob/living/carbon/human)

	mobs_spawned = list(
		get_in_the_hole,
		you_too,
		mindless,
		no_brain,
		empty,
		dummy,
	)

	// create our chasm and remember the previous turf so we can change it back once we're done
	original_turf_type = run_loc_floor_bottom_left.type
	original_turf_baseturfs = islist(run_loc_floor_bottom_left.baseturfs) ? run_loc_floor_bottom_left.baseturfs.Copy() : run_loc_floor_bottom_left.baseturfs
	run_loc_floor_bottom_left.ChangeTurf(/turf/open/chasm)
	var/turf/open/chasm/the_hole = run_loc_floor_bottom_left

	// into the hole they go
	for(var/mob/mob_spawned in mobs_spawned)
		the_hole.drop(mob_spawned)
		sleep(0.2 SECONDS) // we have to WAIT because the drop() proc sleeps.

	// our 'fisherman' where we expect the item to be moved to after fishing it up
	var/mob/living/carbon/human/a_fisherman = allocate(/mob/living/carbon/human, run_loc_floor_top_right)

	// pretend like this mob has a mind. they should be fished up first
	no_brain.mind_initialize()

	var/datum/component/fishing_spot/the_hole_fishing_spot = the_hole.GetComponent(/datum/component/fishing_spot)
	var/datum/fish_source/fishing_source = the_hole_fishing_spot.fish_source
	var/obj/item/fishing_hook/rescue/the_hook = allocate(/obj/item/fishing_hook/rescue, run_loc_floor_top_right)
	the_hook.chasm_detritus_type = /datum/chasm_detritus/restricted/bodies/no_defaults

	// try to fish up our minded victim
	var/atom/movable/reward = fishing_source.dispense_reward(the_hook.chasm_detritus_type, a_fisherman, the_hole)

	// mobs with minds (aka players) should have precedence over any other mobs that are in the chasm
	TEST_ASSERT_EQUAL(reward, no_brain, "Fished up [reward] ([REF(reward)]) with a rescue hook; expected to fish up [no_brain]([REF(no_brain)])")
	// it should end up on the same turf as the fisherman
	TEST_ASSERT_EQUAL(get_turf(reward), get_turf(a_fisherman), "[reward] was fished up with the rescue hook and ended up at [get_turf(reward)]; expected to be at [get_turf(a_fisherman)]")

	// let's further test that by giving a second mob a mind. they should be fished up immediately..
	empty.mind_initialize()

	reward = fishing_source.dispense_reward(the_hook.chasm_detritus_type, a_fisherman, the_hole)

	TEST_ASSERT_EQUAL(reward, empty, "Fished up [reward]([REF(reward)]) with a rescue hook; expected to fish up [empty]([REF(empty)])")
	TEST_ASSERT_EQUAL(get_turf(reward), get_turf(a_fisherman), "[reward] was fished up with the rescue hook and ended up at [get_turf(reward)]; expected to be at [get_turf(a_fisherman)]")

// clean up so we don't mess up subsequent tests
/datum/unit_test/fish_rescue_hook/Destroy()
	QDEL_LIST(mobs_spawned)
	run_loc_floor_bottom_left.ChangeTurf(original_turf_type, original_turf_baseturfs)
	return ..()

//We don't have edible component yet.
/datum/unit_test/edible_fish

/datum/unit_test/edible_fish/Run()
	var/obj/item/fish/fish = allocate(/obj/item/fish/testdummy/food)
	var/datum/component/edible/edible = fish.GetComponent(/datum/component/edible)
	TEST_ASSERT(edible, "Fish is not edible")
	edible.eat_time = 0
	TEST_ASSERT(fish.GetComponent(/datum/component/infective), "Fish doesn't have the infective component")

	var/mob/living/carbon/human/gourmet = allocate(/mob/living/carbon/human)

	var/food_quality = edible.get_perceived_food_quality(gourmet)
	TEST_ASSERT(food_quality < 0, "Humans don't seem to dislike raw, unprocessed fish when they should")
	ADD_TRAIT(gourmet, TRAIT_FISH_EATER, TRAIT_FISH_TESTING)
	food_quality = edible.get_perceived_food_quality(gourmet)
	TEST_ASSERT(food_quality >= LIKED_FOOD_QUALITY_CHANGE, "mobs with the TRAIT_FISH_EATER traits don't seem to like fish when they should")
	REMOVE_TRAIT(gourmet, TRAIT_FISH_EATER, TRAIT_FISH_TESTING)

	fish.attack(gourmet, gourmet)
	TEST_ASSERT(gourmet.reagents.has_reagent(REAGENT_ID_PROTEIN), "Human hasn't ingested protein when eating fish")
	TEST_ASSERT(gourmet.reagents.has_reagent(/datum/reagent/blood), "Human hasn't ingested blood when eating fish")
	TEST_ASSERT(gourmet.reagents.has_reagent(/datum/reagent/fishdummy), "Human doesn't have the reagent from /datum/fish_trait/dummy after eating fish")

	TEST_ASSERT_EQUAL(fish.status, FISH_DEAD, "The fish is not dead, despite having sustained enough damage that it should. health: [PERCENT(fish.get_health_percentage())]%")

//	var/obj/item/organ/stomach/belly = gourmet.get_organ_slot(ORGAN_SLOT_STOMACH)
//	belly.reagents.clear_reagents()

	fish.set_status(FISH_ALIVE)
	TEST_ASSERT(!fish.bites_amount, "bites_amount wasn't reset after the fish revived")

	fish.update_size_and_weight(fish.size, FISH_WEIGHT_BITE_DIVISOR)
	var/bite_size = edible.bite_consumption
	fish.AddElement(/datum/element/fried_item, FISH_SAFE_COOKING_DURATION)
	TEST_ASSERT_EQUAL(fish.status, FISH_DEAD, "The fish didn't die after being cooked")
	TEST_ASSERT(bite_size < edible.bite_consumption, "The bite_consumption value hasn't increased after being cooked (it removes blood but doubles protein). Old: [bite_size]. New: [edible.bite_consumption]")
	TEST_ASSERT(!(edible.foodtypes & (RAW|GORE)), "Fish still has the GORE and/or RAW foodtypes flags after being cooked")
	TEST_ASSERT(!fish.GetComponent(/datum/component/infective), "Fish still has the infective component after being cooked for long enough")


	food_quality = edible.get_perceived_food_quality(gourmet)
	TEST_ASSERT(food_quality >= 0, "Humans still dislike fish, even when it's cooked")
	fish.attack(gourmet, gourmet)
	TEST_ASSERT(!gourmet.reagents.has_reagent(/datum/reagent/blood), "Human has ingested blood from eating a fish when it shouldn't since the fish has been cooked")

	TEST_ASSERT(QDELETED(fish), "The fish is not being deleted, despite having sustained enough bites. Reagents volume left: [fish.reagents.total_volume]")

/obj/item/fish/testdummy/food
	average_weight = FISH_WEIGHT_BITE_DIVISOR * 2 //One bite, it's death; the other, it's gone.
