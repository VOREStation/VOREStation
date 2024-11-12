/datum/disease/brainrot
	name = "Brainrot"
	max_stages = 4
	spread_text = "On contact"
	spread_flags = CONTACT_GENERAL
	cure_text = "Alkysine"
	cures = list("alkysine")
	agent = "Cryptococcus Cosmosis"
	viable_mobtypes = list(/mob/living/carbon/human)
	cure_chance = 15
	desc = "This disease destroys the braincells, causing brain fever, brain necrosis and general intoxication."
	required_organs = list(/obj/item/organ/internal/brain)
	severity = HARMFUL

/datum/disease/brainrot/stage_act()
	if(!..())
		return FALSE
	switch(stage)
		if(2)
			if(prob(2))
				affected_mob.say("*blink")
			if(prob(2))
				affected_mob.say("*yawn")
			if(prob(2))
				to_chat(affected_mob, span_danger("You don't feel like yourself."))
			if(prob(5))
				affected_mob.adjustBrainLoss(1)
		if(3)
			if(prob(2))
				affected_mob.say("*stare")
			if(prob(3))
				affected_mob.say("*drool")
			if(prob(10) && affected_mob.getBrainLoss() < 100)
				affected_mob.adjustBrainLoss(3)
				if(prob(2))
					to_chat(affected_mob, span_danger("Strange buzzing fills your head, removing all thoughts."))
			if(prob(3))
				to_chat(affected_mob, span_danger("You lose consciousness..."))
				affected_mob.Sleeping(rand(5, 10))
				if(prob(1))
					affected_mob.emote("snore")
			if(prob(15))
				affected_mob.apply_effect(5, STUTTER)
