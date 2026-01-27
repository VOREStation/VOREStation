/datum/trait/nyctophobia
	name = "Phobia: Nyctophobia"
	desc = "You are afraid of the dark. When in very dark conditions, you will become afraid."
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL

/datum/trait/nyctophobia/apply(var/datum/species/S,var/mob/living/carbon/human/H, var/trait_prefs = null)
	..()
	H.phobias |= NYCTOPHOBIA

/datum/trait/arachnophobia
	name = "Phobia: Arachnophobia"
	desc = "You are afraid of spiders. When you can see a large spider, you will become afraid."
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL

/datum/trait/arachnophobia/apply(var/datum/species/S,var/mob/living/carbon/human/H, var/trait_prefs = null)
	..()
	H.phobias |= ARACHNOPHOBIA

/datum/trait/hemophobia
	name = "Phobia: Hemophobia"
	desc = "You are afraid of blood. When you can see large amounts of blood, you will become afraid."
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL

/datum/trait/hemophobia/apply(var/datum/species/S,var/mob/living/carbon/human/H, var/trait_prefs = null)
	..()
	H.phobias |= HEMOPHOBIA

/datum/trait/thalassophobia
	name = "Phobia: Thalassophobia"
	desc = "You are afraid of deep water. When in deep water, you will become afraid."
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL

/datum/trait/thalassophobia/apply(var/datum/species/S,var/mob/living/carbon/human/H, var/trait_prefs = null)
	..()
	H.phobias |= THALASSOPHOBIA

/datum/trait/clasutrophobia_minor
	name = "Phobia: Claustrophobia (non-vore)"
	desc = "You are afraid of tight, enclosed spaces. When inside of another object, you will become afraid."
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL

/datum/trait/clasutrophobia_minor/apply(var/datum/species/S,var/mob/living/carbon/human/H, var/trait_prefs = null)
	..()
	H.phobias |= CLAUSTROPHOBIA_MINOR

/datum/trait/clasutrophobia_major
	name = "Phobia: Claustrophobia (vore)"
	desc = "You are afraid of tight, enclosed spaces. When inside of another object, including vore bellies, you will become afraid."
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL

/datum/trait/clasutrophobia_major/apply(var/datum/species/S,var/mob/living/carbon/human/H, var/trait_prefs = null)
	..()
	H.phobias |= CLAUSTROPHOBIA_MAJOR

/datum/trait/anatidaephobia
	name = "Phobia: Anatidaephobia"
	desc = "You are afraid of ducks. When you can see a duck (even rubber ones), you will become afraid."
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL

/datum/trait/anatidaephobia/apply(var/datum/species/S,var/mob/living/carbon/human/H, var/trait_prefs = null)
	..()
	H.phobias |= ANATIDAEPHOBIA

/datum/trait/agraviaphobia
	name = "Phobia: Agraviaphobia"
	desc = "You are afraid of a lack of gravity. When you find yourself floating, you will become afraid."
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL

/datum/trait/agraviaphobia/apply(var/datum/species/S,var/mob/living/carbon/human/H, var/trait_prefs = null)
	..()
	H.phobias |= AGRAVIAPHOBIA
