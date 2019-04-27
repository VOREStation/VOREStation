/datum/species/shadekin
	name = SPECIES_SHADEKIN
	name_plural = "Shadekin"
	blurb = "Waow! A shaadefluffer!"
	catalogue_data = list(/datum/category_item/catalogue/fauna/shadekin)

	//default_language = "Xenomorph"
	language = LANGUAGE_SHADEKIN
	assisted_langs = list()
	unarmed_types = list()	//TODO: shadekin-unique pawbings
	hud_type = /datum/hud_data/shadekin
	rarity_value = 15	//INTERDIMENSIONAL FLUFFERS

	has_fine_manipulation = 0
	siemens_coefficient = 0

	slowdown = -1
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

	flags =  NO_SCAN | NO_PAIN | NO_SLIP | NO_MINOR_CUT | NO_INFECT
	spawn_flags = SPECIES_IS_RESTRICTED

	//reagent_tag = IS_SHADEKIN

	flesh_color = "#34AF10"		//TODO: set colors
	blood_color = "#b3cbc3"
	base_color = "#066000"

	has_glowing_eyes = TRUE

	death_message = "lets out a waning guttural screech, green blood bubbling from its maw."
	//death_sound = 'sound/voice/hiss6.ogg'
	male_cough_sounds = null
	female_cough_sounds = null
	male_sneeze_sound = null
	female_sneeze_sound = null

	//speech_sounds = list('sound/voice/hiss1.ogg','sound/voice/hiss2.ogg','sound/voice/hiss3.ogg','sound/voice/hiss4.ogg')
	//speech_chance = 100

	speech_bubble_appearance = "ghost"

	genders = list(PLURAL, NEUTER)		//no sexual dymorphism
	ambiguous_genders = TRUE	//but just in case

	virus_immune = 1

	breath_type = null
	poison_type = null

	vision_flags = SEE_SELF|SEE_MOBS
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_SKIN_COLOR | HAS_EYE_COLOR

	move_trail = /obj/effect/decal/cleanable/blood/tracks/paw

	has_organ = list(
		O_HEART =		/obj/item/organ/internal/heart,
		O_LUNGS =		/obj/item/organ/internal/lungs,
		O_VOICE = 		/obj/item/organ/internal/voicebox,
		O_LIVER =		/obj/item/organ/internal/liver,
		O_KIDNEYS =		/obj/item/organ/internal/kidneys,
		O_BRAIN =		/obj/item/organ/internal/brain/shadekin,
		O_EYES =		/obj/item/organ/internal/eyes
		)

	//SHADEKIN-UNIQUE STUFF GOES HERE
	var/shadekin_eye_color = BLUE_EYES

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

/datum/species/shadekin/get_bodytype()
	return SPECIES_SHADEKIN

/datum/species/shadekin/get_random_name()
	return "shadekin"

/datum/species/shadekin/handle_environment_special(var/mob/living/carbon/human/H)
	handle_shade(H)

/datum/species/shadekin/can_breathe_water()
	return TRUE	//they dont quite breathe

/datum/species/shadekin/proc/get_shadekin_eyecolor()
	return shadekin_eye_color

/datum/species/shadekin/proc/handle_shade(var/mob/living/carbon/human/H)
	//Shifted kin don't gain/lose energy (and save time if we're at the cap)
	var/darkness = 1
	var/dark_gains = 0

	var/turf/T = get_turf(H)
	if(!T)
		dark_gains = 0
		return

	var/brightness = T.get_lumcount() //Brightness in 0.0 to 1.0
	darkness = 1-brightness //Invert

	if(H.ability_flags & AB_PHASE_SHIFTED)
		dark_gains = 0
	else
		//Heal (very) slowly in good darkness
		if(darkness >= 0.75)
			H.adjustFireLoss(-0.05)
			H.adjustBruteLoss(-0.05)
			H.adjustToxLoss(-0.05)

		switch(get_shadekin_eyecolor())
			//Blue has constant, steady (slow) regen and ignores darkness.
			if(BLUE_EYES)
				dark_gains = 0.5
			//Red has extremely tiny energy buildup in dark, none in light, and hunts for energy.
			if(RED_EYES)
				if(darkness >= 0.75)
					dark_gains = 0.25
			//Purple eyes have moderate gains in darkness and loss in light.
			if(PURPLE_EYES)
				dark_gains = round((darkness - 0.5) * 2, 0.1)
			//Yellow has extreme gains in darkness and loss in light.
			if(YELLOW_EYES)
				dark_gains = round((darkness - 0.5) * 4, 0.1)
			//Similar to blues, but passive is less, and affected by dark
			if(GREEN_EYES)
				dark_gains = 0.25
				dark_gains += round((darkness - 0.5), 0.1)
			//More able to get energy out of the dark, worse attack gains tho
			if(ORANGE_EYES)
				if(darkness >= 0.65)
					dark_gains = 0.30

	set_energy(H, get_energy(H) + dark_gains)

	//Update huds
	update_shadekin_hud()

/datum/species/shadekin/proc/get_energy(var/mob/living/carbon/human/H)
	var/obj/item/organ/internal/brain/shadekin/shade_organ = H.internal_organs_by_name[O_BRAIN]

	if(!istype(shade_organ))
		return 0

	return shade_organ.dark_energy

/datum/species/shadekin/proc/get_max_energy(var/mob/living/carbon/human/H)
	var/obj/item/organ/internal/brain/shadekin/shade_organ = H.internal_organs_by_name[O_BRAIN]

	if(!istype(shade_organ))
		return 0

	return shade_organ.max_dark_energy

/datum/species/shadekin/proc/set_energy(var/mob/living/carbon/human/H, var/new_energy)
	var/obj/item/organ/internal/brain/shadekin/shade_organ = H.internal_organs_by_name[O_BRAIN]

	if(!istype(shade_organ))
		return

	shade_organ.dark_energy = CLAMP(new_energy, 0, get_max_energy(H))

/datum/species/shadekin/proc/set_max_energy(var/mob/living/carbon/human/H, var/new_max_energy)
	var/obj/item/organ/internal/brain/shadekin/shade_organ = H.internal_organs_by_name[O_BRAIN]

	if(!istype(shade_organ))
		return 0

	shade_organ.max_dark_energy = new_max_energy

/datum/species/shadekin/proc/update_shadekin_hud()
	return

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
		"head" =			list("loc" = ui_shoes,     "name" = "Hat",        "slot" = slot_head,     "state" = "hair",   "toggle" = 1),
		"suit storage" =	list("loc" = ui_sstore1,   "name" = "Uniform", "slot" = slot_w_uniform,   "state" = "center",   "toggle" = 1),
		"id" =				list("loc" = ui_id,        "name" = "ID",          "slot" = slot_wear_id,      "state" = "id"),
		"belt" =			list("loc" = ui_belt,      "name" = "Belt",         "slot" = slot_belt, "state" = "belt"),
		"back" =			list("loc" = ui_back,      "name" = "Back",         "slot" = slot_back,      "state" = "back"),
		"storage1" =		list("loc" = ui_storage1,  "name" = "Left Pocket",  "slot" = slot_l_store,   "state" = "pocket"),
		"storage2" =		list("loc" = ui_storage2,  "name" = "Right Pocket", "slot" = slot_r_store,   "state" = "pocket")
		)

/obj/screen/shadekin
	icon = 'icons/mob/shadekin_hud.dmi'
	invisibility = 101

/obj/screen/shadekin/darkness
	name = "darkness"
	icon_state = "dark"
	alpha = 150

/obj/screen/shadekin/energy
	name = "energy"
	icon_state = "energy0"
	alpha = 150