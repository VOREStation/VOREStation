/*
//////////////////////////////////////

Photosensitivity

	Noticable.
	Increases resistance.
	Increases stage speed slightly.
	Decreases transmittablity tremendously.
	Fatal Level.

Bonus
	Deals brute damage over time.

//////////////////////////////////////
*/

/datum/symptom/photosensitivity
	name = "Photosensitivity"
	stealth = -2
	resistance = 2
	stage_speed = 1
	transmittable = -4
	level = 6
	severity = 5

/datum/symptom/photosensitivity/Activate(datum/disease/advance/A)
	..()

	if(prob(SYMPTOM_ACTIVATION_PROB))
		var/mob/living/carbon/human/H = A.affected_mob
		var/turf/T = get_turf(H)
		switch(A.stage)
			if(3)
				if(T.get_lumcount() > 0.5)
					to_chat(H, span_danger("Your skin itches under the light..."))
			if(4, 5)
				if(T.get_lumcount() > 0.5)
					to_chat(H, span_danger("Your skin feels like burning!"))
					H.adjustFireLoss(T.get_lumcount())
	return
