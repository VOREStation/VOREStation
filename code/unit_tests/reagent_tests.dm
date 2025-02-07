/datum/unit_test/reagent_shall_have_unique_name_and_id
	name = "REAGENTS: Reagent IDs and names shall be unique"

/datum/unit_test/reagent_shall_have_unique_name_and_id/start_test()
	var/failed = FALSE
	//var/collection_name = list()
	var/collection_id = list()

	for(var/Rpath in subtypesof(/datum/reagent))
		var/datum/reagent/R = new Rpath()

		if(R.name == REAGENT_DEVELOPER_WARNING) // Ignore these types as they are meant to be overridden
			continue

		if(R.name == "")
			log_unit_test("[Rpath]: Reagents - reagent ID blank.")
			failed = TRUE

		if(R.id == REAGENT_ID_DEVELOPER_WARNING)
			log_unit_test("[Rpath]: Reagents - reagent ID not set.")
			failed = TRUE

		if(R.id == "")
			log_unit_test("[Rpath]: Reagents - reagent ID blank.")
			failed = TRUE

		/* Optional, makes names exclusive, this breaks the poisoned beer2
		if(collection_name[R.name])
			log_unit_test("[Rpath]: Reagents - reagent name \"[R.name]\" is not unique, used first in [collection_name[R.name]].")
			failed = TRUE
		collection_name[R.name] = R.type
		*/

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

	for(var/R in subtypesof(/decl/chemical_reaction))
		var/decl/chemical_reaction/CR = new R()

		if(CR.name == REAGENT_DEVELOPER_WARNING) // Ignore these types as they are meant to be overridden
			continue

		if(!CR.name)
			log_unit_test("[CR.type]: Reagents - chemical reaction had null name.")
			failed = TRUE

		if(CR.name == "")
			log_unit_test("[CR.type]: Reagents - chemical reaction had blank name.")
			failed = TRUE

		if(!CR.id)
			log_unit_test("[CR.type]: Reagents - chemical reaction had invalid id.")
			failed = TRUE

		if(CR.id in collection_id)
			log_unit_test("[CR.type]: Reagents - chemical reaction id \"[CR.name]\" is not unique, used first in [collection_id[CR.id]].")
			failed = TRUE
		else
			collection_id[CR.id] = CR.type

		if(CR.required_reagents)
			for(var/RR in CR.required_reagents)
				if(!SSchemistry.chemical_reagents[RR])
					log_unit_test("[CR.type]: Reagents - chemical reaction had invalid required reagent ID \"[RR]\".")
					failed = TRUE

		if(CR.catalysts)
			for(var/RR in CR.catalysts)
				if(!SSchemistry.chemical_reagents[RR])
					log_unit_test("[CR.type]: Reagents - chemical reaction had invalid required reagent ID \"[RR]\".")
					failed = TRUE

		if(CR.inhibitors)
			for(var/RR in CR.inhibitors)
				if(!SSchemistry.chemical_reagents[RR])
					log_unit_test("[CR.type]: Reagents - chemical reaction had invalid required reagent ID \"[RR]\".")
					failed = TRUE

		if(CR.result)
			if(!SSchemistry.chemical_reagents[CR.result])
				log_unit_test("[CR.type]: Reagents - chemical reaction had invalid result reagent ID \"[CR.result]\".")
				failed = TRUE

		qdel(CR)

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
	qdel(container)

	if(failed)
		fail("One or more /obj/item/reagent_containers had an invalid prefill reagent.")
	else
		pass("All /obj/item/reagent_containers containers had valid prefill reagents.")
	return TRUE
