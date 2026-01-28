/datum/trait/hide
	name = "Hide"
	desc = "You can hide beneath objects!"
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL

/datum/trait/hide/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	add_verb(H,/mob/living/proc/hide)
