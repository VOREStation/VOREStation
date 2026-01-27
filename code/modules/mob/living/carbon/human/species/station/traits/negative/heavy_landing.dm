/datum/trait/heavy_landing
	name = "Heavy Landing"
	desc = "Your heavy frame causes you to crash heavily when falling from heights. The bigger they are, the harder they fall!"
	cost = -1
	var_changes = list("soft_landing" = FALSE) //override soft landing if the species would otherwise start with it
	custom_only = FALSE
	excludes = list(/datum/trait/soft_landing)
	category = TRAIT_TYPE_NEGATIVE


/datum/trait/heavy_landing/apply(datum/species/S, mob/living/carbon/human/H, trait_prefs)
	..()
	ADD_TRAIT(H, TRAIT_HEAVY_LANDING, ROUNDSTART_TRAIT)
