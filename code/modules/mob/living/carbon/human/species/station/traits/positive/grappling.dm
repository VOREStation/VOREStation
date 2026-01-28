/datum/trait/grappling_expert
	name = "Grappling Expert"
	desc = "Your grabs are much harder to escape from, and you are better at escaping from other's grabs!"
	cost = 3
	var_changes = list("grab_resist_divisor_victims" = 1.5, "grab_resist_divisor_self" = 0.5, "grab_power_victims" = -1, "grab_power_self" = 1)
	category = TRAIT_TYPE_POSITIVE
