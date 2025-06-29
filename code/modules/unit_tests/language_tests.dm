/// converted unit test, maybe should be fully refactored

/// Test that language entries have distinct names
/datum/unit_test/language_test_shall_have_distinct_names

/datum/unit_test/language_test_shall_have_distinct_names/Run()
	if(length(GLOB.language_name_conflicts) != 0)
		var/list/name_conflict_log = list()
		for(var/conflicted_name in GLOB.language_name_conflicts)
			name_conflict_log += "+[length(GLOB.language_name_conflicts[conflicted_name])] languages with name \"[conflicted_name]\"!"
			for(var/datum/language/L in GLOB.language_name_conflicts[conflicted_name])
				name_conflict_log += "+-+[L.type]"
		TEST_FAIL("Some names are used by more than one language:\n" + name_conflict_log.Join("\n"))

/// Test that language entries have distinct keys
/datum/unit_test/language_test_shall_have_distinct_keys

/datum/unit_test/language_test_shall_have_distinct_keys/Run()
	if(length(GLOB.language_key_conflicts) != 0)
		var/list/key_conflict_log = list()
		for(var/conflicted_key in GLOB.language_key_conflicts)
			key_conflict_log += "+[length(GLOB.language_key_conflicts[conflicted_key])] languages with key \"[conflicted_key]\"!"
			for(var/datum/language/L in GLOB.language_key_conflicts[conflicted_key])
				key_conflict_log += "+-+[L]([L.type])"
		TEST_FAIL("Some keys are used by more than one language:\n" + key_conflict_log.Join("\n"))
