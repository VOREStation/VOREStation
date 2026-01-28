/datum/trait/stuffing_feeder
	name = "Food Stuffer"
	desc = "Allows you to feed food to other people whole, rather than bite by bite."
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL
	has_preferences = list("stuffing_feeder" = list(TRAIT_PREF_TYPE_BOOLEAN, "Default", TRAIT_VAREDIT_TARGET_MOB, FALSE))

/datum/trait/stuffing_feeder/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	add_verb(H, /mob/living/proc/toggle_stuffing_mode)
