//Meant for simple animals to drop lootable human bodies.

//If someone can do this in a neater way, be my guest-Kor

//This has to be seperate from the Away Mission corpses, because New() doesn't work for those, and initialize() doesn't work for these.

//To do: Allow corpses to appear mangled, bloody, etc. Allow customizing the bodies appearance (they're all bald and white right now).


/obj/effect/landmark/mobcorpse
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

/obj/effect/landmark/mobcorpse/New()
	createCorpse()

/obj/effect/landmark/mobcorpse/proc/createCorpse() //Creates a mob and checks for gear in each slot before attempting to equip it.
	var/mob/living/carbon/human/M = new /mob/living/carbon/human (src.loc)
	M.real_name = src.name
	M.set_stat(DEAD) //Kills the new mob
	if(src.corpseuniform)
		M.equip_to_slot_or_del(new src.corpseuniform(M), slot_w_uniform)
	if(src.corpsesuit)
		M.equip_to_slot_or_del(new src.corpsesuit(M), slot_wear_suit)
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
	if(src.corpsehelmet)
		M.equip_to_slot_or_del(new src.corpsehelmet(M), slot_head)
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
		W.name = "[M.real_name]'s ID Card"
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
		W.registered_name = M.real_name
		M.equip_to_slot_or_del(W, slot_wear_id)
	delete_me = 1
	qdel(src)



//List of different corpse types

/obj/effect/landmark/mobcorpse/syndicatesoldier
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

/obj/effect/landmark/mobcorpse/solarpeacekeeper
	name = "Mercenary"
	corpseuniform = /obj/item/clothing/under/syndicate
	corpsesuit = /obj/item/clothing/suit/armor/pcarrier/blue/sol
	corpseshoes = /obj/item/clothing/shoes/boots/swat
	corpsegloves = /obj/item/clothing/gloves/swat
	corpseradio = /obj/item/device/radio/headset
	corpsemask = /obj/item/clothing/mask/gas
	corpsehelmet = /obj/item/clothing/head/helmet/swat
	corpseback = /obj/item/weapon/storage/backpack
	corpseid = 1
	corpseidjob = "Peacekeeper"
	corpseidaccess = "Syndicate"

/obj/effect/landmark/mobcorpse/syndicatecommando
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

/obj/effect/landmark/mobcorpse/android
	name = "Android Drone"

	var/list/brandList = list(
		BP_L_HAND = "Unbranded",
		BP_R_HAND  = "Unbranded",
		BP_L_FOOT = "Unbranded",
		BP_R_FOOT = "Unbranded",
		BP_L_ARM = "Unbranded",
		BP_R_ARM = "Unbranded",
		BP_L_LEG = "Unbranded",
		BP_R_LEG = "Unbranded",
		BP_HEAD = "Unbranded",
		BP_TORSO = "Unbranded",
		BP_GROIN = "Unbranded"
		)


	corpseid = 0

/obj/effect/landmark/mobcorpse/android/createCorpse()
	var/mob/living/carbon/human/M = new /mob/living/carbon/human (src.loc)
	M.real_name = src.name
	for(var/injuries in 1 to rand(3,5))
		var/deal_brute = rand(round(M.species.total_health * 0.10), round(M.species.total_health * 0.30))
		M.take_overall_damage(deal_brute, "Death Trauma")
	M.set_stat(DEAD) //Kills the new mob

	var/obj/item/organ/internal/brain = M.internal_organs_by_name[O_BRAIN] //specific special cases
	brain.digitize()
	var/obj/item/organ/internal/eyes = M.internal_organs_by_name[O_EYES]
	eyes.robotize()

	for (var/limb in brandList)
		var/obj/item/organ/external/E = M.get_organ(limb)
		if(E)
			E.robotize(brandList[limb])

	if(src.corpseuniform)
		M.equip_to_slot_or_del(new src.corpseuniform(M), slot_w_uniform)
	if(src.corpsesuit)
		M.equip_to_slot_or_del(new src.corpsesuit(M), slot_wear_suit)
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
	if(src.corpsehelmet)
		M.equip_to_slot_or_del(new src.corpsehelmet(M), slot_head)
	if(src.corpsebelt)
		M.equip_to_slot_or_del(new src.corpsebelt(M), slot_belt)
	if(src.corpsepocket1)
		M.equip_to_slot_or_del(new src.corpsepocket1(M), slot_r_store)
	if(src.corpsepocket2)
		M.equip_to_slot_or_del(new src.corpsepocket2(M), slot_l_store)
	if(src.corpseback)
		M.equip_to_slot_or_del(new src.corpseback(M), slot_back)
	if(src.corpseid == 1)
		var/obj/item/card/id/W = new(M)
		W.name = "[M.real_name]'s ID Card"
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
		W.registered_name = M.real_name
		M.equip_to_slot_or_del(W, slot_wear_id)
	delete_me = 1

