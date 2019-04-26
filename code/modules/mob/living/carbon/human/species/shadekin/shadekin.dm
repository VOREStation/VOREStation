/datum/species/shadekin
	name = SPECIES_SHADEKIN
	name_plural = "Shadekin"

	//default_language = "Xenomorph"
	language = "Shadekin Empathy"
	assisted_langs = list()
	unarmed_types = list()	//TODO: shadekin-unique pawbings
	hud_type = /datum/hud_data/shadekin	//TODO: shadekin hud
	rarity_value = 15	//INTERDIMENSIONAL FLUFFERS

	has_fine_manipulation = 0
	siemens_coefficient = 0

	slowdown = -2

	brute_mod = 0.7	// Naturally sturdy.
	burn_mod = 1.2	// Furry

	warning_low_pressure = 50
	hazard_low_pressure = -1

	warning_high_pressure = 300
	hazard_high_pressure = INFINITY

	cold_level_1 = -1	//Immune to cold
	cold_level_2 = -1
	cold_level_3 = -1

	flags =  NO_SCAN | NO_PAIN | NO_SLIP | NO_POISON | NO_MINOR_CUT | NO_INFECT
	spawn_flags = SPECIES_IS_RESTRICTED

	//reagent_tag = IS_SHADEKIN

	blood_color = "#05EE05"
	flesh_color = "#282846"
	gibbed_anim = "gibbed-a"
	dusted_anim = "dust-a"
	death_message = "lets out a waning guttural screech, green blood bubbling from its maw."
	//death_sound = 'sound/voice/hiss6.ogg'

	//speech_sounds = list('sound/voice/hiss1.ogg','sound/voice/hiss2.ogg','sound/voice/hiss3.ogg','sound/voice/hiss4.ogg')
	//speech_chance = 100

	virus_immune = 1

	breath_type = null
	poison_type = null

	vision_flags = SEE_SELF|SEE_MOBS

	has_organ = list(
		O_HEART =    /obj/item/organ/internal/heart,
		O_BRAIN =    /obj/item/organ/internal/brain/xeno,
		O_PLASMA =   /obj/item/organ/internal/xenos/plasmavessel,
		O_HIVE =     /obj/item/organ/internal/xenos/hivenode,
		O_NUTRIENT = /obj/item/organ/internal/diona/nutrients
		)

	//SHADEKIN STUFF GOES HERE

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

/datum/species/xenos/get_bodytype()
	return SPECIES_SHADEKIN

/datum/species/xenos/get_random_name()
	return "shadekin"


/mob/living/carbon/human/shadekin/New(var/new_loc)
	h_style = "Bald"
	..(new_loc, SPECIES_SHADEKIN)





/datum/hud_data/shadekin

	icon = 'icons/mob/shadekin_hud.dmi'
	has_a_intent =  1
	has_m_intent =  1
	has_warnings =  1
	has_hands =     1
	has_drop =      1
	has_throw =     1
	has_resist =    1
	has_pressure =  1
	has_nutrition = 1
	has_bodytemp =  1
	has_internals = 0

	gear = list(
		"head" =			list("loc" = ui_shoes,     "name" = "Hat",        "slot" = slot_head,     "state" = "hair"),
		"suit storage" =	list("loc" = ui_sstore1,   "name" = "Suit Storage", "slot" = slot_w_uniform,   "state" = "center"),
		"id" =				list("loc" = ui_id,        "name" = "ID",          "slot" = slot_wear_id,      "state" = "id"),
		"belt" =			list("loc" = ui_belt,      "name" = "Belt",         "slot" = slot_belt, "state" = "belt"),
		"back" =			list("loc" = ui_back,      "name" = "Back",         "slot" = slot_back,      "state" = "back"),
		"storage1" =		list("loc" = ui_storage1,  "name" = "Left Pocket",  "slot" = slot_l_store,   "state" = "pocket"),
		"storage2" =		list("loc" = ui_storage2,  "name" = "Right Pocket", "slot" = slot_r_store,   "state" = "pocket")
		)