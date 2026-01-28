/datum/trait/nonconductive
	name = "Non-Conductive"
	desc = "Decreases your susceptibility to electric shocks by 25%."
	cost = 2
	var_changes = list("siemens_coefficient" = 0.75)
	category = TRAIT_TYPE_POSITIVE

/datum/trait/nonconductive_plus
	name = "Non-Conductive, Major"
	desc = "Decreases your susceptibility to electric shocks by 50%."
	cost = 3
	var_changes = list("siemens_coefficient" = 0.5)
	category = TRAIT_TYPE_POSITIVE
