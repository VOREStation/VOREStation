/datum/symptom/dance
	name = "Choreomania"
	desc = "The symptom allows the virus to hijack the motor system of the affected, making them dance."
	stealth = 2
	resistance = 0
	stage_speed = 3
	transmission = 1
	level = 5
	severity = 0
	symptom_delay_min = 15 SECONDS
	symptom_delay_max = 30 SECONDS

	prefixes = list("Dancing ", "Footloose ", "Frenzied ", "Groovy ")
	bodies = list("Tremor", "Jig", "Shuffle", "Spasm")
	suffixes = list(" Fit", " Twitch")

/datum/symptom/dance/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/M = A.affected_mob
	if(M.stat == DEAD)
		return
	switch(A.stage)
		if(2)
			if(prob(base_message_chance))
				to_chat(M, span_notice("You feel a tingle down your spine..."))
		if(3)
			if(prob(base_message_chance))
				to_chat(M, span_notice("You feel a tingle down your spine..."))
			if(prob(5))
				M.visible_emote("taps their foot rhythmically.")
		if(4, 5)
			if(prob(base_message_chance))
				to_chat(M, span_notice("You feel like giving it all out there!"))
				M.emote("whistle")
			/*
			if(prob(5))
				dance_one(M)
			*/
			if(prob(5))
				penguin_dance(M)
/*
/datum/symptom/dance/proc/dance_one(mob/living/M)
	var/list/dance = list(2,4,8,2,4,8,2,4,8,2,4,8,1,4,1,4,1,4,2,4,8,2)

	for(var/D in dance)
		M.dir = D
		animate(M, pixel_x = 5, time = 5)
		animate(M, pixel_x = -5, time = 5)
		animate(M, pixel_x = M.default_pixel_x, pixel_y = M.default_pixel_y, time = 2)
*/
/datum/symptom/dance/proc/penguin_dance(mob/living/M)
	if(!M)
		return

	animate(M)
	M.transform = matrix()
	M.pixel_x = 0
	M.pixel_y = 0

	var/matrix/left = matrix()
	left.Translate(-3, 2)

	var/matrix/right = matrix()
	right.Translate(3, -2)

	var/tag = "penguin_dance"

	animate(M, dir = EAST, time = 2, tag = tag)
	animate(M, dir = NORTH, time = 2, tag = tag)
	animate(M, dir = WEST, time = 2, tag = tag)
	animate(M, dir = SOUTH, time = 2, tag = tag)

	animate(M, dir = WEST, transform = left, time = 4, tag = tag)
	animate(transform = right, time = 4)
	animate(transform = matrix(), time = 4)

	animate(dir = EAST, transform = left, time = 4)
	animate(transform = right, time = 4)
	animate(transform = matrix(), time = 4)
