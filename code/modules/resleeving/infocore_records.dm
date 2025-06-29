////////////////////////////////
//// Mind/body data storage system
//// for the resleeving tech
////////////////////////////////

/mob/living/carbon/human/var/resleeve_lock
/mob/living/carbon/human/var/changeling_locked
/mob/living/carbon/human/var/original_player

/////// Mind-backup record ///////
/datum/transhuman/mind_record
	//User visible
	var/mindname = "!!ERROR!!"

	//0: Normal, 1: Might be dead, 2: Definitely dead, show on console
	var/dead_state = 0
	var/last_update = 0
	var/last_notification
	var/do_notify = TRUE

	//Backend
	var/ckey = ""
	var/id_gender = MALE
	var/datum/mind/mind_ref
	var/cryo_at = 0
	var/languages = list()
	var/mind_oocnotes = ""
	var/mind_ooclikes = ""
	var/mind_oocdislikes = ""
	var/mind_oocfavs = ""
	var/mind_oocmaybes = ""
	var/mind_oocstyle = FALSE
	var/nif_path
	var/nif_durability
	var/list/nif_software
	var/list/nif_savedata = list()

	var/one_time = FALSE

/datum/transhuman/mind_record/New(var/datum/mind/mind, var/mob/living/carbon/human/M, var/add_to_db = TRUE, var/one_time = FALSE, var/database_key)
	ASSERT(mind)

	src.one_time = one_time

	//The mind!
	mind_ref = mind
	mindname = mind.name
	ckey = ckey(mind.key)

	cryo_at = 0

	//Mental stuff the game doesn't keep mentally
	if(istype(M) || istype(M,/mob/living/carbon/brain/caught_soul))
		id_gender = M.identifying_gender
		languages = M.languages.Copy()
		mind_oocnotes = M.ooc_notes
		if(M.nif)
			nif_path = M.nif.type
			nif_durability = M.nif.durability
			var/list/nifsofts = list()
			for(var/N in M.nif.nifsofts)
				if(N)
					var/datum/nifsoft/nifsoft = N
					nifsofts += nifsoft.type
			nif_software = nifsofts
			nif_savedata = M.nif.save_data.Copy()

	if(istype(M,/mob) && !M.read_preference(/datum/preference/toggle/autotranscore))
		do_notify = FALSE

	last_update = world.time

	if(add_to_db)
		SStranscore.add_backup(src, database_key = database_key)

/////// Body Record ///////
/datum/transhuman/body_record
	var/datum/dna2/record/mydna

	//These may or may not be set, mostly irrelevant since it's just a body record.
	var/ckey
	var/locked
	var/changeling_locked
	var/client/client_ref
	var/datum/mind/mind_ref
	var/synthetic
	var/speciesname
	var/bodygender
	var/body_oocnotes
	var/body_ooclikes
	var/body_oocdislikes
	var/body_oocfavs
	var/body_oocmaybes
	var/body_oocstyle
	var/list/limb_data = list(BP_HEAD, BP_L_HAND, BP_R_HAND, BP_L_ARM, BP_R_ARM, BP_L_FOOT, BP_R_FOOT, BP_L_LEG, BP_R_LEG, BP_GROIN, BP_TORSO)
	var/list/organ_data = list(O_HEART, O_EYES, O_LUNGS, O_BRAIN)
	var/list/genetic_modifiers = list()
	var/toocomplex
	var/sizemult
	var/weight
	var/aflags
	var/breath_type = GAS_O2

/datum/transhuman/body_record/New(var/copyfrom, var/add_to_db = 0, var/ckeylock = 0)
	..()
	if(istype(copyfrom, /datum/transhuman/body_record))
		init_from_br(copyfrom)
	else if(ishuman(copyfrom))
		init_from_mob(copyfrom, add_to_db, ckeylock)

