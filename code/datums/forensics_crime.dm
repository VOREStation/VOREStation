/datum/forensics_crime
	VAR_PRIVATE/list/fingerprints = null
	VAR_PRIVATE/list/fingerprintshidden = null
	VAR_PRIVATE/list/suit_fibres = null
	VAR_PRIVATE/list/blood_DNA = null
	VAR_PRIVATE/fingerprintslast = null
	VAR_PRIVATE/gunshot_residue = null


//////////////////////////////////////////////////////////////////////////////////////
// Fingerprints
//////////////////////////////////////////////////////////////////////////////////////
/// Adds fingerprints to the object, prints can be smudged, glove handling is done on the atom side of this proc.
/datum/forensics_crime/proc/add_prints(var/mob/living/carbon/human/H)
	//Now, lets get to the dirty work.
	if(!fingerprints)
		fingerprints = list()
	if(!fingerprintshidden)
		fingerprintshidden = list()

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

/// Returns a list of fingerprint strings that have touched an object. Always returns a list.
/datum/forensics_crime/proc/get_prints()
	RETURN_TYPE(/list)
	if(!fingerprints)
		return list()
	return fingerprints

/// Returns true if any fingerprints are present on this object.
/datum/forensics_crime/proc/has_prints()
	if(!fingerprints || !fingerprints.len)
		return FALSE
	return TRUE

/// Merges data from another forensics crime datum into this one. Entries with the same key will be merged. Does nothing if the origin datum's list is empty.
/datum/forensics_crime/proc/merge_prints(var/datum/forensics_crime/origin)
	if(!islist(origin?.fingerprints))
		return
	LAZYOR(fingerprints,origin.fingerprints)

/// Clears data to default state, wiping all evidence
/datum/forensics_crime/proc/clear_prints()
	LAZYCLEARLIST(fingerprints)
	fingerprintslast = null

/// Sets the key of the last mob to touch this object
/datum/forensics_crime/proc/set_lastprint(var/val)
	fingerprintslast = val

/// Gets the key of the last mob to touch this object
/datum/forensics_crime/proc/get_lastprint()
	return fingerprintslast


//////////////////////////////////////////////////////////////////////////////////////
// Hidden prints
//////////////////////////////////////////////////////////////////////////////////////
/// Adds hidden admin trackable fingerprints, visible even if normal fingerprints are smudged.
/datum/forensics_crime/proc/add_hiddenprints(mob/living/M as mob)
	if(!fingerprintshidden)
		fingerprintshidden = list()
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

/// Returns a list of hidden admin fingerprint strings that describe how a mob interacted with an object, for debugging forensics, or investigating player behavior. Always returns a list.
/datum/forensics_crime/proc/get_hiddenprints()
	RETURN_TYPE(/list)
	if(!fingerprintshidden)
		return list()
	return fingerprintshidden

/// Returns true if and hidden admin fingerprints are on this object
/datum/forensics_crime/proc/has_hiddenprints()
	if(!fingerprintshidden || !fingerprintshidden.len)
		return FALSE
	return TRUE

/// Merges data from another forensics crime datum into this one. Entries with the same key will be merged. Does nothing if the origin datum's list is empty.
/datum/forensics_crime/proc/merge_hiddenprints(var/datum/forensics_crime/origin)
	if(!islist(origin?.fingerprintshidden))
		return
	LAZYOR(fingerprintshidden,origin.fingerprintshidden)


//////////////////////////////////////////////////////////////////////////////////////
// Fibres
//////////////////////////////////////////////////////////////////////////////////////
/// Adds stray fibres from clothing worn by a mob while handling something
/datum/forensics_crime/proc/add_fibres(var/mob/living/carbon/human/M)
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
	if(suit_fibres)
		if(!(fibertext in suit_fibres))
			suit_fibres.Add(fibertext)
		return
	suit_fibres = list()
	suit_fibres.Add(fibertext)

/// Gets a list of fibres contaminating this object
/datum/forensics_crime/proc/get_fibres()
	RETURN_TYPE(/list)
	if(!suit_fibres)
		return list()
	return suit_fibres

/// Returns true if any stray clothing fibres are on this object
/datum/forensics_crime/proc/has_fibres()
	if(!suit_fibres || !suit_fibres.len)
		return FALSE
	return TRUE

