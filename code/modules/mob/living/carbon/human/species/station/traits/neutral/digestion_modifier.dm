/datum/trait/digestion_value_up
	name = "Highly Filling"
	desc = "You provide notably more nutrition to anyone who makes a meal of you."
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL
	var_changes = list("digestion_nutrition_modifier" = 2)

/datum/trait/digestion_value_up_plus
	name = "Extremely Filling"
	desc = "You provide a lot more nutrition to anyone who makes a meal of you."
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL
	var_changes = list("digestion_nutrition_modifier" = 3)

/datum/trait/digestion_value_down
	name = "Slightly Filling"
	desc = "You provide notably less nutrition to anyone who makes a meal of you."
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL
	var_changes = list("digestion_nutrition_modifier" = 0.5)

/datum/trait/digestion_value_down_plus
	name = "Barely Filling"
	desc = "You provide a lot less nutrition to anyone who makes a meal of you."
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL
	var_changes = list("digestion_nutrition_modifier" = 0.25)
