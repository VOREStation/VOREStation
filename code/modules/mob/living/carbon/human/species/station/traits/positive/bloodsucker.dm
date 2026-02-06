/datum/trait/bloodsucker_plus
	name = "Evolved Bloodsucker"
	desc = "Makes you able to gain nutrition by draining blood as well as eating food. To compensate, you get fangs that can be used to drain blood from prey."
	cost = 1
	var_changes = list("organic_food_coeff" = 0.5)
	excludes = list(/datum/trait/bloodsucker)
	category = TRAIT_TYPE_POSITIVE

/datum/trait/bloodsucker_plus/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	add_verb(H,/mob/living/carbon/human/proc/bloodsuck)
