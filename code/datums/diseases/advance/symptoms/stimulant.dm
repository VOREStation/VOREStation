/*
//////////////////////////////////////

Healing

	No change to stealth.
	Slightly decreases resistance.
	Increases stage speed.
	Decreases transmittablity considerably.
	Moderate Level.

Bonus
	Heals toxins in the affected mob's blood stream.

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
				if(L.reagents.get_reagent_amount("hyperzine" < 10))
					L.reagents.add_reagent("hyperzine", 5)
				if(prob(30))
					L.jitteriness += 15
	return
