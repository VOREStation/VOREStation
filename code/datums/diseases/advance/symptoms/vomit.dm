/*
//////////////////////////////////////

Vomiting

	Noticeable.
	No change to resistance.
	Slightly increases stage speed.
	Increases transmissibility.
	Medium Level.

Bonus
	Forces the affected mob to vomit

//////////////////////////////////////
*/

/datum/symptom/vomit
	name = "Vomiting"
	stealth = -2
	resistance = 0
	stage_speed = 1
	transmittable = 2
	level = 3
	severity = 1

/datum/symptom/vomit/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/M = A.affected_mob
	if(prob(2))
		to_chat(M, span_warning(pick("you feel nauseated.", "You feel like you're going to throw up!")))
	if(prob(SYMPTOM_ACTIVATION_PROB))
		M.vomit()
