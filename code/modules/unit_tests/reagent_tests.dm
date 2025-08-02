/// converted unit test, maybe should be fully refactored
/// MIGHT REQUIRE BIGGER REWORK

// Used to test distillations without hacking the other machinery's code up
/obj/distilling_tester
	icon = 'icons/obj/weapons.dmi'
	icon_state = "cartridge"
	var/datum/gas_mixture/GM = new()
	var/current_temp = 0

/obj/distilling_tester/Initialize(mapload)
	create_reagents(5000,/datum/reagents/distilling)
	. = ..()

/obj/distilling_tester/return_air()
	return GM

/obj/distilling_tester/proc/test_distilling(var/decl/chemical_reaction/distilling/D, var/temp_prog)
	qdel_swap(GM,new())
	if(D.require_xgm_gas)
		GM.gas[D.require_xgm_gas] = 100
	else
		if(D.rejects_xgm_gas == GAS_N2)
			GM.gas[GAS_O2] = 100
		else
			GM.gas[GAS_N2] = 100
	if(D.minimum_xgm_pressure)
		GM.temperature = (D.minimum_xgm_pressure * CELL_VOLUME) / (GM.gas[D.require_xgm_gas] * R_IDEAL_GAS_EQUATION)

	// Try this 10 times, We need to know if something is blocking at multiple temps.
	// If it passes unit test, it might still be awful to make though, gotta find the right gas mix!
	current_temp = LERP( D.temp_range[1], D.temp_range[2], temp_prog)
	reagents.handle_reactions()

/obj/distilling_tester/Destroy(force, ...)
	qdel_null(GM)
	. = ..()

/// Test that makes sure that reagent ids and names are unique
/datum/unit_test/reagent_shall_have_unique_name_and_id

/datum/unit_test/reagent_shall_have_unique_name_and_id/Run()
	var/collection_name = list()
	var/collection_id = list()

	for(var/Rpath in subtypesof(/datum/reagent))
		var/datum/reagent/R = new Rpath()

		if(R.name == REAGENT_DEVELOPER_WARNING) // Ignore these types as they are meant to be overridden
			continue

		TEST_ASSERT(R.name != "", "[Rpath]: Reagents - reagent name blank.")
		TEST_ASSERT_NOTEQUAL(R.id, REAGENT_ID_DEVELOPER_WARNING, "[Rpath]: Reagents - reagent ID not set.")
		TEST_ASSERT_NOTEQUAL(R.description, REAGENT_DESC_DEVELOPER_WARNING, "[Rpath]: Reagents - reagent description unset.")

		TEST_ASSERT(R.id != "", "[Rpath]: Reagents - reagent ID blank.")
		TEST_ASSERT_EQUAL(R.id, lowertext(R.id), "[Rpath]: Reagents - Reagent ID must be all lowercase.")

		if(!(R.wiki_flag & WIKI_SPOILER)) // If wiki hidden then don't conflict test it against name, used for intentionally copied names like beer2's
			TEST_ASSERT(!collection_name[R.name], "[Rpath]: Reagents - reagent name \"[R.name]\" is not unique, used first in [collection_name[R.name]].")
			collection_name[R.name] = R.type

		TEST_ASSERT(!collection_id[R.id], "[Rpath]: Reagents - reagent ID \"[R.id]\" is not unique, used first in [collection_id[R.id]].")
		collection_id[R.id] = R.type

		TEST_ASSERT(R.supply_conversion_value, "[Rpath]: Reagents - reagent ID \"[R.id]\" does not have supply_conversion_value set.")
		TEST_ASSERT(R.industrial_use && R.industrial_use != "", "[Rpath]: Reagents - reagent ID \"[R.id]\" does not have industrial_use set.")
		TEST_ASSERT_NOTEQUAL(R.description, REAGENT_DESC_DEVELOPER_WARNING, "[Rpath]: Reagents - reagent description unset.")

		qdel(R)

/// Test that makes sure that chemical reactions use and produce valid reagents
/datum/unit_test/chemical_reactions_shall_use_and_produce_valid_reagents

