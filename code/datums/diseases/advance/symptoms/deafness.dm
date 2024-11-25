/*
//////////////////////////////////////

Deafness

	Slightly hidden.
	Lowers resistance.
	Increases stage speed slightly.
	Decreases transmittablity.
	Intense Level.

Bonus
	Causes intermittent loss of hearing.

//////////////////////////////////////
*/

/datum/symptom/deafness
	name = "Deafness"
	stealth = 1
	resistance = -2
	stage_speed = 1
	transmittable = -3
	level = 4
	severity = 3

/datum/symptom/deafness/Activate(datum/disease/advance/A)
	..()
	if(prob(SYMPTOM_ACTIVATION_PROB))
		var/mob/living/M = A.affected_mob

		switch(A.stage)
			if(3, 4)
				to_chat(M, span_warning("[pick("you hear a ringing in your ear.", "You ears pop.")]"))
			if(5)
				to_chat(M, span_userdanger("You ear pop and begin ringing loudly!"))
				M.ear_deaf += 20
	return
