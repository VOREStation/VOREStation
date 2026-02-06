/datum/trait/insect_sting
	name = "Insect Sting"
	desc = "Allows you to sting your victim with a smalll amount of poison"
	cost = 1
	category = TRAIT_TYPE_POSITIVE

/datum/trait/insect_sting/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	add_verb(H,/mob/living/proc/insect_sting)
