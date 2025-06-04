/datum/forensics_crime
	VAR_PRIVATE/list/fingerprints = null
	VAR_PRIVATE/list/fingerprintshidden = null
	VAR_PRIVATE/list/suit_fibers = null
	VAR_PRIVATE/list/blood_DNA = null
	VAR_PRIVATE/fingerprintslast = null
	VAR_PRIVATE/gunshot_residue = null

// Fingerprints
//////////////////////////////////////////////////////////////////////////////////////
/datum/forensics_crime/proc/add_prints(mob/living/M as mob, ignoregloves)
	//He has no prints!
	if (mFingerprints in M.mutations)
		if(fingerprintslast != M.key)
			if(!fingerprintshidden)
				fingerprintshidden = list()
			fingerprintshidden += "[time_stamp()]: [key_name(M)] (No fingerprints mutation)"
			fingerprintslast = M.key
		return FALSE

	//Smudge up dem prints some if it's just a mob
	if(!ishuman(M))
		if(fingerprintslast != M.key)
			if(!fingerprintshidden)
				fingerprintshidden = list()
			fingerprintshidden += "[time_stamp()]: [key_name(M)]"
			fingerprintslast = M.key
		return TRUE
	var/mob/living/carbon/human/H = M

	//Now, lets get to the dirty work.
	if(!fingerprints)
		fingerprints = list()
	if(!fingerprintshidden)
		fingerprintshidden = list()

	//Now, deal with gloves.
	if (H.gloves && H.gloves != src)
		if(fingerprintslast != H.key)
			fingerprintshidden += "[time_stamp()]: [key_name(H)] (Wearing [H.gloves])"
			fingerprintslast = H.key
		H.gloves.add_fingerprint(M)

	//Deal with gloves the pass finger/palm prints.
	if(!ignoregloves)
		if(H.gloves && H.gloves != src)
			if(istype(H.gloves, /obj/item/clothing/gloves))
				var/obj/item/clothing/gloves/G = H.gloves
				if(!prob(G.fingerprint_chance))
					return 0

	//More adminstuffz
	if(fingerprintslast != H.key)
		fingerprintshidden += "[time_stamp()]: [key_name(H)]"
		fingerprintslast = H.key

	//Hash this shit.
	var/full_print = H.get_full_print()

	// Add the fingerprints
	if(fingerprints[full_print])
		switch(stringpercent(fingerprints[full_print]))		//tells us how many stars are in the current prints.

			if(28 to 32)
				if(prob(1))
					fingerprints[full_print] = full_print 		// You rolled a one buddy.
				else
					fingerprints[full_print] = stars(full_print, rand(0,40)) // 24 to 32

			if(24 to 27)
				if(prob(3))
					fingerprints[full_print] = full_print     	//Sucks to be you.
				else
					fingerprints[full_print] = stars(full_print, rand(15, 55)) // 20 to 29

			if(20 to 23)
				if(prob(5))
					fingerprints[full_print] = full_print		//Had a good run didn't ya.
				else
					fingerprints[full_print] = stars(full_print, rand(30, 70)) // 15 to 25

			if(16 to 19)
				if(prob(5))
					fingerprints[full_print] = full_print		//Welp.
				else
					fingerprints[full_print]  = stars(full_print, rand(40, 100))  // 0 to 21

			if(0 to 15)
				if(prob(5))
					fingerprints[full_print] = stars(full_print, rand(0,50)) 	// small chance you can smudge.
				else
					fingerprints[full_print] = full_print

	else
		fingerprints[full_print] = stars(full_print, rand(0, 20))	//Initial touch, not leaving much evidence the first time.

	return TRUE

/datum/forensics_crime/proc/get_prints()
	RETURN_TYPE(/list)
	if(!fingerprints)
		return list()
	return fingerprints

/datum/forensics_crime/proc/has_prints()
	if(!fingerprints || !fingerprints.len)
		return FALSE
	return TRUE

