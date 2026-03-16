/// converted unit test, maybe should be fully refactored

/// Test that there are enough free gene slots available
/datum/unit_test/enough_free_gene_slots_must_be_available

/datum/unit_test/enough_free_gene_slots_must_be_available/Run()
	// Based off of traitgenes scanned on startup
	TEST_ASSERT(!(GLOB.dna_genes.len > (DNA_SE_LENGTH - 10)), "Too few geneslots are empty, minimum 10. Increase DNA_SE_LENGTH.")

/// Test that there is at least one positive gene
/datum/unit_test/enough_positive_genes_must_exist

/datum/unit_test/enough_positive_genes_must_exist/Run()
	// Based off of traitgenes scanned on startup
	TEST_ASSERT(!(GLOB.dna_genes_good.len < 1), "Must have at least one positive gene.")

/// Test that there is at least one neutral gene
/datum/unit_test/enough_neutral_genes_must_exist

/datum/unit_test/enough_neutral_genes_must_exist/Run()
	// Based off of traitgenes scanned on startup
	TEST_ASSERT(!(GLOB.dna_genes_neutral.len < 1), "Must have at least one neutral gene.")

/// Test that there is at least one bad gene
/datum/unit_test/enough_bad_genes_must_exist

/datum/unit_test/enough_bad_genes_must_exist/Run()
	// Based off of traitgenes scanned on startup
	TEST_ASSERT(!(GLOB.dna_genes_bad.len < 1), "Must have at least one bad gene.")

/// Test that all dna injectors are valid
/datum/unit_test/all_dna_injectors_must_be_valid

/datum/unit_test/all_dna_injectors_must_be_valid/Run()
	for(var/injector_path in subtypesof(/obj/item/dnainjector/set_trait))
		var/obj/item/dnainjector/D = new injector_path()
		TEST_ASSERT(D.block, "[injector_path]: Genetics - Injector could not resolve geneblock for trait. Missing traitgene?")
		qdel(D)

/// Test that all genes have unique names
/datum/unit_test/all_genes_shall_have_unique_name

/datum/unit_test/all_genes_shall_have_unique_name/Run()
	var/collection = list()
	for(var/datum/gene/G in GLOB.dna_genes)
		TEST_ASSERT(!collection[G.name], "[G.name]: Genetics - Gene name was already in use.")
		collection[G.name] = G.name

/// Test that all genes should have valid activation bounds
/datum/unit_test/genetraits_should_have_valid_dna_bounds

/datum/unit_test/genetraits_should_have_valid_dna_bounds/Run()
	for(var/datum/gene/trait/G in GLOB.trait_to_dna_genes)
		TEST_ASSERT(G.linked_trait, "[G.name]: Genetics - Has missing linked trait.")
		TEST_ASSERT(G.linked_trait.activity_bounds, "[G.name]: Genetics - Has no activation bounds.")
		TEST_ASSERT(G.linked_trait.activity_bounds.len, "[G.name]: Genetics - Has empty activation bounds.")

		// DNA activation bounds. Usually they are in a list as follows:
		// [1]DNA_OFF_LOWERBOUND = 1, begining of the threshold where a gene turns off.
		// [2]DNA_OFF_UPPERBOUND = a number above 1, end of the treshold where a gene turns off.
		// [3]DNA_ON_LOWERBOUND = a number above DNA_OFF_UPPERBOUND(even if just by 1), threshold where a gene turns on.
		// [4]DNA_ON_UPPERBOUND = 4095, end of the threshold where a gene turns on.

		var/list/bounds = G.linked_trait.activity_bounds
		TEST_ASSERT(bounds[1] > 1, "[G.name]: Genetics - DNA_OFF_LOWERBOUND, was smaller than 1.") // lowest value a gene can be to turn off
		TEST_ASSERT(bounds[2] > bounds[1], "[G.name]: Genetics - DNA_OFF_UPPERBOUND must be larger than DNA_OFF_LOWERBOUND, and never equal.")
		TEST_ASSERT(bounds[2] <= bounds[3], "[G.name]: Genetics - DNA_OFF_UPPERBOUND must be smaller than DNA_ON_LOWERBOUND, and never equal.")
		TEST_ASSERT(bounds[3] < bounds[4], "[G.name]: Genetics - DNA_ON_LOWERBOUND must be smaller than DNA_ON_UPPERBOUND, and never equal.")
		TEST_ASSERT(bounds[4] < 4095, "[G.name]: Genetics - DNA_ON_UPPERBOUND, was larger than 4095.") // highest value a gene can be to turn on
