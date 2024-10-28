/*
//////////////////////////////////////

Telepathy

	Hidden.
	Decreases resistance.
	Decreases stage speed significantly.
	Decreases transmittablity tremendously.
	Critical Level.

Bonus
	The user gains telepathy.

//////////////////////////////////////
*/

/datum/symptom/telepathy
	name = "Pineal Gland Decalcification"
	stealth = 2
	resistance = -2
	stage_speed = -3
	transmittable = -4
	level = 5

/datum/symptom/telepathy/Start(datum/disease/advance/A)
	var/mob/living/carbon/human/H = A.affected_mob
	H.dna.SetSEState(REMOTETALKBLOCK, 1)
	domutcheck(H, null, TRUE)
	to_chat(H, span_notice("Your mind expands..."))

/datum/symptom/telepathy/End(datum/disease/advance/A)
	var/mob/living/carbon/human/H = A.affected_mob
	H.dna.SetSEState(REMOTETALKBLOCK, 0)
	domutcheck(H, null, TRUE)
	to_chat(H, span_notice("Everything feels... Normal."))
