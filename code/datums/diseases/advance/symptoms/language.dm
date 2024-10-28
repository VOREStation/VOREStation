/*
//////////////////////////////////////

Lingual Disocation

	Improves stealth.
	Increases resistance.
	Decreases stage speed.
	Slightly decreases transmissibility.
	Moderate Level.

Bonus
	Forces the affected mob to vomit

//////////////////////////////////////
*/

/datum/symptom/language
	name = "Lingual Disocation"
	stealth = 3
	resistance = 2
	stage_speed = -2
	transmittable = -1
	level = 3

/datum/symptom/language/Activate(var/datum/disease/advance/A)
	..()
	if(prob(SYMPTOM_ACTIVATION_PROB))
		var/mob/living/carbon/human/H = A.affected_mob
		H.apply_default_language(pick(H.languages))
	return
