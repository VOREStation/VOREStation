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

//////////////////////////////////////
*/

/datum/symptom/spyndrome
	name = "Flippinov"
	desc = "The virus hijacks the host's motor system, making them flip incontrollably."
	stealth = 2
	resistance = 0
	stage_speed = 3
	transmission = 1
	level = 1
	severity = 0

	threshold_descs = list(
		"Resistance 5" = "The host will flip more violently"
	)

/datum/symptom/spyndrome/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/M = A.affected_mob
	if(prob(base_message_chance) && M.stat != DEAD)
		if(prob(base_message_chance) && A.resistance >= 5)
			M.emote("floorspin")
		else if(prob(base_message_chance))
			M.emote("spin")
