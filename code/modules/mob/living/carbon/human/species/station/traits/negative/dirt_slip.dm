/datum/trait/slipperydirt
	name = "Dirt Vulnerability"
	desc = "Even the tiniest particles of dirt give you uneasy footing, even through several layers of footwear."
	cost = -5
	var_changes = list("dirtslip" = TRUE)
	excludes = list(/datum/trait/absorbent)
	category = TRAIT_TYPE_NEGATIVE
