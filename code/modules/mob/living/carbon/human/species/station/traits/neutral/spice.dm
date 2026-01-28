// Spicy Food Traits, from negative to positive.
/datum/trait/spice_intolerance_extreme
	name = "Spice Intolerance, Extreme"
	desc = "Spicy (and chilly) peppers are three times as strong. (This does not affect pepperspray.)"
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL
	var_changes = list("spice_mod" = 3) // 300% as effective if spice_mod is set to 1. If it's not 1 in species.dm, update this!

	// Traitgenes Made into a gene trait
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="Your belly feels strange..."

/datum/trait/spice_intolerance_basic
	name = "Spice Intolerance, Heavy"
	desc = "Spicy (and chilly) peppers are twice as strong. (This does not affect pepperspray.)"
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL
	var_changes = list("spice_mod" = 2) // 200% as effective if spice_mod is set to 1. If it's not 1 in species.dm, update this!

/datum/trait/spice_intolerance_slight
	name = "Spice Intolerance, Slight"
	desc = "You have a slight struggle with spicy foods. Spicy (and chilly) peppers are one and a half times stronger. (This does not affect pepperspray.)"
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL
	var_changes = list("spice_mod" = 1.5) // 150% as effective if spice_mod is set to 1. If it's not 1 in species.dm, update this!

/datum/trait/spice_tolerance_basic
	name = "Spice Tolerance"
	desc = "Spicy (and chilly) peppers are only three-quarters as strong. (This does not affect pepperspray.)"
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL
	var_changes = list("spice_mod" = 0.75) // 75% as effective if spice_mod is set to 1. If it's not 1 in species.dm, update this!

/datum/trait/spice_tolerance_advanced
	name = "Spice Tolerance, Strong"
	desc = "Spicy (and chilly) peppers are only half as strong. (This does not affect pepperspray.)"
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL
	var_changes = list("spice_mod" = 0.5) // 50% as effective if spice_mod is set to 1. If it's not 1 in species.dm, update this!

/datum/trait/spice_immunity
	name = "Spice Tolerance, Extreme"
	desc = "Spicy (and chilly) peppers are basically ineffective! (This does not affect pepperspray.)"
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL
	var_changes = list("spice_mod" = 0.25) // 25% as effective if spice_mod is set to 1. If it's not 1 in species.dm, update this!

	// Traitgenes Made into a gene trait
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="Your belly feels strange..."
