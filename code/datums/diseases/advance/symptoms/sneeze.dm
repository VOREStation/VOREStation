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
	stealth = -2
	resistance = 3
	stage_speed = 0
	transmittable = 4
	level = 1
	severity = 1

/datum/symptom/sneeze/Activate(datum/disease/advance/A)
	..()
	if(prob(SYMPTOM_ACTIVATION_PROB))
		var/mob/living/M = A.affected_mob
		switch(A.stage)
			if(1, 2, 3)
				M.emote("sniff")
			else
				M.emote("sneeze")
				if(!M.wear_mask) // Spread only if they're not covering their face
					A.spread(5)

				if(prob(30) && !M.wear_mask) // Same for mucus
					var/obj/effect/decal/cleanable/mucus/icky = new(get_turf(M))
					icky.viruses |= A.Copy()

	return

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

/datum/symptom/sneeze/bluespace
	name = "Bluespace Sneezing"
	stealth = -2
	resistance = 3
	stage_speed = 0
	transmittable = 1
	level = 4
	severity = 3

/datum/symptom/sneeze/bluespace/Activate(datum/disease/advance/A)
	..()
	if(prob(SYMPTOM_ACTIVATION_PROB))
		var/mob/living/M = A.affected_mob
		switch(A.stage)
			if(1, 2, 3)
				M.emote("sniff")
			else
				SneezeTeleport(A, M)
				if(!M.wear_mask)
					A.spread(A.stage)
				if(prob(30) && !M.wear_mask)
					var/obj/effect/decal/cleanable/mucus/icky = new(get_turf(M))
					icky.viruses |= A.Copy()

	return

/datum/symptom/sneeze/bluespace/proc/SneezeTeleport(datum/disease/advance/A, var/mob/living/mob)
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

	if(unlucky)
		if(unlucky.can_be_drop_pred && mob.can_be_drop_prey && mob.devourable)
			place = unlucky.vore_selected
		else if(unlucky.devourable && unlucky.can_be_drop_prey && mob.can_be_drop_pred)
			unlucky.forceMove(mob.vore_selected)

	mob.emote("sneeze")
	do_teleport(mob, place)
	return TRUE
