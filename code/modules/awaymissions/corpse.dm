//These are meant for spawning on maps, namely Away Missions.

//If someone can do this in a neater way, be my guest-Kor

//To do: Allow corpses to appear mangled, bloody, etc. Allow customizing the bodies appearance (they're all bald and white right now).

/obj/effect/landmark/corpse
	name = "Unknown"
	var/mobname = "Unknown"  //Unused now but it'd fuck up maps to remove it now
	var/corpseuniform = null //Set this to an object path to have the slot filled with said object on the corpse.
	var/corpsesuit = null
	var/corpseshoes = null
	var/corpsegloves = null
	var/corpseradio = null
	var/corpseglasses = null
	var/corpsemask = null
	var/corpsehelmet = null
	var/corpsebelt = null
	var/corpsepocket1 = null
	var/corpsepocket2 = null
	var/corpseback = null
	var/corpseid = 0     //Just set to 1 if you want them to have an ID
	var/corpseidjob = null // Needs to be in quotes, such as "Clown" or "Chef." This just determines what the ID reads as, not their access
	var/corpseidaccess = null //This is for access. See access.dm for which jobs give what access. Again, put in quotes. Use "Captain" if you want it to be all access.
	var/corpseidicon = null //For setting it to be a gold, silver, CentCom etc ID
	var/species = SPECIES_HUMAN	//defaults to generic-ass humans
	var/random_species = FALSE	//flip to TRUE to randomize species from the list below
	var/list/random_species_list = list(SPECIES_HUMAN,SPECIES_TAJ,SPECIES_UNATHI,SPECIES_SKRELL)	//preset list that can be overriden downstream. only includes common humanoids for voidsuit compatibility's sake.
//	var/random_appearance = FALSE	//TODO: make this work
//	var/cause_of_death = null //TODO: set up a cause-of-death system. needs to support both damage types and actual wound types, so a body can have been bitten/stabbed/clawed/shot/burned/lasered/etc. to death
	delete_me = TRUE

/obj/effect/landmark/corpse/Initialize()
	..()
	createCorpse()
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/corpse/proc/createCorpse() //Creates a mob and checks for gear in each slot before attempting to equip it.
	var/mob/living/carbon/human/M = new /mob/living/carbon/human (src.loc)
	M.low_sorting_priority = TRUE
	if(random_species)
		var/random_pick = pick(random_species_list)
		M.set_species(random_pick)
		src.species = random_pick
	else
		M.set_species(species)
	//TODO: insert appearance randomization, needs to be species-based
	M.real_name = src.name
	M.death(1) //Kills the new mob
	//TODO: insert cause of death handling/wound simulation here
	if(src.corpseuniform)
		M.equip_to_slot_or_del(new src.corpseuniform(M), slot_w_uniform)
	if(src.corpseshoes)
		M.equip_to_slot_or_del(new src.corpseshoes(M), slot_shoes)
	if(src.corpsegloves)
		M.equip_to_slot_or_del(new src.corpsegloves(M), slot_gloves)
	if(src.corpseradio)
		M.equip_to_slot_or_del(new src.corpseradio(M), slot_l_ear)
	if(src.corpseglasses)
		M.equip_to_slot_or_del(new src.corpseglasses(M), slot_glasses)
	if(src.corpsemask)
		M.equip_to_slot_or_del(new src.corpsemask(M), slot_wear_mask)
	if(src.corpsebelt)
		M.equip_to_slot_or_del(new src.corpsebelt(M), slot_belt)
	if(src.corpsepocket1)
		M.equip_to_slot_or_del(new src.corpsepocket1(M), slot_r_store)
	if(src.corpsepocket2)
		M.equip_to_slot_or_del(new src.corpsepocket2(M), slot_l_store)
	if(src.corpseback)
		M.equip_to_slot_or_del(new src.corpseback(M), slot_back)
	if(src.corpseid == 1)
		var/obj/item/weapon/card/id/W = new(M)
		var/datum/job/jobdatum
		for(var/jobtype in typesof(/datum/job))
			var/datum/job/J = new jobtype
			if(J.title == corpseidaccess)
				jobdatum = J
				break
		if(src.corpseidicon)
			W.icon_state = corpseidicon
		if(src.corpseidaccess)
			if(jobdatum)
				W.access = jobdatum.get_access()
			else
				W.access = list()
		if(corpseidjob)
			W.assignment = corpseidjob
		M.set_id_info(W)
		M.equip_to_slot_or_del(W, slot_wear_id)
	// Do suit last to avoid equipping issues
	if(src.corpsehelmet)
		M.equip_voidhelm_to_slot_or_del_with_refit(new src.corpsehelmet(M), slot_head, src.species)
	if(src.corpsesuit)
		M.equip_voidsuit_to_slot_or_del_with_refit(new src.corpsesuit(M), slot_wear_suit, src.species)



