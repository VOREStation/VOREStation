SUBSYSTEM_DEF(chemistry)
	name = "Chemistry"
	wait = 20
	flags = SS_NO_FIRE
	dependencies = list(
		/datum/controller/subsystem/garbage
	)

	var/list/chemical_reactions = list()
	var/list/chemical_reactions_by_product = list()
	var/list/instant_reactions_by_reagent = list()
	var/list/distilled_reactions_by_reagent = list()
	var/list/distilled_reactions_by_product = list()
//	var/list/fusion_reactions_by_reagent = list() // TODO: Fusion reactions as chemical reactions
	var/list/chemical_reagents = list()

/datum/controller/subsystem/chemistry/Recover()
	chemical_reactions = SSchemistry.chemical_reactions
	chemical_reagents = SSchemistry.chemical_reagents

/datum/controller/subsystem/chemistry/Initialize()
	initialize_chemical_reagents()
	initialize_chemical_reactions()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/chemistry/stat_entry(msg)
	msg = "C: [length(chemical_reagents)] | R: [length(chemical_reactions)]"
	return ..()

//Chemical Reactions - Initialises all /decl/chemical_reaction into a list
// It is filtered into multiple lists within a list.
// For example:
// chemical_reactions_by_reagent[REAGENT_ID_PHORON] is a list of all reactions relating to phoron
// Note that entries in the list are NOT duplicated. So if a reaction pertains to
// more than one chemical it will still only appear in only one of the sublists.
/datum/controller/subsystem/chemistry/proc/initialize_chemical_reactions()
	var/list/paths = decls_repository.get_decls_of_subtype(/decl/chemical_reaction)

	for(var/path in paths)
		var/decl/chemical_reaction/D = paths[path]
		chemical_reactions += D

		var/list/scan_list = list()
		if(length(D.required_reagents))
			scan_list += D.required_reagents
		if(length(D.catalysts))
			scan_list += D.catalysts

		for(var/i in 1 to length(scan_list))
			var/reagent_id = scan_list[i]

			var/list/add_to = instant_reactions_by_reagent // Default to instant reactions list, if something's gone wrong
//			if(istype(D, /decl/chemical_reaction/fusion)) // TODO: fusion reactions as chemical reactions
//				add_to = fusion_reactions_by_reagent
			if(istype(D, /decl/chemical_reaction/distilling))
				add_to = distilled_reactions_by_reagent

			if(D.result)
				if(istype(D, /decl/chemical_reaction/distilling))
					LAZYINITLIST(distilled_reactions_by_product[D.result])
					distilled_reactions_by_product[D.result] |= D // for reverse lookup
				else
					LAZYINITLIST(chemical_reactions_by_product[D.result])
					chemical_reactions_by_product[D.result] |= D // for reverse lookup

			// we want to maintain original chemistry behavior, but still document all reactions above, only add to this list with the first reagent
			if(i > 1)
				continue
			LAZYINITLIST(add_to[reagent_id])
			add_to[reagent_id] |= D

//Chemical Reagents - Initialises all /datum/reagent into a list indexed by reagent id
/datum/controller/subsystem/chemistry/proc/initialize_chemical_reagents()
	var/paths = subtypesof(/datum/reagent)
	chemical_reagents = list()
	for(var/path in paths)
		var/datum/reagent/D = new path()
		if(!D.name)
			continue
		chemical_reagents[D.id] = D
