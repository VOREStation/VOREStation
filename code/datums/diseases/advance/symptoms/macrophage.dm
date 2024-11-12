/*
//////////////////////////////////////

Macrophages

	Very noticeable.
	Lowers resistance slightly.
	Decreases stage speed.
	Increases transmittablity
	Fatal leve.

BONUS
	The virus grows and ceases to be microscopic.

//////////////////////////////////////
*/

/datum/symptom/macrophage
	name = "Macrophage"
	stealth = -4
	resistance = -1
	stage_speed = -2
	transmittable = 2
	level = 6
	severity = 2

	var/gigagerms = FALSE
	var/netspeed = 0
	var/phagecounter = 10

/datum/symptom/macrophage/Start(datum/disease/advance/A)
	netspeed = max(1, A.stage)
	if(A.severity >= HARMFUL)
		gigagerms = TRUE

/datum/symptom/macrophage/Activate(datum/disease/advance/A)
	..()
	if(prob(SYMPTOM_ACTIVATION_PROB))
		var/mob/living/M = A.affected_mob
		switch(A.stage)
			if(1, 2, 3)
				to_chat(M, span_notice("Your skin crawls."))
			if(4)
				M.visible_message(span_danger("Lumps form on [M]'s skin!"), span_userdanger("You cringe in pain as lumps form and move around on your skin!"))
			if(5)
				phagecounter -= max(2, A.totalStageSpeed())
				if(gigagerms && phagecounter <= 0)
					Burst(A, M, TRUE)
					phagecounter += 10
				while(phagecounter <= 0)
					phagecounter += 5
					Burst(A, M)

/datum/symptom/macrophage/proc/Burst(datum/disease/advance/A, var/mob/living/M, var/gigagerms = FALSE)
	var/mob/living/simple_mob/vore/aggressive/macrophage/phage
	phage = new(M.loc)
	M.apply_damage(rand(1, 7))
	phage.viruses = A.Copy()
	phage.health += A.totalResistance()
	phage.maxHealth += A.totalResistance()
	phage.infections += A
	phage.base_disease = A

	if(A.spread_flags & CONTACT_GENERAL)
		for(var/datum/disease/D in M.GetViruses())
			if((D.spread_flags & SPECIAL) || (D.spread_flags & NON_CONTAGIOUS))
				continue
			if(D == A)
				continue
			phage.viruses += D

	M.visible_message(span_danger("A strange crearure bursts out of [M]!"), span_userdanger("A slimy creature bursts forth from your flesh!"))
	addtimer(CALLBACK(phage, TYPE_PROC_REF(/mob/living/simple_mob/vore/aggressive/macrophage, deathcheck)), 3000)
