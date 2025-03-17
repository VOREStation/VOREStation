/datum/unit_test/language_test_shall_have_distinct_names
	name = "LANGUAGES: Entries shall have distinct names"

/datum/unit_test/language_test_shall_have_distinct_names/start_test()
	if(length(GLOB.language_name_conflicts) != 0)
		var/list/name_conflict_log = list()
		for(var/conflicted_name in GLOB.language_name_conflicts)
			name_conflict_log += "+[length(GLOB.language_name_conflicts[conflicted_name])] languages with name \"[conflicted_name]\"!"
			for(var/datum/language/L in GLOB.language_name_conflicts[conflicted_name])
				name_conflict_log += "+-+[L.type]"
		fail("Some names are used by more than one language:\n" + name_conflict_log.Join("\n"))
	else
		pass("All languages have distinct names")
	return 1

/datum/unit_test/language_test_shall_have_distinct_keys
	name = "LANGUAGES: Entries shall have distinct keys"

/datum/unit_test/language_test_shall_have_distinct_keys/start_test()
	if(length(GLOB.language_key_conflicts) != 0)
		var/list/key_conflict_log = list()
		for(var/conflicted_key in GLOB.language_key_conflicts)
			key_conflict_log += "+[length(GLOB.language_key_conflicts[conflicted_key])] languages with key \"[conflicted_key]\"!"
			for(var/datum/language/L in GLOB.language_key_conflicts[conflicted_key])
				key_conflict_log += "+-+[L]([L.type])"
		fail("Some keys are used by more than one language:\n" + key_conflict_log.Join("\n"))
	else
		pass("All languages in GLOB.all_languages have distinct keys")
	return 1
