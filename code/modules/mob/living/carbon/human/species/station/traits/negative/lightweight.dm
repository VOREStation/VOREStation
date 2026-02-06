/datum/trait/lightweight_light
	name = "Lesser Lightweight"
	desc = "Your light weight and poor balance make you very susceptible to unhelpful bumping if you are unprepared)"
	cost = -1
	var_changes = list("lightweight_light" = 1)
	excludes = list(/datum/trait/lightweight)
	custom_only = FALSE
	category = TRAIT_TYPE_NEGATIVE


/datum/trait/lightweight
	name = "Lightweight"
	desc = "Your light weight and poor balance make you very susceptible to unhelpful bumping. Think of it like a bowling ball versus a pin."
	cost = -2
	var_changes = list("lightweight" = 1)
	custom_only = FALSE

	//Traitgenes
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="You feel off balance..."
	primitive_expression_messages=list("staggers")
	excludes = list(/datum/trait/lightweight_light)
	category = TRAIT_TYPE_NEGATIVE
