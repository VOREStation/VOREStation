/*
//////////////////////////////////////
Sensory-Restoration
	Very very very very noticable.
	Lowers resistance tremendously.
	Decreases stage speed tremendously.
	Decreases transmittablity tremendously.
	Fatal.
Bonus
	The body generates Sensory restorational chemicals.
	imidazoline for eyes
	removes alcohol
	removes hallucinogens
	alkysine to kickstart the mind

//////////////////////////////////////
*/
/datum/symptom/mind_restoration
	name = "Mind Restoration"
	stealth = -3
	resistance = -4
	stage_speed = -4
	transmission = -3
	level = 5
	severity = 0

/datum/symptom/mind_restoration/Activate(datum/disease/advance/A)
	..()
	if(prob(SYMPTOM_ACTIVATION_PROB * 3))
		var/mob/living/M = A.affected_mob

		if(A.stage >= 3)
			M.slurring = max(0, M.slurring-4)
			M.druggy = max(0, M.druggy-4)
			M.reagents.remove_reagent(REAGENT_ID_ETHANOL, 3)
		if(A.stage >= 4)
			M.drowsyness = max(0, M.drowsyness-4)
			if(M.reagents.has_reagent(REAGENT_ID_BLISS))
				M.reagents.del_reagent(REAGENT_ID_BLISS)
			M.hallucination = max(0, M.hallucination-4)
		if(A.stage >= 5)
			if(M.reagents.get_reagent_amount(REAGENT_ID_ALKYSINE) < 10)
				M.reagents.add_reagent(REAGENT_ID_ALKYSINE, 5)

/datum/symptom/sensory_restoration
	name = "Sensory Restoration"
	stealth = -1
	resistance = -3
	stage_speed = -2
	transmission = -4
	level = 4

/datum/symptom/sensory_restoration/Activate(datum/disease/advance/A)
	..()
	if(prob(SYMPTOM_ACTIVATION_PROB * 5))
		var/mob/living/M = A.affected_mob
		switch(A.stage)
			if(4, 5)
				if(M.reagents.get_reagent_amount(REAGENT_ID_IMIDAZOLINE) < 10)
					M.reagents.add_reagent(REAGENT_ID_IMIDAZOLINE, 5)
			else
				if(prob(SYMPTOM_ACTIVATION_PROB))
					to_chat(M, span_notice(pick("Your eyes feel great.","You feel like your eyes can focus more clearly.", "You don't feel the need to blink.")))
