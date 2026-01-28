/datum/trait/conductive
	name = "Conductive"
	desc = "Increases your susceptibility to electric shocks by 50%"
	cost = -1
	var_changes = list("siemens_coefficient" = 1.5) //This makes you a lot weaker to tasers.
	category = TRAIT_TYPE_NEGATIVE


/datum/trait/conductive_plus
	name = "Conductive, Major"
	desc = "Increases your susceptibility to electric shocks by 100%"
	cost = -1
	var_changes = list("siemens_coefficient" = 2.0) //This makes you extremely weak to tasers.
	custom_only = FALSE
	varchange_type = TRAIT_VARCHANGE_LESS_BETTER

	//Traitgenes
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="You recieve a sudden shock of static."
	primitive_expression_messages=list("shudders as their hair stands on end")
	category = TRAIT_TYPE_NEGATIVE
