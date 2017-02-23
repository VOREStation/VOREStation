////////////////////////////////
//// Mind/body data storage system
//// for the resleeving tech
////////////////////////////////

/mob/living/carbon/human/var/resleeve_lock

var/datum/transhuman/infocore/transcore = new/datum/transhuman/infocore

//Mind-backup database
/datum/transhuman/infocore
	var/ping_time = 5 MINUTES

	var/datum/transhuman/mind_record/list/backed_up = list()
	var/datum/transhuman/mind_record/list/has_left = list()
	var/datum/transhuman/body_record/list/body_scans = list()

/datum/transhuman/infocore/New()
	process()

/datum/transhuman/infocore/proc/process()

	for(var/N in backed_up)
		var/datum/transhuman/mind_record/curr_MR = backed_up[N]
		if(!curr_MR)
			log_debug("Tried to process [N] in transcore w/o a record!")
			continue

		switch(curr_MR.dead_state)
			if(MR_NORMAL)
				if(!curr_MR.ping())
					curr_MR.dead_state = MR_UNSURE
			if(MR_UNSURE)
				if(curr_MR.ping())
					curr_MR.dead_state = MR_NORMAL
				else
					curr_MR.dead_state = MR_DEAD
					notify(N)
			if(MR_DEAD)
				if(curr_MR.ping())
					curr_MR.dead_state = MR_NORMAL

	spawn(ping_time)
		process()

/datum/transhuman/infocore/proc/notify(var/name)
	ASSERT(name)
	var/obj/item/device/radio/headset/a = new /obj/item/device/radio/headset/heads/captain(null)
	a.autosay("[name] is past-due for a mind backup. This will be the only notification.", "Backup Monitor", "Medical")
	qdel(a)

/datum/transhuman/infocore/proc/add_backup(var/datum/transhuman/mind_record/MR)
	ASSERT(MR)
	backed_up[MR.charname] = MR
	log_debug("Added [MR.charname] to transcore DB.")

/datum/transhuman/infocore/proc/stop_backup(var/datum/transhuman/mind_record/MR)
	ASSERT(MR)
	has_left[MR.charname] = MR
	backed_up.Remove("[MR.charname]")
	log_debug("Put [MR.charname] in transcore suspended DB.")

/datum/transhuman/infocore/proc/add_body(var/datum/transhuman/body_record/BR)
	ASSERT(BR)
	body_scans[BR.mydna.name] = BR
	log_debug("Added [BR.mydna.name] to transcore body DB.")

/////// Mind-backup record ///////
/datum/transhuman/mind_record
	//User visible
	var/charname = "!!ERROR!!"
	var/implanted_at
	var/body_type
	var/id_gender

	//0: Normal, 1: Might be dead, 2: Definitely dead, show on console
	var/dead_state = 0

	//Backend
	var/obj/item/weapon/implant/backup/imp_ref
	var/ckey = ""
	var/mob/living/carbon/human/mob_ref
	var/client/client
	var/datum/mind/mind
	var/cryo_at
	var/languages
	var/mind_oocnotes

/datum/transhuman/mind_record/New(var/mob/living/carbon/human/M,var/obj/item/weapon/implant/backup/imp,var/add_to_db = 1)
	ASSERT(M && imp)

	if(!istype(M))
		return //Only works with humanoids.

	//Scrape info from mob.
	mob_ref = M
	charname = M.real_name
	implanted_at = world.time
	body_type = M.isSynthetic()
	id_gender = M.identifying_gender

	imp_ref = imp
	ckey = M.ckey
	cryo_at = 0
	languages = M.languages.Copy()
	mind_oocnotes = M.ooc_notes

	//If these are gone then it's a problemmmm.
	client = M.client
	mind = M.mind

	if(add_to_db)
		transcore.add_backup(src)

/datum/transhuman/mind_record/proc/ping()
	if(!imp_ref || !mob_ref || imp_ref.loc != mob_ref || mob_ref.stat >= DEAD) //Ways you can be considered past-due
		return 0

	return 1 //Ping replied

/////// Body Record ///////
/datum/transhuman/body_record
	var/datum/dna2/record/mydna

	//These may or may not be set, mostly irrelevant since it's just a body record.
	var/ckey
	var/locked
	var/client/client_ref
	var/datum/mind/mind_ref
	var/synthetic
	var/speciesname
	var/bodygender
	var/body_oocnotes
	var/list/limb_data = list(BP_HEAD, BP_L_HAND, BP_R_HAND, BP_L_ARM, BP_R_ARM, BP_L_FOOT, BP_R_FOOT, BP_L_LEG, BP_R_LEG, BP_GROIN, BP_TORSO)
	var/list/organ_data = list(O_HEART, O_EYES, O_LUNGS, O_BRAIN)
	var/toocomplex
	var/sizemult

/datum/transhuman/body_record/New(var/mob/living/carbon/human/M,var/add_to_db = 1,var/ckeylock = 0)
	ASSERT(M)

	//Person OOCly doesn't want people impersonating them
	locked = ckeylock

	//Prevent people from printing restricted and whitelisted species
	var/datum/species/S = all_species["[M.dna.species]"]
	if(S)
		toocomplex = (S.spawn_flags & SPECIES_IS_WHITELISTED) || (S.spawn_flags & SPECIES_IS_RESTRICTED)

	//General stuff about them
	synthetic = M.isSynthetic()
	speciesname = M.custom_species ? M.custom_species : null
	bodygender = M.gender
	body_oocnotes = M.ooc_notes
	sizemult = M.size_multiplier

	//Probably should
	M.dna.check_integrity()

	//The DNA2 stuff
	mydna = new ()
	mydna.dna = M.dna.Clone()
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

	if(add_to_db)
		transcore.add_body(src)