// I'll work on making a list of corpses people request for maps, or that I think will be commonly used. Syndicate operatives for example.

/obj/effect/landmark/corpse/syndicatesoldier
	name = "Mercenary"
	corpseuniform = /obj/item/clothing/under/syndicate
	corpsesuit = /obj/item/clothing/suit/armor/vest
	corpseshoes = /obj/item/clothing/shoes/boots/swat
	corpsegloves = /obj/item/clothing/gloves/swat
	corpseradio = /obj/item/device/radio/headset
	corpsemask = /obj/item/clothing/mask/gas
	corpsehelmet = /obj/item/clothing/head/helmet/swat
	corpseback = /obj/item/weapon/storage/backpack
	corpseid = 1
	corpseidjob = "Operative"
	corpseidaccess = "Syndicate"

/obj/effect/landmark/corpse/syndicatecommando
	name = "Mercenary Commando"
	corpseuniform = /obj/item/clothing/under/syndicate
	corpsesuit = /obj/item/clothing/suit/space/void/merc
	corpseshoes = /obj/item/clothing/shoes/boots/swat
	corpsegloves = /obj/item/clothing/gloves/swat
	corpseradio = /obj/item/device/radio/headset
	corpsemask = /obj/item/clothing/mask/gas/syndicate
	corpsehelmet = /obj/item/clothing/head/helmet/space/void/merc
	corpseback = /obj/item/weapon/tank/jetpack/oxygen
	corpsepocket1 = /obj/item/weapon/tank/emergency/oxygen
	corpseid = 1
	corpseidjob = "Operative"
	corpseidaccess = "Syndicate"

///////////Civilians//////////////////////

/obj/effect/landmark/corpse/random_civ
	name = "Civilian"
	corpseuniform = /obj/item/clothing/under/color/grey
	corpseshoes = /obj/item/clothing/shoes/black
	random_species = TRUE



/obj/effect/landmark/corpse/chef
	name = JOB_CHEF
	corpseuniform = /obj/item/clothing/under/rank/chef
	corpsesuit = /obj/item/clothing/suit/chef/classic
	corpseshoes = /obj/item/clothing/shoes/black
	corpsehelmet = /obj/item/clothing/head/chefhat
	corpseback = /obj/item/weapon/storage/backpack
	corpseradio = /obj/item/device/radio/headset
	corpseid = 1
	corpseidjob = JOB_CHEF
	corpseidaccess = JOB_CHEF


/obj/effect/landmark/corpse/doctor
	name = "Doctor"
	corpseradio = /obj/item/device/radio/headset/headset_med
	corpseuniform = /obj/item/clothing/under/rank/medical
	corpsesuit = /obj/item/clothing/suit/storage/toggle/labcoat
	corpseback = /obj/item/weapon/storage/backpack/medic
	corpsepocket1 = /obj/item/device/flashlight/pen
	corpseshoes = /obj/item/clothing/shoes/black
	corpseid = 1
	corpseidjob = JOB_MEDICAL_DOCTOR
	corpseidaccess = JOB_MEDICAL_DOCTOR

