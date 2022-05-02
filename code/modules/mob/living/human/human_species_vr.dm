/mob/living/carbon/human/dummy
	no_vore = TRUE //Dummies don't need bellies.

/mob/living/carbon/human/sergal/New(var/new_loc)
	h_style = "Sergal Plain"
	..(new_loc, "Sergal")

/mob/living/carbon/human/akula/New(var/new_loc)
	..(new_loc, "Akula")

/mob/living/carbon/human/nevrean/New(var/new_loc)
	..(new_loc, "Nevrean")

/mob/living/carbon/human/xenochimera/New(var/new_loc)
	..(new_loc, "Xenochimera")

/mob/living/carbon/human/spider/New(var/new_loc)
	..(new_loc, "Vasilissan")

/mob/living/carbon/human/vulpkanin/New(var/new_loc)
	..(new_loc, "Vulpkanin")

/mob/living/carbon/human/protean/New(var/new_loc)
	..(new_loc, "Protean")

/mob/living/carbon/human/alraune/New(var/new_loc)
	..(new_loc, "Alraune")

/mob/living/carbon/human/shadekin/New(var/new_loc)
	..(new_loc, SPECIES_SHADEKIN)