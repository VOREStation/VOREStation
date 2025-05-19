/*
 * And so you've reached it. You just wanted to add a new cosmetic system, and realized that it isn't persisting through
 * resleeves, and now you need to edit DNA code, and body records. Except, as you do, this begins to scream at you. So you
 * have come here seeking awnsers to your plight. Thankfully, I have some goods news for you! There are likely several easy
 * to handle solutions to finish what you are working on! Here are some common fixes.
 *
 *
 * 1) Where is your data stored? Mobs do not persist data through resleeves themselves. Cosmetic data should be moved to the
 * DNA datum of the human mob. The dna datum AUTOMATICALLY copies all of its vars when its Clone() proc is called. If you
 * already have your var in the DNA datum. Check to see if it is being written, and read from it when the human mob runs
 * its UpdateAppearance() proc. This is where the data is read from dna, and written to the mob.
 *
 * Check that the order is correct. Sometimes procs in the UpdateAppearance() order will reset the var you want to edit, your
 * var needs to be changed after them. A pretty ugly example is blood_color. As the species blood color gets set, but then because
 * of how custom species code works, it needs to set the color in the dna, then set the color in the copy of species it makes!
 *
 *
 * 2) You should be using the UI system in dna if possible for anything using colors or icon_state. While preferable, you can still
 * use standalone vars instead. The UI system is a large list DNA_UI_LENGTH entries long. Each entry can store a value from 0 to 4096.
 * There are several helper procs to handle this system. Allowing you to encode that range of numbers into anything you want.
 *
 * Commonly, the UI system will store the INDEX of a cosmetic in their global cosmetic list. Take a look at hair or wings. They just
 * use the helper to stretch the length of the hair/wing list over the length of the UI range(4096), and decode it back. This is the
 * same thing done by colors. Colors encoding the range between 0 to 255, and writing those colors back to the mob when read.
 *
 * Just be certain to make DNA_UI_LENGTH match the HIGHEST number in the define section you'll need to edit, as each UI is set by a
 * define macro in code\__defines\dna.dm. Some types of cosmetic may be impossible to use as a UI, for example, marking code is entirely
 * incompatible with how UIs work, and requires it's own kind of system using standalone vars. There is no single perfect solution.
 *
 *
 * 3) Avoid using species to store vars. You may be working on a "custom species" var, but the species datum is not shared between resleeves.
 * Only your dna, dna2/record, and body_record are used for resleeving. The autosleever is a cheat machine that uses admin healing, and
 * does NOT use any of this to spawn your character. It should not be used as reference while testing. the DNA datum is exchanged cleanly
 * between your mob, body record, and back. You only need to ensure that the dna datum is reading and writing to your mob correctly.
 *
 * Hopefully in the future, it will be possible to return to a system that does not edit the species datum at all, and properly uses DNA to
 * transfer data between resleeves. However that still requires extensive refactoring.
 *
 *
 * 4) If you var requires extremely specific and safe data to function. You may need to alter the test. This is not usually the case however,
 * check the above sections for the most common solutions. If you need to edit the test, add a condition to the var randomization during the
 * proc prepare_test_monkey() in this test. The vars are normally randomized to ensure that normally nulled or otherwise unused vars are also
 * checked for if they are being copied correctly or not to the mob, and back to the records. There is no other good solution without somhow
 * moving all vars in dna to UI... Which isn't really feasable.
 *
 *
 * Good luck out there - Willbird
 */

/datum/unit_test/bodyrecord_integrity_test
	name = "BODY RECORD: Body records must ensure integrity"

/datum/unit_test/bodyrecord_integrity_test/start_test()
	var/failed = FALSE

	var/obj/holder = new()

	// We must find the lost data through intensive reiteration.
	var/mob/living/carbon/human/subject = new /mob/living/carbon/human/monkey(holder) // I have a new use for you, my son.
	prepare_test_monkey(subject)
	subject.Stasis(1000) // We are a HIGHLY unstable mob. Lets not life tick.

	var/datum/dna/org_dna = subject.dna

	var/datum/transhuman/body_record/first_iteration = new(subject)
	var/datum/dna2/record/first_record = first_iteration.mydna
	var/datum/dna/first_dna = first_iteration.mydna.dna

	var/mob/living/carbon/human/clone = first_iteration.produce_human_mob(holder,FALSE,FALSE,"TESTING TED")
	var/datum/dna/clone_dna = clone.dna
	clone.Stasis(1000) // We are a HIGHLY unstable mob. Lets not life tick.

	var/datum/transhuman/body_record/second_interation = new(clone)
	var/datum/dna2/record/second_record = second_interation.mydna
	var/datum/dna/second_dna = second_interation.mydna.dna

	var/mob/living/carbon/human/descendant = second_interation.produce_human_mob(holder,FALSE,FALSE,"TESTING FRED")
	var/datum/dna/descendant_dna = descendant.dna
	descendant.Stasis(1000) // We are a HIGHLY unstable mob. Lets not life tick.

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
	// Absolutely brutalize this monkey. Yes this would HORRIDLY BREAK under almost any circumstance. Good thing it's going to vanish quickly!
	for(var/A in H.dna.vars)
		switch(A)
			if(BLACKLISTED_COPY_VARS)
				continue
			if("species") // Everything explodes if scrambled
				H.dna.species = SPECIES_HUMAN
				continue
			if("UI","SE","dirtyUI","dirtySE","genetic_modifiers","body_markings","species_traits") // Don't scramblize these
				continue
			if("blood_color")
				H.dna.blood_color = pick(list("#576347","#067234","#982319")) // Can't use randoms for this one
				continue
			else
				if(islist(H.dna.vars[A]))
					H.dna.vars[A] = list("rand","test[rand(1,200)]","hello","[rand(1,200)]")
				else
					H.dna.vars[A] = pick(list("rand","test[rand(1,200)]","hello","[rand(1,200)]"))

	// Stablize anything that shouldn't be wagoozleized by above
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
	for(var/i = 1 to 20)
		G = pick(GLOB.dna_genes)
		H.dna.SetSEState(G.block,TRUE)

	// Breath phoron
	for(var/trait in subtypesof(/datum/trait/negative/breathes))
		G = GLOB.trait_to_dna_genes[trait]
		H.dna.SetSEState(G.block,FALSE)
	G = GLOB.trait_to_dna_genes[/datum/trait/negative/breathes/phoron]
	H.dna.SetSEState(G.block,TRUE)
	H.dna.UpdateUI()
	H.dna.UpdateSE()

	// Finish off
	H.UpdateAppearance()
	H.sync_dna_traits(FALSE,TRUE)
	H.sync_organ_dna()
	H.initialize_vessel()
	H.regenerate_icons()