/datum/transhuman/body_record/Destroy()
	qdel_null(mydna.dna)
	qdel_null(mydna)
	client_ref = null
	mind_ref = null
	limb_data.Cut()
	organ_data.Cut()
	..()
	return QDEL_HINT_HARDDEL // For now at least there is no easy way to clear references to this in GLOB.machines etc.

/datum/transhuman/body_record/proc/init_from_mob(var/mob/living/carbon/human/M, var/add_to_db = 0, var/ckeylock = 0, var/database_key)
	ASSERT(!QDELETED(M))
	ASSERT(istype(M))

	//Person OOCly doesn't want people impersonating them
	locked = ckeylock

	//The mob is a changeling, don't allow anyone to possess them. Not using locked as locked gives OOC notices.
	if(is_changeling(M))
		changeling_locked = TRUE


	var/datum/species/S = GLOB.all_species["[M.dna.species]"]
	if(S)
		// Force ckey locking if species is whitelisted
		if((S.spawn_flags & SPECIES_IS_WHITELISTED) || (S.spawn_flags & SPECIES_IS_RESTRICTED))
			locked = TRUE

	//General stuff about them
	synthetic = M.isSynthetic()
	speciesname = M.custom_species ? M.custom_species : null
	bodygender = M.gender
	body_oocnotes = M.ooc_notes
	body_ooclikes = M.ooc_notes_likes
	body_oocdislikes = M.ooc_notes_dislikes
	body_oocfavs = M.ooc_notes_favs
	body_oocmaybes = M.ooc_notes_maybes
	body_oocstyle = M.ooc_notes_style
	sizemult = M.size_multiplier
	weight = M.weight
	aflags = M.appearance_flags
	breath_type = M.species.breath_type

	//Probably should
	M.dna.check_integrity()

	//The DNA2 stuff
	mydna = new ()
	qdel_swap(mydna.dna, M.dna.Clone())
	mydna.ckey = M.ckey
	mydna.id = copytext(md5(M.real_name), 2, 6)
	mydna.name = M.dna.real_name
	mydna.types = DNA2_BUF_UI|DNA2_BUF_UE|DNA2_BUF_SE
	mydna.flavor = M.flavor_texts.Copy()

	//My stuff
	client_ref = M.client
	ckey = M.ckey
	mind_ref = M.mind

	//External organ status. 0:gone, 1:normal, "string":manufacturer
	for(var/limb in limb_data)
		var/obj/item/organ/external/O = M.organs_by_name[limb]

		//Missing limb.
		if(!O)
			limb_data[limb] = 0

		//Has model set, is pros.
		else if(O.model)
			limb_data[limb] = O.model

		//Nothing special, present and normal.
		else
			limb_data[limb] = 1

	//Internal organ status
	for(var/org in organ_data)
		var/obj/item/organ/I = M.internal_organs_by_name[org]

		//Who knows? Missing lungs maybe on synths, etc.
		if(!I)
			continue

		//This needs special handling because brains never think they are 'robotic', even posibrains
		if(org == O_BRAIN)
			switch(I.type)
				if(/obj/item/organ/internal/mmi_holder) //Assisted
					organ_data[org] = 1
				if(/obj/item/organ/internal/mmi_holder/posibrain) //Mechanical
					organ_data[org] = 2
				if(/obj/item/organ/internal/mmi_holder/robot) //Digital
					organ_data[org] = 3
				else //Anything else just give a brain to
					organ_data[org] = 0
			continue

		//Just set the data to this. 0:normal, 1:assisted, 2:mechanical, 3:digital
		organ_data[org] = I.robotic

	//Genetic modifiers
	for(var/datum/modifier/mod as anything in M.modifiers)
		if(mod.flags & MODIFIER_GENETIC)
			genetic_modifiers.Add(mod.type)

	if(add_to_db)
		SStranscore.add_body(src, database_key = database_key)

/**
 * Make a deep copy of this record so it can be saved on a disk without modifications
 * to the original affecting the copy.
 * Just to be clear, this has nothing to do do with acutal biological cloning, body printing, resleeving,
 * or anything like that! This is the computer science concept of "cloning" a data structure!
 */
