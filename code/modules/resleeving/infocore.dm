////////////////////////////////
//// Mind/body data storage system
//// for the resleeving tech
////////////////////////////////

/mob/living/carbon/human/var/resleeve_lock

var/datum/transhuman/infocore/transcore = new/datum/transhuman/infocore

//Mind-backup database
/datum/transhuman/infocore
	var/notify_min = 5 MINUTES
	var/notify_max = 15 MINUTES
	var/ping_time = 3 MINUTES

	var/datum/transhuman/mind_record/list/backed_up = list()
	var/datum/transhuman/mind_record/list/has_left = list()
	var/datum/transhuman/body_record/list/body_scans = list()

	var/in_use = 1 //Whether to use this thing at all
	var/time_to_ping = 0 //When to do the next backup 'ping', in world.time

/datum/transhuman/infocore/New()
	process()

/datum/transhuman/infocore/proc/process()
	if(!in_use)
		return

	for(var/N in backed_up)
		var/datum/transhuman/mind_record/curr_MR = backed_up[N]
		if(!curr_MR)
			log_debug("Tried to process [N] in transcore w/o a record!")
		else
			if(!curr_MR.secretly_dead) //If we're not already working on it.
				//Implant is gone or was removed.
				if(!curr_MR.imp_ref || curr_MR.imp_ref.loc != curr_MR.mob_ref) //Implant gone
					curr_MR.secretly_dead = DEAD
					spawn(rand(notify_min,notify_max))
						curr_MR.obviously_dead = curr_MR.secretly_dead
						notify(N)
					continue
				//Mob is gone or dead.
				else if(!curr_MR.mob_ref || curr_MR.mob_ref.stat >= DEAD) //Mob appears to be dead
					curr_MR.secretly_dead = DEAD
					spawn(rand(notify_min,notify_max))
						if(!curr_MR.mob_ref || curr_MR.mob_ref.stat >= DEAD) //Still dead
							curr_MR.obviously_dead = curr_MR.secretly_dead
							notify(N)
						else
							curr_MR.secretly_dead = null //Not dead now, restore status.
					continue

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
	var/obviously_dead
	var/id_gender

	//Backend
	var/obj/item/weapon/implant/backup/imp_ref
	var/ckey = ""
	var/mob/living/carbon/human/mob_ref
	var/client/client
	var/datum/mind/mind
	var/cryo_at
	var/secretly_dead
	var/languages
	var/mind_oocnotes

/datum/transhuman/mind_record/New(var/mob/living/carbon/human/M,var/obj/item/weapon/implant/backup/imp,var/add_to_db = 1)
	ASSERT(M && imp)

	if(!istype(M))
		return //Only works with humanoids.

	//Scrape info from mob.
	mob_ref = M
	charname = M.name
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
	speciesname = M.custom_species ? M.custom_species : M.dna.species
	bodygender = M.gender
	body_oocnotes = M.ooc_notes

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

		//Just set the data to this. 0:normal, 1:assisted, 2:robotic, 3:crazy
		organ_data[org] = I.robotic

	if(add_to_db)
		transcore.add_body(src)