/datum/unit_test/disease_must_be_valid
	name = "DISEASE: All diseases must have valid data"

/datum/unit_test/disease_must_be_valid/start_test()
	var/failed = FALSE
	var/list/used_ids = list()

	for(var/datum/disease/D in GLOB.diseases)
		if(D.medical_name in used_ids)
			log_unit_test("[D]: Disease - Had a reused medical name, this is used as an ID and must be unique.")
			failed = TRUE
		else
			used_ids.Add(D.medical_name)

		if(!D.name || D.name == "")
			log_unit_test("[D]: Disease - Lacks a name.")
			failed = TRUE

		if(!D.desc || D.desc == "")
			log_unit_test("[D]: Disease - Lacks a description.")
			failed = TRUE

	if(failed)
		fail("All diseases must have valid data.")
	else
		pass("All diseases have proper data.")
	return failed
