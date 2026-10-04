/datum/disease/roanoke
	name = "Roanoke Syndrome"
	medical_name = "Roanoke Syndrome"
	max_stages = 6
	stage_prob = 2
	spread_text = "Blood and close contact"
	spread_flags = DISEASE_SPREAD_BLOOD
	cure_text = REAGENT_SPACEACILLIN
	agent = "Chimera cells"
	cures = list(REAGENT_ID_SPACEACILLIN)
	cure_chance = 10
	viable_mobtypes = list(/mob/living/carbon/human)
	desc = "If left untreated, subject will become a xenochimera upon perishing."
	danger = DISEASE_BIOHAZARD
	disease_flags = CURABLE | CAN_CARRY | CAN_NOT_POPULATE
	virus_modifiers = BYPASSES_IMMUNITY | SPREAD_DEAD

/datum/disease/roanoke/stage_act()
	if(!..())
		return FALSE
	var/mob/living/carbon/human/M = affected_mob
	var/list/obj/item/organ/organ_target = pick(M.organs + M.internal_organs)
	switch(stage)
		if(2)
			if(prob(1))
				to_chat(M, span_notice("You feel a slight shiver through your spine..."))
			if(prob(1))
				to_chat(M, span_warning(pick("You feel hot.", "You feel like you're burning.")))
				if(M.bodytemperature < BODYTEMP_HEAT_DAMAGE_LIMIT)
					fever(M)
		if(3)
			if(prob(1))
				to_chat(M, span_notice("You shiver a bit."))
			if(prob(1))
				to_chat(M, span_warning(pick("You feel hot.", "You feel like you're burning.")))
				if(M.bodytemperature < BODYTEMP_HEAT_DAMAGE_LIMIT)
					fever(M)
			if(prob(1))
				organ_target.adjust_germ_level(rand(5, 10))
		if(4)
			if(prob(1))
				to_chat(M, span_warning(pick("You feel hot.", "You feel like you're burning.")))
				if(M.bodytemperature < BODYTEMP_HEAT_DAMAGE_LIMIT)
					fever(M)
			if(prob(2))
				organ_target.adjust_germ_level(rand(5, 10))
		if(5)
			if(prob(1))
				to_chat(M, span_warning(pick("You feel hot.", "You feel like you're burning.")))
				if(M.bodytemperature < BODYTEMP_HEAT_DAMAGE_LIMIT)
					fever(M)
			if(prob(2))
				organ_target.adjust_germ_level(rand(5, 10))
			if(prob(1))
				organ_target.take_damage(rand(1, 3))
		if(6)
			if(prob(1))
				to_chat(M, span_warning(pick("You feel hot.", "You feel like you're burning.")))
				if(M.bodytemperature < BODYTEMP_HEAT_DAMAGE_LIMIT)
					fever(M)

			if(prob(2))
				organ_target.adjust_germ_level(rand(5, 10))

			if(prob(2))
				organ_target.take_damage(rand(1, 3))

			if(prob(1) && prob(10))
				var/obj/item/organ/external/E = organ_target.parent_organ
				var/datum/wound/W = new /datum/wound/internal_bleeding(5)
				E.wounds += W
				E.update_damages()
				M.handle_organs(TRUE) //Force an update so we start processing the internal bleeding.

			if(M.stat == DEAD || M.allow_spontaneous_tf)
				M.LoadComponent(/datum/component/xenochimera)
				cure()
	return

/datum/disease/roanoke/proc/fever(mob/living/M, datum/disease/D)
	M.bodytemperature = min(M.bodytemperature + (2 * stage), BODYTEMP_HEAT_DAMAGE_LIMIT - 1)
	return TRUE
