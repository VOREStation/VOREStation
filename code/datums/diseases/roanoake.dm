/datum/disease/roanoake
	name = "Roanoake Syndrome"
	max_stages = 6
	stage_prob = 2
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

	var/list/obj/item/organ/organ_list = list()
	var/obj/item/organ/O

/datum/disease/roanoake/Start
	var/mob/living/carbon/human/M = affected_mob

	organ_list += M.organs
	organ_list += M.internal_organs

/datum/disease/roanoake/stage_act()
	if(!..())
		return FALSE
	var/mob/living/carbon/human/M = affected_mob
	switch(stage)
		if(2)
			if(prob(1))
				to_chat(M, span_notice("You feel a slight shiver through your spine..."))
			if(prob(1))
				to_chat(M, span_warning(pick("You feel hot.", "You feel like you're burning.")))
				if(M.bodytemperature < BODYTEMP_HEAT_DAMAGE_LIMIT)
		if(3)
			if(prob(1))
				to_chat(M, span_notice("You shiver a bit."))
			if(prob(1))
				to_chat(M, span_warning(pick("You feel hot.", "You feel like you're burning.")))
				if(M.bodytemperature < BODYTEMP_HEAT_DAMAGE_LIMIT)
					fever(M)
			if(prob(1))
				O = pick(organ_list)
				O.adjust_germ_level(rand(5, 10))
		if(4)
			if(prob(1))
				to_chat(M, span_warning(pick("You feel hot.", "You feel like you're burning.")))
				if(M.bodytemperature < BODYTEMP_HEAT_DAMAGE_LIMIT)
					fever(M)
			if(prob(2))
				O = pick(organ_list)
				O.adjust_germ_level(rand(5, 10))
		if(5)
			if(prob(1))
				to_chat(M, span_warning(pick("You feel hot.", "You feel like you're burning.")))
				if(M.bodytemperature < BODYTEMP_HEAT_DAMAGE_LIMIT)
					fever(M)
			if(prob(2))
				O = pick(organ_list)
				O.adjust_germ_level(rand(5, 10))
			if(prob(1))
				O.take_damage(rand(1, 3))
		if(6)
			if(prob(1))
				to_chat(M, span_warning(pick("You feel hot.", "You feel like you're burning.")))
				if(M.bodytemperature < BODYTEMP_HEAT_DAMAGE_LIMIT)
					fever(M)

			if(prob(2))
				O = pick(organ_list)
				O.adjust_germ_level(rand(5, 10))

			if(prob(2))
				O.take_damage(rand(1, 3))

			if(prob(1) && prob(10))
				var/datum/wound/W = new /datum/wound/internal_bleeding(5)
				O.wounds += W

			if(M.stat == DEAD)
				M.species = /datum/species/xenochimera
				cure()
	return

/datum/disease/roanoake/proc/fever(var/mob/living/M, var/datum/disease/D)
	M.bodytemperature = min(M.bodytemperature + (2 * stage), BODYTEMP_HEAT_DAMAGE_LIMIT - 1)
	return TRUE
