/datum/trait/light_sensitivity
	name = "Photosensitivity"
	desc = "You have trouble dealing with sudden flashes of light, taking some time for you to recover. The effects of flashes from cameras and security equipment leaves you stunned for some time. 50% increased stun duration from flashes."
	cost = -1
	var_changes = list("flash_mod" = 1.5)
	category = TRAIT_TYPE_NEGATIVE


/datum/trait/light_sensitivity_plus
	name = "Photosensitivity, Major"
	desc = "You have trouble dealing with sudden flashes of light, taking quite a long time for you to be able to recover. The effects of flashes from cameras and security equipment leave you stunned for some time. 100% (2x) stun duration from flashes."
	cost = -2
	var_changes = list("flash_mod" = 2.0)

	//Traitgenes
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="Lights feel painful to look at..."
	primitive_expression_messages=list("holds a hand up to their eyes")
	category = TRAIT_TYPE_NEGATIVE
