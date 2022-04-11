/datum/unit_test/loadout_test_shall_have_name_cost_path
	name = "LOADOUT: Entries shall have name, cost, and path definitions"

/datum/unit_test/loadout_test_shall_have_name_cost_path/start_test()
	var/failed = 0
	for(var/datum/gear/G as anything in subtypesof(/datum/gear))

		if(!initial(G.display_name))
			log_unit_test("[G]: Loadout - Missing display name.")
			failed = 1
		else if(isnull(initial(G.cost)))
			log_unit_test("[G]: Loadout - Missing cost.")
			failed = 1
		else if(!initial(G.path))
			log_unit_test("[G]: Loadout - Missing path definition.")
			failed = 1

	if(failed)
		fail("One or more /datum/gear definitions had invalid display names, costs, or path definitions")
	else
		pass("All /datum/gear definitions had correct settings.")
	return 1
