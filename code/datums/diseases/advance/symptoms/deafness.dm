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
	desc = "The virus causes inflammation of the eardrums, causing intermittent deafness."
	stealth = -1
	resistance = -1
	stage_speed = 1
	transmission = -3
	level = 3
	severity = 2
	base_message_chance = 100
	symptom_delay_min = 25
	symptom_delay_max = 80

	threshold_descs = list(
		"Resistance 9" = "Causes permanent hearing loss.",
		"Stealth 4" = "The symptom remains hidden until active."
	)

/datum/symptom/deafness/severityset(datum/disease/advance/A)
	. = ..()
	if(A.resistance >= 9)
		severity += 1

/datum/symptom/deafness/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.stealth >= 4)
		supress_warning = TRUE
	if(A.resistance >= 9)
		power = 2

/datum/symptom/deafness/Activate(var/datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/carbon/M = A.affected_mob
	if(M.stat == DEAD)
		return
	switch(A.stage)
		if(3, 4)
			if(prob(base_message_chance) && !supress_warning)
				to_chat(M, span_warning(pick("You hear a ringing in your ears.", "Your ears pop.")))