/obj/effect/landmark/corpse/engineer
	name = JOB_ENGINEER
	corpseradio = /obj/item/device/radio/headset/headset_eng
	corpseuniform = /obj/item/clothing/under/rank/engineer
	corpseback = /obj/item/weapon/storage/backpack/industrial
	corpseshoes = /obj/item/clothing/shoes/orange
	corpsebelt = /obj/item/weapon/storage/belt/utility/full
	corpsegloves = /obj/item/clothing/gloves/yellow
	corpsehelmet = /obj/item/clothing/head/hardhat
	corpseid = 1
	corpseidjob = JOB_ENGINEER
	corpseidaccess = JOB_ENGINEER

/obj/effect/landmark/corpse/engineer/rig
	corpsesuit = /obj/item/clothing/suit/space/void/engineering
	corpsemask = /obj/item/clothing/mask/breath
	corpsehelmet = /obj/item/clothing/head/helmet/space/void/engineering
	corpseback = /obj/item/weapon/tank/oxygen

/obj/effect/landmark/corpse/clown
	name = JOB_CLOWN
	corpseuniform = /obj/item/clothing/under/rank/clown
	corpseshoes = /obj/item/clothing/shoes/clown_shoes
	corpseradio = /obj/item/device/radio/headset
	corpsemask = /obj/item/clothing/mask/gas/clown_hat
	corpsepocket1 = /obj/item/weapon/bikehorn
	corpseback = /obj/item/weapon/storage/backpack/clown
	corpseid = 1
	corpseidjob = JOB_CLOWN
	corpseidaccess = JOB_CLOWN

/obj/effect/landmark/corpse/scientist
	name = JOB_SCIENTIST
	corpseradio = /obj/item/device/radio/headset/headset_sci
	corpseuniform = /obj/item/clothing/under/rank/scientist
	corpsesuit = /obj/item/clothing/suit/storage/toggle/labcoat/science
	corpseback = /obj/item/weapon/storage/backpack
	corpseshoes = /obj/item/clothing/shoes/white
	corpseid = 1
	corpseidjob = JOB_SCIENTIST
	corpseidaccess = JOB_SCIENTIST

/obj/effect/landmark/corpse/security
	name = JOB_SECURITY_OFFICER
	corpseradio = /obj/item/device/radio/headset/headset_sec
	corpseuniform = /obj/item/clothing/under/rank/security
	corpsesuit = /obj/item/clothing/suit/armor/vest
	corpseback = /obj/item/weapon/storage/backpack/security
	corpseshoes = /obj/item/clothing/shoes/boots/jackboots
	corpseglasses = /obj/item/clothing/glasses/sunglasses/sechud
	corpsegloves = /obj/item/clothing/gloves/black
	corpsehelmet = /obj/item/clothing/head/helmet
	corpseid = 1
	corpseidjob = JOB_SECURITY_OFFICER
	corpseidaccess = JOB_SECURITY_OFFICER

/obj/effect/landmark/corpse/security/rig
	corpsesuit = /obj/item/clothing/suit/space/void/security
	corpsemask = /obj/item/clothing/mask/breath
	corpsehelmet = /obj/item/clothing/head/helmet/space/void/security
	corpseback = /obj/item/weapon/tank/jetpack/oxygen

/obj/effect/landmark/corpse/security/rig/eva
	corpsesuit = /obj/item/clothing/suit/space/void/security/alt
	corpsehelmet = /obj/item/clothing/head/helmet/space/void/security/alt
	corpseidjob = "Starship Security Officer"

/obj/effect/landmark/corpse/prisoner
	name = "Unknown Prisoner"
	corpseuniform = /obj/item/clothing/under/color/prison
	corpseshoes = /obj/item/clothing/shoes/orange
	corpseid = 1
	corpseidjob = "Prisoner"
	random_species = TRUE

