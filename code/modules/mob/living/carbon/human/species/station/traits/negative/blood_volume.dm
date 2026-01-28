/datum/trait/less_blood
	name = "Low Blood Volume"
	desc = "You have 33.3% less blood volume compared to most species, making you more prone to blood loss issues."
	cost = -2
	var_changes = list("blood_volume" = 375)
	excludes = list(/datum/trait/less_blood_extreme)
	can_take = ORGANICS
	category = TRAIT_TYPE_NEGATIVE

/datum/trait/less_blood_extreme
	name = "Low Blood Volume, Extreme"
	desc = "You have 60% less blood volume compared to most species, making you much more prone to blood loss issues."
	cost = -3
	var_changes = list("blood_volume" = 224)
	excludes = list(/datum/trait/less_blood)
	can_take = ORGANICS
	category = TRAIT_TYPE_NEGATIVE
