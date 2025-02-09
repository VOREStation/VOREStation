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
		pass("No positive genes.")
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
		pass("No neutral genes.")
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
		pass("No bad genes.")
	return failed
