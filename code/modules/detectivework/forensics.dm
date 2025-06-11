/obj/item/forensics
	icon = 'icons/obj/forensics.dmi'
	w_class = ITEMSIZE_TINY

//This is the output of the stringpercent(print) proc, and means about 80% of
//the print must be there for it to be complete.  (Prints are 32 digits)
var/const/FINGERPRINT_COMPLETE = 6
/proc/is_complete_print(var/print)
	return stringpercent(print) <= FINGERPRINT_COMPLETE

/// Forensics: Returns the object's forensic information datum. If none exists, it makes it.
/atom/proc/init_forensic_data()
	RETURN_TYPE(/datum/forensics_crime)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(!forensic_data)
		forensic_data = new()
	return forensic_data

/// Forensics: Handles most forensic investigation actions while touching an object. Including fingerprints, stray fibers from clothing, and bloody hands smearing objects. Returns true if a fingerprint was made.
/atom/proc/add_fingerprint(mob/living/M as mob, ignoregloves = FALSE)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(isnull(M) || isAI(M) || isnull(M.key))
		return FALSE

	//Fibers from worn clothing get transfered along with fingerprints~
	var/datum/forensics_crime/C = init_forensic_data()

	// bloodied gloves and hands transfer blood to touched objects. Blood does not transfer if we are already bloody.
	if(!forensic_data?.has_blooddna())
		var/mob/living/carbon/human/H = M
		if(ishuman(M) && H.gloves && istype(H.gloves,/obj/item/clothing/gloves))
			var/obj/item/clothing/gloves/G = H.gloves
			if(G.transfer_blood)
				forensic_data.merge_blooddna(G.forensic_data)
				G.transfer_blood--
		else if(M.bloody_hands)
			forensic_data.merge_blooddna(M.forensic_data)
			M.bloody_hands--

	//He has no prints!
	if(mFingerprints in M.mutations)
		if(C.get_lastprint() != M.key)
			C.add_hiddenprints(M)
			C.set_lastprint(M.key)
		return FALSE

	//Smudge up dem prints some if it's just a mob
	if(!ishuman(M))
		if(C.get_lastprint() != M.key)
			C.add_hiddenprints(M)
			C.set_lastprint(M.key)
		return TRUE

	var/mob/living/carbon/human/H = M
	C.add_fibres(H)

	//Now, deal with gloves.
	if (H.gloves && H.gloves != src)
		C.add_hiddenprints(M)
		H.gloves.add_fingerprint(M,ignoregloves)

	//Deal with gloves the pass finger/palm prints.
	if(!ignoregloves)
		if(H.gloves && H.gloves != src)
			if(istype(H.gloves, /obj/item/clothing/gloves))
				var/obj/item/clothing/gloves/G = H.gloves
				if(!prob(G.fingerprint_chance))
					return 0

	return C.add_prints(H)

/// Forensics: Adds an admin investigation fingerprint, even if no actual fingerprints are made. Used even if the action is done with a weapon as a way of logging actions for admins.
/atom/proc/add_hiddenprint(mob/living/M as mob)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(isnull(M))
		return
	if(isnull(M.key))
		return
	init_forensic_data().add_hiddenprints(M)

/// Forensics: Adds blood dna to an object, this also usually gives the object a bloody overlay, but that is handled by the object itself. Returns true if this is the first time this dna is being added to this object.
/atom/proc/add_blooddna(var/datum/dna/dna_data,var/mob/M)
	SHOULD_NOT_OVERRIDE(TRUE)
	return init_forensic_data().add_blooddna(dna_data,M)

/// Forensics: Adds blood dna to an object, this version uses an organ's more restricted dna datum, but it still has all the information needed. Returns true if this is the first time this dna is being added to this object.
/atom/proc/add_blooddna_organ(var/datum/organ_data/dna_data)
	SHOULD_NOT_OVERRIDE(TRUE)
	return init_forensic_data().add_blooddna_organ(dna_data)

/// Forensics: Adds fibres from suits or gloves
/atom/proc/add_fibres(mob/living/carbon/human/M)
	SHOULD_NOT_OVERRIDE(TRUE)
	init_forensic_data().add_fibres(M)

/// Forensics: Transfers both our normal and hidden fingerprints to the specified object, handles the forensics datum creation itself.
/atom/proc/transfer_fingerprints_to(var/atom/transfer_to)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(!forensic_data)
		return
	var/datum/forensics_crime/C = transfer_to.init_forensic_data()
	C.merge_prints(forensic_data)
	C.merge_hiddenprints(forensic_data)

/// Forensics: Transfers our blood dna to the specified object, handles the forensics datum creation itself.
/atom/proc/transfer_blooddna_to(var/atom/transfer_to)
	if(!forensic_data)
		return
	transfer_to.init_forensic_data().merge_blooddna(forensic_data)

/// Forensics: Transfers our stray fibers to the specified object, handles the forensics datum creation itself.
/atom/proc/transfer_fibres_to(var/atom/transfer_to)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(!forensic_data)
		return
	transfer_to.init_forensic_data().merge_fibres(forensic_data)

/// Forensics: Adds gunshot residue from firing boolets
/atom/proc/add_gunshotresidue(var/obj/item/ammo_casing/shell)
	init_forensic_data().add_gunshotresidue(shell.caliber)


/datum/data/record/forensic
	name = "forensic data"
	var/uid

/datum/data/record/forensic/New(var/atom/A)
	uid = "\ref [A]"
	fields["name"] = sanitize(A.name)
	fields["area"] = sanitize("[get_area(A)]")
	fields["fprints"] = A.forensic_data?.get_prints().Copy()
	fields["fibers"] = A.forensic_data?.get_fibres().Copy()
	fields["blood"] = A.forensic_data?.get_blooddna().Copy()
	fields["time"] = world.time

/datum/data/record/forensic/proc/merge(var/datum/data/record/other)
	var/list/prints = fields["fprints"]
	var/list/o_prints = other.fields["fprints"]
	for(var/print in o_prints)
		if(!prints[print])
			prints[print] = o_prints[print]
		else
			prints[print] = stringmerge(prints[print], o_prints[print])
	fields["fprints"] = prints

	var/list/fibers = fields["fibers"]
	var/list/o_fibers = other.fields["fibers"]
	fibers |= o_fibers
	fields["fibers"] = fibers

	var/list/blood = other.fields["blood"]
	var/list/o_blood = other.fields["blood"]
	blood |= o_blood
	fields["blood"] = blood

	fields["area"] = other.fields["area"]
	fields["time"] = other.fields["time"]

/datum/data/record/forensic/proc/update_prints(var/list/o_prints)
	var/list/prints = fields["fprints"]
	for(var/print in o_prints)
		if(prints[print])
			prints[print] = stringmerge(prints[print], o_prints[print])
			.=1
	fields["fprints"] = prints
