/datum/trait/food_value_down
	name = "Insatiable"
	desc = "You need to eat a third of a plate more to be sated."
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL
	can_take = ORGANICS
	var_changes = list(organic_food_coeff = 0.67, digestion_efficiency = 0.66)
	excludes = list(/datum/trait/bloodsucker)

/datum/trait/food_value_down_plus
	name = "Insatiable, Greater"
	desc = "You need to eat three times as much to feel sated."
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL
	can_take = ORGANICS
	var_changes = list(organic_food_coeff = 0.33, digestion_efficiency = 0.33)
	excludes = list(/datum/trait/bloodsucker, /datum/trait/food_value_down)

/datum/trait/biofuel_value_down
	name = "Discount Biofuel processor"
	desc = "You are able to gain energy through consuming and processing normal food. Unfortunately, it is half as effective as premium models. On the plus side, you still recharge from charging stations fairly efficiently."
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL
	can_take = SYNTHETICS
	var_changes = list("organic_food_coeff" = 0, "synthetic_food_coeff" = 0.3, digestion_efficiency = 0.5)
	excludes = list(/datum/trait/synth_chemfurnace)
