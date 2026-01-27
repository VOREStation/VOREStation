/datum/trait/unlucky
	name = "Unlucky"
	desc = "You are naturally unlucky and ill-events often befall you."
	cost = -2
	is_genetrait = FALSE
	hidden = FALSE
	custom_only = FALSE
	added_component_path = /datum/component/omen/trait
	excludes = list(/datum/trait/unlucky/major)
	category = TRAIT_TYPE_NEGATIVE



/datum/trait/unlucky/major
	name = "Unlucky, Major"
	desc = "Your luck is extremely awful and potentially fatal."
	cost = -5
	tutorial = "You should avoid disposal bins."
	is_genetrait = TRUE
	hidden = TRUE //VOREStation Note: Disabled
	added_component_path = /datum/component/omen/trait/major
	excludes = list(/datum/trait/unlucky)
	activation_message= span_cult(span_bold("What a terrible night to have a curse!"))
	primitive_expression_messages=list("unluckily stubs their toe!")
	category = TRAIT_TYPE_NEGATIVE
