/datum/trait/succubus_drain
	name = "Succubus Drain"
	desc = "Makes you able to gain nutrition from draining prey in your grasp."
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL

/datum/trait/succubus_drain/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	add_verb(H, /mob/living/carbon/human/proc/succubus_drain)
	add_verb(H, /mob/living/carbon/human/proc/succubus_drain_finalize)
	add_verb(H, /mob/living/carbon/human/proc/succubus_drain_lethal)
