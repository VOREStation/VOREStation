/datum/unit_test/mech_construction/Run()
	var/failed = FALSE
	for(var/datum/construction/C as anything in subtypesof(/datum/construction))
		// We check for null, as null is legal here... For now... Mech construction needs a full refactor to make them unittest-able in a not ugly way.
		if(!C.result)
			continue
		if(!ispath(C.result))
			TEST_NOTICE(src, "[C.type]: Mech Construction - Had invalid result \"[C.result]\", must be a path.")
			failed = TRUE
	if(failed)
		TEST_FAIL("Mech Construction - A construction datum had incorrect data.")
