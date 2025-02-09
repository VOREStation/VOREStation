/datum/unit_test/enough_free_gene_slots_must_be_available
	name = "GENETICS: Enough free gene slots must be available."

/datum/unit_test/enough_free_gene_slots_will_be_available/start_test()
	var/failed = FALSE

	if(GLOB.trait_to_dna_genes.len > (DNA_SE_LENGTH - 10)) // Based off of traitgenes scanned on startup
		failed = TRUE

	if(failed)
		fail("Too few geneslots are empty, minimum 10. Increase DNA_SE_LENGTH.")
	else
		pass("DNA_SE_LENGTH has enough free space remaining.")
	return failed
