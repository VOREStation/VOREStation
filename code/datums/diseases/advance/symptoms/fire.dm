/*
//////////////////////////////////////

Spontaneous Combustion

	Slightly hidden.
	Lowers resistance tremendously.
	Decreases stage tremendously.
	Decreases transmittablity tremendously.
	Fatal Level.

Bonus
	Ignites infected mob.

//////////////////////////////////////
*/

/datum/symptom/fire
	name = "Spontaneous Combustion"
	desc = "The virus turns fat into an extremely flammable compound, and raises the body's temperature, making the host burst into flames spontaneously."
	stealth = 1
	resistance = -1
	stage_speed = -2
	transmission = -1
	level = 7
	severity = 4

	base_message_chance = 20
	symptom_delay_min = 40 SECONDS
	symptom_delay_max = 85 SECONDS

	var/infective = FALSE

	threshold_descs = list(
		"Stage Speed 4" = "Increases the intensity of the flames.",
		"Stage Speed 8" = "Further increases the intensity of the flames.",
		"Transmission 8" = "Host will spread the virus through skin flake when bursting into flames.",
		"Stealth 4" = "The symptom remains hidden until active."
	)

/datum/symptom/fire/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.stage_rate >= 4)
		power = 1.5
		if(A.stage_rate >= 8)
			power = 2
	if(A.stealth >= 4)
		supress_warning = TRUE
	if(A.transmission >= 8)
		infective = TRUE

/datum/symptom/fire/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/M = A.affected_mob
	switch(A.stage)
		if(3)
			if(prob(base_message_chance) && !supress_warning && M.stat != DEAD)
				to_chat(M, span_warning(pick("You feel hot.", "You hear a crackling noise.", "You smell smoke.")))
		if(4)
			Firestacks_stage_4(M, A)
			M.IgniteMob()
			to_chat(M, span_userdanger("Your skin bursts into flames!"))
			M.emote("scream")
		if(5)
			Firestacks_stage_5(M, A)
			M.IgniteMob()
			if(M.stat != DEAD)
				to_chat(M, span_userdanger("Your skin erupts into an inferno!"))
				M.emote("scream")
	return

/datum/symptom/fire/proc/Firestacks_stage_4(mob/living/M, datum/disease/advance/A)
	M.adjust_fire_stacks(1 * power)
	M.take_overall_damage(burn = 2 * power)
	if(infective)
		M.visible_message(span_danger("[M] bursts into flames, spreading burning sparks about the area!"))
	return TRUE

/datum/symptom/fire/proc/Firestacks_stage_5(mob/living/M, datum/disease/advance/A)
	M.adjust_fire_stacks(3 * power)
	M.take_overall_damage(burn = 5 * power)
	if(infective)
		M.visible_message(span_danger("[M] bursts into flames, spreading burning sparks about the area!"))
	return TRUE
