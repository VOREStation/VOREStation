/*
//////////////////////////////////////

Spyndrome

	Slightly hidden.
	No change to resistance.
	Increases stage speed.
	Little transmittable.
	Low Level.

BONUS
	Makes the host spin.

//////////////////////////////////////
*/

/datum/symptom/spyndrome
	name = "Spyndrome"
	desc = "The virus hijacks the host's motor system, making them spin incontrollably."
	stealth = -1
	resistance = 3
	stage_speed = 3
	transmission = 1
	level = 1
	symptom_delay_min = 15 SECONDS
	symptom_delay_max = 35 SECONDS
	severity = 0
	threshold_descs = list(
		"Resistance 6" = "The target will spin more violently."
	)

	var/bigspin = FALSE

	prefixes = list("Spinning ", "Rotatory ")
	bodies = list("Rotato")

/datum/symptom/spyndrome/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.resistance >= 6)
		bigspin = TRUE

/datum/symptom/spyndrome/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/M = A.affected_mob
	switch(A.stage)
		if(1 to 3)
			if(prob(base_message_chance))
				to_chat(M, span_notice("You can't stand still."))
		else
			if(bigspin)
				M.emote("floorspin")
			else
				M.emote("spin")
