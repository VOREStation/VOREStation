
/datum/trait/slip_reflex
	name ="Slippery Reflexes"
	desc = "Your reflexes are quick enough to react to slippery surfaces. You are not immune though."
	cost = 0
	category = TRAIT_TYPE_NEUTRAL

/datum/trait/slip_reflex/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	ADD_TRAIT(H, SLIP_REFLEX_TRAIT, ROUNDSTART_TRAIT)
