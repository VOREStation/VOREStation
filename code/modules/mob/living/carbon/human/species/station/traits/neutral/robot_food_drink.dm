// “Live fast, die young, and leave behind a pretty corpse, that's what I always say.”
/datum/trait/synth_ethanolburner
	name = "Ethanol Burner"
	desc = "You are able to gain energy through consuming and processing alcohol. The more alcoholic it is, the more energy you gain. Doesn't allow you to get drunk by itself (for that, take Ethanol Simulator)."
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL
	can_take = SYNTHETICS
	var_changes = list("robo_ethanol_proc" = 1)

/datum/trait/synth_ethanol_sim
	name = "Ethanol Simulator"
	desc = "An unusual modification allows your synthetic body to simulate all but the lethal effects of ingested alcohols. You'll get dizzy, slur your speech, suffer temporary loss of vision and even pass out! But hey, at least you don't have a liver to destroy."
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL
	can_take = SYNTHETICS
	var_changes = list("robo_ethanol_drunk" = 1)

/datum/trait/synth_chemfurnace
	name = "Biofuel Processor"
	desc = "You are able to gain energy through consuming and processing normal food, at the cost of significantly slower recharging via cyborg chargers. Energy-dense foods such as protein bars and survival food will yield the best results."
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL
	can_take = SYNTHETICS
	var_changes = list("organic_food_coeff" = 0.75, "synthetic_food_coeff" = 1)
	excludes = list(/datum/trait/biofuel_value_down)
