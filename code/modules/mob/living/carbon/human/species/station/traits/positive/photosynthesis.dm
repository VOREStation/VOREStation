/datum/trait/photosynth
	name = "Photosynthesis"
	desc = "Your body is able to produce nutrition from being in light."
	cost = 3
	can_take = ORGANICS|SYNTHETICS //Synths actually use nutrition, just with a fancy covering.
	added_component_path = /datum/component/photosynth
	category = TRAIT_TYPE_POSITIVE
