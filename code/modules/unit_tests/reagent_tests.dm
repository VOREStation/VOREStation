/// converted unit test, maybe should be fully refactored
/// MIGHT REQUIRE BIGGER REWORK

/// Test that makes sure that reagent ids and names are unique
/datum/unit_test/reagent_shall_have_unique_name_and_id

/datum/unit_test/reagent_shall_have_unique_name_and_id/Run()
	var/failed = FALSE
	var/collection_name = list()
	var/collection_id = list()

	for(var/Rpath in subtypesof(/datum/reagent))
		var/datum/reagent/R = new Rpath()

		if(R.name == REAGENT_DEVELOPER_WARNING) // Ignore these types as they are meant to be overridden
			continue

		if(R.name == "")
			TEST_NOTICE("[Rpath]: Reagents - reagent name blank.")
			failed = TRUE

		if(R.id == REAGENT_ID_DEVELOPER_WARNING)
			TEST_NOTICE("[Rpath]: Reagents - reagent ID not set.")
			failed = TRUE

		if(R.id == "")
			TEST_NOTICE("[Rpath]: Reagents - reagent ID blank.")
			failed = TRUE

		if(R.id != lowertext(R.id))
			TEST_NOTICE("[Rpath]: Reagents - Reagent ID must be all lowercase.")
			failed = TRUE

		if(!(R.wiki_flag & WIKI_SPOILER)) // If wiki hidden then don't conflict test it against name, used for intentionally copied names like beer2's
			if(collection_name[R.name])
				TEST_NOTICE("[Rpath]: Reagents - reagent name \"[R.name]\" is not unique, used first in [collection_name[R.name]].")
				failed = TRUE
			collection_name[R.name] = R.type

		if(collection_id[R.id])
			TEST_NOTICE("[Rpath]: Reagents - reagent ID \"[R.id]\" is not unique, used first in [collection_id[R.id]].")
			failed = TRUE
		collection_id[R.id] = R.type

		if(R.description == REAGENT_DESC_DEVELOPER_WARNING)
			TEST_NOTICE("[Rpath]: Reagents - reagent description unset.")
			failed = TRUE

		qdel(R)

	if(failed)
		TEST_FAIL("One or more /datum/reagent subtypes had invalid definitions.")

/// Test that makes sure that chemical reactions use and produce valid reagents
/datum/unit_test/chemical_reactions_shall_use_and_produce_valid_reagents

/datum/unit_test/chemical_reactions_shall_use_and_produce_valid_reagents/Run()
	var/failed = FALSE
	var/list/collection_id = list()

	var/list/all_reactions = decls_repository.get_decls_of_subtype(/decl/chemical_reaction)
	for(var/rtype in all_reactions)
		var/decl/chemical_reaction/CR = all_reactions[rtype]
		if(CR.name == REAGENT_DEVELOPER_WARNING) // Ignore these types as they are meant to be overridden
			continue

		if(!CR.name)
			TEST_NOTICE("[CR.type]: Reagents - chemical reaction had null name.")
			failed = TRUE

		if(CR.name == "")
			TEST_NOTICE("[CR.type]: Reagents - chemical reaction had blank name.")
			failed = TRUE

		if(!CR.id)
			TEST_NOTICE("[CR.type]: Reagents - chemical reaction had invalid ID.")
			failed = TRUE

		if(CR.id != lowertext(CR.id))
			TEST_NOTICE("[CR.type]: Reagents - chemical reaction ID must be all lowercase.")
			failed = TRUE

		if(CR.id in collection_id)
			TEST_NOTICE("[CR.type]: Reagents - chemical reaction ID \"[CR.name]\" is not unique, used first in [collection_id[CR.id]].")
			failed = TRUE
		else
			collection_id[CR.id] = CR.type

		if(CR.result_amount < 0)
			TEST_NOTICE("[CR.type]: Reagents - chemical reaction ID \"[CR.name]\" had less than 0 as as result_amount?")
			failed = TRUE

		if(CR.required_reagents && CR.required_reagents.len)
			for(var/RR in CR.required_reagents)
				if(!SSchemistry.chemical_reagents[RR])
					TEST_NOTICE("[CR.type]: Reagents - chemical reaction had invalid required reagent ID \"[RR]\".")
					failed = TRUE
				if(CR.required_reagents[RR] <= 0)
					TEST_NOTICE("[CR.type]: Reagents - chemical reaction had invalid required reagent amount or in invalid format \"[CR.required_reagents[RR]]\".")
					failed = TRUE


		if(CR.catalysts && CR.catalysts.len)
			for(var/RR in CR.catalysts)
				if(!SSchemistry.chemical_reagents[RR])
					TEST_NOTICE("[CR.type]: Reagents - chemical reaction had invalid required reagent ID \"[RR]\".")
					failed = TRUE
				if(CR.catalysts[RR] <= 0)
					TEST_NOTICE("[CR.type]: Reagents - chemical reaction had invalid catalysts amount or in invalid format \"[CR.catalysts[RR]]\".")
					failed = TRUE

		if(CR.inhibitors && CR.inhibitors.len)
			for(var/RR in CR.inhibitors)
				if(!SSchemistry.chemical_reagents[RR])
					TEST_NOTICE("[CR.type]: Reagents - chemical reaction had invalid required reagent ID \"[RR]\".")
					failed = TRUE
				if(CR.inhibitors[RR] <= 0)
					TEST_NOTICE("[CR.type]: Reagents - chemical reaction had invalid inhibitors amount or in invalid format \"[CR.inhibitors[RR]]\".")
					failed = TRUE

		if(CR.result)
			if(!SSchemistry.chemical_reagents[CR.result])
				TEST_NOTICE("[CR.type]: Reagents - chemical reaction had invalid result reagent ID \"[CR.result]\".")
				failed = TRUE

	if(failed)
		TEST_FAIL("One or more /decl/chemical_reaction subtypes had invalid results or components.")

