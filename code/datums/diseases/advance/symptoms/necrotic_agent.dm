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
	desc = "Allows the virus to infect corpses, and work on the dead."
	stealth = 2
	resistance = -2
	stage_speed = -1
	transmission = 0
	level = 6
	severity = 3

/datum/symptom/necrotic_agent/OnAdd(datum/disease/advance/A)
	A.virus_modifiers |= SPREAD_DEAD

/datum/symptom/necrotic_agent/OnRemove(datum/disease/advance/A)
	A.virus_modifiers &= ~SPREAD_DEAD
