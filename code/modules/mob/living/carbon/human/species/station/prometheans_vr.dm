/datum/species/shapeshifter/promethean
	min_age = 18 //Required for server rules
	max_age = 80
	valid_transform_species = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_UNATHI, SPECIES_TAJ, SPECIES_SKRELL, SPECIES_DIONA, SPECIES_TESHARI, SPECIES_MONKEY, SPECIES_MONKEY_TAJ, SPECIES_MONKEY_SKRELL, SPECIES_MONKEY_STOK, SPECIES_SERGAL, SPECIES_AKULA, SPECIES_NEVREAN, SPECIES_ZORREN_HIGH, SPECIES_ZORREN_FLAT, SPECIES_VULPKANIN, SPECIES_VASILISSAN, SPECIES_RAPALA, "Sobaka", "Wolpin", "Saru", "Sparra")

	heal_rate = 0.2 //As of writing, original was 0.5 - Slows regen speed (bad)
	hunger_factor = 0.1 //As of writing, original was 0.2 - Slows hunger rate (good)
	siemens_coefficient = 1 //As of writing, original was 0.4 (bad)
	active_regen_mult = 0.66 //As of writing, original was 1 (good)

	color_mult = 1
	mob_size = MOB_MEDIUM //As of writing, original was MOB_SMALL - Allows normal swapping (good)
	num_alternate_languages = 3
	trashcan = 1 //They have goopy bodies. They can just dissolve things within them.

	appearance_flags = HAS_SKIN_COLOR | HAS_EYE_COLOR | HAS_HAIR_COLOR | RADIATION_GLOWS | HAS_UNDERWEAR

	inherent_verbs = list(
		/mob/living/carbon/human/proc/shapeshifter_select_shape,
		/mob/living/carbon/human/proc/shapeshifter_select_colour,
		/mob/living/carbon/human/proc/shapeshifter_select_hair,
		/mob/living/carbon/human/proc/shapeshifter_select_hair_colors,
		/mob/living/carbon/human/proc/shapeshifter_select_gender,
		/mob/living/carbon/human/proc/shapeshifter_select_wings,
		/mob/living/carbon/human/proc/shapeshifter_select_tail,
		/mob/living/carbon/human/proc/shapeshifter_select_ears,
		/mob/living/carbon/human/proc/regenerate,
		/mob/living/proc/set_size,
		/mob/living/carbon/human/proc/succubus_drain,
		/mob/living/carbon/human/proc/succubus_drain_finalize,
		/mob/living/carbon/human/proc/succubus_drain_lethal,
		/mob/living/carbon/human/proc/slime_feed,
		/mob/living/proc/eat_trash
		)
