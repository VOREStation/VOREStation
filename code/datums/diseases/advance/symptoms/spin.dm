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
	stealth = 2
	resistance = 0
	stage_speed = 3
	transmission = 1
	level = 1
	symptom_delay_min = 15 SECONDS
	symptom_delay_max = 35 SECONDS
	severity = 0
	threshold_descs = list(
		"Resistance 6" = "The target will flip more violently."
	)

	var/bigspin = FALSE

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
		if(1, 2, 3)
			if(prob(base_message_chance))
				to_chat(M, span_notice("You can't stand still."))
		else
			if(bigspin)
				M.emote("floorspin")
			else
				M.emote("spin")
