/datum/trait/minor_brute_resist
	name = "Brute Resist, Minor"
	desc = "Adds 15% resistance to brute damage sources."
	cost = 2
	var_changes = list("brute_mod" = 0.85)
	custom_only = FALSE
	banned_species = list(SPECIES_TESHARI, SPECIES_UNATHI, SPECIES_XENOCHIMERA, SPECIES_VASILISSAN, SPECIES_WEREBEAST) //Most of these are already this resistant or stronger, or it'd be way too much of a boost for tesh.
	excludes = list(/datum/trait/brute_resist, /datum/trait/brute_resist_plus)
	category = TRAIT_TYPE_POSITIVE

/datum/trait/brute_resist
	name = "Brute Resist"
	desc = "Adds 25% resistance to brute damage sources."
	cost = 3
	var_changes = list("brute_mod" = 0.75)
	excludes = list(/datum/trait/minor_brute_resist, /datum/trait/brute_resist_plus)
	category = TRAIT_TYPE_POSITIVE

/datum/trait/brute_resist_plus // Equivalent to Brute Weakness Major, cannot be taken at the same time.
	name = "Brute Resist, Major"
	desc = "Adds 40% resistance to brute damage sources."
	cost = 4 // Exact Opposite of Brute Weakness Major, except Weakness Major is 50% incoming, this is -40% incoming.
	var_changes = list("brute_mod" = 0.6)
	excludes = list(/datum/trait/brute_resist, /datum/trait/minor_brute_resist)
	category = TRAIT_TYPE_POSITIVE
