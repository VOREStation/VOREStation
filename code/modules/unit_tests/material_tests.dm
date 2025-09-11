/// converted unit test, maybe should be fully refactored

/// Test that a material should have all the name variables set
/datum/unit_test/materials_shall_have_names

/datum/unit_test/materials_shall_have_names/Run()
	var/list/failures = list()
	populate_material_list()
	for(var/name in global.name_to_material)
		var/datum/material/mat = global.name_to_material[name]
		if(!mat)
			continue // how did we get here?
		if(!mat.display_name || !mat.use_name || !mat.sheet_singular_name || !mat.sheet_plural_name || !mat.sheet_collective_name)
			failures[name] = mat.type

	if(length(failures))
		TEST_FAIL("[length(failures)] material\s had missing name strings: [english_list(failures)].")
