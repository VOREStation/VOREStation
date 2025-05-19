/datum/unit_test/bodyrecord_integrity_test
	name = "GENETICS: Bodyrecords must ensure integrity."

/datum/unit_test/bodyrecord_integrity_test/start_test()
	var/failed = FALSE

	var/obj/holder = new()

	// We must find the lost data through intensive reiteration.
	var/mob/living/carbon/human/subject = new /mob/living/carbon/human/monkey/punpun(holder) // I have a new use for you, my son.
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
			else
				if(islist(org_dna.vars[A]))
					// Test the list
					if(list_test(first_dna.vars[A],org_dna.vars[A], "var [A] DNA ERROR: first record vs origin body."))
						failed = TRUE
					if(list_test(second_dna.vars[A],first_dna.vars[A], "var [A] DNA ERROR: second record vs first record."))
						failed = TRUE
					if(list_test(clone_dna.vars[A],org_dna.vars[A], "var [A] DNA ERROR: clone body vs origin body."))
						failed = TRUE
					if(list_test(second_dna.vars[A],org_dna.vars[A], "var [A] DNA ERROR: second record vs origin body."))
						failed = TRUE
					if(list_test(descendant_dna.vars[A],org_dna.vars[A], "var [A] DNA ERROR: second clone vs origin body."))
						failed = TRUE
				else
					// Test the var
					if(var_test(first_dna.vars[A],org_dna.vars[A], "var [A] DNA ERROR: first record vs origin body."))
						failed = TRUE
					if(var_test(second_dna.vars[A],first_dna.vars[A], "var [A] DNA ERROR: second record vs first record."))
						failed = TRUE
					if(var_test(clone_dna.vars[A],org_dna.vars[A], "var [A] DNA ERROR: clone body vs origin body."))
						failed = TRUE
					if(var_test(second_dna.vars[A],org_dna.vars[A], "var [A] DNA ERROR: second record vs origin body."))
						failed = TRUE
					if(var_test(descendant_dna.vars[A],org_dna.vars[A], "var [A] DNA ERROR: second clone vs origin body."))
						failed = TRUE

	// dna2record


	// bodyrecord


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
	if(!same_entries(A,B))
		log_unit_test(message + ": Lists did not match")
		return TRUE
	return FALSE
