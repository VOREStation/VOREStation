/datum/disease/cold9
	name = "The Cold"
	medical_name = "ICE9 Cold"
	max_stages = 3
	spread_text = "On contact"
	spread_flags = DISEASE_SPREAD_CONTACT | DISEASE_SPREAD_BLOOD | DISEASE_SPREAD_FLUIDS
	cure_text = REAGENT_SPACEACILLIN
	cures = list(REAGENT_ID_SPACEACILLIN)
	agent = "ICE9-rhinovirus"
	viable_mobtypes = list(/mob/living/carbon/human)
	desc = "If left untreated the subject will slow, as if partly frozen."
	danger = DISEASE_HARMFUL

/datum/disease/cold9/stage_act()
	..()
	switch(stage)
		if(1)
			if(prob(1))
				affected_mob.emote("sniff")
		if(2)
			if(prob(10))
				affected_mob.bodytemperature -= 2
			if(prob(1) && prob(10))
				to_chat(affected_mob, span_notice("You feel better."))
				cure()
				return
			if(prob(1))
				affected_mob.emote("sneeze")
			if(prob(1))
				affected_mob.emote("cough")
			if(prob(1))
				to_chat(affected_mob, span_danger("Your throat feels sore."))
			if(prob(5))
				to_chat(affected_mob, span_danger("You feel stiff."))
		if(3)
			if(prob(10))
				affected_mob.bodytemperature -= 5
			if(prob(1))
				affected_mob.emote("sneeze")
			if(prob(1))
				affected_mob.emote("cough")
			if(prob(1))
				to_chat(affected_mob, span_danger("Your throat feels sore."))
			if(prob(10))
				to_chat(affected_mob, span_danger("You feel stiff."))
