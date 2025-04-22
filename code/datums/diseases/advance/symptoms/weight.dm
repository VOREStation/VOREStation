/*
//////////////////////////////////////

Weight Loss

	Very Very Noticable.
	Decreases resistance.
	Decreases stage speed.
	Reduced Transmittable.
	High level.

Bonus
	Decreases the weight of the mob,
	forcing it to be skinny.

//////////////////////////////////////
*/

/datum/symptom/weight_loss
	name = "Weight Loss"
	desc = "The virus mutates the host's metabolism, making it almost unable to gain nutrition from food."
	stealth = 0
	resistance = 2
	stage_speed = -2
	transmission = -1
	level = 3
	severity = 2
	base_message_chance = 100
	symptom_delay_min = 15 SECONDS
	symptom_delay_max = 45 SECONDS

	var/starving = TRUE

	threshold_descs = list(
		"Stealth 2" = "The symptom is less noticeable, and does not cause starvation."
	)

/datum/symptom/weight_loss/severityset(datum/disease/advance/A)
	. = ..()
	if(A.stealth >= 2)
		severity -= 3

/datum/symptom/weight_loss/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.stealth >= 2)
		base_message_chance = 25
		starving = FALSE

/datum/symptom/weight_loss/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/M = A.affected_mob
	if(M.stat == DEAD)
		return
	switch(A.stage)
		if(1, 2, 3, 4)
			if(prob(base_message_chance))
				to_chat(M, span_warning(pick("You feel hungry.", "You crave for food.")))
		else
			if(prob(base_message_chance))
				to_chat(M, span_warning(pick("So hungry...", "You'd kill someone for a bite of food...", "Hunger cramps seize you...")))
			M.adjust_nutrition(rand(10, 50))
			if(starving)
				M.adjust_nutrition(-100)
