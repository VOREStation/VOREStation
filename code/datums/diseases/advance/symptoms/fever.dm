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

	bodies = list("Fever")
	suffixes = list(" Fever")

/datum/symptom/fever/severityset(datum/disease/advance/A)
	. = ..()
	if(A.resistance >= 5)
		severity += 1
		prefixes = list("Desert")
		if(A.resistance >= 10)
			severity += 1
			prefixes = list("Volcanic")

/datum/symptom/fever/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.resistance >= 5)
		power = 2.5
		unsafe = TRUE
		if(A.resistance >= 10)
			power = 5

/datum/symptom/fever/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/carbon/M = A.affected_mob
	if(M.stat == DEAD)
		return
	if(!unsafe || A.stage < 4)
		to_chat(M, span_warning(pick("You feel hot.", "You feel like you're burning.")))
	else
		to_chat(M, span_userdanger(pick("You feel too hot", "You feel like your blood is boiling.")))
	set_body_temp(A.affected_mob, A)

/datum/symptom/fever/proc/set_body_temp(mob/living/M, datum/disease/advance/A)
	if(M.bodytemperature >= BODYTEMP_HEAT_DAMAGE_LIMIT + 100) //If body temp is already that high or beyond, don't lower it.
		return

	if(!unsafe)
		M.bodytemperature = min(M.bodytemperature + max((10 * power), (3 * A.stage)), (BODYTEMP_HEAT_DAMAGE_LIMIT - 1)) //+10 at max power w/o becoming unsafe, +15 at max stage.
		return
	M.bodytemperature = M.bodytemperature + max((9 * power), (5 * A.stage)) //+45 at max power (power 5) 13.5 at power 1.5, +25 at max stage. +45 because it prevents you from geting immediate damage from it when you get +50
