/datum/species/lleill

	name = SPECIES_LLEILL
	name_plural = "Lleill"
	icobase = 'icons/mob/human_races/r_lleill.dmi'
	deform = 'icons/mob/human_races/r_lleill.dmi'
	color_mult = 1
	tail = "tail"
	icobase_tail = 1
	blurb = "A species that appears to originate somewhere in redspace. Their forms are not consistent, \
	they do not care for consistency, and are working under a constant never-ending drive to improve themselves \
	and the world around them. With little care for whether the world itself wants to change." //PLACEHOLDER

	blood_color = "#FFFFFF"
	blood_name = "glamour"
	flesh_color = "#FFFFFF"
	reagent_tag = IS_LLEILL

	num_alternate_languages = 3
	species_language = LANGUAGE_LLEILL
	language = LANGUAGE_LLEILL
	name_language = LANGUAGE_LLEILL

	flags =  NO_SCAN | NO_MINOR_CUT | NO_INFECT |  NO_HALLUCINATION
	spawn_flags = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED | SPECIES_WHITELIST_SELECTABLE
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_SKIN_COLOR | HAS_EYE_COLOR | HAS_UNDERWEAR

	max_age = 200

	economic_modifier = 15

	digi_allowed = TRUE

	//Specific abilities

	var/ring_cooldown = 0

	darksight = 10 //Can see in dark

	burn_mod = 0.25 //Very resistant to fire
	pain_mod = 0.25 //Whilst not resistant to brute or stunning, they are quite resistant to pain, making them tanky in their own way.

	warning_low_pressure = 50
	hazard_low_pressure = -1
	warning_high_pressure = 300
	hazard_high_pressure = 10000 //Can be killed by pressure but you're going to need a hell of a lot

	minimum_breath_pressure = 0 //Doesn't gasp and lungs shouldn't pop

	cold_level_1 = -1	//Safe in space
	cold_level_2 = -1
	cold_level_3 = -1

	heat_level_1 = 1500	//Very resiliant to heat
	heat_level_2 = 2500
	heat_level_3 = 5000

	can_space_freemove = TRUE //Have no issue moving through space.
	can_zero_g_move	= TRUE

	chem_strength_alcohol = 0 //Can't get drunk

	oxy_mod = 0.25 //Suffocates very slowly, but does ultimately need to breathe, will outpace heal most oxygen damage.
	poison_type = null //Not harmed by phoron.
	water_breather = TRUE

	var/list/valid_transform_species = list(
		"Human", "Unathi", "Tajara", "Skrell",
		"Diona", "Teshari", "Monkey","Sergal",
		"Akula","Nevrean","Zorren",
		"Fennec", "Vulpkanin", "Vasilissan",
		"Rapala", "Neaera", "Stok", "Farwa", "Sobaka",
		"Wolpin", "Saru", "Sparra", "Lleill")

	// Looks like a lot but the majority of these are just to change their appearance.
	inherent_verbs = list(
		/mob/living/carbon/human/proc/lleill_select_colour,
		/mob/living/carbon/human/proc/lleill_select_shape,
		/mob/living/carbon/human/proc/shapeshifter_select_hair,
		/mob/living/carbon/human/proc/shapeshifter_select_hair_colors,
		/mob/living/carbon/human/proc/shapeshifter_select_gender,
		/mob/living/carbon/human/proc/shapeshifter_select_wings,
		/mob/living/carbon/human/proc/shapeshifter_select_tail,
		/mob/living/carbon/human/proc/shapeshifter_select_ears,
		/mob/living/proc/set_size,
//		/mob/living/carbon/human/proc/lleill_invisibility,
//		/mob/living/carbon/human/proc/lleill_transmute,
//		/mob/living/carbon/human/proc/lleill_rings,
//		/mob/living/carbon/human/proc/lleill_contact,
//		/mob/living/carbon/human/proc/lleill_alchemy,
//		/mob/living/carbon/human/proc/lleill_beast_form
		)

	//organs, going with just the basics for now

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
		BP_HEAD =   list("path" = /obj/item/organ/external/head/lleill),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right)
		)

	base_species = SPECIES_LLEILL

	var/list/lleill_abilities = list(/datum/power/lleill/invisibility,
									   /datum/power/lleill/transmute,
									   /datum/power/lleill/rings,
									   /datum/power/lleill/contact,
									   /datum/power/lleill/alchemy,
									   /datum/power/lleill/beastform)

	var/list/lleill_ability_datums = list()

