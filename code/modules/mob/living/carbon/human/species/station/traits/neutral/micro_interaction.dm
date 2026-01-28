/datum/trait/micro_size_down
	name = "Light Frame"
	desc = "You are considered smaller than you are for micro interactions."
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL

	var_changes = list("micro_size_mod" = -0.15)

/datum/trait/micro_size_down_plus
	name = "Light Frame, Major"
	desc = "You are considered much smaller than you are for micro interactions."
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL

	var_changes = list("micro_size_mod" = -0.30)

/datum/trait/micro_size_up
	name = "Heavy Frame"
	desc = "You are considered bigger than you are for micro interactions."
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL

	var_changes = list("micro_size_mod" = 0.15)

/datum/trait/micro_size_up_plus
	name = "Heavy Frame, Major"
	desc = "You are considered much bigger than you are for micro interactions."
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL

	var_changes = list("micro_size_mod" = 0.30)
