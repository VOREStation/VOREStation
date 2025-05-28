/*
//////////////////////////////////////

Confusion

	Little bit hidden.
	Lowers resistance.
	Decreases stage speed.
	Not very transmittable.
	Intense Level.

Bonus
	Makes the affected mob be confused for short periods of time.

//////////////////////////////////////
*/

/datum/symptom/confusion
	name = "Confusion"
	desc = "The virus interferes with the proper function of the neural system, leading to bouts of confusion and erratic movement."
	stealth = 1
	resistance = -1
	stage_speed = -3
	transmission = 0
	level = 3
	severity = 2
	base_message_chance = 25
	symptom_delay_min = 15 SECONDS
	symptom_delay_max = 30 SECONDS

	threshold_descs = list(
		"Transmission 6" = "Increases confusion duration.",
		"Stealth 4" = "The symptom remains hidden until active."
	)

/datum/symptom/confusion/severityset(datum/disease/advance/A)
	. = ..()
	if(A.resistance >= 6)
		severity += 1

/datum/symptom/confusion/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.transmission >= 6)
		power = 1.5
	if(A.stealth >= 4)
		supress_warning = TRUE

/datum/symptom/confusion/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/L = A.affected_mob
	if(L.stat == DEAD)
		return
	switch(A.stage)
		if(1, 2, 3, 4)
			if(prob(base_message_chance) && !supress_warning)
				to_chat(L, span_warning(pick("Your head hurts", "Your mind blanks for a moment.")))
		else
			to_chat(L, span_userdanger("You can't think straight!"))
			L.confused = min(50 * power, L.confused+8)
