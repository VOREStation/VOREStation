/*
//////////////////////////////////////

Overactve Adrenal Gland

	No change to stealth.
	Slightly decreases resistance.
	Increases stage speed.
	Decreases transmittablity considerably.
	Moderate Level.

Bonus
	The host produces hyperzine and gets very jittery

//////////////////////////////////////
*/

/datum/symptom/stimulant
	name = "Overactive Adrenal Gland"
	stealth = 0
	resistance = -1
	stage_speed = 2
	transmittable = -3
	level = 3
	severity = 1

/datum/symptom/stimulant/Activate(datum/disease/advance/A)
	..()

	if(prob(SYMPTOM_ACTIVATION_PROB))
		var/mob/living/L = A.affected_mob
		to_chat(L, span_notice("You feel a rush of energy inside you!"))
		switch(A.stage)
			if(1, 2)
				L.jitteriness += 5
			if(3, 4)
				L.jitteriness += 10
			else
				if(L.reagents.get_reagent_amount(REAGENT_ID_HYPERZINE < 10))
					L.reagents.add_reagent(REAGENT_ID_HYPERZINE, 5)
				if(prob(30))
					L.jitteriness += 15
	return
