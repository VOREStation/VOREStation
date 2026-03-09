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

/datum/unit_test/all_sheets_must_be_printable_from_autolathe

/datum/unit_test/all_sheets_must_be_printable_from_autolathe/Run()
	var/list/valid_sheets = list()
	for(var/name in GLOB.name_to_material)
		var/datum/material/mat = GLOB.name_to_material[name]
		if(!mat.stack_type)
			continue
		valid_sheets += mat.stack_type

	var/list/sheet_print_designs = list()
	for(var/id in SSresearch.techweb_designs)
		var/datum/design_techweb/design = SSresearch.techweb_designs[id]
		if(!(AUTOLATHE in design.category))
			continue
		if(!istype(design.build_path, /obj/item/stack/material))
			continue
		sheet_print_designs += design.build_path

	var/failed = FALSE
	for(var/sheet in valid_sheets)
		if(sheet in sheet_print_designs)
			continue
		failed = TRUE
		TEST_NOTICE(src, "[sheet] - Missing an autolathe recipie, all material sheets must be printable, or materials can get stuck in the lathe forever")

	if(failed)
		TEST_FAIL("materials missing autolathe print recipies.")
