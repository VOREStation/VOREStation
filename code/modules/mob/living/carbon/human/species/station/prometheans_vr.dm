/datum/species/shapeshifter/promethean
	min_age = 18 //Required for server rules
	max_age = 80
	push_flags = ~HEAVY
	swap_flags = ~HEAVY
	gluttonous = 0
	water_damage_mod = 0		//No water damage
	valid_transform_species = list(
		"Human", "Unathi", "Tajara", "Skrell",
		"Diona", "Teshari", "Monkey","Sergal",
		"Akula","Nevrean","Zorren",
		"Fennec", "Vulpkanin", "Vasilissan",
		"Rapala", "Neaera", "Stok", "Farwa", "Sobaka",
		"Wolpin", "Saru", "Sparra")

	spawn_flags = SPECIES_CAN_JOIN
	wikilink="https://wiki.vore-station.net/Promethean"
	genders = list(MALE, FEMALE, PLURAL, NEUTER)

	color_mult = 1
	mob_size = MOB_MEDIUM //As of writing, original was MOB_SMALL - Allows normal swapping

	appearance_flags = HAS_SKIN_COLOR | HAS_EYE_COLOR | HAS_HAIR_COLOR | RADIATION_GLOWS | HAS_UNDERWEAR

	inherent_verbs = list(
		/mob/living/carbon/human/proc/shapeshifter_select_shape,
		/mob/living/carbon/human/proc/shapeshifter_select_colour,
		/mob/living/carbon/human/proc/shapeshifter_select_hair,
		/mob/living/carbon/human/proc/shapeshifter_select_hair_colors,
		/mob/living/carbon/human/proc/shapeshifter_select_gender,
		/mob/living/carbon/human/proc/regenerate,
		/mob/living/carbon/human/proc/shapeshifter_select_wings,
		/mob/living/carbon/human/proc/shapeshifter_select_tail,
		/mob/living/carbon/human/proc/shapeshifter_select_ears,
		/mob/living/proc/set_size,
		/mob/living/carbon/human/proc/promethean_select_opaqueness,
		)
