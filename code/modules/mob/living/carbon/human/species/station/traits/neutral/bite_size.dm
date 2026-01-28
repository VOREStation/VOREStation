/datum/trait/small_mouth_extreme
	name = "Slow Eater"
	desc = "It takes four times as many bites to finish food as it does for most people."
	cost = 0
	var_changes = list("bite_mod" = 0.25)
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL

/datum/trait/small_mouth
	name = "Slow Eater, Minor"
	desc = "It takes twice as many bites to finish food as it does for most people."
	cost = 0
	var_changes = list("bite_mod" = 0.5)
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL

/datum/trait/big_mouth
	name = "Fast Eater, Minor"
	desc = "It takes half as many bites to finish food as it does for most people."
	cost = 0
	var_changes = list("bite_mod" = 2)
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL

/datum/trait/big_mouth_extreme
	name = "Fast Eater"
	desc = "It takes a quarter as many bites to finish food as it does for most people."
	cost = 0
	var_changes = list("bite_mod" = 4)
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL

// Doing this BC I can't rename the datum without fucking over savefiles, so meh. Hyper > Extreme, right?
/datum/trait/big_mouth_hyper
	name = "Fast Eater, Major"
	desc = "You will eat anything instantly, in one bite."
	cost = 0
	var_changes = list("bite_mod" = 16) // Setting this intentionally ridiculously high, so anything will overflow and be eaten in one go.
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL
