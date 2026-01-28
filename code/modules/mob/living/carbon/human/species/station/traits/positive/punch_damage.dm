/datum/trait/punchdamage
	name = "Strong Attacks"
	desc = "Your unarmed attacks deal more damage. (+5 per attack)"
	cost = 1
	custom_only = FALSE
	hidden = TRUE //Disabled on Virgo.
	var_changes = list("unarmed_bonus" = 5)
	excludes = list(/datum/trait/punchdamageplus)
	banned_species = list(SPECIES_TESHARI)
	category = TRAIT_TYPE_POSITIVE

/datum/trait/punchdamageplus
	name = "Crushing Attacks"
	desc = "Your unarmed attacks deal high damage. (+10 per attack)"
	cost = 2
	custom_only = FALSE
	hidden = TRUE //Disabled on Virgo.
	var_changes = list("unarmed_bonus" = 10)
	excludes = list(/datum/trait/punchdamage)
	banned_species = list(SPECIES_TESHARI, SPECIES_VOX)
	category = TRAIT_TYPE_POSITIVE

/datum/trait/shredding_attacks //Variant of plus
	name = "Shredding Attacks"
	desc = "Your unarmed attacks can break windows, APCs, deal massive damage to synthetics, and you can break out of restraints 24 times faster."
	cost = 6
	custom_only = FALSE
	hidden = TRUE
	var_changes = list("shredding" = TRUE)
	banned_species = list(SPECIES_TESHARI, SPECIES_VOX)
	category = TRAIT_TYPE_POSITIVE

/datum/trait/strength //combine effects of hardy + strong punches, for if someone wants a generally "strong" character. Exists for the purposes of the trait limit
	name = "High Strength"
	desc = "Your unarmed attacks deal more damage (+5), and you can carry heavy equipment with 50% less slowdown."
	cost = 2
	custom_only = FALSE
	hidden = TRUE //Disabled on Virgo.
	var_changes = list("unarmed_bonus" = 5, "item_slowdown_mod" = 0.5)
	excludes = list(/datum/trait/punchdamage, /datum/trait/hardy, /datum/trait/hardy_plus)
	banned_species = list(SPECIES_ALRAUNE, SPECIES_TESHARI, SPECIES_UNATHI, SPECIES_DIONA, SPECIES_PROMETHEAN, SPECIES_PROTEAN)
	category = TRAIT_TYPE_POSITIVE

/datum/trait/strengthplus //see above comment
	name = "Inhuman Strength"
	desc = "You are unreasonably strong. Your unarmed attacks do high damage (+10), you experience much less slowdown from heavy equipment (75% less)."
	cost = 4
	custom_only = FALSE
	hidden = TRUE //Disabled on Virgo.
	var_changes = list("unarmed_bonus" = 10, "item_slowdown_mod" = 0.25)
	excludes = list(/datum/trait/punchdamage, /datum/trait/hardy, /datum/trait/punchdamageplus, /datum/trait/hardy_plus)
	banned_species = list(SPECIES_ALRAUNE, SPECIES_TESHARI, SPECIES_UNATHI, SPECIES_DIONA, SPECIES_PROMETHEAN, SPECIES_PROTEAN, SPECIES_VOX)
	category = TRAIT_TYPE_POSITIVE
