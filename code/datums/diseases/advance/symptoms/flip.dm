/*
//////////////////////////////////////

Flippinov

	Slightly hidden.
	No change to resistance.
	Increases stage speed.
	Little transmittable.
	Low Level.

BONUS
	Makes the host FLIP.
	Should be used for buffing your disease.

//////////////////////////////////////
*/

/datum/symptom/spyndrome
	name = "Flippinov"
	stealth = 2
	resistance = 0
	stage_speed = 3
	transmittable = 1
	level = 1
	severity = 1

/datum/symptom/spyndrome/Activate(datum/disease/advance/A)
	..()

	if(prob(SYMPTOM_ACTIVATION_PROB))
		var/mob/living/L = A.affected_mob
		L.emote("flip")
