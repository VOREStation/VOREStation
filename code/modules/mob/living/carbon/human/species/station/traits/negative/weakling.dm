/datum/trait/weakling
	name = "Weakling"
	desc = "Causes heavy equipment to slow you down more when carried."
	cost = -1
	var_changes = list("item_slowdown_mod" = 1.5)
	custom_only = FALSE
	banned_species = list(SPECIES_SHADEKIN_CREW, SPECIES_TESHARI) //These are already this weak.
	category = TRAIT_TYPE_NEGATIVE


/datum/trait/weakling_plus
	name = "Weakling, Major"
	desc = "Allows you to carry heavy equipment with much more slowdown."
	cost = -2
	var_changes = list("item_slowdown_mod" = 2.0)
	custom_only = FALSE
	banned_species = list(SPECIES_TESHARI) //These are already this weak.
	//Traitgenes
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="Everything feels so much heavier"
	primitive_expression_messages=list("hunches forwards")
	category = TRAIT_TYPE_NEGATIVE
