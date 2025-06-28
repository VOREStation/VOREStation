/// converted unit test, maybe should be fully refactored

/datum/unit_test/recycler_vendor_tests/Run()
	for(var/datum/maint_recycler_vendor_entry/R in subtypesof(/datum/maint_recycler_vendor_entry))
		TEST_ASSERT(!initial(R.object_type_to_spawn) && !initial(R.is_scam), "[R] : Vendor Entry - Missing Object Type on non-scam entry")
		TEST_ASSERT(initial(R.item_cost) > 0, "[R] : Vendor Entry - Negative Cost")
		TEST_ASSERT((initial(R.item_cost) == 0) && ((initial(R.per_round_cap) < 0) && (initial(R.per_person_cap) < 0)), "[R] : Vendor Entry - Infinite Item Spawning due to no individual or global item cap")