/datum/transhuman/body_record/proc/init_from_br(var/datum/transhuman/body_record/orig)
	ASSERT(!QDELETED(orig))
	ASSERT(istype(orig))
	for(var/A in vars)
		switch(A)
			if(BLACKLISTED_COPY_VARS)
				continue
			if("mydna")
				mydna = orig.mydna.copy()
				continue
		if(islist(vars[A]))
			var/list/L = orig.vars[A]
			vars[A] = L.Copy()
			continue
		vars[A] = orig.vars[A]

/**
 * Spawning a body was once left entirely up to the machine doing it, but bodies are massivley complex
 * objects, and doing it this way lead to huge amounts of copypasted code to do the same thing.
 * If you want to spawn a body from a BR, please use these...
 */

/// The core of resleeving, creates a mob based on the current record
/datum/transhuman/body_record/proc/produce_human_mob(var/location, var/is_synthfab, var/force_unlock, var/backup_name)
	// These are broken up into steps, otherwise the proc gets massive and hard to read.
	var/mob/living/carbon/human/H = internal_producebody(location,backup_name)
	internal_producebody_handlesleevelock(H,force_unlock)
	internal_producebody_updatelimbandorgans(H)
	internal_producebody_updatednastate(H,is_synthfab)
	internal_producebody_virgoOOC(H)
	internal_producebody_misc(H)
	return H

/// Creates a human mob with the correct species, name, and a stable state.
/datum/transhuman/body_record/proc/internal_producebody(var/location,var/backup_name)
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)

	var/mob/living/carbon/human/H = new /mob/living/carbon/human(location, mydna.dna.species)
	if(!mydna.dna.real_name)
		mydna.dna.real_name = backup_name
	H.real_name = mydna.dna.real_name
	H.name = H.real_name
	for(var/datum/language/L in mydna.languages)
		H.add_language(L.name)
	H.suiciding = 0
	H.losebreath = 0
	H.mind = null

	return H

/// Sets the new body's sleevelock status, to prevent impersonation by transfering an incorrect mind.
/datum/transhuman/body_record/proc/internal_producebody_handlesleevelock(var/mob/living/carbon/human/H,var/force_unlock)
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)
	if(locked && !force_unlock)
		if(ckey)
			H.resleeve_lock = ckey
		else
			// Ensure even body scans without an attached ckey respect locking
			H.resleeve_lock = "@badckey"

/// Either converts limbs to robotics or prosthetic states, or removes them entirely based off record.
/datum/transhuman/body_record/proc/internal_producebody_updatelimbandorgans(var/mob/living/carbon/human/H,var/is_synthfab)
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)

	//Fix the external organs
	for(var/part in limb_data)
		var/status = limb_data[part]
		if(status == null) continue //Species doesn't have limb? Child of amputated limb?

		var/obj/item/organ/external/O = H.organs_by_name[part]
		if(!O) continue //Not an organ. Perhaps another amputation removed it already.

		if(status == 1) //Normal limbs
			continue
		else if(status == 0) //Missing limbs
			O.remove_rejuv()
		else if(status) //Anything else is a manufacturer
			if(!is_synthfab)
				O.remove_rejuv() //Don't robotize them, leave them removed so robotics can attach a part.
			else
				O.robotize(status)

	//Then the internal organs
	for(var/part in organ_data)
		var/status = organ_data[part]
		if(status == null) continue //Species doesn't have organ? Child of missing part?

		var/obj/item/organ/I = H.internal_organs_by_name[part]
		if(!I) continue//Not an organ. Perhaps external conversion changed it already?

		if(status == 0) //Normal organ
			continue
		else if(status == 1) //Assisted organ
			I.mechassist()
		else if(status == 2) //Mechanical organ
			I.robotize()
		else if(status == 3) //Digital organ
			I.digitize()

