/// converted unit test, maybe should be fully refactored

/// Test that a material should have all the name variables set
/datum/unit_test/materials_shall_have_names

/datum/unit_test/materials_shall_have_names/Run()
	var/list/failures = list()
	for(var/name, value in GLOB.name_to_material)
		var/datum/material/mat = value
		if(!mat)
			continue // how did we get here?
		if(!mat.display_name || !mat.use_name || !mat.sheet_singular_name || !mat.sheet_plural_name || !mat.sheet_collective_name)
			failures[name] = mat.type

	if(length(failures))
		TEST_FAIL("[length(failures)] material\s had missing name strings: [english_list(failures)].")
