/*
//////////////////////////////////////

Mlemingtong

	Not noticable or unnoticable.
	Resistant.
	Increases stage speed.
	Little transmittable.
	Low Level.

BONUS
	Mlem. Mlem. Mlem.

//////////////////////////////////////
*/

/datum/symptom/mlem
	name = "Mlemington"
	desc = "The host uncontrollably licks their nose. Mlem."
	stealth = 0
	resistance = 3
	stage_speed = 3
	transmission = 1
	level = 1
	severity = 1

	var/infective = FALSE

	threshold_descs = list(
		"Resistance 5" = "The host may occasionally go on a mlemming spree.",
		"Transmission 8" = "The host will spread the virus through saliva when mlemming."
	)

/datum/symptom/mlem/severityset(datum/disease/advance/A)
	. = ..()
	if(A.transmission >= 8)
		infective = TRUE
		severity += 1

/datum/symptom/mlem/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.resistance >= 5)
		power = 1.5

/datum/symptom/itching/Activate(var/datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/M = A.affected_mob
	if(M.stat == DEAD)
		return
	switch(A.stage)
		if(1, 2, 3)
			if(prob(base_message_chance))
				to_chat(M, span_notice("You think about licking your nose..."))
		else
			M.emote("mlem")
			if(power >= 1.5)
				M.emote("mlem")
				if(power >= 2)
					M.emote("mlem")
					addtimer(CALLBACK(M, TYPE_PROC_REF(/mob, emote), "mlem"), 2 SECONDS)
					addtimer(CALLBACK(M, TYPE_PROC_REF(/mob, emote), "mlem"), 5 SECONDS)
					addtimer(CALLBACK(M, TYPE_PROC_REF(/mob, emote), "mlem"), 8 SECONDS)
