/datum/trait/agoraphobia
	name = "Agoraphobia"
	desc = "You very much dislike being in crowded places. When in the company of more than two other people, you start to panic and experience adverse effects."
	cost = -3
	excludes = list(/datum/trait/lonely,/datum/trait/lonely/major)
	added_component_path = /datum/component/crowd_detection/agoraphobia

	//Traitgenes
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="You feel like you need some space"
	primitive_expression_messages=list("keeps their distance from others")
	category = TRAIT_TYPE_NEGATIVE