/obj/effect/landmark/corpse/miner
	corpseradio = /obj/item/device/radio/headset/headset_cargo
	corpseuniform = /obj/item/clothing/under/rank/miner
	corpsegloves = /obj/item/clothing/gloves/black
	corpseback = /obj/item/weapon/storage/backpack/industrial
	corpseshoes = /obj/item/clothing/shoes/black
	corpseid = 1
	corpseidjob = JOB_SHAFT_MINER
	corpseidaccess = JOB_SHAFT_MINER

/obj/effect/landmark/corpse/miner/rig
	corpsesuit = /obj/item/clothing/suit/space/void/mining
	corpsemask = /obj/item/clothing/mask/breath
	corpsehelmet = /obj/item/clothing/head/helmet/space/void/mining
	corpseback = /obj/item/weapon/tank/oxygen

/////////////////Vintage//////////////////////

//define the basic props at this level and only change specifics for variants, e.z.
/obj/effect/landmark/corpse/vintage
	name = "Unknown Crewmate"
	corpseuniform = /obj/item/clothing/under/utility
	corpsesuit = /obj/item/clothing/suit/space/void/refurb
	corpsehelmet = /obj/item/clothing/head/helmet/space/void/refurb
	corpsemask = /obj/item/clothing/mask/breath
	corpseback = /obj/item/weapon/tank/oxygen
	corpseid = 1
	corpseidjob = "Crewmate"

/obj/effect/landmark/corpse/vintage/engineering
	name = "Unknown " + JOB_ENGINEER
	corpsesuit = /obj/item/clothing/suit/space/void/refurb/engineering
	corpsehelmet = /obj/item/clothing/head/helmet/space/void/refurb/engineering
	corpsebelt = /obj/item/weapon/storage/belt/utility/full
	corpseback = /obj/item/weapon/tank/oxygen/yellow
	corpseidjob = JOB_ENGINEER

/obj/effect/landmark/corpse/vintage/marine
	name = "Unknown Marine"
	corpsesuit = /obj/item/clothing/suit/space/void/refurb/marine
	corpsehelmet = /obj/item/clothing/head/helmet/space/void/refurb/marine
	corpsebelt = /obj/item/weapon/storage/belt/security/tactical
	corpseidjob = "Marine"

/obj/effect/landmark/corpse/vintage/medical
	name = "Unknown Medic"
	corpsesuit = /obj/item/clothing/suit/space/void/refurb/medical
	corpsehelmet = /obj/item/clothing/head/helmet/space/void/refurb/medical
	corpsebelt = /obj/item/weapon/storage/belt/medical
	corpseidjob = "Medic"

/obj/effect/landmark/corpse/vintage/mercenary
	name = "Unknown Mercenary"
	corpsesuit = /obj/item/clothing/suit/space/void/refurb/mercenary
	corpsehelmet = /obj/item/clothing/head/helmet/space/void/refurb/mercenary
	corpsebelt = /obj/item/weapon/storage/belt/security/tactical
	corpseback = /obj/item/weapon/tank/oxygen/red
	corpseidjob = "Mercenary"

/obj/effect/landmark/corpse/vintage/officer
	name = "Unknown Captain"
	corpsesuit = /obj/item/clothing/suit/space/void/refurb/officer
	corpsehelmet = /obj/item/clothing/head/helmet/space/void/refurb/officer
	corpseback = /obj/item/weapon/tank/oxygen/yellow
	corpseidjob = "Captain"

/obj/effect/landmark/corpse/vintage/pilot
	name = "Unknown " + JOB_PILOT
	corpsesuit = /obj/item/clothing/suit/space/void/refurb/pilot
	corpsehelmet = /obj/item/clothing/head/helmet/space/void/refurb/pilot
	corpseidjob = JOB_PILOT

