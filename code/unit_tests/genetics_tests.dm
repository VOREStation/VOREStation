/datum/unit_test/enough_free_gene_slots_must_be_available
	name = "GENETICS: Enough free gene slots must be available."

/datum/unit_test/enough_free_gene_slots_must_be_available/start_test()
	var/failed = FALSE

	if(GLOB.dna_genes.len > (DNA_SE_LENGTH - 10)) // Based off of traitgenes scanned on startup
		failed = TRUE

	if(failed)
		fail("Too few geneslots are empty, minimum 10. Increase DNA_SE_LENGTH.")
	else
		pass("DNA_SE_LENGTH has enough free space remaining.")
	return failed


/datum/unit_test/enough_positive_genes_must_exist
	name = "GENETICS: Must be at least one positive gene."

/datum/unit_test/enough_positive_genes_must_exist/start_test()
	var/failed = FALSE

	if(GLOB.dna_genes_good.len < 1) // Based off of traitgenes scanned on startup
		failed = TRUE

	if(failed)
		fail("Must have at least one positive gene.")
	else
		pass("Has at least one positive gene.")
	return failed


/datum/unit_test/enough_neutral_genes_must_exist
	name = "GENETICS: Must be at least one neutral gene."

/datum/unit_test/enough_neutral_genes_must_exist/start_test()
	var/failed = FALSE

	if(GLOB.dna_genes_neutral.len < 1) // Based off of traitgenes scanned on startup
		failed = TRUE

	if(failed)
		fail("Must have at least one neutral gene.")
	else
		pass("Has at least one neutral gene.")
	return failed


/datum/unit_test/enough_bad_genes_must_exist
	name = "GENETICS: Must be at least one bad gene."

/datum/unit_test/enough_bad_genes_must_exist/start_test()
	var/failed = FALSE

	if(GLOB.dna_genes_bad.len < 1) // Based off of traitgenes scanned on startup
		failed = TRUE

	if(failed)
		fail("Must have at least one bad gene.")
	else
		pass("Has at least one bad gene.")
	return failed


/datum/unit_test/all_dna_injectors_must_be_valid
	name = "GENETICS: All dna injectors must be valid."

/datum/unit_test/all_dna_injectors_must_be_valid/start_test()
	var/failed = FALSE

	for(var/injector_path in subtypesof(/obj/item/dnainjector/set_trait))
		var/obj/item/dnainjector/D = new injector_path()
		if(!D.block)
			log_unit_test("[injector_path]: Genetics - Injector could not resolve geneblock for trait. Missing traitgene?")
			failed = TRUE
		qdel(D)

	if(failed)
		fail("Dna injectors have traits that are not genetraits or are missing.")
	else
		pass("No invalid dna injectors.")
	return failed


/datum/unit_test/all_genes_shall_have_unique_name
	name = "GENETICS: All genes shall be init with unique names."

/datum/unit_test/all_genes_shall_have_unique_name/start_test()
	var/failed = FALSE

	var/collection = list()
	for(var/datum/gene/G in GLOB.dna_genes)
		if(collection[G.name])
			log_unit_test("[G.name]: Genetics - Gene name was already in use.")
			failed = TRUE
		else
			collection[G.name] = G.name

	if(failed)
		fail("Genes shared names. This should not be possible on init, all genes should have their blocknumber attached to them to ensure unique names.")
	else
		pass("All genes have unique names to use as list ids.")
	return failed



/datum/unit_test/genetraits_should_have_valid_dna_bounds
	name = "GENETICS: All genes should have valid activation bounds."

/datum/unit_test/genetraits_should_have_valid_dna_bounds/start_test()
	var/failed = FALSE

	for(var/datum/gene/trait/G in GLOB.trait_to_dna_genes)
		if(!G.linked_trait)
			log_unit_test("[G.name]: Genetics - Has missing linked trait.")
			failed = TRUE
			continue

		if(!G.linked_trait.activity_bounds)
			log_unit_test("[G.name]: Genetics - Has no activation bounds.")
			failed = TRUE
			continue

		if(!G.linked_trait.activity_bounds.len)
			log_unit_test("[G.name]: Genetics - Has empty activation bounds.")
			failed = TRUE
			continue

		// DNA activation bounds. Usually they are in a list as follows:
		// [1]DNA_OFF_LOWERBOUND = 1, begining of the threshold where a gene turns off.
		// [2]DNA_OFF_UPPERBOUND = a number above 1, end of the treshold where a gene turns off.
		// [3]DNA_ON_LOWERBOUND = a number above DNA_OFF_UPPERBOUND(even if just by 1), threshold where a gene turns on.
		// [4]DNA_ON_UPPERBOUND = 4095, end of the threshold where a gene turns on.

		var/list/bounds = G.linked_trait.activity_bounds
		if(bounds[1] < 1) // lowest value a gene can be to turn off
			log_unit_test("[G.name]: Genetics - DNA_OFF_LOWERBOUND, was smaller than 1.")
			failed = TRUE

		if(bounds[2] < bounds[1])
			log_unit_test("[G.name]: Genetics - DNA_OFF_UPPERBOUND must be larger than DNA_OFF_LOWERBOUND, and never equal.")
			failed = TRUE

		if(bounds[2] >= bounds[3])
			log_unit_test("[G.name]: Genetics - DNA_OFF_UPPERBOUND must be smaller than DNA_ON_LOWERBOUND, and never equal.")
			failed = TRUE

		if(bounds[3] > bounds[4])
			log_unit_test("[G.name]: Genetics - DNA_ON_LOWERBOUND must be smaller than DNA_ON_UPPERBOUND, and never equal.")
			failed = TRUE

		if(bounds[4] > 4095) // highest value a gene can be to turn on
			log_unit_test("[G.name]: Genetics - DNA_ON_UPPERBOUND, was larger than 4095.")
			failed = TRUE

	if(failed)
		fail("Invalid activity bounds for one or more traitgenes")
	else
		pass("All traitgenes have activity bounds, and activity bounds are legal.")
	return failed
