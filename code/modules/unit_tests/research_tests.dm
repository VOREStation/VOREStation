/// converted unit test, maybe should be fully refactored
/// MIGHT REQUIRE BIGGER REWORK

/// Test that tests that all research designs are unique
/datum/unit_test/research_designs_shall_be_unique

/datum/unit_test/research_designs_shall_be_unique/Run()
	var/list/ids = list()
	var/list/build_paths = list()

	for(var/design_type in typesof(/datum/design) - /datum/design)
		var/datum/design/design = design_type
		if(initial(design.id) == "id")
			continue

		group_by(ids, design, initial(design.id))
		group_by(build_paths, design, initial(design.build_path))

	var/number_of_issues = number_of_issues(ids, "IDs")
	number_of_issues += number_of_issues(build_paths, "Build Paths")

	if(number_of_issues)
		TEST_FAIL("[number_of_issues] issues with research designs found.")

/datum/unit_test/research_designs_shall_be_unique/proc/group_by(var/list/entries, var/datum/design/entry, var/value)
	var/designs = entries[value]
	if(!designs)
		designs = list()
		entries[value] = designs

	designs += entry

/datum/unit_test/research_designs_shall_be_unique/proc/number_of_issues(var/list/entries, var/type)
	var/issues = 0
	for(var/value in entries)
		var/list/list_of_designs = entries[value]
		if(list_of_designs.len > 1)
			TEST_NOTICE("[type] - The following entries have the same value - [value]: " + english_list(list_of_designs))
			issues++

	return issues

/datum/unit_test/research_designs_have_valid_materials
	name = "RESEARCH: Designs Shall Have Valid Materials and Chemicals"

/datum/unit_test/research_designs_have_valid_materials/start_test()
	var/number_of_issues = 0

	for(var/design_type in subtypesof(/datum/design))
		var/datum/design/design = design_type
		if(initial(design.id) == "id")
			continue
		design = new design_type() // Unfortunately we have to actually instantiate to get a list.

		for(var/material_name in design.materials)
			var/datum/material/material = get_material_by_name(material_name)
			if(!material)
				TEST_NOTICE("The entry [design_type] has invalid material type [material_name]")
				number_of_issues++

		for(var/reagent_name in design.chemicals)
			if(!(reagent_name in SSchemistry.chemical_reagents))
				TEST_NOTICE("The entry [design_type] has invalid chemical type [reagent_name]")
				number_of_issues++

	if(number_of_issues)
		TEST_FAIL("[number_of_issues] issues with research designs found.")
