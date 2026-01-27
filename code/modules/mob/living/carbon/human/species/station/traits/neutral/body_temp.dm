/datum/trait/highbodytemp
	name = "Body Temp., Hot"
	desc = "Your body's temperature is hotter than the galactic average. This doesn't change what temperatures you can handle."
	cost = 0
	var_changes = list("body_temperature" = 330)
	excludes = list(/datum/trait/lowbodytemp)
	category = TRAIT_TYPE_NEUTRAL

/datum/trait/lowbodytemp
	name = "Body Temp., Cold"
	desc = "Your body's temperature is colder than the galactic average. This doesn't change what temperatures you can handle."
	cost = 0
	var_changes = list("body_temperature" = 290)
	excludes = list(/datum/trait/highbodytemp)
	category = TRAIT_TYPE_NEUTRAL
