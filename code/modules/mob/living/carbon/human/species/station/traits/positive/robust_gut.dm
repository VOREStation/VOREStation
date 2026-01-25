/datum/trait/toxin_gut
	name ="Robust Gut"
	desc = "You are immune to most ingested toxins. Does not protect from possible harm caused by other drugs, meds, allergens etc."
	cost = 1
	custom_only = FALSE
	category = TRAIT_TYPE_POSITIVE

/datum/trait/toxin_gut/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	ADD_TRAIT(H, INGESTED_TOXIN_IMMUNE, ROUNDSTART_TRAIT)
