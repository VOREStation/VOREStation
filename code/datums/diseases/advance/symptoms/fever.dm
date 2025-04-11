/*
//////////////////////////////////////

Fever

	No change to hidden.
	Increases resistance.
	Increases stage speed.
	Little transmittable.
	Low level.

Bonus
	Heats up your body.

//////////////////////////////////////
*/

/datum/symptom/fever
	name = "Fever"
	desc = "The virus causes a febrile response from the host, raising it's body temperature."
	stealth = -1
	resistance = 3
	stage_speed = 3
	transmission = 2
	level = 2
	severity = 0
	base_message_chance = 20
	symptom_delay_min = 25 SECONDS
	symptom_delay_max = 50 SECONDS

	var/unsafe = FALSE

	threshold_descs = list(
		"Resistance 5" = "Increases fever intensity, fever can overheat and harm the host.",
		"Resistance 10" = "Further increases fever intensity."
	)

/datum/symptom/fever/severityset(datum/disease/advance/A)
	. = ..()
	if(A.resistance >= 5)
		severity += 1
		if(A.resistance >= 10)
			severity += 1

/datum/symptom/fever/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.resistance >= 5)
		power = 1.5
		unsafe = TRUE
		if(A.resistance >= 10)
			power = 2.5

/datum/symptom/fever/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/carbon/M = A.affected_mob
	if(M.stat == DEAD)
		return
	if(!unsafe || A.stage < 4)
		to_chat(M, span_warning(pick("You feel hot.", "You feel like you're burning.")))
	else
		to_chat(M, span_userdanger(pick("You feel too hot", "You feel like your blod is boiling.")))
	set_body_temp(A.affected_mob, A)

/datum/symptom/fever/proc/set_body_temp(mob/living/M, datum/disease/advance/A)
	if(!unsafe)
		M.bodytemperature = min(M.bodytemperature + max((3 * power) * A.stage, (BODYTEMP_HEAT_DAMAGE_LIMIT - 1)))
	else
		M.bodytemperature = min(M.bodytemperature + max((3 * power) * A.stage, (BODYTEMP_HEAT_DAMAGE_LIMIT + 20)))
