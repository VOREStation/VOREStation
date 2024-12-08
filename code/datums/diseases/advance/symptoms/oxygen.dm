/*
//////////////////////////////////////

Self-Respiration

	Slightly hidden.
	Lowers resistance significantly.
	Decreases stage speed significantly.
	Decreases transmittablity tremendously.
	Fatal Level.

Bonus
	The body generates dexalin.

//////////////////////////////////////
*/

/datum/symptom/oxygen
	name = "Self-Respiration"
	stealth = 1
	resistance = -3
	stage_speed = -3
	transmittable = -4
	level = 6

/datum/symptom/oxygen/Activate(var/datum/disease/advance/A)
	..()
	if(prob(SYMPTOM_ACTIVATION_PROB * 5))
		var/mob/living/M = A.affected_mob
		switch(A.stage)
			if(4, 5)
				if(M.reagents.get_reagent_amount(REAGENT_ID_DEXALIN) < 10)
					M.reagents.add_reagent(REAGENT_ID_DEXALIN, 10)
			else
				if(prob(SYMPTOM_ACTIVATION_PROB * 5))
					to_chat(M, span_notice(pick("Your lungs feel great.", "You realize you haven't been breathing.", "You don't feel the need to breathe.")))
	return
