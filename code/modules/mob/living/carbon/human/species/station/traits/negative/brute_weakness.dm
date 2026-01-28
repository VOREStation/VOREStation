/datum/trait/minor_brute_weak
	name = "Brute Weakness, Minor"
	desc = "Increases damage from brute damage sources by 15%"
	cost = -1
	custom_only = FALSE
	var_changes = list("brute_mod" = 1.15)
	banned_species = list(SPECIES_TESHARI, SPECIES_TAJARAN, SPECIES_ZADDAT, SPECIES_SHADEKIN_CREW) //These are already this weak.
	category = TRAIT_TYPE_NEGATIVE

/datum/trait/brute_weak
	name = "Brute Weakness"
	desc = "Increases damage from brute damage sources by 25%"
	cost = -2
	custom_only = FALSE
	var_changes = list("brute_mod" = 1.25)
	banned_species = list(SPECIES_TESHARI, SPECIES_SHADEKIN_CREW) //These are already this weak.
	category = TRAIT_TYPE_NEGATIVE

/datum/trait/brute_weak_plus
	name = "Brute Weakness, Major"
	desc = "Increases damage from brute damage sources by 50%"
	cost = -3
	custom_only = FALSE
	var_changes = list("brute_mod" = 1.5)
	category = TRAIT_TYPE_NEGATIVE
