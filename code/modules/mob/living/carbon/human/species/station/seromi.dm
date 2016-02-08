/datum/species/teshari
	name = "Teshari"
	name_plural = "Tesharii"
	blurb = "A race of feathered raptors who developed alongside the Skrell, inhabiting \
	the polar tundral regions outside of Skrell territory. Extremely fragile, they developed \
	hunting skills that emphasized taking out their prey without themselves getting hit. They \
	are only recently becoming known on human stations after reaching space with Skrell assistance."

	num_alternate_languages = 2
	secondary_langs = list("Schechi", "Skrellian")
	name_language = "Schechi"

	blood_color = "#D514F7"
	flesh_color = "#5F7BB0"
	base_color = "#001144"
	tail = "seromitail"
	tail_hair = "feathers"

	icobase = 'icons/mob/human_races/r_seromi.dmi'
	deform = 'icons/mob/human_races/r_seromi.dmi'
	damage_overlays = 'icons/mob/human_races/masks/dam_seromi.dmi'
	damage_mask = 'icons/mob/human_races/masks/dam_mask_seromi.dmi'
	blood_mask = 'icons/mob/human_races/masks/blood_seromi.dmi'

	slowdown = -2
	total_health = 50
	brute_mod = 1.35
	burn_mod =  1.35
	mob_size = MOB_SMALL
	holder_type = /obj/item/weapon/holder/human
	short_sighted = 1
	gluttonous = 1
	blood_volume = 400
	hunger_factor = 1.2

	spawn_flags = CAN_JOIN | IS_WHITELISTED
	appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_COLOR | HAS_EYE_COLOR
	bump_flag = MONKEY
	swap_flags = MONKEY|SLIME|SIMPLE_ANIMAL
	push_flags = MONKEY|SLIME|SIMPLE_ANIMAL|ALIEN

	cold_level_1 = 180
	cold_level_2 = 130
	cold_level_3 = 70
	heat_level_1 = 320
	heat_level_2 = 370
	heat_level_3 = 600
	heat_discomfort_level = 292
	heat_discomfort_strings = list(
		"Your feathers prickle in the heat.",
		"You feel uncomfortably warm.",
		)
	cold_discomfort_level = 180

	has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/seromi),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/seromi),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/seromi),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/seromi),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/seromi)
		)

	has_organ = list(
		O_HEART =    /obj/item/organ/internal/heart,
		O_LUNGS =    /obj/item/organ/internal/lungs,
		O_LIVER =    /obj/item/organ/internal/liver,
		O_KIDNEYS =  /obj/item/organ/internal/kidneys,
		O_BRAIN =    /obj/item/organ/internal/brain,
		O_EYES =     /obj/item/organ/internal/eyes
		)

	unarmed_types = list(
		/datum/unarmed_attack/bite/sharp,
		/datum/unarmed_attack/claws,
		/datum/unarmed_attack/stomp/weak
		)

	var/shock_cap = 30
	var/hallucination_cap = 25

// I'm... so... ronrery, so ronery...
/datum/species/teshari/handle_environment_special(var/mob/living/carbon/human/H)

	// If they're dead or unconcious they're a bit beyond this kind of thing.
	if(H.stat)
		return

	// No point processing if we're already stressing the hell out.
	if(H.hallucination >= hallucination_cap && H.shock_stage >= shock_cap)
		return

	// Check for company.
	for(var/mob/living/M in viewers(H))
		if(M == H || M.stat == DEAD || M.invisibility > H.see_invisible)
			continue
		if(M.faction == "neutral" || M.faction == H.faction)
			return

	// No company? Suffer :(
	if(H.shock_stage < shock_cap)
		H.shock_stage += 1
	if(H.shock_stage >= shock_cap && H.hallucination < hallucination_cap)
		H.hallucination += 2.5

/datum/species/teshari/get_vision_flags(var/mob/living/carbon/human/H)
	if(!(H.sdisabilities & DEAF) && !H.ear_deaf)
		return SEE_SELF|SEE_MOBS
	else
		return SEE_SELF

/datum/species/teshari/equip_survival_gear(var/mob/living/carbon/human/H)
	..()
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal(H),slot_shoes)