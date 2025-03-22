/*
//////////////////////////////////////

Synthetic Infection

	Slightly hidden.
	Increases resistance.
	Doesn't increase stage speed.
	Slightly transmittable.
	High Level.

Bonus
	Allows the disease to infect synthetics

//////////////////////////////////////
*/

/datum/symptom/infect_synthetics
	name = "Synthetic Infection"
	stealth = 1
	resistance = 2
	stage_speed = 0
	transmission = 1
	level = 5
	severity = 3

/datum/symptom/infect_synthetics/Start(datum/disease/advance/A)
	A.infect_synthetics = TRUE

/datum/symptom/infect_synthetics/End(datum/disease/advance/A)
	A.infect_synthetics = FALSE