// Shapeshifters have some behaviour that doesn't play well with this species so I have taken the main parts needed for here.

/datum/species/lleill/get_valid_shapeshifter_forms(var/mob/living/carbon/human/H)
	return valid_transform_species

/datum/species/lleill/get_icobase(var/mob/living/carbon/human/H, var/get_deform)
	if(!H) return ..(null, get_deform)
	var/datum/species/S = GLOB.all_species[wrapped_species_by_ref["\ref[H]"]]
	if(!S || S.type == src.type) return ..(H, get_deform)
	return S.get_icobase(H,get_deform)

/datum/species/lleill/get_race_key(var/mob/living/carbon/human/H)
	return "[..()]-[wrapped_species_by_ref["\ref[H]"]]"

/datum/species/lleill/get_bodytype(var/mob/living/carbon/human/H)
	var/datum/species/S = GLOB.all_species[wrapped_species_by_ref["\ref[H]"]]
	if(!H || !S) return ..()
	if(S.type == src.type) return ..(H)
	return S.get_bodytype(H)

/datum/species/lleill/get_blood_mask(var/mob/living/carbon/human/H)
	if(!H) return ..()
	var/datum/species/S = GLOB.all_species[wrapped_species_by_ref["\ref[H]"]]
	if(!S || S.name == src.name)
		return ..()
	return S?.get_blood_mask(H)

/datum/species/lleill/get_damage_mask(var/mob/living/carbon/human/H)
	if(!H) return ..()
	var/datum/species/S = GLOB.all_species[wrapped_species_by_ref["\ref[H]"]]
	if(!S || S.name == src.name)
		return ..()
	return S?.get_damage_mask(H)

/datum/species/lleill/get_damage_overlays(var/mob/living/carbon/human/H)
	if(!H) return ..()
	var/datum/species/S = GLOB.all_species[wrapped_species_by_ref["\ref[H]"]]
	if(!S || S.name == src.name)
		return ..()
	return S?.get_damage_overlays(H)

/datum/species/lleill/get_tail(var/mob/living/carbon/human/H)
	if(!H) return ..()
	var/datum/species/S = GLOB.all_species[wrapped_species_by_ref["\ref[H]"]]
	if(!S || S.name == src.name)
		return ..()
	return S?.get_tail(H)

/datum/species/lleill/get_tail_animation(var/mob/living/carbon/human/H)
	if(!H) return ..()
	var/datum/species/S = GLOB.all_species[wrapped_species_by_ref["\ref[H]"]]
	if(!S || S.name == src.name)
		return ..()
	return S?.get_tail_animation(H)

/datum/species/lleill/get_tail_hair(var/mob/living/carbon/human/H)
	if(!H) return ..()
	var/datum/species/S = GLOB.all_species[wrapped_species_by_ref["\ref[H]"]]
	if(!S || S.name == src.name)
		return ..()
	return S?.get_tail_hair(H)

/datum/species/lleill/New()
	..()
	for(var/power in lleill_abilities)
		var/datum/power/lleill/LP = new power(src)
		lleill_ability_datums.Add(LP)

/datum/species/lleill/proc/add_lleill_abilities(var/mob/living/carbon/human/H)
	if(!H.ability_master || !istype(H.ability_master, /obj/screen/movable/ability_master/lleill))
		H.ability_master = null
		H.ability_master = new /obj/screen/movable/ability_master/lleill(H)
	for(var/datum/power/lleill/P in lleill_ability_datums)
		if(!(P.verbpath in H.verbs))
			add_verb(H, P.verbpath)
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

/datum/species/proc/update_lleill_hud(var/mob/living/carbon/human/H)
	var/relative_energy = ((lleill_energy/lleill_energy_max)*100)
	if(H.lleill_display)
		H.lleill_display.invisibility = 0
		switch(relative_energy)
			if(0 to 24)
				H.lleill_display.icon_state = "lleill-0"
			if(25 to 49)
				H.lleill_display.icon_state = "lleill-1"
			if(50 to 74)
				H.lleill_display.icon_state = "lleill-2"
			if(75 to 99)
				H.lleill_display.icon_state = "lleill-3"
			if(100 to INFINITY)
				H.lleill_display.icon_state = "lleill-4"
	return

/datum/species/lleill/add_inherent_verbs(var/mob/living/carbon/human/H)
	..()
	add_lleill_abilities(H)
