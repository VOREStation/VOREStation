/datum/species/shadekin
	name = SPECIES_SHADEKIN
	name_plural = "Shadekin"
	icobase = 'icons/mob/human_races/r_shadekin_vr.dmi'
	deform = 'icons/mob/human_races/r_shadekin_vr.dmi'
	tail = "tail"
	icobase_tail = 1
	blurb = "Very little is known about these creatures. They appear to be largely mammalian in appearance. \
	Seemingly very rare to encounter, there have been widespread myths of these creatures the galaxy over, \
	but next to no verifiable evidence to their existence. However, they have recently been more verifiably \
	documented in the Virgo system, following a mining bombardment of Virgo 3. The crew of NSB Adephagia have \
	taken to calling these creatures 'Shadekin', and the name has generally stuck and spread. "		//TODO: Something that's not wiki copypaste
	wikilink = "https://wiki.vore-station.net/Shadekin"
	catalogue_data = list(/datum/category_item/catalogue/fauna/shadekin)

	language = LANGUAGE_SHADEKIN
	name_language = LANGUAGE_SHADEKIN
	species_language = LANGUAGE_SHADEKIN
	secondary_langs = list(LANGUAGE_SHADEKIN)
	num_alternate_languages = 3
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws/shadekin, /datum/unarmed_attack/bite/sharp/shadekin)
	rarity_value = 15	//INTERDIMENSIONAL FLUFFERS

	inherent_verbs = list(/mob/proc/adjust_hive_range)

	siemens_coefficient = 1
	darksight = 10

	slowdown = -0.5
	item_slowdown_mod = 0.5

	brute_mod = 0.7	// Naturally sturdy.
	burn_mod = 1.2	// Furry

	warning_low_pressure = 50
	hazard_low_pressure = -1

	warning_high_pressure = 300
	hazard_high_pressure = INFINITY

	cold_level_1 = -1	//Immune to cold
	cold_level_2 = -1
	cold_level_3 = -1

	heat_level_1 = 850	//Resistant to heat
	heat_level_2 = 1000
	heat_level_3 = 1150

	flags =  NO_DNA | NO_SLEEVE | NO_MINOR_CUT | NO_INFECT
	spawn_flags = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED | SPECIES_WHITELIST_SELECTABLE

	reagent_tag = IS_SHADEKIN		// for shadekin-unqiue chem interactions

	flesh_color = "#FFC896"
	blood_color = "#A10808"
	base_color = "#f0f0f0"
	color_mult = 1

	// has_glowing_eyes = TRUE			//Applicable through neutral taits.

	death_message = "phases to somewhere far away!"
	speech_bubble_appearance = "ghost"

	genders = list(MALE, FEMALE, PLURAL, NEUTER)

	virus_immune = 1

	breath_type = null
	poison_type = null
	water_breather = TRUE	//They don't quite breathe

	vision_flags = SEE_SELF|SEE_MOBS
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_SKIN_COLOR | HAS_EYE_COLOR | HAS_UNDERWEAR

	move_trail = /obj/effect/decal/cleanable/blood/tracks/paw

	has_organ = list(
		O_HEART =		/obj/item/organ/internal/heart,
		O_VOICE = 		/obj/item/organ/internal/voicebox,
		O_LIVER =		/obj/item/organ/internal/liver,
		O_KIDNEYS =		/obj/item/organ/internal/kidneys,
		O_SPLEEN =		/obj/item/organ/internal/spleen,
		O_BRAIN =		/obj/item/organ/internal/brain/shadekin,
		O_EYES =		/obj/item/organ/internal/eyes,
		O_STOMACH =		/obj/item/organ/internal/stomach,
		O_INTESTINE =	/obj/item/organ/internal/intestine
		)

	has_limbs = list(
		BP_TORSO =  list("path" = /obj/item/organ/external/chest),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/shadekin),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right)
		)

	species_component = /datum/component/shadekin

/datum/species/shadekin/handle_death(var/mob/living/carbon/human/H)
	spawn(1)
		for(var/obj/item/W in H)
			H.drop_from_inventory(W)
		qdel(H)

/datum/species/shadekin/get_bodytype()
	return SPECIES_SHADEKIN

/datum/species/shadekin/get_random_name()
	return "shadekin"

/datum/species/shadekin/proc/get_shadekin_eyecolor(var/mob/living/carbon/human/H)
	var/eyecolor_rgb = rgb(H.r_eyes, H.g_eyes, H.b_eyes)

	var/eyecolor_hue = rgb2num(eyecolor_rgb, COLORSPACE_HSV)[1]
	var/eyecolor_sat = rgb2num(eyecolor_rgb, COLORSPACE_HSV)[2]
	var/eyecolor_val = rgb2num(eyecolor_rgb, COLORSPACE_HSV)[3]

	//First, clamp the saturation/value to prevent black/grey/white eyes
	if(eyecolor_sat < 10)
		eyecolor_sat = 10
	if(eyecolor_val < 40)
		eyecolor_val = 40

	eyecolor_rgb = rgb(eyecolor_hue, eyecolor_sat, eyecolor_val, space=COLORSPACE_HSV)

	H.r_eyes = rgb2num(eyecolor_rgb)[1]
	H.g_eyes = rgb2num(eyecolor_rgb)[2]
	H.b_eyes = rgb2num(eyecolor_rgb)[3]

	//Now determine what color we fall into.
	var/eyecolor_type = BLUE_EYES
	switch(eyecolor_hue)
		if(0 to 20)
			eyecolor_type = RED_EYES
		if(21 to 50)
			eyecolor_type = ORANGE_EYES
		if(51 to 70)
			eyecolor_type = YELLOW_EYES
		if(71 to 160)
			eyecolor_type = GREEN_EYES
		if(161 to 260)
			eyecolor_type = BLUE_EYES
		if(261 to 340)
			eyecolor_type = PURPLE_EYES
		if(341 to 360)
			eyecolor_type = RED_EYES

	return eyecolor_type

/datum/species/shadekin/post_spawn_special(var/mob/living/carbon/human/H)
	.=..()

	var/eyecolor_type = get_shadekin_eyecolor(H)
	var/datum/component/shadekin/SK = H.get_shadekin_component()
	if(!SK)
		CRASH("A shadekin [H] somehow is missing their shadekin component post-spawn!")

	switch(eyecolor_type)
		if(BLUE_EYES)
			total_health = 100
			SK.set_light_and_darkness(0.75,0.75)
		if(RED_EYES)
			total_health = 200
			SK.set_light_and_darkness(-0.5,0.5)
		if(PURPLE_EYES)
			total_health = 150
			SK.set_light_and_darkness(-0.5,1)
		if(YELLOW_EYES)
			total_health = 100
			SK.set_light_and_darkness(-2,3)
		if(GREEN_EYES)
			total_health = 100
			SK.set_light_and_darkness(0.125,2)
		if(ORANGE_EYES)
			total_health = 175
			SK.set_light_and_darkness(-0.25,0.75)

	H.maxHealth = total_health

	H.health = H.getMaxHealth()

/datum/species/shadekin/produceCopy(var/list/traits, var/mob/living/carbon/human/H, var/custom_base, var/reset_dna = TRUE) // Traitgenes reset_dna flag required, or genes get reset on resleeve
	var/datum/species/shadekin/new_copy = ..()
	new_copy.total_health = total_health

	return new_copy