/// Test that makes sure that prefilled reagent containers have valid reagents
/datum/unit_test/prefilled_reagent_containers_shall_have_valid_reagents

/datum/unit_test/prefilled_reagent_containers_shall_have_valid_reagents/Run()
	var/failed = FALSE

	var/obj/container = new /obj
	for(var/RC in subtypesof(/obj/item/reagent_containers/glass))
		var/obj/item/reagent_containers/glass/R = new RC(container)

		if(R.prefill && R.prefill.len)
			for(var/ID in R.prefill)
				if(!SSchemistry.chemical_reagents[ID])
					TEST_NOTICE("[RC]: Reagents - reagent prefill had invalid reagent ID \"[ID]\".")
					failed = TRUE

		qdel(R)

	for(var/DC in subtypesof(/obj/item/reagent_containers/chem_disp_cartridge))
		var/obj/item/reagent_containers/chem_disp_cartridge/D = new DC(container)

		if(D.spawn_reagent)
			if(!SSchemistry.chemical_reagents[D.spawn_reagent])
				TEST_NOTICE("[DC]: Reagents - chemical dispenser cartridge had invalid reagent ID \"[D.spawn_reagent]\".")
				failed = TRUE

		qdel(D)

	qdel(container)

	if(failed)
		TEST_FAIL("One or more /obj/item/reagent_containers had an invalid prefill reagent.")

/// Test that makes sure that chemical reactions do not conflict
/datum/unit_test/chemical_reactions_shall_not_conflict
	var/obj/fake_beaker = null
	var/list/result_reactions = list()

/datum/unit_test/chemical_reactions_shall_not_conflict/Run()
	var/failed = FALSE

	#ifdef UNIT_TEST
	var/list/all_reactions = decls_repository.get_decls_of_subtype(/decl/chemical_reaction)
	for(var/rtype in all_reactions)
		var/decl/chemical_reaction/CR = all_reactions[rtype]

		if(CR.name == REAGENT_DEVELOPER_WARNING) // Ignore these types as they are meant to be overridden
			continue
		if(!CR.name || CR.name == "" || !CR.id || CR.id == "")
			continue
		if(CR.result_amount <= 0) //Makes nothing anyway, or maybe an effect/explosion!
			continue
		if(!CR.result) // Cannot check for this
			continue

		if(istype(CR, /decl/chemical_reaction/instant/slime))
		// slime time
			var/decl/chemical_reaction/instant/slime/SR = CR
			if(!SR.required)
				continue
			var/obj/item/slime_extract/E = new SR.required()
			qdel_swap(fake_beaker, E)
			fake_beaker.reagents.maximum_volume = 5000
		else if(istype(CR, /decl/chemical_reaction/distilling))
			// distilling
			var/decl/chemical_reaction/distilling/DR = CR
			var/obj/machinery/portable_atmospherics/powered/reagent_distillery/D = new()
			D.current_temp = DR.temp_range[1]
			qdel_swap(fake_beaker, D)
			fake_beaker.reagents.maximum_volume = 5000
		else
			// regular beaker
			qdel_swap(fake_beaker, new /obj/item/reagent_containers/glass/beaker())
			fake_beaker.reagents.maximum_volume = 5000

		// Perform test! If it fails once, it will perform a deeper check trying to use the inhibitors of anything in the beaker
		RegisterSignal(fake_beaker.reagents, COMSIG_UNITTEST_DATA, PROC_REF(get_signal_data))
		if(perform_reaction(CR))
			// Check if we failed the test with inhibitors in use, if so we absolutely couldn't make it...
			// Uncomment the UNIT_TEST section in code\modules\reagents\reactions\_reactions.dm if you require more info
			TEST_NOTICE("[CR.type]: Reagents - chemical reaction did not produce \"[CR.result]\". CONTAINS: \"[fake_beaker.reagents.get_reagents()]\"")
			failed = TRUE
		UnregisterSignal(fake_beaker.reagents, COMSIG_UNITTEST_DATA)
	qdel_null(fake_beaker)
	#endif

	if(failed)
		TEST_FAIL("One or more /decl/chemical_reaction subtypes conflict with another reaction.")

