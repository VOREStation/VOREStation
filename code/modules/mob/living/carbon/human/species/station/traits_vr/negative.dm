/datum/trait/speed_slow
	name = "Slowdown"
	desc = "Allows you to move slower on average than baseline."
	cost = -1
	var_changes = list("slowdown" = 0.5)

/datum/trait/speed_slow_plus
	name = "Slowdown (Plus)"
	desc = "Allows you to move MUCH slower on average than baseline."
	cost = -2
	var_changes = list("slowdown" = 1.0)

/datum/trait/weakling
	name = "Weakling"
	desc = "Causes heavy equipment to slow you down more when carried."
	cost = -1
	var_changes = list("item_slowdown_mod" = 1.5)

/datum/trait/weakling_plus
	name = "Weakling (Plus)"
	desc = "Allows you to carry heavy equipment with much more slowdown."
	cost = -2
	var_changes = list("item_slowdown_mod" = 2.0)

/datum/trait/endurance_low
	name = "Low Endurance"
	desc = "Reduces your maximum total hitpoints."
	cost = -2
	var_changes = list("total_health" = 75)

	apply(var/datum/species/S,var/mob/living/carbon/human/H)
		..(S,H)
		H.setMaxHealth(S.total_health)

/datum/trait/brute_weak
	name = "Brute Weakness"
	desc = "Increases damage from brute damage sources."
	cost = -1
	var_changes = list("brute_mod" = 1.15)

/datum/trait/brute_weak_plus
	name = "Brute Weakness (Plus)"
	desc = "Increases damage significantly from brute damage sources."
	cost = -2
	var_changes = list("brute_mod" = 1.30)

/datum/trait/burn_weak
	name = "Burn Weakness"
	desc = "Increases damage from burn damage sources."
	cost = -1
	var_changes = list("burn_mod" = 1.15)

/datum/trait/burn_weak_plus
	name = "Burn Weakness (Plus)"
	desc = "Increases damage significantly from burn damage sources."
	cost = -2
	var_changes = list("burn_mod" = 1.30)

/datum/trait/conductive
	name = "Conductive"
	desc = "Increases your susceptibility to electric shocks by a small amount."
	cost = -1
	var_changes = list("siemens_coefficient" = 1.15)

/datum/trait/conductive_plus
	name = "Conductive (Plus)"
	desc = "Increases your susceptibility to electric shocks by a moderate amount."
	cost = -2
	var_changes = list("siemens_coefficient" = 1.3)

/datum/trait/photosensitive
	name = "Photosensitive"
	desc = "Increases stun duration from flashes and other light-based stuns."
	cost = -1
	var_changes = list("flash_mod" = 2.0)
