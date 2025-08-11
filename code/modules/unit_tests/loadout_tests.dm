/// converted unit test, maybe should be fully refactored

/datum/unit_test/loadout_tests/Run()
	for(var/datum/gear/G as anything in subtypesof(/datum/gear))
		TEST_ASSERT(initial(G.display_name), "[G]: Loadout - Missing display name.")
		TEST_ASSERT_NOTNULL(initial(G.cost), "[G]: Loadout - Missing cost.")
		TEST_ASSERT(initial(G.path), "[G]: Loadout - Missing path definition.")
