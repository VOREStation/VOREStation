/*
//////////////////////////////////////

Coughing

	Noticable.
	Little Resistance.
	Doesn't increase stage speed much.
	Transmittable.
	Low Level.

BONUS
	Will force the affected mob to drop small items. Small spread if not wearing a mask.

//////////////////////////////////////
*/

/datum/symptom/cough
	name = "Cough"
	stealth = -1
	resistance = 3
	stage_speed = 1
	transmittable = 2
	level = 1
	severity = 1

/datum/symptom/cough/Activate(var/datum/disease/advance/A)
	..()
	if(prob(SYMPTOM_ACTIVATION_PROB))
		var/mob/living/M = A.affected_mob
		switch(A.stage)
			if(1, 2, 3)
				to_chat(M, span_warning(pick("You swallow excess mucus", "You lightly cough.")))
			else
				M.emote("cough")
				var/obj/item/I = M.get_active_hand()
				if(I && I.w_class == ITEMSIZE_SMALL)
					M.drop_item()
				if(!M.wear_mask) // Small spread if not wearing a mask
					A.spread(2)
	return
