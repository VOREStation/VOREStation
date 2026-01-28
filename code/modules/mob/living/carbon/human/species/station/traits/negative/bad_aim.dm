/datum/trait/bad_shooter
	name = "Bad Shot"
	desc = "You are terrible at aiming."
	cost = -1
	var_changes = list("gun_accuracy_mod" = -35)
	custom_only = FALSE
	varchange_type = TRAIT_VARCHANGE_MORE_BETTER

	//Traitgenes
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="Your hands quiver"
	primitive_expression_messages=list("hands quiver uncontrollably")
	category = TRAIT_TYPE_NEGATIVE
