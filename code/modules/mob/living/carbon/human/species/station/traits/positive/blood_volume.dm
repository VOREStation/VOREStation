/datum/trait/more_blood
	name = "Blood Volume, High"
	desc = "You have 50% more blood."
	cost = 2
	var_changes = list("blood_volume" = 840)
	excludes = list(/datum/trait/more_blood_extreme,/datum/trait/negative/less_blood,/datum/trait/negative/less_blood_extreme)
	can_take = ORGANICS
	custom_only = FALSE
	category = TRAIT_TYPE_POSITIVE

/datum/trait/more_blood_extreme
	name = "Blood Volume, Very High"
	desc = "You have 150% more blood."
	cost = 4
	var_changes = list("blood_volume" = 1400)
	excludes = list(/datum/trait/more_blood,/datum/trait/negative/less_blood,/datum/trait/negative/less_blood_extreme)
	can_take = ORGANICS
	category = TRAIT_TYPE_POSITIVE
