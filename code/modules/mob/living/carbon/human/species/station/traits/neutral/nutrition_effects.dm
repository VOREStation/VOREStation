/datum/trait/nutritiongrow
	name = "Growing"
	desc = "After you consume enough nutrition, you start to slowly grow while metabolizing nutrition faster."
	cost = 0
	hidden = TRUE //Disabled on Virgo
	added_component_path = /datum/component/nutrition_size_change/growing
	category = TRAIT_TYPE_NEUTRAL

/datum/trait/nutritionshrink
	name = "Shrinking"
	desc = "If you don't eat enough, your body starts shrinking to make up the difference!"
	cost = 0
	hidden = TRUE //Disabled on Virgo
	added_component_path = /datum/component/nutrition_size_change/shrinking
	category = TRAIT_TYPE_NEUTRAL
