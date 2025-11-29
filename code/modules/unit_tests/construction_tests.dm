/datum/unit_test/mech_construction/Run()
	var/failed = FALSE
	for(var/datum/construction/C in subtypesof(/datum/construction))
		if(!ispath(C.result))
			TEST_NOTICE(src, "[C.type]: Mech Construction - Had invalid result \"[C.result]\", must be a path.")
			failed = TRUE
	if(failed)
		TEST_FAIL("Mech Construction - A construction datum had incorrect data.")
