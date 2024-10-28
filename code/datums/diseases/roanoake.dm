/datum/disease/roanoake
	name = "Roanoake Syndrome"
	max_stages = 6
	stage_prob = 5
	spread_text = "Blood and close contact"
	spread_flags = BLOOD
	cure_text = "Spaceacilin"
	agent = "Chimera cells"
	cures = list("spaceacilin")
	cure_chance = 10
	viable_mobtypes = list(/mob/living/carbon/human)
	desc = "If left untreated, subject will become a xenochimera upon perishing."
	severity = BIOHAZARD
	disease_flags = CURABLE
	virus_heal_resistant = TRUE
	allow_dead = TRUE

/datum/disease/roanoake/stage_act()
	if(!..())
		return FALSE
	var/mob/living/carbon/human/M = affected_mob
	switch(stage)
		if(1)
			if(prob(1))
				to_chat(M, span_notice("You feel alright."))
		if(2)
			if(prob(1))
				to_chat(M, span_notice("You feel a slight shiver through your spine..."))
			if(prob(1))
				to_chat(M, span_notice("You sweat a bit."))
		if(3)
			if(prob(1))
				to_chat(M, span_notice("You shiver a bit."))
			if(prob(2))
				to_chat(M, span_danger("You feel... Strange"))
			if(prob(1))
				to_chat(M, span_danger("You feel your body's temperature increase."))
				if(M.bodytemperature < BODYTEMP_HEAT_DAMAGE_LIMIT)
					fever(M)
		if(4)
			if(prob(1))
				to_chat(M, span_danger("Something feels off..."))
			if(prob(1))
				to_chat(M, span_danger("You feel your body's temperature increase."))
				if(M.bodytemperature < BODYTEMP_HEAT_DAMAGE_LIMIT)
					fever(M)
			if(prob(1))
				M.emote("cough")
		if(5)
			if(prob(1))
				to_chat(M, span_danger("Something feels off..."))
			if(prob(1))
				to_chat(M, span_danger("You feel your body's temperature increase."))
				if(M.bodytemperature < BODYTEMP_HEAT_DAMAGE_LIMIT)
					fever(M)
			if(prob(2))
				M.emote("cough")
			if(prob(1))
				to_chat(M, span_danger("You don't feel like yourself."))
		if(6)
			if(prob(1))
				to_chat(M, span_danger("Something feels off..."))
			if(prob(1))
				to_chat(M, span_danger("You feel your body's temperature increase."))
				if(M.bodytemperature < BODYTEMP_HEAT_DAMAGE_LIMIT)
					fever(M)
			if(prob(2))
				M.emote("cough")
			if(prob(2))
				to_chat(M, span_danger("You don't feel like yourself."))

			if(M.stat == DEAD)
				M.species = /datum/species/xenochimera
				var/datum/disease/D = new /datum/disease/roanoake/xenoch
				affected_mob.ContractDisease(D)
				cure()
	return

/datum/disease/roanoake/proc/fever(var/mob/living/M, var/datum/disease/D)
	M.bodytemperature = min(M.bodytemperature + (2 * stage), BODYTEMP_HEAT_DAMAGE_LIMIT - 1)
	return TRUE