/obj/effect/landmark/mobcorpse/android/scientist
	name = "Scientific Drone"
	corpseuniform = /obj/item/clothing/under/lawyer/bluesuit
	corpsesuit = /obj/item/clothing/suit/storage/toggle/labcoat
	corpseshoes = /obj/item/clothing/shoes/boots/duty

	brandList = list(
		BP_L_HAND =  "Cyber Solutions - Wight",
		BP_R_HAND = "Cyber Solutions - Wight",
		BP_L_FOOT =  "Cyber Solutions - Wight",
		BP_R_FOOT =  "Cyber Solutions - Wight",
		BP_L_ARM = "Cyber Solutions - Wight",
		BP_R_ARM =  "Cyber Solutions - Wight",
		BP_L_LEG =  "Cyber Solutions - Wight",
		BP_R_LEG =  "Cyber Solutions - Wight",
		BP_HEAD = "Grayson",
		BP_TORSO =  "Cyber Solutions - Wight",
		BP_GROIN =  "Cyber Solutions - Wight"
		)

/obj/effect/landmark/mobcorpse/android/combat
	name = "Combat Drone"
	corpseuniform = /obj/item/clothing/under/color/white
	corpsesuit = /obj/item/clothing/suit/armor/vest/alt
	corpseshoes = /obj/item/clothing/shoes/boots/duty
	corpsegloves = /obj/item/clothing/gloves/swat
	brandList = list(
		BP_L_HAND =  "Unbranded - Mantis Prosis",
		BP_R_HAND = "Unbranded - Mantis Prosis",
		BP_L_FOOT =  "Unbranded - Mantis Prosis",
		BP_R_FOOT =  "Unbranded - Mantis Prosis",
		BP_L_ARM = "Unbranded - Mantis Prosis",
		BP_R_ARM =  "Unbranded - Mantis Prosis",
		BP_L_LEG =  "Unbranded - Mantis Prosis",
		BP_R_LEG =  "Unbranded - Mantis Prosis",
		BP_HEAD = "Hephaestus - Athena",
		BP_TORSO =  "Hephaestus - Athena",
		BP_GROIN =  "Hephaestus - Athena"
		)



/obj/effect/landmark/mobcorpse/clown
	name = "Clown"
	corpseuniform = /obj/item/clothing/under/rank/clown
	corpseshoes = /obj/item/clothing/shoes/clown_shoes
	corpseradio = /obj/item/device/radio/headset
	corpsemask = /obj/item/clothing/mask/gas/clown_hat
	corpsepocket1 = /obj/item/weapon/bikehorn
	corpseback = /obj/item/weapon/storage/backpack/clown
	corpseid = 1
	corpseidjob = "Clown"
	corpseidaccess = "Clown"



/obj/effect/landmark/mobcorpse/pirate
	name = "Pirate"
	corpseuniform = /obj/item/clothing/under/pirate
	corpseshoes = /obj/item/clothing/shoes/boots/jackboots
	corpseglasses = /obj/item/clothing/glasses/eyepatch
	corpsehelmet = /obj/item/clothing/head/bandana



/obj/effect/landmark/mobcorpse/pirate/ranged
	name = "Pirate Gunner"
	corpsesuit = /obj/item/clothing/suit/pirate
	corpsehelmet = /obj/item/clothing/head/pirate



/obj/effect/landmark/mobcorpse/russian
	name = "Russian"
	corpseuniform = /obj/item/clothing/under/soviet
	corpseshoes = /obj/item/clothing/shoes/boots/jackboots
	corpsehelmet = /obj/item/clothing/head/bearpelt

/obj/effect/landmark/mobcorpse/russian/ranged
	corpsehelmet = /obj/item/clothing/head/ushanka