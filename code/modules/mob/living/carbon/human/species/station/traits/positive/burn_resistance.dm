/datum/trait/minor_burn_resist
	name = "Burn Resist, Minor"
	desc = "Adds 15% resistance to burn damage sources."
	cost = 2
	var_changes = list("burn_mod" = 0.85)
	excludes = list(/datum/trait/burn_resist, /datum/trait/burn_resist_plus)
	category = TRAIT_TYPE_POSITIVE

/datum/trait/burn_resist
	name = "Burn Resist"
	desc = "Adds 25% resistance to burn damage sources."
	cost = 3
	var_changes = list("burn_mod" = 0.75)
	excludes = list(/datum/trait/minor_burn_resist, /datum/trait/burn_resist_plus)
	category = TRAIT_TYPE_POSITIVE

/datum/trait/burn_resist_plus // Equivalent to Burn Weakness Major, cannot be taken at the same time.
	name = "Burn Resist, Major"
	desc = "Adds 40% resistance to burn damage sources."
	cost = 4 // Exact Opposite of Burn Weakness Major, except Weakness Major is 50% incoming, this is -40% incoming.
	var_changes = list("burn_mod" = 0.6)
	excludes = list(/datum/trait/burn_resist, /datum/trait/minor_burn_resist)
	category = TRAIT_TYPE_POSITIVE
