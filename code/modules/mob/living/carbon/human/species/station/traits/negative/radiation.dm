/datum/trait/rad_weakness
	name = "Radiation Weakness"
	desc = "You are approximately 50% more susceptible to radiation, and it dissipates slower from your body."
	cost = -2
	var_changes = list("radiation_mod" = 1.5, "rad_removal_mod" = 0.5, "rad_levels" = WEAKENED_RADIATION_RESISTANCE)
	category = TRAIT_TYPE_NEGATIVE
