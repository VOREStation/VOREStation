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
	var/species = SPECIES_HUMAN	//defaults to generic-ass humans
	var/random_species = FALSE	//flip to TRUE to randomize species from the list below
	var/list/random_species_list = list(SPECIES_HUMAN,SPECIES_TAJARAN,SPECIES_UNATHI,SPECIES_SKRELL)
	var/list/tail_type = null
	var/list/ear_type = null
	/// list(name of ear, color of ear, color of ear, ...).
	/// Color is optional, each position after the name is a color channel from 1 to n.
	var/list/ear_secondary_type
	var/list/wing_type = null
	var/corpsesynthtype = 0			// 0 for organic, 1 for drone, 2 for posibrain
	var/corpsesynthbrand = "Unbranded"
	delete_me = TRUE

/obj/effect/landmark/mobcorpse/Initialize(mapload)
	. = ..()
	createCorpse()

/obj/effect/landmark/mobcorpse/proc/createCorpse() //Creates a mob and checks for gear in each slot before attempting to equip it.
	var/mob/living/carbon/human/M = new /mob/living/carbon/human (src.loc)
	M.low_sorting_priority = TRUE
	if(random_species)
		var/random_pick = pick(random_species_list)
		M.set_species(random_pick)
		src.species = random_pick
	else
		M.set_species(species)
	if(tail_type && tail_type.len)
		if(tail_type[1] in GLOB.tail_styles_list)
			M.tail_style = GLOB.tail_styles_list[tail_type[1]]
			if(tail_type.len > 1)
				var/list/color_rgb_list = hex2rgb(tail_type[2])
				M.r_tail = color_rgb_list[1]
				M.g_tail = color_rgb_list[2]
				M.b_tail = color_rgb_list[3]
				if(tail_type.len > 2)
					color_rgb_list = hex2rgb(tail_type[3])
					M.r_tail2 = color_rgb_list[1]
					M.g_tail2 = color_rgb_list[2]
					M.b_tail2 = color_rgb_list[3]
					if(tail_type.len > 3)
						color_rgb_list = hex2rgb(tail_type[4])
						M.r_tail3 = color_rgb_list[1]
						M.g_tail3 = color_rgb_list[2]
						M.b_tail3 = color_rgb_list[3]
			M.update_tail_showing()
	if(ear_type && ear_type.len)
		if(ear_type[1] in GLOB.ear_styles_list)
			M.ear_style = GLOB.ear_styles_list[ear_type[1]]
			if(ear_type.len > 1)
				var/list/color_rgb_list = hex2rgb(ear_type[2])
				M.r_ears = color_rgb_list[1]
				M.g_ears = color_rgb_list[2]
				M.b_ears = color_rgb_list[3]
				if(ear_type.len > 2)
					color_rgb_list = hex2rgb(ear_type[3])
					M.r_ears2 = color_rgb_list[1]
					M.g_ears2 = color_rgb_list[2]
					M.b_ears2 = color_rgb_list[3]
					if(ear_type.len > 3)
						color_rgb_list = hex2rgb(ear_type[4])
						M.r_ears3 = color_rgb_list[1]
						M.g_ears3 = color_rgb_list[2]
						M.b_ears3 = color_rgb_list[3]
			M.update_hair()
	// handle secondary ears
	if(length(ear_secondary_type) && (ear_secondary_type[1] in GLOB.ear_styles_list))
		M.ear_secondary_style = GLOB.ear_styles_list[ear_secondary_type[1]]
		if(length(ear_secondary_type) > 1)
			M.ear_secondary_colors = ear_secondary_type.Copy(2, min(length(GLOB.fancy_sprite_accessory_color_channel_names), length(ear_secondary_type)) + 1)

	if(wing_type && wing_type.len)
		if(wing_type[1] in GLOB.wing_styles_list)
			M.wing_style = GLOB.wing_styles_list[wing_type[1]]
			if(wing_type.len > 1)
				var/list/color_rgb_list = hex2rgb(wing_type[2])
				M.r_wing = color_rgb_list[1]
				M.g_wing = color_rgb_list[2]
				M.b_wing = color_rgb_list[3]
				if(wing_type.len > 2)
					color_rgb_list = hex2rgb(wing_type[3])
					M.r_wing2 = color_rgb_list[1]
					M.g_wing2 = color_rgb_list[2]
					M.b_wing2 = color_rgb_list[3]
					if(wing_type.len > 3)
						color_rgb_list = hex2rgb(wing_type[4])
						M.r_wing3 = color_rgb_list[1]
						M.g_wing3 = color_rgb_list[2]
						M.b_wing3 = color_rgb_list[3]
			M.update_wing_showing()
	M.real_name = generateCorpseName()
	M.set_stat(DEAD) //Kills the new mob
	if(corpsesynthtype > 0)
		if(!corpsesynthbrand)
			corpsesynthbrand = "Unbranded"
		for(var/obj/item/organ/external/O in M.organs)
			switch(corpsesynthtype)
				if(1)
					O.digitize(corpsesynthbrand)
				if(2)
					O.robotize(corpsesynthbrand)
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
	if(src.corpsehelmet)
		M.equip_voidhelm_to_slot_or_del_with_refit(new src.corpsehelmet(M), slot_head, src.species)
	if(src.corpsesuit)
		M.equip_voidsuit_to_slot_or_del_with_refit(new src.corpsesuit(M), slot_wear_suit, src.species)

