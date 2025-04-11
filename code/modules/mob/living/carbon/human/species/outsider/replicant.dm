/*
 * This species exists for the use of the Alien Reality pod, though can be used for events or other things.
 */

/datum/species/shapeshifter/replicant
	name = SPECIES_REPLICANT
	name_plural = "Replicants"
	primitive_form = SPECIES_MONKEY
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp)
	blurb = "The remnants of some lost or dead race's research. These seem relatively normal."
	num_alternate_languages = 3
	species_language = LANGUAGE_GALCOM
	secondary_langs = list(LANGUAGE_TERMINUS)
	assisted_langs = list(LANGUAGE_ROOTGLOBAL)
	name_language = LANGUAGE_TERMINUS

	blood_color = "#aaaadd"

	show_ssd = "eerily still."

	min_age = 0
	max_age = 999

	health_hud_intensity = 1.5

	flags = NO_MINOR_CUT | NO_HALLUCINATION | NO_INFECT

	vision_flags = SEE_SELF
	darksight = 5

	brute_mod = 0.9
	burn_mod = 0.9
	oxy_mod = 0.7
	toxins_mod = 0.85
	radiation_mod = 0.9
	flash_mod = 0.9
	sound_mod = 0.9
	siemens_coefficient = 0.9

	spawn_flags = SPECIES_IS_RESTRICTED
	appearance_flags = HAS_SKIN_COLOR | HAS_EYE_COLOR | HAS_HAIR_COLOR | HAS_UNDERWEAR

	valid_transform_species = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_UNATHI, SPECIES_TAJARAN, SPECIES_SKRELL, SPECIES_DIONA, SPECIES_TESHARI, SPECIES_MONKEY, SPECIES_VOX)

	inherent_verbs = list(
		/mob/living/carbon/human/proc/shapeshifter_select_shape,
		/mob/living/carbon/human/proc/shapeshifter_select_hair,
		/mob/living/carbon/human/proc/shapeshifter_select_gender,
		/mob/living/carbon/human/proc/shapeshifter_select_colour,
		/mob/living/carbon/human/proc/shapeshifter_select_hair_colors,
		/mob/living/carbon/human/proc/perform_exit_vr
		)

	has_organ = list(
		O_HEART =		/obj/item/organ/internal/heart/replicant/rage,
		O_LUNGS =		/obj/item/organ/internal/lungs/replicant/mending,
		O_VOICE = 		/obj/item/organ/internal/voicebox/replicant,
		O_LIVER =		/obj/item/organ/internal/liver/replicant,
		O_KIDNEYS =		/obj/item/organ/internal/kidneys/replicant,
		O_BRAIN =		/obj/item/organ/internal/brain/replicant,
		O_EYES =		/obj/item/organ/internal/eyes/replicant,
		O_AREJECT =		/obj/item/organ/internal/immunehub/replicant,
		O_VRLINK = 		/obj/item/organ/internal/brainmirror,
		O_STOMACH =		/obj/item/organ/internal/stomach,
		O_INTESTINE =	/obj/item/organ/internal/intestine
		)

/datum/species/shapeshifter/replicant/alpha
	name = SPECIES_REPLICANT_ALPHA
	blurb = "The remnants of some lost or dead race's research. These seem caustic."

	blood_color = "#55ff55"

	species_language = LANGUAGE_SIGN
	assisted_langs = list(LANGUAGE_ROOTGLOBAL, LANGUAGE_SOL_COMMON)

	inherent_verbs = list(
		/mob/living/carbon/human/proc/shapeshifter_select_shape,
		/mob/living/carbon/human/proc/shapeshifter_select_hair,
		/mob/living/carbon/human/proc/shapeshifter_select_gender,
		/mob/living/carbon/human/proc/shapeshifter_select_colour,
		/mob/living/carbon/human/proc/shapeshifter_select_hair_colors,
		/mob/living/carbon/human/proc/perform_exit_vr,
		/mob/living/carbon/human/proc/corrosive_acid,
		/mob/living/carbon/human/proc/neurotoxin,
		/mob/living/carbon/human/proc/acidspit
		)

	has_organ = list(
		O_HEART =		/obj/item/organ/internal/heart/replicant,
		O_LUNGS =		/obj/item/organ/internal/lungs/replicant,
		O_VOICE = 		/obj/item/organ/internal/voicebox/replicant,
		O_LIVER =		/obj/item/organ/internal/liver/replicant,
		O_KIDNEYS =		/obj/item/organ/internal/kidneys/replicant,
		O_BRAIN =		/obj/item/organ/internal/brain/replicant,
		O_EYES =		/obj/item/organ/internal/eyes/replicant,
		O_AREJECT =		/obj/item/organ/internal/immunehub/replicant,
		O_PLASMA = 		/obj/item/organ/internal/xenos/plasmavessel/replicant,
		O_ACID = 		/obj/item/organ/internal/xenos/acidgland/replicant,
		O_VRLINK =		/obj/item/organ/internal/brainmirror,
		O_STOMACH =		/obj/item/organ/internal/stomach,
		O_INTESTINE =	/obj/item/organ/internal/intestine
		)

/datum/species/shapeshifter/replicant/beta
	name = SPECIES_REPLICANT_BETA
	blurb = "The remnants of some lost or dead race's research. These seem elastic."

	blood_color = "#C0C0C0"

	species_language = LANGUAGE_SIGN
	secondary_langs = list(LANGUAGE_TERMINUS, LANGUAGE_ROOTGLOBAL)	// Radio-waves.

	has_organ = list(
		O_HEART =		/obj/item/organ/internal/heart/replicant/rage,
		O_LUNGS =		/obj/item/organ/internal/lungs/replicant/mending,
		O_VOICE = 		/obj/item/organ/internal/voicebox/replicant,
		O_LIVER =		/obj/item/organ/internal/liver/replicant,
		O_KIDNEYS =		/obj/item/organ/internal/kidneys/replicant,
		O_BRAIN =		/obj/item/organ/internal/brain/replicant/torso,
		O_EYES =		/obj/item/organ/internal/eyes/replicant,
		O_AREJECT =		/obj/item/organ/internal/immunehub/replicant,
		O_VENTC =		/obj/item/organ/internal/metamorphgland/replicant,
		O_PLASMA =		/obj/item/organ/internal/xenos/plasmavessel/replicant,
		O_RESIN =		/obj/item/organ/internal/xenos/resinspinner/replicant,
		O_VRLINK =		/obj/item/organ/internal/brainmirror,
		O_STOMACH =		/obj/item/organ/internal/stomach,
		O_INTESTINE =	/obj/item/organ/internal/intestine
		)
