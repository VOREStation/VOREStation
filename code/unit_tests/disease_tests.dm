/datum/unit_test/disease_unique
	name = "DISEASE: All diseases must have a unique medical name"

/datum/unit_test/disease_unique/start_test()
	var/failed = FALSE
	var/list/used_ids = list()

	for(var/datum/disease/D in subtypesof(/datum/disease))
		if(initial(D.medical_name) in used_ids)
			log_unit_test("[D]: Disease - Had a reused medical name, this is used as an ID and must be unique.")
			failed = TRUE
		else
			used_ids.Add(initial(D.medical_name))

	if(failed)
		fail("All diseases must have a unique medical name.")
	else
		pass("All diseases have proper and unique ids.")
	return failed
