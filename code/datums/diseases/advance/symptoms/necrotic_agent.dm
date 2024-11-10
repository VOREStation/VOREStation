/*
//////////////////////////////////////

Necrotic Agent

	Very Noticable.
	Lowers resistance resistance considerably.
	Decreases stage speed.
	Reduced transmittable.
	Critical Level.

Bonus
	Makes the disease work on corpses

//////////////////////////////////////
*/

/datum/symptom/necrotic_agent
	name = "Necrotic Agent"
	stealth = -2
	resistance = -3
	stage_speed = -3
	transmittable = 0
	level = 6
	severity = 3

/datum/symptom/necrotic_agent/Start(datum/disease/advance/A)
	A.allow_dead = TRUE

/datum/symptom/necrotic_agent/End(datum/disease/advance/A)
	A.allow_dead = FALSE
