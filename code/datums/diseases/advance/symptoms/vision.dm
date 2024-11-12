/*
//////////////////////////////////////

Hyphema (Eye bleeding)

	Slightly noticable.
	Lowers resistance tremendously.
	Decreases stage speed tremendously.
	Decreases transmittablity.
	Critical Level.

Bonus
	Causes blindness.

//////////////////////////////////////
*/

/datum/symptom/visionloss
	name = "Hyphema"
	stealth = -1
	resistance = -4
	stage_speed = -4
	transmittable = -3
	level = 5
	severity = 4

/datum/symptom/visionloss/Activate(datum/disease/advance/A)
	..()
	if(prob(SYMPTOM_ACTIVATION_PROB))
		var/mob/living/carbon/M = A.affected_mob
		var/obj/item/organ/internal/eyes/eyes = M.internal_organs_by_name[O_EYES]
		if(!eyes)
			return
		switch(A.stage)
			if(1, 2)
				to_chat(M, span_warning("Your eyes itch."))
			if(3, 4)
				to_chat(M, span_boldwarning("Your eyes burn!"))
				M.eye_blurry = 20
				eyes.take_damage(1)
			else
				to_chat(M, span_userdanger("Your eyes burn horrificly!"))
				M.eye_blurry = 40
				eyes.take_damage(5)
				if(eyes.damage >= 10)
					M.disabilities |= NEARSIGHTED
					if(prob(eyes.damage - 10 + 1))
						if(!M.eye_blind)
							to_chat(M, span_userdanger("You go blind!"))
							M.Blind(20)
