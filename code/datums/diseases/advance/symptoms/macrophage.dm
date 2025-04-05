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
	desc = "The virus grows within the host, ceasing to be microscopic and causing severe bodily harm. These Phages will seek out, attack, and infect more viable hosts."
	stealth = -4
	resistance = -1
	stage_speed = -2
	transmission = 2
	level = 9
	severity = 2
	symptom_delay_min = 40
	symptom_delay_max = 60

	var/gigagerms = FALSE
	var/netspeed = 0
	var/phagecounter = 10

	threshold_descs = list(
		"Stage Speed" = "The higher the stage speed, the more frequently will burst from the host.",
		"Resistance" = "The higher the resistance, the more health phages will have, and the more damage the will do.",
		"Transmission 10" = "Phages can be larger, and more aggressive.",
		"Transmission 12" = "Phages will carry all diseases within the host, instead of only containing their own."
	)

/datum/symptom/macrophage/severityset(datum/disease/advance/A)
	. = ..()
	if(A.transmission >= 10)
		severity += 2

/datum/symptom/macrophage/Start(datum/disease/advance/A)
	if(!..())
		return
	netspeed = max(1, A.stage_rate)
	if(A.transmission >= 10)
		gigagerms = TRUE

/datum/symptom/macrophage/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/M = A.affected_mob
	switch(A.stage)
		if(1, 2, 3)
			if(prob(base_message_chance) && M.stat != DEAD)
				to_chat(M, span_notice("Your skin crawls."))
		if(4)
			if(prob(base_message_chance))
				M.visible_message(span_danger("Lumps form on [M]'s skin!"), span_userdanger("You cringe in pain as lumps form and move around on your skin!"))
		if(5)
			phagecounter -= max(2, A.stage_rate)
			if(gigagerms && phagecounter <= 0)
				Burst(A, M, TRUE)
				phagecounter += 10
			while(phagecounter <= 0)
				phagecounter += 5
				Burst(A, M)

/datum/symptom/macrophage/proc/Burst(datum/disease/advance/A, var/mob/living/M, var/gigagerms = FALSE)
	var/mob/living/simple_mob/vore/aggressive/macrophage/phage

	if(gigagerms)
		phage = new /mob/living/simple_mob/vore/aggressive/macrophage/giant(get_turf((M.loc)))
		phage.melee_damage_lower = rand(10, 15)
		phage.melee_damage_upper = rand(15, 20)
		M.apply_damage(rand(10, 20))
		playsound(M, 'sound/effects/splat.ogg', 50, 1)
		M.emote("scream")
	else
		phage = new(get_turf((M.loc)))
		M.apply_damage(rand(1, 7))

	phage.health += A.resistance
	phage.maxHealth += A.resistance
	phage.infections += A
	phage.base_disease = A

	if(A.transmission >= 12)
		for(var/datum/disease/D in M.GetViruses())
			if((D.spread_flags & DISEASE_SPREAD_SPECIAL) || (D.spread_flags & DISEASE_SPREAD_CONTACT))
				continue
			if(D == A)
				continue
			phage.infections += D
	M.visible_message(span_danger("A strange creature burst out of [M]!"), span_userdanger("A slimy creature bursts forth from your flesh!"))
	addtimer(CALLBACK(phage, TYPE_PROC_REF(/mob/living/simple_mob/vore/aggressive/macrophage, deathcheck)), 3 MINUTES)
