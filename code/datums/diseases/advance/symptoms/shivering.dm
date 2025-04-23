/*
//////////////////////////////////////

Shivering

	No change to hidden.
	Increases resistance.
	Increases stage speed.
	Little transmittable.
	Low level.

Bonus
	Cools down your body.

//////////////////////////////////////
*/

/datum/symptom/shivering
	name = "Shivering"
	desc = "The virus inhibits the body's thermoregulation, cooling the body down."
	stealth = 0
	resistance = 2
	stage_speed = 2
	transmission = 2
	level = 2
	severity = 0
	symptom_delay_min = 20 SECONDS
	symptom_delay_max = 40 SECONDS

	var/unsafe = FALSE

	threshold_descs = list(
		"Stage Speed 5" = "Increases cooling speed; The host can fall below safe temperature levels.",
		"Stage Speed 10" = "Further increases cooling speed."
	)

/datum/symptom/shivering/severityset(datum/disease/advance/A)
	. = ..()
	if(A.stage_rate >= 5)
		severity += 1
		if(A.stage_rate >= 10)
			severity += 1

/datum/symptom/shivering/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.stage_rate >= 5)
		power = 1.5
		unsafe = TRUE
		if(A.stage_rate >= 10)
			power = 2.5

/datum/symptom/shivering/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/carbon/M = A.affected_mob
	if(M.stat == DEAD)
		return
	if(!unsafe || A.stage < 4)
		to_chat(M, span_warning(pick("You feel cold.", "You shiver.")))
	else
		to_chat(M, span_userdanger(pick("You fel your blood run cold.", "You feel ice in your veins.", "You feel like you can't heat up.", "You shiver violently.")))
		set_body_temp(M, A)

/datum/symptom/shivering/proc/set_body_temp(var/mob/living/carbon/H, datum/disease/advance/A)
	if(!unsafe)
		H.bodytemperature = max(-((3 * power) * A.stage), (BODYTEMP_COLD_DAMAGE_LIMIT +1))
	else
		H.bodytemperature = max(-((3 * power) * A.stage), (BODYTEMP_COLD_DAMAGE_LIMIT - 20))
