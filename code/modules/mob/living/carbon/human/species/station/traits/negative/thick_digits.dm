/datum/trait/thick_digits
	name = "Thick Digits"
	desc = "Your hands are not shaped in a way that allows useage of guns."
	cost = -4
	custom_only = FALSE
	category = TRAIT_TYPE_NEGATIVE


/datum/trait/thick_digits/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.add_modifier(/datum/modifier/trait/thickdigits)
