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
	desc = "The virus causes distortion of the host's body, causing it to change size."
	stealth = 1
	resistance = 0
	stage_speed = 2
	transmission = 2
	level = 4
	severity = 0
	symptom_delay_min = 20 SECONDS
	symptom_delay_max = 60 SECONDS
	var/min_size = 25
	var/max_size = 200

/datum/symptom/size/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/M = A.affected_mob
	switch(A.stage)
		if(4, 5)
			M.emote("twitch")
			Resize(M, rand(min_size, max_size))

/datum/symptom/size/proc/Resize(mob/living/M, var/size)
	M.resize(size/100)

/datum/symptom/size/grow
	name = "Enlargement Disorder"
	min_size = 100
	max_size = 200

/datum/symptom/size/shrink
	name = "Dwindling Malady"
	min_size = 25
	max_size = 100