/obj/effect/landmark/mobcorpse/proc/generateCorpseName()
	return name

//List of different corpse types

/obj/effect/landmark/mobcorpse/syndicatesoldier
	name = "Mercenary"
	corpseuniform = /obj/item/clothing/under/syndicate
	corpsesuit = /obj/item/clothing/suit/armor/vest
	corpseshoes = /obj/item/clothing/shoes/boots/swat
	corpsegloves = /obj/item/clothing/gloves/swat
	corpseradio = /obj/item/radio/headset
	corpsemask = /obj/item/clothing/mask/gas
	corpsehelmet = /obj/item/clothing/head/helmet/swat
	corpseback = /obj/item/storage/backpack
	corpseid = 1
	corpseidjob = "Operative"
	corpseidaccess = JOB_SYNDICATE

/obj/effect/landmark/mobcorpse/solarpeacekeeper
	name = "Mercenary"
	corpseuniform = /obj/item/clothing/under/syndicate
	corpsesuit = /obj/item/clothing/suit/armor/pcarrier/blue/sol
	corpseshoes = /obj/item/clothing/shoes/boots/swat
	corpsegloves = /obj/item/clothing/gloves/swat
	corpseradio = /obj/item/radio/headset
	corpsemask = /obj/item/clothing/mask/gas
	corpsehelmet = /obj/item/clothing/head/helmet/swat
	corpseback = /obj/item/storage/backpack
	corpseid = 1
	corpseidjob = "Peacekeeper"
	corpseidaccess = JOB_SYNDICATE

/obj/effect/landmark/mobcorpse/syndicatecommando
	name = "Mercenary Commando"
	corpseuniform = /obj/item/clothing/under/syndicate
	corpsesuit = /obj/item/clothing/suit/space/void/merc
	corpseshoes = /obj/item/clothing/shoes/boots/swat
	corpsegloves = /obj/item/clothing/gloves/swat
	corpseradio = /obj/item/radio/headset
	corpsemask = /obj/item/clothing/mask/gas/syndicate
	corpsehelmet = /obj/item/clothing/head/helmet/space/void/merc
	corpseback = /obj/item/tank/jetpack/oxygen
	corpsepocket1 = /obj/item/tank/emergency/oxygen
	corpseid = 1
	corpseidjob = "Operative"
	corpseidaccess = JOB_SYNDICATE



/obj/effect/landmark/mobcorpse/clown
	name = JOB_CLOWN
	corpseuniform = /obj/item/clothing/under/rank/clown
	corpseshoes = /obj/item/clothing/shoes/clown_shoes
	corpseradio = /obj/item/radio/headset
	corpsemask = /obj/item/clothing/mask/gas/clown_hat
	corpsepocket1 = /obj/item/bikehorn
	corpseback = /obj/item/storage/backpack/clown
	corpseid = 1
	corpseidjob = JOB_CLOWN
	corpseidaccess = JOB_CLOWN



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