/datum/unit_test/chemical_reactions_shall_use_and_produce_valid_reagents/Run()
	var/list/collection_id = list()

	var/list/all_reactions = decls_repository.get_decls_of_subtype(/decl/chemical_reaction)
	for(var/rtype in all_reactions)
		var/decl/chemical_reaction/CR = all_reactions[rtype]
		if(CR.name == REAGENT_DEVELOPER_WARNING) // Ignore these types as they are meant to be overridden
			continue

		TEST_ASSERT_NOTNULL(CR.name, "[CR.type]: Reagents - chemical reaction had null name.")
		TEST_ASSERT(CR.name != "", "[CR.type]: Reagents - chemical reaction had blank name.")
		TEST_ASSERT(CR.id, "[CR.type]: Reagents - chemical reaction had invalid ID.")
		TEST_ASSERT_EQUAL(CR.id, lowertext(CR.id), "[CR.type]: Reagents - chemical reaction ID must be all lowercase.")
		TEST_ASSERT(!(CR.id in collection_id), "[CR.type]: Reagents - chemical reaction ID \"[CR.name]\" is not unique, used first in [collection_id[CR.id]].")


		if(!(CR.id in collection_id))
			collection_id[CR.id] = CR.type

		TEST_ASSERT(CR.result_amount >= 0, "[CR.type]: Reagents - chemical reaction ID \"[CR.name]\" had less than 0 as as result_amount?")

		if(CR.required_reagents && CR.required_reagents.len)
			for(var/RR in CR.required_reagents)
				TEST_ASSERT(SSchemistry.chemical_reagents[RR], "[CR.type]: Reagents - chemical reaction had invalid required reagent ID \"[RR]\".")
				TEST_ASSERT(CR.required_reagents[RR] > 0, "[CR.type]: Reagents - chemical reaction had invalid required reagent amount or in invalid format \"[CR.required_reagents[RR]]\".")

		if(CR.catalysts && CR.catalysts.len)
			for(var/RR in CR.catalysts)
				TEST_ASSERT(SSchemistry.chemical_reagents[RR], "[CR.type]: Reagents - chemical reaction had invalid required reagent ID \"[RR]\".")
				TEST_ASSERT(CR.catalysts[RR] > 0, "[CR.type]: Reagents - chemical reaction had invalid catalysts amount or in invalid format \"[CR.catalysts[RR]]\".")

		if(CR.inhibitors && CR.inhibitors.len)
			for(var/RR in CR.inhibitors)
				TEST_ASSERT(SSchemistry.chemical_reagents[RR], "[CR.type]: Reagents - chemical reaction had invalid required reagent ID \"[RR]\".")
				TEST_ASSERT(CR.inhibitors[RR] > 0, "[CR.type]: Reagents - chemical reaction had invalid inhibitors amount or in invalid format \"[CR.inhibitors[RR]]\".")

		if(CR.result)
			TEST_ASSERT(SSchemistry.chemical_reagents[CR.result], "[CR.type]: Reagents - chemical reaction had invalid result reagent ID \"[CR.result]\".")

/// Test that makes sure that prefilled reagent containers have valid reagents
/datum/unit_test/prefilled_reagent_containers_shall_have_valid_reagents

/datum/unit_test/prefilled_reagent_containers_shall_have_valid_reagents/Run()
	var/obj/container = new /obj
	for(var/RC in subtypesof(/obj/item/reagent_containers/glass))
		var/obj/item/reagent_containers/glass/R = new RC(container)

		if(R.prefill && R.prefill.len)
			for(var/ID in R.prefill)
				TEST_ASSERT(SSchemistry.chemical_reagents[ID], "[RC]: Reagents - reagent prefill had invalid reagent ID \"[ID]\".")

		qdel(R)

	for(var/DC in subtypesof(/obj/item/reagent_containers/chem_disp_cartridge))
		var/obj/item/reagent_containers/chem_disp_cartridge/D = new DC(container)

		if(D.spawn_reagent)
			TEST_ASSERT(SSchemistry.chemical_reagents[D.spawn_reagent], "[DC]: Reagents - chemical dispenser cartridge had invalid reagent ID \"[D.spawn_reagent]\".")

		qdel(D)

	qdel(container)

