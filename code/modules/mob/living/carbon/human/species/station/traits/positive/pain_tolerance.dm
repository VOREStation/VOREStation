/datum/trait/pain_tolerance_minor // Minor Pain Tolerance, 10% reduced pain
	name = "Pain Tolerance, Minor"
	desc = "You are slightly more resistant to pain than most, and experience 10% less pain from all sources."
	cost = 1
	custom_only = FALSE
	var_changes = list("pain_mod" = 0.9)
	category = TRAIT_TYPE_POSITIVE

/datum/trait/pain_tolerance
	name = "Pain Tolerance"
	desc = "You are noticeably more resistant to pain than most, and experience 20% less pain from all sources."
	cost = 2
	custom_only = FALSE
	var_changes = list("pain_mod" = 0.8)
	category = TRAIT_TYPE_POSITIVE

/datum/trait/pain_tolerance_advanced // High Pain Intolerance is 50% incoming pain, but this is 40% reduced incoming pain.
	name = "Pain Tolerance, Major"
	desc = "You are extremely resistant to pain sources, and experience 40% less pain from all sources."
	cost = 3 // Equivalent to High Pain Intolerance, but less pain resisted for balance reasons.
	custom_only = FALSE
	var_changes = list("pain_mod" = 0.6)
	category = TRAIT_TYPE_POSITIVE
