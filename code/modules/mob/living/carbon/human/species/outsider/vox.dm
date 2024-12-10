/datum/species/vox
	name = SPECIES_VOX
	name_plural = "Vox"
	icobase = 'icons/mob/human_races/r_vox.dmi'
	deform = 'icons/mob/human_races/r_def_vox.dmi'
	default_language = LANGUAGE_VOX
	language = LANGUAGE_GALCOM
	species_language = LANGUAGE_VOX
	num_alternate_languages = 3
	assisted_langs = list(LANGUAGE_ROOTGLOBAL)
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick,  /datum/unarmed_attack/claws/strong, /datum/unarmed_attack/bite/strong)
	rarity_value = 4
	blurb = "The Vox are the broken remnants of a once-proud race, now reduced to little more than \
	scavenging vermin who prey on isolated stations, ships or planets to keep their own ancient arkships \
	alive. They are four to five feet tall, reptillian, beaked, tailed and quilled; human crews often \
	refer to them as 'shitbirds' for their violent and offensive nature, as well as their horrible \
	smell.<br/><br/>Most humans will never meet a Vox raider, instead learning of this insular species through \
	dealing with their traders and merchants; those that do rarely enjoy the experience."
	catalogue_data = list(/datum/category_item/catalogue/fauna/vox)

//	taste_sensitivity = TASTE_DULL

	slowdown = -0.5

	speech_sounds = list('sound/voice/shriek1.ogg')
	speech_chance = 20

	scream_verb_1p = "shriek"
	scream_verb_3p = "shrieks"
	male_scream_sound = 'sound/voice/shriek1.ogg'
	female_scream_sound = 'sound/voice/shriek1.ogg'
	male_cough_sounds = list('sound/voice/shriekcough.ogg')
	female_cough_sounds = list('sound/voice/shriekcough.ogg')
	male_sneeze_sound = 'sound/voice/shrieksneeze.ogg'
	female_sneeze_sound = 'sound/voice/shrieksneeze.ogg'

	warning_low_pressure = 50
	hazard_low_pressure = 0

	cold_level_1 = 80
	cold_level_2 = 50
	cold_level_3 = 0

	gluttonous = 1

	breath_type = GAS_PHORON
	poison_type = GAS_O2
	ideal_air_type = /datum/gas_mixture/belly_air/vox
	siemens_coefficient = 0.2

	flags = NO_SCAN | NO_DEFIB
	spawn_flags = SPECIES_IS_WHITELISTED
	appearance_flags = HAS_EYE_COLOR | HAS_HAIR_COLOR | HAS_SKIN_COLOR

	blood_color = "#9066BD"
	flesh_color = "#808D11"

	reagent_tag = IS_VOX

	has_limbs = list(
		BP_TORSO =  list("path" = /obj/item/organ/external/chest),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/vox),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right)
		)


	has_organ = list(
		O_HEART =    /obj/item/organ/internal/heart/vox,
		O_LUNGS =    /obj/item/organ/internal/lungs/vox,
		O_VOICE =	 /obj/item/organ/internal/voicebox,
		O_LIVER =    /obj/item/organ/internal/liver/vox,
		O_KIDNEYS =  /obj/item/organ/internal/kidneys/vox,
		O_BRAIN =    /obj/item/organ/internal/brain/vox,
		O_EYES =     /obj/item/organ/internal/eyes,
		)

	genders = list(NEUTER)

	descriptors = list(
		/datum/mob_descriptor/height = -1,
		/datum/mob_descriptor/build = 1,
		/datum/mob_descriptor/vox_markings = 0
	)

	default_emotes = list(
		/decl/emote/audible/vox_shriek
	)

/datum/species/vox/get_random_name(var/gender)
	var/datum/language/species_language = GLOB.all_languages[default_language]
	return species_language.get_random_name(gender)

/datum/species/vox/equip_survival_gear(var/mob/living/carbon/human/H, var/extendedtank = 0,var/comprehensive = 0)
	. = ..()

	H.equip_to_slot_or_del(new /obj/item/clothing/mask/breath(H), slot_wear_mask)
	if(H.backbag == 1)
		H.equip_to_slot_or_del(new /obj/item/tank/vox(H), slot_back)
		H.internal = H.back
	else
		H.equip_to_slot_or_del(new /obj/item/tank/vox(H), slot_r_hand)
		H.internal = H.r_hand
	H.internal = locate(/obj/item/tank) in H.contents
	if(istype(H.internal,/obj/item/tank) && H.internals)
		H.internals.icon_state = "internal1"
