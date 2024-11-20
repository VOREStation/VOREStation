/datum/disease/flu
	name = "The Flu"
	max_stages = 3
	spread_text = "Airborne"
	cure_text = "Spaceacillin"
	cures = list("spaceacillin", "chicken_soup")
	cure_chance = 10
	agent = "H13N1 flu virion"
	viable_mobtypes = list(/mob/living/carbon/human, /mob/living/carbon/human/monkey)
	permeability_mod = 0.75
	desc = "If left untreated the subject will feel quite unwell."
	severity = MINOR

/datum/disease/flu/stage_act()
	if(!..())
		return FALSE
	switch(stage)
		if(2)
			if(affected_mob.lying && prob(20))
				to_chat(affected_mob, span_notice("You feel better."))
				stage--
				return
			if(prob(1))
				affected_mob.emote("sneeze")
			if(prob(1))
				affected_mob.emote("cough")
			if(prob(1))
				to_chat(affected_mob, span_danger("Your muscles ache."))
				if(prob(20))
					affected_mob.apply_damage(1)
			if(prob(1))
				to_chat(affected_mob, span_danger("Your stomach hurts."))
				affected_mob.adjustToxLoss(1)
		if(3)
			if(affected_mob.lying && prob(15))
				to_chat(affected_mob, span_notice("You feel better."))
				stage--
				return
			if(prob(1))
				affected_mob.emote("sneeze")
			if(prob(1))
				affected_mob.emote("cough")
			if(prob(1))
				to_chat(affected_mob, span_danger("Your muscles ache."))
				if(prob(20))
					affected_mob.apply_damage(1)
			if(prob(1))
				to_chat(affected_mob, span_danger("Your stomach hurts."))
				affected_mob.adjustToxLoss(1)
	return
