/datum/unit_test/bodyrecord_integrity_test
	name = "BODY RECORD: Body records must ensure integrity."

/datum/unit_test/bodyrecord_integrity_test/start_test()
	var/failed = FALSE

	var/obj/holder = new()

	// We must find the lost data through intensive reiteration.
	var/mob/living/carbon/human/subject = new /mob/living/carbon/human/nevrean(holder) // I have a new use for you, my son.
	prepare_test_monkey(subject)

	var/datum/dna/org_dna = subject.dna

	var/datum/transhuman/body_record/first_iteration = new(subject)
	var/datum/dna2/record/first_record = first_iteration.mydna
	var/datum/dna/first_dna = first_iteration.mydna.dna

	var/mob/living/carbon/human/clone = first_iteration.produce_human_mob(holder,FALSE,FALSE,"TESTING TED")
	var/datum/dna/clone_dna = clone.dna

	var/datum/transhuman/body_record/second_interation = new(clone)
	var/datum/dna2/record/second_record = second_interation.mydna
	var/datum/dna/second_dna = second_interation.mydna.dna

	var/mob/living/carbon/human/descendant = second_interation.produce_human_mob(holder,FALSE,FALSE,"TESTING FRED")
	var/datum/dna/descendant_dna = descendant.dna

	// Testing...

	// dna datum
	for(var/A in org_dna.vars)
		switch(A)
			if(BLACKLISTED_COPY_VARS)
				continue
			if("dirtyUI","dirtySE")
				continue
			else
				if(islist(org_dna.vars[A]))
					// Test the list
					if(list_test(first_dna.vars[A],org_dna.vars[A], "list \"[A]\" DNA ERROR: first record vs origin body."))
						failed = TRUE
					if(list_test(second_dna.vars[A],first_dna.vars[A], "list \"[A]\" DNA ERROR: second record vs first record."))
						failed = TRUE
					if(list_test(clone_dna.vars[A],org_dna.vars[A], "list \"[A]\" DNA ERROR: clone body vs origin body."))
						failed = TRUE
					if(list_test(second_dna.vars[A],org_dna.vars[A], "list \"[A]\" DNA ERROR: second record vs origin body."))
						failed = TRUE
					if(list_test(descendant_dna.vars[A],org_dna.vars[A], "list \"[A]\" DNA ERROR: second clone vs origin body."))
						failed = TRUE
				else
					// Test the var
					if(var_test(first_dna.vars[A],org_dna.vars[A], "var \"[A]\" DNA ERROR: first record vs origin body."))
						failed = TRUE
					if(var_test(second_dna.vars[A],first_dna.vars[A], "var \"[A]\" DNA ERROR: second record vs first record."))
						failed = TRUE
					if(var_test(clone_dna.vars[A],org_dna.vars[A], "var \"[A]\" DNA ERROR: clone body vs origin body."))
						failed = TRUE
					if(var_test(second_dna.vars[A],org_dna.vars[A], "var \"[A]\" DNA ERROR: second record vs origin body."))
						failed = TRUE
					if(var_test(descendant_dna.vars[A],org_dna.vars[A], "var \"[A]\" DNA ERROR: second clone vs origin body."))
						failed = TRUE

	// dna2record
	for(var/A in first_record.vars)
		switch(A)
			if(BLACKLISTED_COPY_VARS)
				continue
			if("dna") // We tested this above
				continue
			if("mind")
				continue
			if("id")
				continue
			else
				if(islist(first_record.vars[A]))
					// Test the list
					if(list_test(first_record.vars[A],second_record.vars[A], "list \"[A]\" DNA2/RECORD ERROR: first vs second."))
						failed = TRUE
				else
					// Test the var
					if(var_test(first_record.vars[A],second_record.vars[A], "var \"[A]\" DNA2/RECORD ERROR: first vs second."))
						failed = TRUE

	// bodyrecord
	for(var/A in first_iteration.vars)
		switch(A)
			if(BLACKLISTED_COPY_VARS)
				continue
			if("mydna") // We tested this above
				continue
			if("client_ref")
				continue
			if("mind_ref")
				continue
			else
				if(islist(first_iteration.vars[A]))
					// Test the list
					if(list_test(first_iteration.vars[A],second_interation.vars[A], "list \"[A]\" BODY_RECORD ERROR: first vs second."))
						failed = TRUE
				else
					// Test the var
					if(var_test(first_iteration.vars[A],second_interation.vars[A], "var \"[A]\" BODY_RECORD ERROR: first vs second."))
						failed = TRUE

	// Cleanup
	qdel(first_iteration)
	qdel(second_interation)

	qdel(subject)
	qdel(clone)
	qdel(descendant)

	qdel(holder)

	if(failed)
		fail("Bodyrecord integrity failed. Check that any new vars added to dna, dna2record, or bodyrecord are properly read from the mob, copied between datum cloning, and when reapplied to the mob.")
	else
		pass("Bodyrecord integrity passed, all records and clones had matching data.")
	return failed

/datum/unit_test/bodyrecord_integrity_test/proc/var_test(var/A,var/B,var/message)
	if(A != B)
		log_unit_test(message + ": [A] != [B]")
		return TRUE
	return FALSE

/datum/unit_test/bodyrecord_integrity_test/proc/list_test(var/list/A,var/list/B,var/message)
	if(isnull(A))
		log_unit_test(message + ": First was null")
		return TRUE
	if(isnull(B))
		log_unit_test(message + ": Second was null")
		return TRUE
	if(A.len != B.len)
		log_unit_test(message + ": Lists did not have matching lengths")
		return TRUE
	var/list/check_list = difflist(A,B)
	if(check_list.len)
		log_unit_test(message + ": Lists did not have matching contents")
		return TRUE
	return FALSE

/// Setup the test subject for various data entries only set by players
/datum/unit_test/bodyrecord_integrity_test/proc/prepare_test_monkey(var/mob/living/carbon/human/H)
	// Non-dna tied flags
	H.resleeve_lock = TRUE
	H.custom_species = "A Carl"
	H.gender = "female"

	// OOC
	H.ooc_notes = "A test note"
	H.ooc_notes_likes = "A test like!"
	H.ooc_notes_dislikes = "A test dislike!"
	H.ooc_notes_favs = "A test fave!"
	H.ooc_notes_maybes = "A test maybe!"
	H.ooc_notes_style = TRUE

	// Cosmetics
	H.flavor_texts = list("general" = "Test. This doesn't need to be a real flavor entry...")
	H.size_multiplier = 1.2
	H.weight = 123
	H.digitigrade = TRUE

	// Randomize that dna, you should really be using the UI system in dna, and not raw vars when adding new cosmetic layers or color blending. Otherwise they're not easily testable...
	H.dna.ResetSE()
	H.dna.ResetUI()

	// Get some genes going
	var/datum/gene/G = null
	var/list/muts = list()
	for(var/i = 1 to 20)
		G = pick(GLOB.dna_genes)
		H.dna.SetSEState(G.block,TRUE)

	// Breath phoron
	for(var/trait in subtypesof(/datum/trait/negative/breathes))
		G = GLOB.trait_to_dna_genes[trait]
		H.dna.SetSEState(G.block,FALSE)
	G = GLOB.trait_to_dna_genes[/datum/trait/negative/breathes/phoron]
	H.dna.SetSEState(G.block,TRUE)

	// Finish off
	H.dna.UpdateSE()
	domutcheck( H, null, MUTCHK_FORCED|MUTCHK_HIDEMSG)
	H.UpdateAppearance()
