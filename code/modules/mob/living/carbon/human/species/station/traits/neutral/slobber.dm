/datum/trait/slobber
	name = "Major Slobberer"
	desc = "You produce more saliva than most people and leave people dripping when you lick them."
	tutorial = "Lick someone! Consensually please!"

	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL

/datum/trait/slobber/apply(var/datum/species/S, var/mob/living/carbon/human/human)
	..()
	ADD_TRAIT(human, TRAIT_SLOBBER, ROUNDSTART_TRAIT)
