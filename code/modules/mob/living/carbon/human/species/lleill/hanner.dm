/datum/species/shapeshifter/hanner

	name =             SPECIES_HANNER
	name_plural =      "Hanner"
	blurb =            "Hanner are a sub-species of almost any other sapient species, \
	they are the offspring of one Lleill and any other non-lleill species. They are natural born fleshy \
	shapeshifters, able to take the appearance of almost any humanoid form. Hanner also have some limited \
	transmutation and energy sharing abilities not unlike they lleill, but considerably more limited. Unlike \
	other shapeshifter species, such as proteans or prometheans, Hanner have a typical humanoid set of organs and can not regenerate."

	color_mult = 1
	appearance_flags = HAS_SKIN_COLOR | HAS_EYE_COLOR | HAS_HAIR_COLOR | HAS_UNDERWEAR | HAS_LIPS
	spawn_flags		 = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED | SPECIES_WHITELIST_SELECTABLE
	health_hud_intensity = 2
	num_alternate_languages = 3
	language = LANGUAGE_LLEILL
	species_language = LANGUAGE_LLEILL
	secondary_langs = list(LANGUAGE_LLEILL, LANGUAGE_SOL_COMMON)	// For some reason, having this as their species language does not allow it to be chosen.

	min_age = 18
	max_age = 200

	//Specific abilities

	burn_mod = 0.8 //Slightly resistant to fire
	pain_mod = 0.8 //Whilst not resistant to brute or stunning, they are slightly resistant to pain.

	hazard_high_pressure = HAZARD_HIGH_PRESSURE + 700  // Dangerously high pressure.
	warning_high_pressure = WARNING_HIGH_PRESSURE + 700 // High pressure warning.
	warning_low_pressure = 100   // Low pressure warning.
	hazard_low_pressure = 50     // Dangerously low pressure.

	minimum_breath_pressure = 0 //Doesn't gasp and lungs shouldn't pop

	cold_level_1 = 150	//Adapt well to temperature changes
	cold_level_2 = 100
	cold_level_3 = 50

	heat_level_1 = 500	//quite resiliant to heat
	heat_level_2 = 600
	heat_level_3 = 700

	chem_strength_alcohol = 0.8 //Handle alcohol slightly better

	metabolic_rate = 0.4 //Major downside of the Hanner, they metabolise drugs much slower, meaning that they are difficult to treat with medicine alone.
	bloodloss_rate = 1.2 //They bleed out faster too

	lleill_energy = 100
	lleill_energy_max = 100

	genders = list(MALE, FEMALE, NEUTER, PLURAL)

	has_organ = list(
		O_HEART =		/obj/item/organ/internal/heart,
		O_LUNGS =		/obj/item/organ/internal/lungs,
		O_VOICE = 		/obj/item/organ/internal/voicebox,
		O_LIVER =		/obj/item/organ/internal/liver,
		O_KIDNEYS =		/obj/item/organ/internal/kidneys,
		O_BRAIN =		/obj/item/organ/internal/brain,
		O_APPENDIX = 	/obj/item/organ/internal/appendix,
		O_SPLEEN = 		/obj/item/organ/internal/spleen,
		O_EYES =		/obj/item/organ/internal/eyes,
		O_STOMACH =		/obj/item/organ/internal/stomach,
		O_INTESTINE =	/obj/item/organ/internal/intestine
		)

	has_limbs = list(
		BP_TORSO =  list("path" = /obj/item/organ/external/chest),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin),
		BP_HEAD =   list("path" = /obj/item/organ/external/head),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right)
		)

	inherent_verbs = list(
		/mob/living/carbon/human/proc/shapeshifter_select_shape,
		/mob/living/carbon/human/proc/shapeshifter_select_colour,
		/mob/living/carbon/human/proc/shapeshifter_select_hair,
		/mob/living/carbon/human/proc/shapeshifter_select_hair_colors,
		/mob/living/carbon/human/proc/shapeshifter_select_gender,
		/mob/living/carbon/human/proc/shapeshifter_select_wings,
		/mob/living/carbon/human/proc/shapeshifter_select_tail,
		/mob/living/carbon/human/proc/shapeshifter_select_ears,
		/mob/living/proc/set_size,
//		/mob/living/carbon/human/proc/lleill_contact,
//		/mob/living/carbon/human/proc/lleill_alchemy,
//		/mob/living/carbon/human/proc/hanner_beast_form
		)

	valid_transform_species = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_UNATHI, SPECIES_TAJ, SPECIES_SKRELL, SPECIES_ALTEVIAN, SPECIES_TESHARI, SPECIES_MONKEY, SPECIES_LLEILL, SPECIES_VULPKANIN, SPECIES_ZORREN_HIGH, SPECIES_RAPALA, SPECIES_NEVREAN, SPECIES_VASILISSAN, SPECIES_AKULA)

	var/list/lleill_abilities = list(/datum/power/lleill/contact,
									   /datum/power/lleill/alchemy,
									   /datum/power/lleill/beastform_hanner)

	var/list/lleill_ability_datums = list()

/datum/species/shapeshifter/hanner/New()
	..()
	for(var/power in lleill_abilities)
		var/datum/power/lleill/LP = new power(src)
		lleill_ability_datums.Add(LP)

/datum/species/shapeshifter/hanner/proc/add_lleill_abilities(var/mob/living/carbon/human/H)
	if(!H.ability_master || !istype(H.ability_master, /obj/screen/movable/ability_master/lleill))
		H.ability_master = null
		H.ability_master = new /obj/screen/movable/ability_master/lleill(H)
	for(var/datum/power/lleill/P in lleill_ability_datums)
		if(!(P.verbpath in H.verbs))
			H.verbs += P.verbpath
			H.ability_master.add_lleill_ability(
					object_given = H,
					verb_given = P.verbpath,
					name_given = P.name,
					ability_icon_given = P.ability_icon_state,
					arguments = list()
					)
	spawn (50)
		if(H.lleill_display)
			H.lleill_display.invisibility = 0
			H.lleill_display.icon_state = "lleill-4"

/datum/species/shapeshifter/hanner/add_inherent_verbs(var/mob/living/carbon/human/H)
	..()
	add_lleill_abilities(H)
