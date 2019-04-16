PROCESSING_SUBSYSTEM_DEF(chemistry)
	name = "Chemistry"
	wait = 20
	flags = SS_BACKGROUND|SS_POST_FIRE_TIMING
	init_order = INIT_ORDER_CHEMISTRY
	var/list/chemical_reactions = list()
	var/list/chemical_reactions_by_reagent = list()
	var/list/chemical_reagents = list()

/datum/controller/subsystem/processing/chemistry/Recover()
	chemical_reactions = SSchemistry.chemical_reactions
	chemical_reagents = SSchemistry.chemical_reagents

/datum/controller/subsystem/processing/chemistry/Initialize()
	initialize_chemical_reactions()
	initialize_chemical_reagents()

//Chemical Reactions - Initialises all /datum/chemical_reaction into a list
// It is filtered into multiple lists within a list.
// For example:
// chemical_reaction_list["phoron"] is a list of all reactions relating to phoron
// Note that entries in the list are NOT duplicated. So if a reaction pertains to
// more than one chemical it will still only appear in only one of the sublists.
/datum/controller/subsystem/processing/chemistry/proc/initialize_chemical_reactions()
	var/paths = typesof(/datum/chemical_reaction) - /datum/chemical_reaction
	chemical_reactions = list()
	chemical_reactions_by_reagent = list()

	for(var/path in paths)
		var/datum/chemical_reaction/D = new path
		chemical_reactions += D
		if(D.required_reagents && D.required_reagents.len)
			var/reagent_id = D.required_reagents[1]
			LAZYINITLIST(chemical_reactions_by_reagent[reagent_id])
			chemical_reactions_by_reagent[reagent_id] += D

//Chemical Reagents - Initialises all /datum/reagent into a list indexed by reagent id
/datum/controller/subsystem/processing/chemistry/proc/initialize_chemical_reagents()
	var/paths = typesof(/datum/reagent) - /datum/reagent
	chemical_reagents = list()
	for(var/path in paths)
		var/datum/reagent/D = new path()
		if(!D.name)
			continue
		chemical_reagents[D.id] = D
