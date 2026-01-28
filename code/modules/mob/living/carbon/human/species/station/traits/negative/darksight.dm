/datum/trait/dark_blind
	name = "Nyctalopia"
	desc = "You cannot see in dark at all."
	cost = -1
	var_changes = list("darksight" = 0)
	custom_only = FALSE
	varchange_type = TRAIT_VARCHANGE_MORE_BETTER

	//Traitgenes
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="The dark seems darker than usual."
	primitive_expression_messages=list("looks towards the light")
	category = TRAIT_TYPE_NEGATIVE