/obj/effect/landmark/corpse/vintage/research
	name = "Unknown Researcher"
	corpsesuit = /obj/item/clothing/suit/space/void/refurb/research
	corpsehelmet = /obj/item/clothing/head/helmet/space/void/refurb/research
	corpseidjob = "Researcher"

/////////////////Officers//////////////////////

/obj/effect/landmark/corpse/bridgeofficer
	name = "Bridge Officer"
	corpseradio = /obj/item/device/radio/headset/heads/hop
	corpseuniform = /obj/item/clothing/under/rank/centcom_officer
	corpsesuit = /obj/item/clothing/suit/armor/bulletproof
	corpseshoes = /obj/item/clothing/shoes/black
	corpseglasses = /obj/item/clothing/glasses/sunglasses
	corpseid = 1
	corpseidjob = "Bridge Officer"
	corpseidaccess = "Captain"

/obj/effect/landmark/corpse/commander
	name = "Commander"
	corpseuniform = /obj/item/clothing/under/rank/centcom_captain
	corpsesuit = /obj/item/clothing/suit/armor/bulletproof
	corpseradio = /obj/item/device/radio/headset/heads/captain
	corpseglasses = /obj/item/clothing/glasses/eyepatch
	corpsemask = /obj/item/clothing/mask/smokable/cigarette/cigar/cohiba
	corpsehelmet = /obj/item/clothing/head/centhat
	corpsegloves = /obj/item/clothing/gloves/swat
	corpseshoes = /obj/item/clothing/shoes/boots/swat
	corpsepocket1 = /obj/item/weapon/flame/lighter/zippo
	corpseid = 1
	corpseidjob = "Commander"
	corpseidaccess = "Captain"

/////////////////Lore Factions//////////////////////

/obj/effect/landmark/corpse/sifguard
	name = "Patrolman"
	corpseuniform = /obj/item/clothing/under/solgov/utility/sifguard
	corpsesuit = /obj/item/clothing/suit/storage/hooded/wintercoat/solgov
	corpsebelt = /obj/item/weapon/storage/belt/security/tactical
	corpseglasses = /obj/item/clothing/glasses/sunglasses/sechud
	corpsemask = /obj/item/clothing/mask/balaclava
	corpsehelmet = /obj/item/clothing/head/beret/solgov/sifguard
	corpsegloves = /obj/item/clothing/gloves/duty
	corpseshoes = /obj/item/clothing/shoes/boots/tactical
	corpsepocket1 = /obj/item/clothing/accessory/armor/tag/sifguard
	corpseid = 1
	corpseidjob = "Sif Defense Force Patrolman"

/obj/effect/landmark/corpse/hedberg
	name = "Hedberg-Hammarstrom Mercenary"
	corpseuniform = /obj/item/clothing/under/solgov/utility/sifguard
	corpsesuit = /obj/item/clothing/suit/storage/vest/solgov/hedberg
	corpsebelt = /obj/item/weapon/storage/belt/security
	corpseglasses = /obj/item/clothing/glasses/sunglasses/sechud
	corpsehelmet = /obj/item/clothing/head/beret/corp/hedberg
	corpseshoes = /obj/item/clothing/shoes/boots/jackboots
	corpseid = 1
	corpseidjob = "Hedberg-Hammarstrom Officer"

/obj/effect/landmark/corpse/hedberg/merc
	name = "Hedberg-Hammarstrom Mercenary"
	corpsebelt = /obj/item/weapon/storage/belt/security/tactical
	corpseglasses = /obj/item/clothing/glasses/sunglasses/sechud
	corpsehelmet = /obj/item/clothing/head/helmet/flexitac
	corpsegloves = /obj/item/clothing/gloves/combat
	corpseshoes = /obj/item/clothing/shoes/boots/tactical
	corpseid = 1
	corpseidjob = "Hedberg-Hammarstrom Enforcer"
