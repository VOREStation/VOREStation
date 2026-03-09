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
	// Get the materials all the sheets can be broken down into
	var/list/needed_materials = list()
	for(var/path in subtypesof(/obj/item/stack))
		var/obj/item/stack/material/sheet = new()
		var/list/get_mats = sheet.get_material_composition()
		TEST_NOTICE(src, "TEST = ADDED MAT FOR SHEET [path]")
		for(var/mat in get_mats)
			needed_materials |= mat
		qdel(sheet)

	// Then get the sheets those materials are represented by
	var/list/required_sheets = list()
	for(var/datum/material/mat in needed_materials)
		if(!mat || !mat.stack_type)
			continue
		TEST_NOTICE(src, "TEST = ADDED REQUIRED MAT [mat.type] > SHEET [mat.stack_type]")
		required_sheets |= mat.stack_type

	// Get all material sheet printing recipies in the autolathe
	var/list/sheet_print_designs = list()
	for(var/id in SSresearch.techweb_designs)
		var/datum/design_techweb/design = SSresearch.techweb_designs[id]
		if(!(design.build_type & AUTOLATHE))
			continue
		if(!istype(design.build_path, /obj/item/stack/material))
			continue
		sheet_print_designs |= design.build_path
		TEST_NOTICE(src, "TEST = LATHE DESIGN [design.build_path]")

	// Check all sheets for EXISTANCE
	var/failed = FALSE
	for(var/sheet in required_sheets)
		if(sheet in sheet_print_designs)
			TEST_NOTICE(src, "TEST = [sheet] WAS CORRECTLY IN DESIGNS")
			continue
		failed = TRUE
		TEST_NOTICE(src, "[sheet] - Missing an autolathe design, all material sheets must be printable, or materials can get stuck in the lathe forever")

	if(failed)
		TEST_FAIL("materials missing autolathe print recipies.")
