/datum/species/shapeshifter/promethean
	min_age = 18
	max_age = 80
	valid_transform_species = list("Human", "Unathi", "Tajara", "Skrell", "Diona", "Teshari", "Monkey","Sergal","Akula","Nevrean","Highlander Zorren","Flatland Zorren", "Vulpkanin", "Vasilissan", "Rapala", "Neaera", "Stok", "Farwa", "Sobaka", "Wolpin", "Saru", "Sparra")
	heal_rate = 0.2 //They heal .2, along with the natural .2 heal per tick when below the  organ natural heal damage threshhold.
	siemens_coefficient = 1 //Prevents them from being immune to tasers and stun weapons.
	death_message = "goes limp, their body becoming softer..."
	color_mult = 1
	mob_size = MOB_MEDIUM
	num_alternate_languages = 1 //Let's at least give them one
	appearance_flags = HAS_SKIN_COLOR | HAS_EYE_COLOR | HAS_HAIR_COLOR | RADIATION_GLOWS | HAS_UNDERWEAR
	inherent_verbs = list(
		/mob/living/carbon/human/proc/shapeshifter_select_shape,
		/mob/living/carbon/human/proc/shapeshifter_select_colour,
		/mob/living/carbon/human/proc/shapeshifter_select_hair,
		/mob/living/carbon/human/proc/shapeshifter_select_hair_colors,
		/mob/living/carbon/human/proc/shapeshifter_select_gender,
		/mob/living/carbon/human/proc/regenerate,
		/mob/living/proc/set_size,
		/mob/living/carbon/human/proc/succubus_drain,
		/mob/living/carbon/human/proc/succubus_drain_finalize,
		/mob/living/carbon/human/proc/succubus_drain_lethal,
		/mob/living/carbon/human/proc/slime_feed
		)


/datum/species/shapeshifter/promethean/handle_death(var/mob/living/carbon/human/H)
	return //This nullifies them gibbing.
