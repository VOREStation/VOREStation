/datum/trait/speed_fast
	name = "Haste"
	desc = "Allows you to move faster on average than baseline."
	cost = 3
	var_changes = list("slowdown" = -0.5)

/datum/trait/speed_fast_plus
	name = "Major Haste"
	desc = "Allows you to move MUCH faster on average than baseline."
	cost = 5
	var_changes = list("slowdown" = -1.0)

/datum/trait/hardy
	name = "Hardy"
	desc = "Allows you to carry heavy equipment with less slowdown."
	cost = 1
	var_changes = list("item_slowdown_mod" = 0.5)

/datum/trait/hardy_plus
	name = "Major Hardy"
	desc = "Allows you to carry heavy equipment with almost no slowdown."
	cost = 2
	var_changes = list("item_slowdown_mod" = 0.1)

/datum/trait/endurance_high
	name = "High Endurance"
	desc = "Increases your maximum total hitpoints to 125"
	cost = 2
	var_changes = list("total_health" = 125)

	apply(var/datum/species/S,var/mob/living/carbon/human/H)
		..(S,H)
		H.setMaxHealth(S.total_health)

/datum/trait/endurance_very_high
	name = "Very High Endurance"
	desc = "Increases your maximum total hitpoints to 150"
	cost = 3
	var_changes = list("total_health" = 150)

	apply(var/datum/species/S,var/mob/living/carbon/human/H)
		..(S,H)
		H.setMaxHealth(S.total_health)

/datum/trait/nonconductive
	name = "Non-Conductive"
	desc = "Decreases your susceptibility to electric shocks by a 25% amount."
	cost = 2 //This effects tasers!
	var_changes = list("siemens_coefficient" = 0.75)

/datum/trait/nonconductive_plus
	name = "Major Non-Conductive"
	desc = "Decreases your susceptibility to electric shocks by a 50% amount."
	cost = 3 //Let us not forget this effects tasers!
	var_changes = list("siemens_coefficient" = 0.5)

/datum/trait/darksight
	name = "Darksight"
	desc = "Allows you to see a short distance in the dark."
	cost = 1
	var_changes = list("darksight" = 3)

/datum/trait/darksight_plus
	name = "Darksight (Major)"
	desc = "Allows you to see in the dark for the whole screen."
	cost = 2
	var_changes = list("darksight" = 7)

/datum/trait/melee_attack
	name = "Sharp Melee"
	desc = "Provides sharp melee attacks that do slightly more damage."
	cost = 1
	var_changes = list("unarmed_types" = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp))

/datum/trait/melee_attack_fangs
	name = "Sharp Melee & Numbing Fangs"
	desc = "Provides sharp melee attacks that do slightly more damage, along with fangs that makes the person bit unable to feel their body or pain."
	cost = 2
	var_changes = list("unarmed_types" = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp, /datum/unarmed_attack/bite/sharp/numbing))

/datum/trait/minor_brute_resist
	name = "Minor Brute Resist"
	desc = "Adds 15% resistance to brute damage sources."
	cost = 1
	var_changes = list("brute_mod" = 0.85)

/datum/trait/brute_resist
	name = "Brute Resist"
	desc = "Adds 25% resistance to brute damage sources."
	cost = 2
	var_changes = list("brute_mod" = 0.75)

/datum/trait/brute_resist_plus
	name = "Major Brute Resist"
	desc = "Adds 50% resistance to brute damage sources."
	cost = 3
	var_changes = list("brute_mod" = 0.5)

/datum/trait/minor_burn_resist
	name = "Minor Brute Resist"
	desc = "Adds 15% resistance to burn damage sources."
	cost = 1
	var_changes = list("burn_mod" = 0.85)

/datum/trait/burn_resist
	name = "Burn Resist"
	desc = "Adds 25% resistance to burn damage sources."
	cost = 2
	var_changes = list("burn_mod" = 0.75)

/datum/trait/burn_resist_plus
	name = "Major Burn Resist"
	desc = "Adds 50% resistance to burn damage sources."
	cost = 3
	var_changes = list("burn_mod" = 0.5)

/datum/trait/photoresistant
	name = "Photoresistant"
	desc = "Decreases stun duration from flashes and other light-based stuns and disabilities by 50%"
	cost = 1
	var_changes = list("flash_mod" = 0.5)
