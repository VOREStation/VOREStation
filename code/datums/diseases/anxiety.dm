/datum/disease/anxiety
	name = "Severe Anxiety"
	form = "Infection"
	max_stages = 4
	spread_text = "On contact"
	spread_flags = CONTACT_GENERAL
	cure_text = "Ethanol"
	cures = list(REAGENT_ID_ETHANOL)
	agent = "Excess Lepdopticides"
	viable_mobtypes = list(/mob/living/carbon/human, /mob/living/carbon/human/monkey)
	desc = "If left untreated subject will regurgitate butterflies."
	severity = MINOR

/datum/disease/anxiety/stage_act()
	if(!..())
		return FALSE
	switch(stage)
		if(2)
			if(prob(15))
				to_chat(affected_mob, span_notice("You feel anxious."))
		if(3)
			if(prob(10))
				to_chat(affected_mob, span_notice("Your stomach flutters."))
			if(prob(5))
				to_chat(affected_mob, span_notice("You feel panicky."))
			if(prob(2))
				to_chat(affected_mob, span_danger("You're overtaken with panic!"))
				affected_mob.AdjustConfused(rand(4, 6))
		if(4)
			if(prob(10))
				to_chat(affected_mob, span_danger("You feel butterflies in your stomach."))
			if(prob(5))
				affected_mob.visible_message(
					span_danger("[affected_mob] stumbles around in a panic"),
					span_userdanger("You have a panic attack!")
				)
				affected_mob.AdjustConfused(rand(12, 16))
				affected_mob.jitteriness = rand(12, 16)
			if(prob(2))
				affected_mob.visible_message(
					span_danger("[affected_mob] coughs up butterflies!"),
					span_userdanger("You cough up butterflies!")
				)
				affected_mob.emote("cough")
				for(var/i in 1 to 2)
					var/mob/living/simple_mob/animal/sif/glitterfly/B = new(affected_mob.loc)
					addtimer(CALLBACK(B, TYPE_PROC_REF(/mob/living/simple_mob/animal/sif/glitterfly, decompose)), rand(5, 25) SECONDS)

/mob/living/simple_mob/animal/sif/glitterfly/proc/decompose()
	visible_message(
		span_notice("[src] decomposes due to being outside of its original habitat for too long!"),
		span_userdanger("You decompose for being too long out of your habitat!"))
	dust()
