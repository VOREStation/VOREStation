/datum/trait/allergen_reduced_effect
	name = "Allergen Reaction: Reduced Intensity"
	desc = "This trait drastically reduces the effects of allergen reactions. If you don't have any allergens set, it does nothing. It does not apply to special reactions (such as unathi drowsiness from sugars)."
	cost = 0
	custom_only = FALSE
	var_changes = list("allergen_damage_severity" = 1.25, "allergen_disable_severity" = 5)
	excludes = list(/datum/trait/allergen_increased_effect)
	category = TRAIT_TYPE_NEUTRAL

/datum/trait/allergen_increased_effect
	name = "Allergen Reaction: Increased Intensity"
	desc = "This trait drastically increases the effects of allergen reactions, enough that even a small dose can be lethal. If you don't have any allergens set, it does nothing. It does not apply to special reactions (such as unathi drowsiness from sugars)."
	cost = 0
	custom_only = FALSE
	var_changes = list("allergen_damage_severity" = 5, "allergen_disable_severity" = 20)
	excludes = list(/datum/trait/allergen_reduced_effect)
	category = TRAIT_TYPE_NEUTRAL