/// Test that makes sure that chemical reactions do not conflict
/datum/unit_test/chemical_reactions_shall_not_conflict
	var/obj/fake_beaker = null
	var/obj/distilling_tester/dist_tester = null
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
			dist_tester = new()
			qdel_swap(fake_beaker, dist_tester)
			fake_beaker.reagents.maximum_volume = 5000
		else
			// regular beaker
			qdel_swap(fake_beaker, new /obj/item/reagent_containers/glass/beaker())
			fake_beaker.reagents.maximum_volume = 5000

		// Perform test! If it fails once, it will perform a deeper check trying to use the inhibitors of anything in the beaker
		RegisterSignal(fake_beaker.reagents, COMSIG_UNITTEST_DATA, PROC_REF(get_signal_data))

		// Check if we failed the test with inhibitors in use, if so we absolutely couldn't make it...
		// Uncomment the UNIT_TEST section in code\modules\reagents\reactions\_reactions.dm if you require more info
		TEST_ASSERT(!perform_reaction(CR), "[CR.type]: Reagents - chemical reaction did not produce \"[CR.result]\". CONTAINS: \"[fake_beaker.reagents.get_reagents()]\"")
		UnregisterSignal(fake_beaker.reagents, COMSIG_UNITTEST_DATA)
	qdel_null(fake_beaker)
	#endif

	if(failed)
		TEST_FAIL("One or more /decl/chemical_reaction subtypes conflict with another reaction.")

/datum/unit_test/chemical_reactions_shall_not_conflict/proc/perform_reaction(var/decl/chemical_reaction/CR, var/list/inhib = list())
	var/scale = 1
	if(CR.result_amount < 1)
		scale = 1 / CR.result_amount // Create at least 1 unit

	// Weird loop here, but this is used to test both instant and distilling reactions
	// Instants will meet the while() condition on the first loop and go to the next stuff
	// but distilling will repeat over and over until the temperature test is finished!
	var/temp_test = 0
	do
		// clear for inhibitor searches
		fake_beaker.reagents.clear_reagents()
		result_reactions.Cut()

		if(inhib.len) // taken from argument and not reaction! Put in FIRST!
			for(var/RR in inhib)
				fake_beaker.reagents.add_reagent(RR, inhib[RR] * scale)
		if(CR.catalysts) // Required for reaction
			for(var/RR in CR.catalysts)
				fake_beaker.reagents.add_reagent(RR, CR.catalysts[RR] * scale)
		if(CR.required_reagents)
			for(var/RR in CR.required_reagents)
				fake_beaker.reagents.add_reagent(RR, CR.required_reagents[RR] * scale)

		if(!istype(CR, /decl/chemical_reaction/distilling))
			break // Skip the next section if we're not distilling

		// Check distillation at 10 points along its temperature range!
		// This is so multiple reactions with the same requirements, but different temps, can be tested.
		temp_test += 0.1
		dist_tester = fake_beaker
		dist_tester.test_distilling(CR,temp_test)

		if(fake_beaker.reagents.has_reagent(CR.result))
			return FALSE // Distilling success

	while(temp_test > 1)

	// Check beaker to see if we reached our goal!
	if(fake_beaker.reagents.has_reagent(CR.result))
		return FALSE // INSTANT SUCCESS!

	if(inhib.len)
		// We've checked with inhibitors, so we're already in inhibitor checking phase.
		// So we've absolutely failed this time. There is no way to make this...
		return TRUE

	if(!result_reactions.len)
		// Nothing to check for inhibitors...
		for(var/decl/chemical_reaction/test_react in result_reactions)
			TEST_FAIL("[CR.type]: Reagents - Used [test_react] but failed.")
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
		TEST_FAIL("[CR.type]: Reagents - Used [test_react] but failed.")
	return TRUE

/datum/unit_test/chemical_reactions_shall_not_conflict/proc/get_signal_data(atom/source, list/data = list())
	result_reactions.Add(data[1]) // Append the reactions that happened, then use that to check their inhibitors

/// Test that makes sure that chemical grinding has valid results
/datum/unit_test/chemical_grinding_must_produce_valid_results

/datum/unit_test/chemical_grinding_must_produce_valid_results/Run()
	for(var/grind in GLOB.sheet_reagents + GLOB.ore_reagents)
		var/list/results = GLOB.sheet_reagents[grind]

		if(!results)
			results = GLOB.ore_reagents[grind]

		// Cursed test
		TEST_ASSERT(!(!results || !islist(results)), "[grind]: Reagents - Grinding result had invalid list.")
		if(!results || !islist(results))
			continue

		TEST_ASSERT(results.len, "[grind]: Reagents - Grinding result had empty.")
		if(!results.len)
			continue

		for(var/reg_id in results)
			TEST_ASSERT(SSchemistry.chemical_reagents[reg_id], "[grind]: Reagents - Grinding result had invalid reagent id \"[reg_id]\".")
