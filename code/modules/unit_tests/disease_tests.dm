/// converted unit test, maybe should be fully refactored

/datum/unit_test/disease_tests/Run()
	var/list/used_ids = list()

	for(var/datum/disease/D as anything in subtypesof(/datum/disease))
		if(initial(D.name) == DEVELOPER_WARNING_NAME)
			continue

		TEST_ASSERT(initial(D.medical_name) in used_ids, "[D]: Disease - Had a reused medical name, this is used as an ID and must be unique.")
		used_ids.Add(initial(D.medical_name))

		TEST_ASSERT_NOTNULL(initial(D.name), "[D]: Disease - Lacks a name.")
		TEST_ASSERT_NOTEQUAL(initial(D.name), "", "[D]: Disease - Lacks a name.")

		TEST_ASSERT_NOTNULL(initial(D.desc), "[D]: Disease - Lacks a description.")
		TEST_ASSERT_NOTEQUAL(initial(D.desc), "", "[D]: Disease - Lacks a description.")
