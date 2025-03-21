/*
//////////////////////////////////////

Necrotizing Fasciitis (AKA Flesh-Eating Disease)

	Very very noticable.
	Lowers resistance tremendously.
	No changes to stage speed.
	Decreases transmittablity tremendously.
	Fatal Level.

Bonus
	Deals brute damage over time.

//////////////////////////////////////
*/

/datum/symptom/flesh_eating
	name = "Necrotizing Fasciitis"
	desc = "The virus aggressively attacks the skin and blood, leading to extreme bleeding."
	stealth = -3
	resistance = -2
	stage_speed = 0
	transmission = -1
	level = 7
	severity = 4
	base_message_chance = 50
	symptom_delay_min = 20 SECONDS
	symptom_delay_max = 60 SECONDS

	var/bleed = FALSE
	var/damage = FALSE

	threshold_descs = list(
		"Resistance 10" = "The host takes brute damage as their flesh is burst open.",
		"Transmission 8" = "The host will bleed far more violently, loosing even more blood, and spraying infected blood everywhere."
	)

/datum/symptom/flesh_eating/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.resistance >= 10)
		damage = TRUE
	if(A.transmission >= 8)
		power = 2
		bleed = TRUE

/datum/symptom/flesh_eating/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/M = A.affected_mob
	switch(A.stage)
		if(2, 3)
			if(prob(base_message_chance) && M.stat != DEAD)
				to_chat(M, span_warning(pick("You feel a sudden pain across your body.", "Drops of blood appear suddenly on your skin.")))
		if(4, 5)
			if(M.stat != DEAD)
				to_chat(M, span_userdanger(pick("You cringe as a violent pan takes over your body.", "It feels like your body is eating itself inside out.", "IT HURTS.")))
			Flesheat(M, A)

/datum/symptom/flesh_eating/proc/Flesheat(mob/living/M, datum/disease/advance/A)
	if(damage)
		M.take_overall_damage(BRUTE = rand(15, 25))
	if(ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	var/obj/item/organ/external/O = pick(H.organs)

	if(bleed)
		O.createwound(PIERCE, 5 * power)
	else
		O.createwound(BRUISE, 7.5 * power)
	return TRUE
