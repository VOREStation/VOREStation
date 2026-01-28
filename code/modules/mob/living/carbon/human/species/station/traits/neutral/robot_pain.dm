/datum/trait/synth_cosmetic_pain
	name = "Pain simulation"
	desc = "You have added modules in your synthetic shell that simulates the sensation of pain. You are able to turn this on and off for repairs as needed or convenience at will."
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL
	can_take = SYNTHETICS
	has_preferences = list("pain" = list(TRAIT_PREF_TYPE_BOOLEAN, "Enabled on spawn", TRAIT_VAREDIT_TARGET_MOB, FALSE))

/datum/trait/synth_cosmetic_pain/apply(var/datum/species/S,var/mob/living/carbon/human/H, var/trait_prefs = null)
	..()
	add_verb(H, /mob/living/carbon/human/proc/toggle_pain_module)
