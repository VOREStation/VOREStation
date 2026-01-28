/datum/trait/drippy
	name = "Drippy"
	desc = "You cannot hold your form together, or produce a constant film of sludge that drips off of your body. Hope the station has a janitor."
	cost = 0

	// Traitgenes Made into a genetrait
	is_genetrait = TRUE
	hidden = FALSE
	category = TRAIT_TYPE_NEUTRAL

	activation_message="You feel softer..."
	primitive_expression_messages=list("drips.")
	added_component_path = /datum/component/drippy
