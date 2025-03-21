/*
//////////////////////////////////////

Choking

	Very very noticable.
	Lowers resistance.
	Decreases stage speed.
	Decreases transmittablity tremendously.
	Moderate Level.

Bonus
	Inflicts spikes of oxyloss

//////////////////////////////////////
*/

/datum/symptom/choking
	name = "Acute Respiratory Distress Syndrome"
	desc = "The virus causes shrinking of the host's lungs, causing severe asphyxiation."
	stealth = -2
	resistance = 0
	stage_speed = -1
	transmission = -2
	level = 9
	severity = 5
	naturally_occuring = FALSE
	base_message_chance = 15
	symptom_delay_min = 10 SECONDS
	symptom_delay_max = 30 SECONDS

	var/paralysis = FALSE

	threshold_descs = list(
		"Transmission 8" = "Doubles the damage caused by the symptom."
	)

/datum/symptom/choking/severityset(datum/disease/advance/A)
	. = ..()
	if(A.transmission >= 8)
		severity += 1

/datum/symptom/choking/Start(datum/disease/advance/A)
	if(!..())
		return

	if(A.transmission >= 8)
		power = 2

/datum/symptom/choking/Activate(datum/disease/advance/A)
	if(!..())
		return

	var/mob/living/M = A.affected_mob
	if(!M.needs_to_breathe() || M.stat == DEAD)
		return

	switch(A.stage)
		if(3, 4)
			to_chat(M, span_warning(pick("Your windpipe feels thin.", "Your lungs feel small-")))
			Choke_stage_3_4(M, A)
			M.emote("gasp")
		if(5)
			to_chat(M, span_userdanger(pick("Your lungs hurt!", "It hurts to breathe!")))
			Choke(M, A)
			M.emote("gasp")
	return

/datum/symptom/choking/proc/Choke_stage_3_4(mob/living/M, datum/disease/advance/A)
	var/get_damage = rand(5, 10) * power
	M.adjustOxyLoss(get_damage)
	return TRUE

/datum/symptom/choking/proc/Choke(mob/living/M, datum/disease/advance/A)
	var/get_damage = rand(2, 5) * power
	M.adjustOxyLoss(get_damage)
	return TRUE
