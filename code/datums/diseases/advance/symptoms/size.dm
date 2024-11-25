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

/datum/symptom/size
	name = "Dwindling Malady"
	stealth = -4
	resistance = 1
	stage_speed = 2
	transmittable = -2
	level = 4
	severity = 1

	var/initial_size

/datum/symptom/size/Start(datum/disease/advance/A)
	initial_size = A.affected_mob.size_multiplier

/datum/symptom/size/End(datum/disease/advance/A)
	A.affected_mob = initial_size

/datum/symptom/size/Activate(datum/disease/advance/A)
	..()
	if(prob(SYMPTOM_ACTIVATION_PROB))
		var/mob/living/M = A.affected_mob

		switch(A.stage)
			if(1, 2, 3)
				to_chat(M, span_notice("Your clothes feel loose."))
			if(4, 5)
				if(prob(10))
					M.emote("twitches")
					Resize(M, -rand(0.1, 0.5))

/datum/symptom/size/proc/Resize(mob/living/M, var/size)
	M.resize(size+M.size_multiplier)

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
			if(1, 2, 3)
				to_chat(M, span_notice("Your clothes feel tight."))
			if(4, 5)
				if(prob(10))
					M.emote("twitches")
					Resize(M, rand(0.1, 0.5))
