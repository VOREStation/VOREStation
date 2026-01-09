
/*
//////////////////////////////////////
Narcolepsy
	Noticeable.
	Lowers resistance
	Decreases stage speed tremendously.
	Decreases transmittablity tremendously.

Bonus
	Causes weakness and sleep.

//////////////////////////////////////
*/

/datum/symptom/narcolepsy
	name = "Narcolepsy"
	stealth = 1
	resistance = -1
	stage_speed = -2
	transmission = -2
	symptom_delay_min = 15 SECONDS
	symptom_delay_max = 30 SECONDS
	level = 3
	severity = 2

	var/weakens = FALSE

	var/sleep_level = 0
	var/sleepy_ticks = 0

	prefixes = list("Lazy ", "Yawning ")
	bodies = list("Sleep")

	threshold_descs = list(
		"Trasmission 7" = "Also relaxes the muscles, weakning and slowing the host.",
		"Resistance 10" = "Causes narcolepsy more often, increasing the chance of the host falling asleep."
	)

/datum/symptom/narcolepsy/severityset(datum/disease/advance/A)
	. = ..()
	if(A.resistance >= 10)
		severity += 1

/datum/symptom/narcolepsy/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.transmission >= 7)
		weakens = TRUE
	if(A.resistance >= 10)
		symptom_delay_min = 5 SECONDS
		symptom_delay_max = 20 SECONDS

/datum/symptom/narcolepsy/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/M = A.affected_mob
	if(M.stat == DEAD)
		return

	switch(sleep_level)
		if(10 to 19)
			M.drowsyness += 1
		if(20 to INFINITY)
			M.AdjustSleeping(30)
			sleep_level = 0
			sleepy_ticks = 0

	if(sleepy_ticks && A.stage >= 5)
		sleep_level++
		sleepy_ticks--
	else
		sleep_level = 0

	switch(A.stage)
		if(1)
			if(base_message_chance)
				to_chat(M, span_warning("You feel tired."))
		if(2)
			if(prob(10))
				to_chat(M, span_warning("You feel very tired."))
				sleepy_ticks += rand(10, 14)
				if(weakens)
					M.AdjustWeakened(10)
		if(3)
			if(prob(15))
				to_chat(M, "You try to focus on staying awake.")
				sleepy_ticks += rand(10, 14)
				if(weakens)
					M.AdjustWeakened(15)
		if(4)
			if(prob(20))
				to_chat(M, "You nod off for a moment.")
				sleepy_ticks += rand(10, 14)
				if(weakens)
					M.AdjustWeakened(20)
		if(5)
			if(prob(25))
				to_chat(M, span_warning("[pick("So tired...","You feel very sleepy.","You have a hard time keeping your eyes open.","You try to stay awake.")]"))
				M.drowsyness = max(M.drowsyness, 2)
				sleepy_ticks += rand(10, 14)
				if(weakens)
					M.AdjustWeakened(30)
