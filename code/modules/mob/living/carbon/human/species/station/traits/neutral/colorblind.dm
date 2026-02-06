/datum/trait/colorblind/mono
	name = "Colorblindness (Monochromancy)"
	desc = "You simply can't see colors at all, period. You are 100% colorblind."
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL

	// Traitgenes Made into a gene trait
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="Your eyes feel strange..."

/datum/trait/colorblind/mono/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.add_modifier(/datum/modifier/trait/colorblind_monochrome)

// Traitgenes Made into a gene trait
/datum/trait/colorblind/mono/unapply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.remove_a_modifier_of_type(/datum/modifier/trait/colorblind_monochrome)

/datum/trait/colorblind/para_vulp
	name = "Colorblindness (Para Vulp)"
	desc = "You have a severe issue with green colors and have difficulty recognizing them from red colors."
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL

	// Traitgenes Made into a gene trait
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="Your eyes feel strange..."

/datum/trait/colorblind/para_vulp/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.add_modifier(/datum/modifier/trait/colorblind_vulp)

// Traitgenes Made into a gene trait
/datum/trait/colorblind/para_vulp/unapply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.remove_a_modifier_of_type(/datum/modifier/trait/colorblind_vulp)

/datum/trait/colorblind/para_taj
	name = "Colorblindness (Para Taj)"
	desc = "You have a minor issue with blue colors and have difficulty recognizing them from red colors."
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL

	// Traitgenes - Made into a gene trait
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="Your eyes feel strange..."

/datum/trait/colorblind/para_taj/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.add_modifier(/datum/modifier/trait/colorblind_taj)

// Traitgenes Made into a gene trait
/datum/trait/colorblind/para_taj/unapply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.remove_a_modifier_of_type(/datum/modifier/trait/colorblind_taj)
