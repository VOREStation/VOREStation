/datum/unit_test/recycler_vendor_entry_invalid
	name = "RECYCLER: Recycler Vendor Entry shall have valid definitions"

/datum/unit_test/recycler_vendor_entry_invalid/start_test()
	var/failed = FALSE



	for(var/datum/maint_recycler_vendor_entry/R in subtypesof(/datum/maint_recycler_vendor_entry))
		var/item_to_spawn = initial(R.object_type_to_spawn)
		var/item_cost = initial(R.item_cost)
		var/global_item_cap = initial(R.per_round_cap)
		var/individual_item_cap = initial(R.per_person_cap)
		var/is_scam = initial(R.is_scam)
		if(!item_to_spawn && !is_scam)
			log_unit_test("[R] : Vendor Entry - Missing Object Type on non-scam entry")
			failed = TRUE
		if(item_cost < 0)
			log_unit_test("[R] : Vendor Entry - Negative Cost")
			failed = TRUE
		if((item_cost == 0) && ((global_item_cap < 0)&&(individual_item_cap < 0))) //nobody SHOULD set the cost to 0 but it's possible i guess. maybe for future scams
			log_unit_test("[R] : Vendor Entry - Infinite Item Spawning due to no individual or global item cap")
			failed = TRUE

	if(failed)
		fail("One or more /datum/maint_recycler_vendor_entry had invalid results or definitions.")
	else
		pass("All /datum/maint_recycler_vendor_entry subtypes had correct settings.")

	return TRUE
