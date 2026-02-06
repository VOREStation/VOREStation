/datum/trait/endurance_high
	name = "High Endurance"
	desc = "Increases your maximum total hitpoints to 125. You require 250 damage in total to die, compared to 200 normally. You will still go into crit after losing 125 HP, compared to crit at 100 HP."
	cost = 3
	var_changes = list("total_health" = 125)
	custom_only = FALSE
	excludes = list(/datum/trait/endurance_very_high, /datum/trait/endurance_extremely_high)
	banned_species = list(SPECIES_TESHARI, SPECIES_UNATHI, SPECIES_SHADEKIN_CREW) //Either not applicable or buffs are too strong
	category = TRAIT_TYPE_POSITIVE

/datum/trait/endurance_high/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.setMaxHealth(S.total_health)

/datum/trait/endurance_very_high
	name = "High Endurance, Major"
	desc = "Increases your maximum total hitpoints to 150. You require 300 damage in total to die, compared to 200 normally. You will still go into crit after losing 150 HP, compared to crit at 100 HP."
	cost = 6 // This should cost a LOT, because your total health becomes 300 to be fully dead, rather than 200 normally, or 250 for High Endurance. HE costs 3, double it here.
	var_changes = list("total_health" = 150)
	excludes = list(/datum/trait/endurance_high, /datum/trait/endurance_extremely_high)
	category = TRAIT_TYPE_POSITIVE

/datum/trait/endurance_very_high/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.setMaxHealth(S.total_health)

/datum/trait/endurance_extremely_high
	name = "High Endurance, Extreme"
	desc = "Increases your maximum total hitpoints to 175. You require 350 damage in total to die, compared to 200 normally. You will still go into crit after losing 175 HP, compared to crit at 100 HP."
	cost = 9 // This should cost a LOT, because your total health becomes 350 to be fully dead, rather than 200 normally, or 250 for High Endurance. HE costs 3, this costs 3x it.
	var_changes = list("total_health" = 175)
	excludes = list(/datum/trait/endurance_high, /datum/trait/endurance_very_high)
	category = TRAIT_TYPE_POSITIVE

/datum/trait/endurance_extremely_high/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.setMaxHealth(S.total_health)
