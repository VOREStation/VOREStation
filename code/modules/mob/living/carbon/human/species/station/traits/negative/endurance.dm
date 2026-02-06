/datum/trait/endurance_low
	name = "Low Endurance"
	desc = "Reduces your maximum total hitpoints to 75."
	cost = -2
	var_changes = list("total_health" = 75)
	custom_only = FALSE
	banned_species = list(SPECIES_TESHARI, SPECIES_SHADEKIN_CREW) //These are already this weak.
	category = TRAIT_TYPE_NEGATIVE


/datum/trait/endurance_low/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.setMaxHealth(S.total_health)

/datum/trait/endurance_very_low
	name = "Low Endurance, Major"
	desc = "Reduces your maximum total hitpoints to 50."
	cost = -3 //Teshari HP. This makes the person a lot more suseptable to getting stunned, killed, etc.
	var_changes = list("total_health" = 50)
	custom_only = FALSE
	banned_species = list(SPECIES_TESHARI) //These are already this weak.
	category = TRAIT_TYPE_NEGATIVE


/datum/trait/endurance_very_low/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.setMaxHealth(S.total_health)

/datum/trait/endurance_glass // Glass Cannon
	name = "Glass Endurance"
	desc = "Your body is very fragile. Reduces your maximum hitpoints to 25. Beware sneezes. You require only 50 damage in total to die, compared to 200 normally. You will go into crit after losing 25 HP, compared to crit at 100 HP."
	cost = -12 // Similar to Very Low Endurance, this straight up will require you NEVER getting in a fight. This is extremely crippling. I salute the madlad that takes this.
	var_changes = list("total_health" = 25)
	category = TRAIT_TYPE_NEGATIVE


/datum/trait/endurance_glass/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.setMaxHealth(S.total_health)