/// Merges data from another forensics crime datum into this one. Entries with the same key will be merged. Does nothing if the origin datum's list is empty.
/datum/forensics_crime/proc/merge_fibres(var/datum/forensics_crime/origin)
	if(!islist(origin?.suit_fibres))
		return
	LAZYOR(suit_fibres,origin.suit_fibres)

/// Clears data to default state, wiping all evidence
/datum/forensics_crime/proc/clear_fibres()
	LAZYCLEARLIST(suit_fibres)


//////////////////////////////////////////////////////////////////////////////////////
// Blood dna
//////////////////////////////////////////////////////////////////////////////////////
#define XENO_DNA "UNKNOWN DNA STRUCTURE"
#define NOT_HUMAN_DNA "Non-human DNA"
/// Adds the mob's bloodtype to a UE keyed list, returns true if the key was not present in the list before.
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
		blood_DNA[NOT_HUMAN_DNA] = DEFAULT_BLOOD_TYPE
		return fresh
	// Standard blood
	var/fresh = isnull(blood_DNA[dna_data.unique_enzymes])
	blood_DNA[dna_data.unique_enzymes] = dna_data.b_type
	return fresh
#undef XENO_DNA
#undef NOT_HUMAN_DNA

/// Adds the mob's bloodtype to a UE keyed list, returns true if the key was not present in the list before. Uses an organ's dna_data datum instead of a mob's dna datum.
/datum/forensics_crime/proc/add_blooddna_organ(var/datum/organ_data/dna_data)
	if(!blood_DNA)
		blood_DNA = list()
	var/fresh = isnull(blood_DNA[dna_data.unique_enzymes])
	blood_DNA[dna_data.unique_enzymes] = dna_data.b_type
	return fresh

/// Returns a list of UE keys with bloodtype values that have contaminated this object. Always returns a list.
/datum/forensics_crime/proc/get_blooddna()
	RETURN_TYPE(/list)
	if(!blood_DNA)
		return list()
	return blood_DNA

/// Returns true if any blood contaminated this object
/datum/forensics_crime/proc/has_blooddna()
	if(!blood_DNA || !blood_DNA.len)
		return FALSE
	return TRUE

/// Merges data from another forensics crime datum into this one. Entries with the same key will be merged. Does nothing if the origin datum's list is empty. Supports merging from a list directly as well.
/datum/forensics_crime/proc/merge_blooddna(var/datum/forensics_crime/origin, var/list/raw_list = null)
	// Copying from a list, blood on a mob's feet is stored as a list outside of forensics data
	if(raw_list)
		LAZYOR(blood_DNA,raw_list)
		return
	// Copying from another datums
	if(!islist(origin?.blood_DNA))
		return
	LAZYOR(blood_DNA,origin.blood_DNA)

/// Clears data to default state, wiping all evidence
/datum/forensics_crime/proc/clear_blooddna()
	LAZYCLEARLIST(blood_DNA)


//////////////////////////////////////////////////////////////////////////////////////
// Gunshot residue
//////////////////////////////////////////////////////////////////////////////////////
/// Sets a string name of the last fired bullet's caliber from a projectile based gun.
/datum/forensics_crime/proc/add_gunshotresidue(var/gsr)
	gunshot_residue = gsr

/// Gets a string name of the last bullet caliber fired from a projectile based gun.
/datum/forensics_crime/proc/get_gunshotresidue()
	return gunshot_residue

/// Clears data to default state, wiping all evidence
/datum/forensics_crime/proc/clear_gunshotresidue()
	gunshot_residue = null


//////////////////////////////////////////////////////////////////////////////////////
// Misc procs
//////////////////////////////////////////////////////////////////////////////////////
/// Cleans off forensic information, different cleaning types remove different things.
/datum/forensics_crime/proc/wash(var/clean_types)
	// These require specific cleaning flags
	if(clean_types & CLEAN_TYPE_BLOOD)
		clear_blooddna()
	if(clean_types & CLEAN_TYPE_FINGERPRINTS)
		clear_prints()
	if(clean_types & CLEAN_TYPE_FIBERS)
		clear_fibres()
	// anything will wash away gunshot residue
	if(clean_types > 0)
		clear_gunshotresidue()

/// Merges both visible and admin hidden investigation fingerprints, as well as setting the last fingerprint from the origin datum's if one is not already set.
/datum/forensics_crime/proc/merge_allprints(var/datum/forensics_crime/origin)
	if(!origin)
		return
	merge_prints(origin)
	merge_hiddenprints(origin)
	if(origin.fingerprintslast)
		fingerprintslast = origin.fingerprintslast
