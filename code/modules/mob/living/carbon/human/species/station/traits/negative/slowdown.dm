/datum/trait/speed_slow
	name = "Slowdown"
	desc = "Allows you to move slower on average than baseline."
	cost = -2
	var_changes = list("slowdown" = 0.5)
	banned_species = list(SPECIES_ALRAUNE, SPECIES_SHADEKIN_CREW, SPECIES_DIONA, SPECIES_UNATHI) //These are already this slow.
	custom_only = FALSE
	category = TRAIT_TYPE_NEGATIVE

/datum/trait/speed_slow_plus
	name = "Slowdown, Major"
	desc = "Allows you to move MUCH slower on average than baseline."
	cost = -3
	var_changes = list("slowdown" = 1.0)
	custom_only = FALSE
	banned_species = list(SPECIES_DIONA) //Diona are even slower than this
	category = TRAIT_TYPE_NEGATIVE


/datum/trait/extreme_slowdown
	name = "Slowdown, Extreme"
	desc = "You move EXTREMELY slower than baseline"
	cost = -8
	var_changes = list("slowdown" = 4.0)

	//Traitgenes
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="You feel like moving is more difficult..."
	primitive_expression_messages=list("moves sluggishly")
	category = TRAIT_TYPE_NEGATIVE
