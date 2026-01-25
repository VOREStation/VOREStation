/datum/trait/hardy
	name = "Hardy"
	desc = "Allows you to carry heavy equipment with less slowdown."
	cost = 1
	var_changes = list("item_slowdown_mod" = 0.5)
	custom_only = FALSE
	banned_species = list(SPECIES_ALRAUNE, SPECIES_TESHARI, SPECIES_UNATHI, SPECIES_DIONA, SPECIES_PROMETHEAN, SPECIES_PROTEAN) //Either not applicable or buffs are too strong
	category = TRAIT_TYPE_POSITIVE

/datum/trait/hardy_plus
	name = "Hardy, Major"
	desc = "Allows you to carry heavy equipment with almost no slowdown."
	cost = 2
	var_changes = list("item_slowdown_mod" = 0.25)
	banned_species = list(SPECIES_ALRAUNE, SPECIES_TESHARI, SPECIES_UNATHI, SPECIES_DIONA, SPECIES_PROMETHEAN, SPECIES_PROTEAN) //Either not applicable or buffs are too strong
	category = TRAIT_TYPE_POSITIVE
	custom_only = FALSE

/datum/trait/hardy_extreme
	name = "Hardy, Extreme"
	desc = "Allows you to carry heavy equipment with no slowdown at all."
	cost = 3
	var_changes = list("item_slowdown_mod" = 0.0)
	excludes = list(/datum/trait/speed_fast,/datum/trait/hardy,/datum/trait/hardy_plus)
	category = TRAIT_TYPE_POSITIVE
