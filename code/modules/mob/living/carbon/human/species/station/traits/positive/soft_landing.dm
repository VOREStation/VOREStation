/datum/trait/soft_landing
	name = "Soft Landing"
	desc = "You can fall from certain heights without suffering any injuries, be it via wings, lightness of frame or general dexterity."
	cost = 1
	var_changes = list("soft_landing" = TRUE)
	custom_only = FALSE
	excludes = list(/datum/trait/heavy_landing)
	category = TRAIT_TYPE_POSITIVE
