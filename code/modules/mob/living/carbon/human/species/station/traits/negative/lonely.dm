/datum/trait/lonely
	name = "Minor loneliness vulnerability"
	desc = "You're very prone to loneliness! Being alone for extended periods of time causes adverse effects. Most mobs will cure this loneliness as long as they aren't hostile."
	cost = -1
	excludes = list(/datum/trait/lonely/major,/datum/trait/agoraphobia)
	added_component_path = /datum/component/crowd_detection/lonely
	category = TRAIT_TYPE_NEGATIVE


/datum/trait/lonely/major
	name = "Major loneliness vulnerability"
	desc = "You're extremely prone to loneliness! Being alone for extended periods of time causes adverse effects. Most mobs won't be enough to cure this loneliness, you need other social beings."
	cost = -3
	excludes = list(/datum/trait/lonely,/datum/trait/agoraphobia)
	added_component_path = /datum/component/crowd_detection/lonely/major

	//Traitgenes
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="You feel like you are in desperate need of company..."
	primitive_expression_messages=list("Looks up at you pleadingly")
	category = TRAIT_TYPE_NEGATIVE
