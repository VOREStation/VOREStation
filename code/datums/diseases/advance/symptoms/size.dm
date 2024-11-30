/*
//////////////////////////////////////

Mass Revectoring

	Very noticeable.
	Increases resistance slightly.
	Increases stage speed.
	Decreases transmittablity
	Intense level.

BONUS
	Changes the size of the host.

//////////////////////////////////////
*/

/datum/symptom/size
	name = "Mass Revectoring"
	stealth = -4
	resistance = 1
	stage_speed = 2
	transmittable = -2
	level = 4
	severity = 1

/datum/symptom/size/Activate(datum/disease/advance/A)
	..()
	if(prob(SYMPTOM_ACTIVATION_PROB))
		var/mob/living/M = A.affected_mob

		switch(A.stage)
			if(4, 5)
				M.emote("twitch")
				Resize(M, rand(25, 200))

/datum/symptom/size/proc/Resize(mob/living/M, var/size)
	M.resize(size+M.size_multiplier/100)

/*
//////////////////////////////////////

Enlargement Disorder

	Very noticeable.
	Increases resistance slightly.
	Increases stage speed.
	Decreases transmittablity
	Intense level.

BONUS
	Grows the host to bigger sizes

//////////////////////////////////////
*/

/datum/symptom/size/grow
	name = "Enlargement Disorder"

/datum/symptom/size/Activate(datum/disease/advance/A)
	..()
	if(prob(SYMPTOM_ACTIVATION_PROB))
		var/mob/living/M = A.affected_mob

		switch(A.stage)
			if(4, 5)
				M.emote("twitch")
				Resize(M, rand(100, 200))

/*
//////////////////////////////////////

Dwindling Malady

	Very noticeable.
	Increases resistance slightly.
	Increases stage speed.
	Decreases transmittablity
	Intense level.

BONUS
	Shrinks the host to small sizes

//////////////////////////////////////
*/

/datum/symptom/size/shrink
	name = "Dwindling Malady"

/datum/symptom/size/Activate(datum/disease/advance/A)
	..()
	if(prob(SYMPTOM_ACTIVATION_PROB))
		var/mob/living/M = A.affected_mob

		switch(A.stage)
			if(4, 5)
				M.emote("twitch")
				Resize(M, rand(25, 100))
