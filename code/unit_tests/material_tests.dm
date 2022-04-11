/datum/unit_test/materials_shall_have_names
	name = "MATERIALS: Materials Shall Have All Names"

/datum/unit_test/materials_shall_have_names/start_test()
	var/list/failures = list()
	populate_material_list()
	for(var/name in global.name_to_material)
		var/datum/material/mat = global.name_to_material[name]
		if(!mat)
			continue // how did we get here?
		if(!mat.display_name || !mat.use_name || !mat.sheet_singular_name || !mat.sheet_plural_name || !mat.sheet_collective_name)
			failures[name] = mat.type

	if(length(failures))
		fail("[length(failures)] material\s had missing name strings: [english_list(failures)].")
	else
		pass("All materials had all their name strings.")

	return TRUE
