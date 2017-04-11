////////////////////////////////
//// Mind/body data storage system
//// for the resleeving tech
////////////////////////////////

/mob/living/carbon/human/var/resleeve_lock
/mob/living/carbon/human/var/original_player

var/datum/transhuman/infocore/transcore = new/datum/transhuman/infocore

//Mind-backup database
/datum/transhuman/infocore
	var/overdue_time = 15 MINUTES
	var/process_time = 1 MINUTE
	var/core_dumped = 0

	var/datum/transhuman/mind_record/list/backed_up = list()
	var/datum/transhuman/mind_record/list/has_left = list()
	var/datum/transhuman/body_record/list/body_scans = list()

/datum/transhuman/infocore/New()
	process()

/datum/transhuman/infocore/proc/process()
	if(core_dumped) return
	for(var/N in backed_up)
		var/datum/transhuman/mind_record/curr_MR = backed_up[N]
		if(!curr_MR)
			log_debug("Tried to process [N] in transcore w/o a record!")
			continue

		var/since_backup = world.time - curr_MR.last_update
		if(since_backup < overdue_time)
			curr_MR.dead_state = MR_NORMAL
		else
			if(curr_MR.dead_state != MR_DEAD) //First time switching to dead
				notify(N)
			curr_MR.dead_state = MR_DEAD

	spawn(process_time)
		process()

/datum/transhuman/infocore/proc/m_backup(var/datum/mind/mind)
	ASSERT(mind)
	if(!mind.name || core_dumped)
		return 0

	var/datum/transhuman/mind_record/MR

	if(mind.name in backed_up)
		MR = backed_up[mind.name]
		MR.last_update = world.time
	else
		MR = new(mind, mind.current, 1)

	return 1

/datum/transhuman/infocore/proc/notify(var/name)
	ASSERT(name)
	var/obj/item/device/radio/headset/a = new /obj/item/device/radio/headset/heads/captain(null)
	a.autosay("[name] is past-due for a mind backup. This will be the only notification.", "TransCore Oversight", "Medical")
	qdel(a)

/datum/transhuman/infocore/proc/add_backup(var/datum/transhuman/mind_record/MR)
	ASSERT(MR)
	backed_up[MR.mindname] = MR
	backed_up = sortAssoc(backed_up)
	log_debug("Added [MR.mindname] to transcore DB.")

/datum/transhuman/infocore/proc/stop_backup(var/datum/transhuman/mind_record/MR)
	ASSERT(MR)
	has_left[MR.mindname] = MR
	backed_up.Remove("[MR.mindname]")
	MR.cryo_at = world.time
	log_debug("Put [MR.mindname] in transcore suspended DB.")

/datum/transhuman/infocore/proc/add_body(var/datum/transhuman/body_record/BR)
	ASSERT(BR)
	body_scans[BR.mydna.name] = BR
	body_scans = sortAssoc(body_scans)
	log_debug("Added [BR.mydna.name] to transcore body DB.")

/datum/transhuman/infocore/proc/remove_body(var/datum/transhuman/body_record/BR)
	ASSERT(BR)
	body_scans.Remove("[BR.mydna.name]")
	log_debug("Removed [BR.mydna.name] from transcore body DB.")

/datum/transhuman/infocore/proc/core_dump(var/obj/item/weapon/disk/transcore/disk)
	ASSERT(disk)
	var/obj/item/device/radio/headset/a = new /obj/item/device/radio/headset/heads/captain(null)
	a.autosay("An emergency core dump has been initiated!", "TransCore Oversight", "Command")
	a.autosay("An emergency core dump has been initiated!", "TransCore Oversight", "Medical")
	qdel(a)

	disk.stored += backed_up
	backed_up.Cut()
	core_dumped = 1
	return disk.stored.len

/////// Mind-backup record ///////
/datum/transhuman/mind_record
	//User visible
	var/mindname = "!!ERROR!!"

	//0: Normal, 1: Might be dead, 2: Definitely dead, show on console
	var/dead_state = 0
	var/last_update = 0

	//Backend
	var/ckey = ""
	var/id_gender
	var/datum/mind/mind_ref
	var/cryo_at
	var/languages
	var/mind_oocnotes

/datum/transhuman/mind_record/New(var/datum/mind/mind,var/mob/living/carbon/human/M,var/obj/item/weapon/implant/backup/imp,var/add_to_db = 1)
	ASSERT(mind && M && imp)

	if(!istype(M))
		return //Only works with humanoids.

	//The mind!
	mind_ref = mind
	mindname = mind.name
	ckey = ckey(mind.key)

	cryo_at = 0

	//Mental stuff the game doesn't keep mentally
	id_gender = M.identifying_gender
	languages = M.languages.Copy()
	mind_oocnotes = M.ooc_notes

	last_update = world.time

	if(add_to_db)
		transcore.add_backup(src)

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
	var/weight

/datum/transhuman/body_record/New(var/copyfrom, var/add_to_db = 0, var/ckeylock = 0)
	..()
	if(istype(copyfrom, /datum/transhuman/body_record))
		init_from_br(copyfrom)
	else if(ishuman(copyfrom))
		init_from_mob(copyfrom, add_to_db, ckeylock)

/datum/transhuman/body_record/Destroy()
	mydna = null
	client_ref = null
	mind_ref = null
	limb_data.Cut()
	organ_data.Cut()
	..()

/datum/transhuman/body_record/proc/init_from_mob(var/mob/living/carbon/human/M, var/add_to_db = 0, var/ckeylock = 0)
	ASSERT(!deleted(M))
	ASSERT(istype(M))

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
	weight = M.weight

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


/**
 * Make a deep copy of this record so it can be saved on a disk without mofidications
 * to the original affecting the copy.
 * Just to be clear, this has nothing to do do with acutal biological cloning, body printing, resleeving,
 * or anything like that! This is the computer science concept of "cloning" a data structure!
 */
/datum/transhuman/body_record/proc/init_from_br(var/datum/transhuman/body_record/orig)
	ASSERT(!deleted(orig))
	ASSERT(istype(orig))
	src.mydna = new ()
	src.mydna.dna = orig.mydna.dna.Clone()
	src.mydna.ckey = orig.mydna.ckey
	src.mydna.id = orig.mydna.id
	src.mydna.name = orig.mydna.name
	src.mydna.types = orig.mydna.types
	src.mydna.flavor = orig.mydna.flavor.Copy()
	src.ckey = orig.ckey
	src.locked = orig.locked
	src.client_ref = orig.client_ref
	src.mind_ref = orig.mind_ref
	src.synthetic = orig.synthetic
	src.speciesname = orig.speciesname
	src.bodygender = orig.bodygender
	src.body_oocnotes = orig.body_oocnotes
	src.limb_data = orig.limb_data.Copy()
	src.organ_data = orig.organ_data.Copy()
	src.toocomplex = orig.toocomplex
	src.sizemult = orig.sizemult
