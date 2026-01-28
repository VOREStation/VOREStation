/datum/trait/alcohol_intolerance_advanced
	name = "Liver of Air"
	desc = "The only way you can hold a drink is if it's in your own two hands, and even then you'd best not inhale too deeply near it. Alcohol hits you three times as hard as they do other people."
	cost = 0
	custom_only = FALSE
	var_changes = list("chem_strength_alcohol" = 0.33)

	// Traitgenes Made into a gene trait
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="Your belly feels strange..."
	category = TRAIT_TYPE_NEUTRAL

/datum/trait/alcohol_intolerance_basic
	name = "Liver of Lilies"
	desc = "You have a hard time with alcohol. Maybe you just never took to it, or maybe it doesn't agree with your system... either way, alcohol hits you twice as hard."
	cost = 0
	custom_only = FALSE
	var_changes = list("chem_strength_alcohol" = 0.5)
	category = TRAIT_TYPE_NEUTRAL

/datum/trait/alcohol_intolerance_slight
	name = "Liver of Tulips"
	desc = "You are what some might call 'a bit of a lightweight', but you can still keep your drinks down... most of the time. Alcohol hits you fifty percent harder."
	cost = 0
	custom_only = FALSE
	var_changes = list("chem_strength_alcohol" = 0.75)
	category = TRAIT_TYPE_NEUTRAL

/datum/trait/alcohol_tolerance_reset
	name = "Liver of Unremarkableness"
	desc = "This trait exists to reset alcohol (in)tolerance for non-custom species to baseline normal. It can only be taken by Skrell, Tajara, Unathi, Diona, and Prometheans, as it would have no effect on other species."
	cost = 0
	custom_only = FALSE
	var_changes = list("chem_strength_alcohol" = 1)
	allowed_species = list(SPECIES_SKRELL,SPECIES_TAJARAN,SPECIES_UNATHI,SPECIES_DIONA,SPECIES_PROMETHEAN)
	category = TRAIT_TYPE_NEUTRAL

/datum/trait/alcohol_tolerance_basic
	name = "Liver of Iron"
	desc = "You can hold drinks much better than those lily-livered land-lubbers! Arr! Alcohol's effects on you are reduced by about a quarter."
	cost = 0
	custom_only = FALSE
	var_changes = list("chem_strength_alcohol" = 1.25)
	category = TRAIT_TYPE_NEUTRAL

/datum/trait/alcohol_tolerance_advanced
	name = "Liver of Steel"
	desc = "Drinks tremble before your might! You can hold your alcohol twice as well as those blue-bellied barnacle boilers! Alcohol has just half the effect on you as it does on others."
	cost = 0
	custom_only = FALSE
	var_changes = list("chem_strength_alcohol" = 2)
	category = TRAIT_TYPE_NEUTRAL

/datum/trait/alcohol_immunity
	name = "Liver of Durasteel"
	desc = "You've drunk so much that most booze doesn't even faze you. It takes something like a Pan-Galactic or a pint of Deathbell for you to even get slightly buzzed."
	cost = 0
	custom_only = FALSE
	var_changes = list("chem_strength_alcohol" = 4)
	category = TRAIT_TYPE_NEUTRAL

	// Traitgenes Made into a gene trait
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="Your belly feels strange..."
