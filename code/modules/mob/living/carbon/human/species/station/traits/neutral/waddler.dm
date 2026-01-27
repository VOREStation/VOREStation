/datum/trait/waddle
	name = "Waddle / Animated Movement (Adjustable)"
	desc = "You move with a waddle or otherwise animated movement! Has adjustable settings with more adjustments able to be made in game!"
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL
	is_genetrait = TRUE
	hidden = FALSE
	has_preferences = list("waddler" = list(TRAIT_PREF_TYPE_BOOLEAN, "Waddle on Spawn", TRAIT_NO_VAREDIT_TARGET, TRUE))
	added_component_path = /datum/component/waddle_trait

/datum/trait/waddle/apply(var/datum/species/S,var/mob/living/carbon/human/H, var/list/trait_prefs)
	..()
	var/datum/component/waddle_trait/G = H.GetComponent(added_component_path)
	if(trait_prefs)
		G.waddling = trait_prefs["waddler"]
