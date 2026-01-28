/datum/trait/feeder
	name = "Feeder"
	desc = "Allows you to feed your prey using your own body."
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL

/datum/trait/feeder/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	add_verb(H, /mob/living/carbon/human/proc/slime_feed)
