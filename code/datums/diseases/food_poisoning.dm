/datum/disease/food_poisoning
	name = "Food Poisoning"
	max_stages = 3
	stage_prob = 5
	spread_text = "Non-Contagious"
	spread_flags = NON_CONTAGIOUS
	cure_text = "Sleep"
	agent = REAGENT_SALMONELLA
	cures = list(REAGENT_ID_CHICKENSOUP)
	cure_chance = 10
	viable_mobtypes = list(/mob/living/carbon/human)
	desc = "Nausea, sickness, and vomitting."
	severity = MINOR
	disease_flags = CURABLE|CAN_NOT_POPULATE
	virus_heal_resistant = TRUE

/datum/disease/food_poisoning/stage_act()
	if(!..())
		return FALSE
	if(affected_mob.stat == UNCONSCIOUS && prob(33))
		to_chat(affected_mob, span_notice("You feel better."))
		cure()
		return
	switch(stage)
		if(1)
			if(prob(5))
				to_chat(affected_mob, span_danger("Your stomach feels weird."))
			if(prob(5))
				to_chat(affected_mob, span_danger("You feel queasy."))
		if(2)
			if(affected_mob.stat == UNCONSCIOUS && prob(40))
				to_chat(affected_mob, span_notice("You feel better."))
				cure()
				return
			if(prob(1) && prob(10))
				to_chat(affected_mob, span_notice("You feel better."))
			if(prob(10))
				affected_mob.emote("groan")
			if(prob(5))
				to_chat(affected_mob, span_danger("Your stomach aches."))
			if(prob(5))
				to_chat(affected_mob, span_danger("You feel nauseous"))
		if(3)
			if(affected_mob.stat == UNCONSCIOUS && prob(25))
				to_chat(affected_mob, span_notice("You feel better."))
				cure()
				return
			if(prob(1) && prob(10))
				to_chat(affected_mob, span_notice("You feel better."))
				cure()
				return
			if(prob(10))
				affected_mob.emote("moan")
			if(prob(10))
				affected_mob.emote("groan")
			if(prob(1))
				to_chat(affected_mob, span_danger("Your stomach hurts."))
			if(prob(1))
				to_chat(affected_mob, span_danger("You feel sick."))
			if(prob(5))
				if(affected_mob.nutrition > 10)
					affected_mob.emote("vomit")
				else
					to_chat(affected_mob, span_danger("Your stomach lurches painfully"))
					affected_mob.visible_message(span_danger("[affected_mob] gags and retches!"))
					affected_mob.Stun(rand(4, 8))
					affected_mob.Weaken(rand(4, 8))
