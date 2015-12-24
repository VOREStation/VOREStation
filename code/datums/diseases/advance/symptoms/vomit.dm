/*
//////////////////////////////////////

Vomiting

	Very Very Noticable.
	Decreases resistance.
	Doesn't increase stage speed.
	Little transmittable.
	Medium Level.

Bonus
	Forces the affected mob to vomit!
	Meaning your disease can spread via
	people walking on vomit.
	Makes the affected mob lose nutrition and
	heal toxin damage.

//////////////////////////////////////
*/

/datum/symptom/vomit

	name = "Vomiting"
	stealth = -2
	resistance = -1
	stage_speed = 0
	transmittable = 1
	level = 3
	var/bloodvomit

/datum/symptom/vomit/Activate(var/datum/disease/advance/A)
	..()
	if(prob(SYMPTOM_ACTIVATION_PROB / 2))
		var/mob/living/M = A.affected_mob
		spawn M.vomit(M, bloodvomit)
	return

/*
//////////////////////////////////////

Vomiting Blood

	Very Very Noticable.
	Decreases resistance.
	Decreases stage speed.
	Little transmittable.
	Intense level.

Bonus
	Forces the affected mob to vomit blood!
	Meaning your disease can spread via
	people walking on the blood.
	Makes the affected mob lose health.

//////////////////////////////////////
*/

/datum/symptom/vomit/blood

	name = "Blood Vomiting"
	stealth = -2
	resistance = -1
	stage_speed = -1
	transmittable = 1
	level = 4
	bloodvomit = 1