/datum/unit_test/chemical_reactions_shall_not_conflict/proc/perform_reaction(var/decl/chemical_reaction/CR, var/list/inhib = list())
	// clear for inhibitor searches
	fake_beaker.reagents.clear_reagents()
	result_reactions.Cut()

	var/scale = 1
	if(CR.result_amount < 1)
		scale = 1 / CR.result_amount // Create at least 1 unit

	if(inhib.len) // taken from argument and not reaction! Put in FIRST!
		for(var/RR in inhib)
			fake_beaker.reagents.add_reagent(RR, inhib[RR] * scale)
	if(CR.catalysts) // Required for reaction
		for(var/RR in CR.catalysts)
			fake_beaker.reagents.add_reagent(RR, CR.catalysts[RR] * scale)
	if(CR.required_reagents)
		for(var/RR in CR.required_reagents)
			fake_beaker.reagents.add_reagent(RR, CR.required_reagents[RR] * scale)

	if(fake_beaker.reagents.has_reagent(CR.result))
		return FALSE // INSTANT SUCCESS!

	if(inhib.len)
		// We've checked with inhibitors, so we're already in inhibitor checking phase.
		// So we've absolutely failed this time. There is no way to make this...
		return TRUE

	if(!result_reactions.len)
		// Nothing to check for inhibitors...
		for(var/decl/chemical_reaction/test_react in result_reactions)
			TEST_NOTICE("[CR.type]: Reagents - Used [test_react] but failed.")
		return TRUE

	// Otherwise we check the resulting reagents and use their inhibitor this time!
	for(var/decl/chemical_reaction/test_react in result_reactions)
		if(!test_react)
			continue
		if(!test_react.inhibitors.len)
			continue
		// Test one by one
		for(var/each in test_react.inhibitors)
			if(!perform_reaction(CR, list("[each]" = test_react.inhibitors["[each]"])))
				return FALSE // SUCCESS using an inhibitor!
		// Test all at once
		if(!perform_reaction(CR, test_react.inhibitors))
			return FALSE // SUCCESS using all inhibitors!

	// No inhibiting reagent worked...
	for(var/decl/chemical_reaction/test_react in result_reactions)
		TEST_NOTICE("[CR.type]: Reagents - Used [test_react] but failed.")
	return TRUE

/datum/unit_test/chemical_reactions_shall_not_conflict/get_signal_data(atom/source, list/data = list())
	result_reactions.Add(data[1]) // Append the reactions that happened, then use that to check their inhibitors

/// Test that makes sure that chemical grinding has valid results
/datum/unit_test/chemical_grinding_must_produce_valid_results

/datum/unit_test/chemical_grinding_must_produce_valid_results/Run()
	var/failed = FALSE

	for(var/grind in GLOB.sheet_reagents + GLOB.ore_reagents)
		var/list/results = GLOB.sheet_reagents[grind]
		if(!results)
			results = GLOB.ore_reagents[grind]
		if(!results || !islist(results))
			TEST_NOTICE("[grind]: Reagents - Grinding result had invalid list.")
			failed = TRUE
			continue
		if(!results.len)
			TEST_NOTICE("[grind]: Reagents - Grinding result had empty.")
			failed = TRUE
			continue
		for(var/reg_id in results)
			if(!SSchemistry.chemical_reagents[reg_id])
				TEST_NOTICE("[grind]: Reagents - Grinding result had invalid reagent id \"[reg_id]\".")
				failed = TRUE

	if(failed)
		TEST_FAIL("One or more grindable sheet or ore entries had invalid reagents or lists.")
