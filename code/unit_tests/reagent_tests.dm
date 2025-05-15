/datum/unit_test/reagent_shall_have_unique_name_and_id
	name = "REAGENTS: Reagent IDs and names shall be unique"

/datum/unit_test/reagent_shall_have_unique_name_and_id/start_test()
	var/failed = FALSE
	var/collection_name = list()
	var/collection_id = list()

	for(var/Rpath in subtypesof(/datum/reagent))
		var/datum/reagent/R = new Rpath()

		if(R.name == REAGENT_DEVELOPER_WARNING) // Ignore these types as they are meant to be overridden
			continue

		if(R.name == "")
			log_unit_test("[Rpath]: Reagents - reagent name blank.")
			failed = TRUE

		if(R.id == REAGENT_ID_DEVELOPER_WARNING)
			log_unit_test("[Rpath]: Reagents - reagent ID not set.")
			failed = TRUE

		if(R.id == "")
			log_unit_test("[Rpath]: Reagents - reagent ID blank.")
			failed = TRUE

		if(R.id != lowertext(R.id))
			log_unit_test("[Rpath]: Reagents - Reagent ID must be all lowercase.")
			failed = TRUE

		if(collection_name[R.name] && !(R.wiki_flag & WIKI_SPOILER)) // If wiki hidden it's probably intentional!
			log_unit_test("[Rpath]: Reagents - WARNING - reagent name \"[R.name]\" is not unique, used first in [collection_name[R.name]]. Is this intentional?")
		collection_name[R.name] = R.type

		if(collection_id[R.id])
			log_unit_test("[Rpath]: Reagents - reagent ID \"[R.id]\" is not unique, used first in [collection_id[R.id]].")
			failed = TRUE
		collection_id[R.id] = R.type

		if(R.description == REAGENT_DESC_DEVELOPER_WARNING)
			log_unit_test("[Rpath]: Reagents - reagent description unset.")
			failed = TRUE

		qdel(R)

	if(failed)
		fail("One or more /datum/reagent subtypes had invalid definitions.")
	else
		pass("All /datum/reagent subtypes had correct settings.")
	return TRUE



/datum/unit_test/chemical_reactions_shall_use_and_produce_valid_reagents
	name = "REAGENTS: Chemical Reactions shall use and produce valid reagents"

/datum/unit_test/chemical_reactions_shall_use_and_produce_valid_reagents/start_test()
	var/failed = FALSE
	var/list/collection_id = list()

	var/list/all_reactions = decls_repository.get_decls_of_subtype(/decl/chemical_reaction)
	for(var/rtype in all_reactions)
		var/decl/chemical_reaction/CR = all_reactions[rtype]
		if(CR.name == REAGENT_DEVELOPER_WARNING) // Ignore these types as they are meant to be overridden
			continue

		if(!CR.name)
			log_unit_test("[CR.type]: Reagents - chemical reaction had null name.")
			failed = TRUE

		if(CR.name == "")
			log_unit_test("[CR.type]: Reagents - chemical reaction had blank name.")
			failed = TRUE

		if(!CR.id)
			log_unit_test("[CR.type]: Reagents - chemical reaction had invalid ID.")
			failed = TRUE

		if(CR.id != lowertext(CR.id))
			log_unit_test("[CR.type]: Reagents - chemical reaction ID must be all lowercase.")
			failed = TRUE

		if(CR.id in collection_id)
			log_unit_test("[CR.type]: Reagents - chemical reaction ID \"[CR.name]\" is not unique, used first in [collection_id[CR.id]].")
			failed = TRUE
		else
			collection_id[CR.id] = CR.type

		if(CR.result_amount < 0)
			log_unit_test("[CR.type]: Reagents - chemical reaction ID \"[CR.name]\" had less than 0 as as result_amount?")
			failed = TRUE

		if(CR.required_reagents && CR.required_reagents.len)
			for(var/RR in CR.required_reagents)
				if(!SSchemistry.chemical_reagents[RR])
					log_unit_test("[CR.type]: Reagents - chemical reaction had invalid required reagent ID \"[RR]\".")
					failed = TRUE
				if(CR.required_reagents[RR] <= 0)
					log_unit_test("[CR.type]: Reagents - chemical reaction had invalid required reagent amount or in invalid format \"[CR.required_reagents[RR]]\".")
					failed = TRUE


		if(CR.catalysts && CR.catalysts.len)
			for(var/RR in CR.catalysts)
				if(!SSchemistry.chemical_reagents[RR])
					log_unit_test("[CR.type]: Reagents - chemical reaction had invalid required reagent ID \"[RR]\".")
					failed = TRUE
				if(CR.catalysts[RR] <= 0)
					log_unit_test("[CR.type]: Reagents - chemical reaction had invalid catalysts amount or in invalid format \"[CR.catalysts[RR]]\".")
					failed = TRUE

		if(CR.inhibitors && CR.inhibitors.len)
			for(var/RR in CR.inhibitors)
				if(!SSchemistry.chemical_reagents[RR])
					log_unit_test("[CR.type]: Reagents - chemical reaction had invalid required reagent ID \"[RR]\".")
					failed = TRUE
				if(CR.inhibitors[RR] <= 0)
					log_unit_test("[CR.type]: Reagents - chemical reaction had invalid inhibitors amount or in invalid format \"[CR.inhibitors[RR]]\".")
					failed = TRUE

		if(CR.result)
			if(!SSchemistry.chemical_reagents[CR.result])
				log_unit_test("[CR.type]: Reagents - chemical reaction had invalid result reagent ID \"[CR.result]\".")
				failed = TRUE

	if(failed)
		fail("One or more /decl/chemical_reaction subtypes had invalid results or components.")
	else
		pass("All /decl/chemical_reaction subtypes had correct settings.")
	return TRUE



