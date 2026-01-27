/datum/trait/bad_swimmer
	name = "Bad Swimmer"
	desc = "You can't swim very well, all water slows you down a lot and you drown in deep water. You also swim up and down 25% slower."
	cost = -1
	custom_only = FALSE
	var_changes = list("bad_swimmer" = 1, "water_movement" = 4, "swim_mult" = 1.25)
	varchange_type = TRAIT_VARCHANGE_LESS_BETTER
	excludes = list(/datum/trait/good_swimmer)
	category = TRAIT_TYPE_NEGATIVE
