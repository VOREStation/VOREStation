/datum/trait/low_blood_sugar
	name = "Low Blood Sugar"
	desc = "If you let your nutrition get too low, you will start to experience adverse affects including hallucinations, unconsciousness, and weakness"
	cost = -1

	// Traitgenes Made into a gene trait
	is_genetrait = TRUE
	hidden = FALSE
	added_component_path = /datum/component/diabetic

	activation_message="You feel drowsy..."
	primitive_expression_messages=list("looks drowsy")
	category = TRAIT_TYPE_NEGATIVE
