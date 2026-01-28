/datum/trait/nodefib
	name = "Unreviveable"
	desc = "For whatever strange genetic reason, defibs cannot restart your heart."
	cost = -1
	custom_only = FALSE
	var_changes = list("flags" = NO_DEFIB)
	can_take = ORGANICS
	excludes = list(/datum/trait/noresleeve, /datum/trait/onelife)
	category = TRAIT_TYPE_NEGATIVE


/datum/trait/noresleeve
	name = "Unsleeveable"
	desc = "Your genetics have been ruined, to the point where resleeving can no longer bring you back. Your DNA is unappealing to slimes as a result." //The autoresleever still resleeves on Virgo as that section has been commented out, but eh, whatever. It's not really a big concern. -1+-1 = -2 is all I care about.
	cost = -1
	custom_only = TRUE
	var_changes = list("flags" = NO_SLEEVE)
	excludes = list(/datum/trait/nodefib, /datum/trait/onelife)
	category = TRAIT_TYPE_NEGATIVE


/datum/trait/onelife
	name = "One Life"
	desc = "Once you are dead, you are incapable of being resleeved or revived using a defib."
	cost = -2
	custom_only = TRUE
	var_changes = list("flags" = NO_SLEEVE | NO_DEFIB)
	excludes = list(/datum/trait/nodefib, /datum/trait/noresleeve)
	category = TRAIT_TYPE_NEGATIVE
