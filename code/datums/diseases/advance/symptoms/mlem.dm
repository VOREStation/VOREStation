/*
//////////////////////////////////////

Mlemingtong

	Not noticable or unnoticable.
	Resistant.
	Increases stage speed.
	Little transmittable.
	Low Level.

BONUS
	Mlem. Mlem. Mlem.
	Should be used for buffing your disease.

//////////////////////////////////////
*/

/datum/symptom/mlem
	name = "Mlemington"
	stealth = 0
	resistance = 3
	stage_speed = 3
	transmittable = 1
	level = 1
	severity = 1

/datum/symptom/itching/Activate(var/datum/disease/advance/A)
	..()
	if(prob(SYMPTOM_ACTIVATION_PROB))
		var/mob/living/M = A.affected_mob
		M.emote("mlem")
	return
