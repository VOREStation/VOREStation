/datum/trait/meltable
	name = "Water Weakness"
	desc = "Due to your biology, water is harmful to you."
	cost = -1
	custom_only = TRUE
	var_changes = list("water_resistance" = 0, "water_damage_mod" = 0.3)
	excludes = list(/datum/trait/meltable_major)
	category = TRAIT_TYPE_NEGATIVE


/datum/trait/meltable_major
	name = "Extreme Water Weakness"
	desc = "Due to your biology, water is very harmful to you."
	cost = -3
	custom_only = TRUE
	var_changes = list("water_resistance" = 0, "water_damage_mod" = 0.8)
	excludes = list(/datum/trait/meltable)
	category = TRAIT_TYPE_NEGATIVE