/datum/forensics_crime/proc/merge_prints(var/datum/forensics_crime/origin)
	if(!origin || !origin.fingerprints)
		return
	if(fingerprints)
		fingerprints |= origin.fingerprints
	else
		fingerprints = origin.fingerprints.Copy()

/datum/forensics_crime/proc/clear_prints()
	LAZYCLEARLIST(fingerprints)
	fingerprintslast = null

// Hidden prints
//////////////////////////////////////////////////////////////////////////////////////
/datum/forensics_crime/proc/add_hiddenprints(mob/living/M as mob)
	if(!ishuman(M))
		if(fingerprintslast != M.key)
			fingerprintshidden += text("\[[time_stamp()]\] (Non-human mob). Real name: [], Key: []",M.real_name, M.key)
			fingerprintslast = M.key
		return FALSE
	var/mob/living/carbon/human/H = M
	if(H.gloves)
		if(fingerprintslast != H.key)
			fingerprintshidden += text("\[[time_stamp()]\] (Wearing gloves). Real name: [], Key: []",H.real_name, H.key)
			fingerprintslast = H.key
		return FALSE
	if (mFingerprints in M.mutations)
		if(fingerprintslast != H.key)
			fingerprintshidden += text("\[[time_stamp()]\] (Noprint mutation). Real name: [], Key: []",H.real_name, H.key)
			fingerprintslast = H.key
		return FALSE
	if(fingerprints)
		return FALSE
	if(fingerprintslast != H.key)
		fingerprintshidden += text("\[[time_stamp()]\] Real name: [], Key: []",H.real_name, H.key)
		fingerprintslast = H.key
	return TRUE

/datum/forensics_crime/proc/get_hiddenprints()
	RETURN_TYPE(/list)
	if(!fingerprintshidden)
		return list()
	return fingerprintshidden

/datum/forensics_crime/proc/has_hiddenprints()
	if(!fingerprintshidden || !fingerprintshidden.len)
		return FALSE
	return TRUE

/datum/forensics_crime/proc/merge_hiddenprints(var/datum/forensics_crime/origin)
	if(!origin || !origin.fingerprintshidden)
		return
	if(fingerprintshidden)
		fingerprintshidden |= origin.fingerprintshidden
	else
		fingerprintshidden = origin.fingerprintshidden.Copy()

// Fibres
//////////////////////////////////////////////////////////////////////////////////////
/// Adds stray fibres from clothing worn by a mob while handling something
/datum/forensics_crime/proc/add_fibers(var/mob/living/carbon/human/M)
	var/fibertext = null
	var/item_multiplier = istype(src,/obj/item)?1.2:1
	var/suit_coverage = 0
	if(M.wear_suit)
		if(prob(10*item_multiplier))
			fibertext = "Material from \a [M.wear_suit]."
		suit_coverage = M.wear_suit.body_parts_covered

	if(M.w_uniform && (M.w_uniform.body_parts_covered & ~suit_coverage))
		if(prob(15*item_multiplier))
			fibertext = "Fibers from \a [M.w_uniform]."

	if(M.gloves && (M.gloves.body_parts_covered & ~suit_coverage))
		if(prob(20*item_multiplier))
			fibertext = "Material from a pair of [M.gloves.name]."

	if(!fibertext)
		return

	// Add to dataset
	if(suit_fibers)
		if(!(fibertext in suit_fibers))
			suit_fibers.Add(fibertext)
		return
	suit_fibers = list()
	suit_fibers.Add(fibertext)

/datum/forensics_crime/proc/get_fibers()
	RETURN_TYPE(/list)
	if(!suit_fibers)
		return list()
	return suit_fibers

/datum/forensics_crime/proc/has_fibers()
	if(!suit_fibers || !suit_fibers.len)
		return FALSE
	return TRUE

/datum/forensics_crime/proc/merge_fibers(var/datum/forensics_crime/origin)
	if(!origin || !origin.suit_fibers)
		return
	if(suit_fibers)
		suit_fibers |= origin.suit_fibers
	else
		suit_fibers = origin.suit_fibers.Copy()

