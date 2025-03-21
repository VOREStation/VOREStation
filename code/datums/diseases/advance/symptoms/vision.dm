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
	desc = "The virus causes inflammation of the retina, leading to eye damage and eventually blindness."
	stealth = -1
	resistance = -3
	stage_speed = -4
	transmission = -2
	level = 3
	severity = 2
	base_message_chance = 50
	symptom_delay_min = 30 SECONDS
	symptom_delay_max = 80 SECONDS

	var/remove_eyes = FALSE

	threshold_descs = list(
		"Resistance 12" = "Weakens extraocular muscles, eventually leading to complete detachment of the eyes.",
		"Stealth 4" = "The symptom remains hidden until active."
	)

/datum/symptom/visionloss/severityset(datum/disease/advance/A)
	. = ..()
	if(A.resistance >= 12)
		severity += 1

/datum/symptom/visionloss/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.stealth >= 4)
		supress_warning = TRUE
	if(A.resistance >= 12)
		remove_eyes = TRUE

/datum/symptom/visionloss/Activate(datum/disease/advance/A)
	if(!..())
		return
	if(iscarbon(A.affected_mob))
		var/mob/living/carbon/M = A.affected_mob
		var/obj/item/organ/internal/eyes/eyes = M.internal_organs_by_name[O_EYES]
		if(!eyes)
			return
		switch(A.stage)
			if(1, 2)
				if(prob(base_message_chance) && !supress_warning && M.stat != DEAD)
					to_chat(M, span_warning("Your eyes itch."))
			if(3, 4)
				if(M.stat != DEAD)
					to_chat(M, span_boldwarning("Your eyes burn!"))
				M.eye_blurry = 20
				eyes.take_damage(1)
			else
				M.eye_blurry += 20
				eyes.take_damage(5)
				if(eyes.damage >= 10)
					M.disabilities |= NEARSIGHTED
				if(prob(eyes.damage - 10 + 1))
					if(!remove_eyes)
						if(!M.is_blind())
							if(M.stat != DEAD)
								to_chat(M, span_userdanger("You go blind!"))
							eyes.take_damage(eyes.max_damage)
					else
						M.visible_message(span_warning("[M]'s eyes fall out of their sockets!"), span_userdanger("Your eyes out of their sockets!"))
						eyes.forceMove(get_turf(M))

				else
					if(M.stat != DEAD)
						to_chat(M, span_userdanger("Your eyes burn horrifically!"))
