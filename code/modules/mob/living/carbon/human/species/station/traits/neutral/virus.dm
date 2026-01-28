/datum/trait/disease_carrier
	name = "Disease Carrier"
	desc = "Your species is a carrier of diseases! Watch out for virologists."
	excludes = list(/datum/trait/strongimmunesystem)
	cost = 0
	can_take = ORGANICS
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL

/datum/trait/disease_carrier/apply(datum/species/S, mob/living/carbon/human/H, trait_prefs)
	..()
	H.give_random_dormant_disease(200, 2, 3, 1, 9)

/datum/trait/strongimmunesystem
	name = "Strong Immune System"
	desc = "Your immune system is so strong, that not even dormant diseases can survive in you."
	cost = 0

	can_take = ORGANICS
	category = TRAIT_TYPE_NEUTRAL

/datum/trait/strongimmunesystem/apply(datum/species/S, mob/living/carbon/human/H, trait_prefs)
	..()
	ADD_TRAIT(H, STRONG_IMMUNITY_TRAIT, ROUNDSTART_TRAIT)
