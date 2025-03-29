/*
//////////////////////////////////////

Sneezing

	Very Noticable.
	Increases resistance.
	Doesn't increase stage speed.
	Very transmittable.
	Low Level.

Bonus
	Forces a spread type of AIRBORNE
	with extra range!

//////////////////////////////////////
*/

/datum/symptom/sneeze
	name = "Sneezing"
	desc = "The virus causes irritation of the nasal cavity, making the host sneeze occasionally."
	stealth = -2
	resistance = 3
	stage_speed = 0
	transmission = 4
	symptom_delay_min = 15 SECONDS
	symptom_delay_max = 40 SECONDS
	level = 1
	severity = 0

	var/infective = FALSE

	threshold_descs = list(
		"Stealth 4" = "The symptom remains hidden until active.",
		"Trasmission 12" = "The host may spread the disease through sneezing."
	)

/datum/symptom/sneeze/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.stealth >= 4)
		supress_warning = TRUE
	if(A.transmission >= 12)
		infective = TRUE

/datum/symptom/sneeze/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/M = A.affected_mob
	switch(A.stage)
		if(1, 2, 3)
			if(!supress_warning)
				M.emote("sniff")
		else
			M.emote("sneeze")
			if(infective)
				addtimer(CALLBACK(A, TYPE_PROC_REF(/datum/disease, spread), 4), 20)

/*
//////////////////////////////////////

Bluespace Sneezing

	Very Noticable.
	Resistant
	Doesn't increase stage speed.
	Little transmittable.
	Low Level.

Bonus
	Forces a spread type of AIRBORNE
	with extra range AND teleports the mob

//////////////////////////////////////
*/

/datum/symptom/bsneeze
	name = "Bluespace Sneezing"
	desc = "The virus condenses bluespace particles in the host's nasal cavity, teleporting the host on sneeze."
	stealth = -2
	resistance = 3
	stage_speed = 0
	transmission = 1
	symptom_delay_min = 20 SECONDS
	symptom_delay_max = 30 SECONDS
	level = 4
	severity = 3

/datum/symptom/bsneeze/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/M = A.affected_mob
	switch(A.stage)
		if(1, 2, 3)
			if(!supress_warning)
				M.emote("sniff")
		else
			SneezeTeleport(A, A.affected_mob)

/datum/symptom/bsneeze/proc/SneezeTeleport(datum/disease/advance/A, var/mob/living/mob)
	var/list/destination = list()
	var/place

	for(var/mob/living/carbon/human/B in range(A.stage, mob))
		if(B.can_be_drop_pred && mob.can_be_drop_prey && mob.devourable)
			destination += B.vore_selected

	for(var/turf/T in range(A.stage, mob))
		if(istype(T, /turf/space)) // No danger, this is just a fun/vore symptom
			continue
		destination += T

	if(isemptylist(destination))
		to_chat(mob, span_warning("You go to sneeze, but can't."))
		return FALSE

	place = safepick(destination)

	var/mob/living/unlucky = locate() in place

	if(unlucky && !unlucky.is_incorporeal())
		if(unlucky.can_be_drop_pred && mob.can_be_drop_prey && mob.devourable)
			place = unlucky.vore_selected
		else if(unlucky.devourable && unlucky.can_be_drop_prey && mob.can_be_drop_pred)
			unlucky.forceMove(mob.vore_selected)

	mob.emote("sneeze")
	do_teleport(mob, place)
	return TRUE