/datum/forensics_crime/proc/clear_fibers()
	LAZYCLEARLIST(suit_fibers)

// Blood dna
//////////////////////////////////////////////////////////////////////////////////////
#define XENO_DNA "UNKNOWN DNA STRUCTURE"
#define NOT_HUMAN_DNA "Non-human DNA"
/// Adds the mob's bloodtype to a UE keyed list, returns true if the key was not present in the list before
/datum/forensics_crime/proc/add_blooddna(var/datum/dna/dna_data,var/mob/M)
	if(!blood_DNA)
		blood_DNA = list()
	// Special alien handling
	if(istype(M, /mob/living/carbon/alien))
		var/fresh = isnull(blood_DNA[XENO_DNA])
		blood_DNA[XENO_DNA] = "X*"
		return fresh
	// Simple mob gibbing
	if(!dna_data)
		var/fresh = isnull(blood_DNA[NOT_HUMAN_DNA])
		blood_DNA[NOT_HUMAN_DNA] = "A+"
		return fresh
	// Standard blood
	var/fresh = isnull(blood_DNA[dna_data.unique_enzymes])
	blood_DNA[dna_data.unique_enzymes] = dna_data.b_type
	return fresh
#undef XENO_DNA
#undef NOT_HUMAN_DNA

/datum/forensics_crime/proc/add_blooddna_organ(var/datum/organ_data/dna_data)
	if(!blood_DNA)
		blood_DNA = list()
	var/fresh = isnull(blood_DNA[dna_data.unique_enzymes])
	blood_DNA[dna_data.unique_enzymes] = dna_data.b_type
	return fresh


/datum/forensics_crime/proc/get_blooddna()
	RETURN_TYPE(/list)
	if(!blood_DNA)
		return list()
	return blood_DNA

/datum/forensics_crime/proc/has_blooddna()
	if(!blood_DNA || !blood_DNA.len)
		return FALSE
	return TRUE

/datum/forensics_crime/proc/merge_blooddna(var/datum/forensics_crime/origin, var/list/raw_list = null)
	// Copying from a list, blood on a mob's feet is stored as a list outside of forensics data
	if(raw_list)
		if(blood_DNA)
			blood_DNA |= raw_list
		else
			blood_DNA = raw_list.Copy()
		return
	// Copying from another datums
	if(!origin || !origin.blood_DNA)
		return
	if(blood_DNA)
		blood_DNA |= origin.blood_DNA
	else
		blood_DNA = origin.blood_DNA.Copy()

/datum/forensics_crime/proc/clear_blooddna()
	LAZYCLEARLIST(blood_DNA)

// Gunshot residue
//////////////////////////////////////////////////////////////////////////////////////
/datum/forensics_crime/proc/add_gunshotresidue(var/gsr)
	gunshot_residue = gsr

/datum/forensics_crime/proc/get_gunshotresidue()
	return gunshot_residue

/datum/forensics_crime/proc/clear_gunshotresidue()
	gunshot_residue = null


// Misc procs
//////////////////////////////////////////////////////////////////////////////////////
/// Cleans off forensic information, different cleaning types might not remove everything
/datum/forensics_crime/proc/wash(var/clean_types)
	if(clean_types & CLEAN_TYPE_BLOOD)
		clear_blooddna()
	if(clean_types & CLEAN_TYPE_FINGERPRINTS)
		clear_prints()
	if(clean_types & CLEAN_TYPE_FIBERS)
		clear_fibers()
	if(clean_types > 0)
		clear_gunshotresidue()

/datum/forensics_crime/proc/get_lastprint()
	return fingerprintslast

/datum/forensics_crime/proc/merge_allprints(var/datum/forensics_crime/origin)
	if(!origin)
		return
	merge_prints(origin)
	merge_hiddenprints(origin)
	if(origin.fingerprintslast)
		fingerprintslast = origin.fingerprintslast
