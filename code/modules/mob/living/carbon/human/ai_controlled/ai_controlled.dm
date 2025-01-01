/mob/living/carbon/human/ai_controlled
	name = "Nameless Joe"

	ai_holder_type = /datum/ai_holder/simple_mob/melee/evasive

	a_intent = I_HURT

	low_sorting_priority = TRUE

	var/generate_species = SPECIES_HUMAN
	var/generate_dead = FALSE

	var/generate_gender = FALSE
	var/generate_id_gender = FALSE

	var/to_wear_hair = "Bald"

	var/to_wear_helmet = /obj/item/clothing/head/welding
	var/to_wear_glasses = /obj/item/clothing/glasses/threedglasses
	var/to_wear_mask = /obj/item/clothing/mask/gas
	var/to_wear_l_radio = /obj/item/radio/headset
	var/to_wear_r_radio = null
	var/to_wear_uniform = /obj/item/clothing/under/color/grey
	var/to_wear_suit = /obj/item/clothing/suit/armor/material/makeshift/glass
	var/to_wear_gloves = /obj/item/clothing/accessory/ring/material/platinum
	var/to_wear_shoes = /obj/item/clothing/shoes/galoshes
	var/to_wear_belt = /obj/item/storage/belt/utility/full
	var/to_wear_l_pocket = /obj/item/soap
	var/to_wear_r_pocket = /obj/item/pda
	var/to_wear_back = /obj/item/storage/backpack
	var/to_wear_id_type = /obj/item/card/id
	var/to_wear_id_job = JOB_ALT_ASSISTANT

	var/to_wear_l_hand = null
	var/to_wear_r_hand = /obj/item/melee/baton

/mob/living/carbon/human/ai_controlled/Initialize()
	if(generate_gender)
		gender = pick(list(MALE, FEMALE, PLURAL, NEUTER))

	if(generate_id_gender)
		identifying_gender = pick(list(MALE, FEMALE, PLURAL, NEUTER))

	..(loc, generate_species)

	species.produceCopy(species.traits.Copy(),src,null,FALSE)

	h_style = to_wear_hair

	if(to_wear_uniform)
		equip_to_slot_or_del(new to_wear_uniform(src), slot_w_uniform)

	if(to_wear_suit)
		equip_to_slot_or_del(new to_wear_suit(src), slot_wear_suit)

	if(to_wear_shoes)
		equip_to_slot_or_del(new to_wear_shoes(src), slot_shoes)

	if(to_wear_gloves)
		equip_to_slot_or_del(new to_wear_gloves(src), slot_gloves)

	if(to_wear_l_radio)
		equip_to_slot_or_del(new to_wear_l_radio(src), slot_l_ear)

	if(to_wear_r_radio)
		equip_to_slot_or_del(new to_wear_r_radio(src), slot_r_ear)

	if(to_wear_glasses)
		equip_to_slot_or_del(new to_wear_glasses(src), slot_glasses)

	if(to_wear_mask)
		equip_to_slot_or_del(new to_wear_mask(src), slot_wear_mask)

	if(to_wear_helmet)
		equip_to_slot_or_del(new to_wear_helmet(src), slot_head)

	if(to_wear_belt)
		equip_to_slot_or_del(new to_wear_belt(src), slot_belt)

	if(to_wear_r_pocket)
		equip_to_slot_or_del(new to_wear_r_pocket(src), slot_r_store)

	if(to_wear_l_pocket)
		equip_to_slot_or_del(new to_wear_l_pocket(src), slot_l_store)

	if(to_wear_back)
		equip_to_slot_or_del(new to_wear_back(src), slot_back)

	if(to_wear_l_hand)
		equip_to_slot_or_del(new to_wear_l_hand(src), slot_l_hand)

	if(to_wear_r_hand)
		equip_to_slot_or_del(new to_wear_r_hand(src), slot_r_hand)

	if(to_wear_id_type)
		var/obj/item/card/id/W = new to_wear_id_type(src)
		W.name = "[real_name]'s ID Card"
		var/datum/job/jobdatum
		for(var/jobtype in typesof(/datum/job))
			var/datum/job/J = new jobtype
			if(J.title == to_wear_id_job)
				jobdatum = J
				break
		if(jobdatum)
			W.access = jobdatum.get_access()
		else
			W.access = list()
		if(to_wear_id_job)
			W.assignment = to_wear_id_job
		W.registered_name = real_name
		equip_to_slot_or_del(W, slot_wear_id)

	if(generate_dead)
		death()

/*
 * Subtypes.
 */

/mob/living/carbon/human/ai_controlled/replicant
	generate_species = SPECIES_REPLICANT_BETA

	generate_gender = TRUE
	identifying_gender = NEUTER

	faction = FACTION_XENO

	to_wear_helmet = /obj/item/clothing/head/helmet/dermal
	to_wear_glasses = /obj/item/clothing/glasses/goggles
	to_wear_mask = /obj/item/clothing/mask/gas/half
	to_wear_l_radio = /obj/item/radio/headset
	to_wear_r_radio = null
	to_wear_uniform = /obj/item/clothing/under/color/grey
	to_wear_suit = /obj/item/clothing/suit/armor/vest
	to_wear_gloves = null
	to_wear_shoes = /obj/item/clothing/shoes/boots/combat/changeling
	to_wear_belt = /obj/item/storage/belt/utility/full
	to_wear_l_pocket = /obj/item/grenade/explosive/mini
	to_wear_r_pocket = /obj/item/grenade/explosive/mini
	to_wear_back = /obj/item/radio/electropack
	to_wear_id_type = /obj/item/card/id
	to_wear_id_job = "Experiment"

	to_wear_r_hand = null

/mob/living/carbon/human/ai_controlled/replicant/Initialize()
	. = ..()
	name = species.get_random_name(gender)
	add_modifier(/datum/modifier/homeothermic, 0, null)
