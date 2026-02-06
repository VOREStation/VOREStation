/datum/trait/scrawny
	name = "Scrawny"
	desc = "You have a much harder time breaking free of grabs as well as creating and holding onto grabs on other people."
	cost = -2
	var_changes = list("grab_resist_divisor_victims" = 0.5, "grab_resist_divisor_self" = 3, "grab_power_victims" = 1, "grab_power_self" = -1)
	category = TRAIT_TYPE_NEGATIVE