/// Transfers dna data to mob, and reinits traits and appearance from it
/datum/transhuman/body_record/proc/internal_producebody_updatednastate(var/mob/living/carbon/human/H,var/is_synthfab)
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)

	//Apply DNA from record
	if(!mydna.dna) // This case should never happen, but copied from clone pod... Who knows with this codebase.
		mydna.dna = new /datum/dna()
	qdel_swap(H.dna, mydna.dna.Clone())
	H.original_player = ckey

	//Apply genetic modifiers, synths don't use these
	if(!is_synthfab)
		for(var/modifier_type in mydna.genetic_modifiers)
			H.add_modifier(modifier_type)

	//Update appearance, remake icons
	H.UpdateAppearance()
	H.sync_dna_traits(FALSE) // Traitgenes Sync traits to genetics if needed
	H.sync_organ_dna()
	H.regenerate_icons()
	H.initialize_vessel()

/// Transfers VORE related information cached in the mob
/datum/transhuman/body_record/proc/internal_producebody_virgoOOC(var/mob/living/carbon/human/H)
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)
	H.ooc_notes = body_oocnotes
	H.ooc_notes_likes = body_ooclikes
	H.ooc_notes_dislikes = body_oocdislikes
	H.ooc_notes_favs = body_oocfavs
	H.ooc_notes_maybes = body_oocmaybes
	H.ooc_notes_style = body_oocstyle

/datum/transhuman/body_record/proc/internal_producebody_misc(var/mob/living/carbon/human/H)
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)
	H.flavor_texts = mydna.flavor.Copy()
	H.resize(sizemult, FALSE)
	H.appearance_flags = aflags
	H.weight = weight
	if(speciesname)
		H.custom_species = speciesname

/**
 * Specialty revival procs. Uses the BR for data, but needs to handle some weird logic for xenochi/slimes
 */
/datum/transhuman/body_record/proc/revive_xenochimera(var/mob/living/carbon/human/H,var/heal_robot_limbs,var/from_save_slot)
	// Boy this one is complex, but what do we expect when trying to heal damage and organ loss in this game!
	if(!H || QDELETED(H)) // Someone, somewhere, will call this without any safety. I feel it in my bones cappin'
		return

	// Don't unlock unwilling xenochi!
	internal_producebody_handlesleevelock(H,FALSE)

	// Reset our organs/limbs.
	H.species.create_organs(H)
	internal_producebody_updatelimbandorgans(H, heal_robot_limbs)

	//Don't boot out anyone already in the mob.
	if(!H.client || !H.key)
		for (var/obj/item/organ/internal/brain/CH in GLOB.all_brain_organs)
			if(CH.brainmob)
				if(CH.brainmob.real_name == H.real_name)
					if(CH.brainmob.mind)
						CH.brainmob.mind.transfer_to(H)
						qdel(CH)

	// Traitgenes Disable all traits currently active, before species.produceCopy() applies them during updatednastate(). Relevant here as genetraits may not match prior dna!
	for(var/datum/gene/trait/gene in GLOB.dna_genes)
		if(gene.name in H.active_genes)
			gene.deactivate(H)
			H.active_genes -= gene.name

	internal_producebody_updatednastate(H,FALSE)
	internal_producebody_virgoOOC(H) // Is this needed?
	internal_producebody_misc(H)

	// Begin actual REVIVIAL. Do NOT use revive(). That uses client prefs and allows save hacking.
	H.revival_healing_action()

	// Update record from vanity copy of slot if needed
	if(from_save_slot)
		H.client.prefs.vanity_copy_to(H,FALSE,TRUE,TRUE,FALSE)
		for(var/category in H.all_underwear) // No undies
			H.hide_underwear[category] = TRUE
		H.update_underwear()

	return H

/datum/transhuman/body_record/proc/revive_promethean(var/mob/living/carbon/human/H)
	// TODO - See note in code\modules\organs\internal\brain.dm for slime brains
	return
