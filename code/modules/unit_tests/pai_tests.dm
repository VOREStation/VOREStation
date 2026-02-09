/datum/unit_test/pai_software_shall_have_unique_id

/datum/unit_test/pai_software_shall_have_unique_id/Run()
	for(var/datum/pai_software/P as anything in subtypesof(/datum/pai_software))
		// Compare against all other pai softwares
		for(var/datum/pai_software/O as anything in subtypesof(/datum/pai_software))
			if(P == O) // Don't test against ourselves
				continue
			if(initial(P.id) == initial(O.id))
				TEST_FAIL("pAI software module [P] has the same id as [O]!")