/datum/unit_test/prefilled_reagent_containers_shall_have_valid_reagents
	name = "REAGENTS: Prefilled reagent containers shall have valid reagents"

/datum/unit_test/prefilled_reagent_containers_shall_have_valid_reagents/start_test()
	var/failed = FALSE

	var/obj/container = new /obj
	for(var/RC in subtypesof(/obj/item/reagent_containers/glass))
		var/obj/item/reagent_containers/glass/R = new RC(container)

		if(R.prefill && R.prefill.len)
			for(var/ID in R.prefill)
				if(!SSchemistry.chemical_reagents[ID])
					log_unit_test("[RC]: Reagents - reagent prefill had invalid reagent ID \"[ID]\".")
					failed = TRUE

		qdel(R)

	for(var/DC in subtypesof(/obj/item/reagent_containers/chem_disp_cartridge))
		var/obj/item/reagent_containers/chem_disp_cartridge/D = new DC(container)

		if(D.spawn_reagent)
			if(!SSchemistry.chemical_reagents[D.spawn_reagent])
				log_unit_test("[DC]: Reagents - chemical dispenser cartridge had invalid reagent ID \"[D.spawn_reagent]\".")
				failed = TRUE

		qdel(D)

	qdel(container)

	if(failed)
		fail("One or more /obj/item/reagent_containers had an invalid prefill reagent.")
	else
		pass("All /obj/item/reagent_containers had valid prefill reagents.")
	return TRUE


/datum/unit_test/chemical_reactions_shall_not_conflict
	name = "REAGENTS: Chemical Reactions shall not conflict"
	var/obj/fake_beaker = null
	var/list/result_reactions = list()

/datum/unit_test/chemical_reactions_shall_not_conflict/start_test()
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
			log_unit_test("[CR.type]: Reagents - chemical reaction did not produce \"[CR.result]\". CONTAINS: \"[fake_beaker.reagents.get_reagents()]\"")
			failed = TRUE
		UnregisterSignal(fake_beaker.reagents, COMSIG_UNITTEST_DATA)
	qdel_null(fake_beaker)
	#endif

	if(failed)
		fail("One or more /decl/chemical_reaction subtypes conflict with another reaction.")
	else
		pass("All /decl/chemical_reaction subtypes had no conflicts.")
	return TRUE

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
			log_unit_test("[CR.type]: Reagents - Used [test_react] but failed.")
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
		log_unit_test("[CR.type]: Reagents - Used [test_react] but failed.")
	return TRUE

/datum/unit_test/chemical_reactions_shall_not_conflict/get_signal_data(atom/source, list/data = list())
	SIGNAL_HANDLER
	result_reactions.Add(data[1]) // Append the reactions that happened, then use that to check their inhibitors


/datum/unit_test/chemical_grinding_must_produce_valid_results
	name = "REAGENTS: Chemical Grinding Must Have Valid Results"

/datum/unit_test/chemical_grinding_must_produce_valid_results/start_test()
	var/failed = FALSE

	for(var/grind in global.sheet_reagents + global.ore_reagents)
		var/list/results = global.sheet_reagents[grind]
		if(!results)
			results = global.ore_reagents[grind]
		if(!results || !islist(results))
			log_unit_test("[grind]: Reagents - Grinding result had invalid list.")
			failed = TRUE
			continue
		if(!results.len)
			log_unit_test("[grind]: Reagents - Grinding result had empty.")
			failed = TRUE
			continue
		for(var/reg_id in results)
			if(!SSchemistry.chemical_reagents[reg_id])
				log_unit_test("[grind]: Reagents - Grinding result had invalid reagent id \"[reg_id]\".")
				failed = TRUE

	if(failed)
		fail("One or more grindable sheet or ore entries had invalid reagents or lists.")
	else
		pass("All grindable sheet or ore entries had valid lists and reagents.")
	return TRUE
