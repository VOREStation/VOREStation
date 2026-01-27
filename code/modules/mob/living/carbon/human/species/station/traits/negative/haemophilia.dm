/datum/trait/haemophilia
	name = "Haemophilia - Organics only"
	desc = "When you bleed, you bleed a LOT."
	cost = -2
	var_changes = list("bloodloss_rate" = 2)
	can_take = ORGANICS
	custom_only = FALSE
	varchange_type = TRAIT_VARCHANGE_LESS_BETTER
	category = TRAIT_TYPE_NEGATIVE


/datum/trait/haemophilia_plus
	name = "Haemophilia, Major"
	desc = "Some say that when it rains, it pours.  Unfortunately, this is also true for yourself if you get cut. You bleed much faster than average, at 3x the normal rate."
	cost = -3
	can_take = ORGANICS
	var_changes = list("bloodloss_rate" = 3)

	activation_message="You feel like your skin is made of paper!"
	primitive_expression_messages=list("bumps their toe, screaming in pain")
	category = TRAIT_TYPE_NEGATIVE
