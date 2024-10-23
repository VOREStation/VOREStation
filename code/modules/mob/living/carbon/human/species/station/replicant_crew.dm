/datum/species/shapeshifter/replicant/crew
	name = SPECIES_REPLICANT_CREW
	blurb = "Replicants are one of the few remaining living examples of precursor technology. \
	While their origins remain unknown, they are a facsimile of organic life held together by amalgamate, \
	rubbery flesh and anomalous organs. Whilst their original purpose is speculated to be used through cortical \
	mirrors as a way to 'wirelessly exist' in a different body via VR pods, this specific variant has had its \
	forking capabilities severed in exchange for a more stable, self-sufficient (albeit weaker) form."

	min_age = 18
	max_age = 200
	blood_color = "#C0C0C0"

	radiation_mod = 1.2 //Affected more by radiation
	siemens_coefficient = 1.5 //Don't get electrocuted

	secondary_langs = list()	// None by default

	has_organ = list(
		O_HEART =		/obj/item/organ/internal/heart/replicant/rage/crew,
		O_LUNGS =		/obj/item/organ/internal/lungs/replicant/mending/crew,
		O_VOICE = 		/obj/item/organ/internal/voicebox/replicant,
		O_LIVER =		/obj/item/organ/internal/liver/replicant,
		O_KIDNEYS =		/obj/item/organ/internal/kidneys/replicant,
		O_BRAIN =		/obj/item/organ/internal/brain/replicant/torso,
		O_EYES =		/obj/item/organ/internal/eyes/replicant,
		O_AREJECT =		/obj/item/organ/internal/immunehub/replicant,
		O_VENTC =		/obj/item/organ/internal/metamorphgland/replicant,
		O_PLASMA =		/obj/item/organ/internal/xenos/plasmavessel/replicant/crew,
		O_RESIN =		/obj/item/organ/internal/xenos/resinspinner/replicant,
		O_STOMACH =		/obj/item/organ/internal/stomach,
		O_INTESTINE =	/obj/item/organ/internal/intestine
		)

	appearance_flags = HAS_SKIN_COLOR | HAS_EYE_COLOR | HAS_HAIR_COLOR | HAS_UNDERWEAR | HAS_LIPS
	spawn_flags		 = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED | SPECIES_WHITELIST_SELECTABLE
	color_mult = 1
	valid_transform_species = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_UNATHI, SPECIES_TAJ, SPECIES_SKRELL, SPECIES_ALTEVIAN, SPECIES_TESHARI, SPECIES_MONKEY, SPECIES_LLEILL, SPECIES_VULPKANIN, SPECIES_ZORREN_HIGH, SPECIES_RAPALA, SPECIES_NEVREAN, SPECIES_VASILISSAN, SPECIES_AKULA)

	inherent_verbs = list(
		/mob/living/carbon/human/proc/shapeshifter_select_shape,
		/mob/living/carbon/human/proc/shapeshifter_select_colour,
		/mob/living/carbon/human/proc/shapeshifter_select_hair,
		/mob/living/carbon/human/proc/shapeshifter_select_hair_colors,
		/mob/living/carbon/human/proc/shapeshifter_select_gender,
		/mob/living/carbon/human/proc/shapeshifter_select_wings,
		/mob/living/carbon/human/proc/shapeshifter_select_tail,
		/mob/living/carbon/human/proc/shapeshifter_select_ears,
		/mob/living/carbon/human/proc/shapeshifter_select_secondary_ears,
		/mob/living/carbon/human/proc/shapeshifter_select_eye_colour,
		/mob/living/proc/set_size
		)
