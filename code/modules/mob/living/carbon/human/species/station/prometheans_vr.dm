/datum/species/shapeshifter/promethean
	min_age = 18
	max_age = 80
	valid_transform_species = list("Human", "Unathi", "Tajara", "Skrell", "Diona", "Teshari", "Monkey","Sergal","Akula","Nevrean","Highlander Zorren","Flatland Zorren", "Vulpkanin", "Vasilissan", "Neaera", "Stok", "Farwa", "Sobaka", "Wolpin", "Saru", "Sparra")
	heal_rate = 0.2 //They heal .2, along with the natural .2 heal per tick when below the  organ natural heal damage threshhold.
	siemens_coefficient = 1 //Prevents them from being immune to tasers and stun weapons.
	death_message = "goes limp, their body becoming softer..."
	color_mult = 1
	mob_size = MOB_MEDIUM
	num_alternate_languages = 1 //Let's at least give them one

/datum/species/shapeshifter/promethean/handle_death(var/mob/living/carbon/human/H)
	return //This nullifies them gibbing.
