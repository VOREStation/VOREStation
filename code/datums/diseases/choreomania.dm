/datum/disease/choreomania
	name = "Choreomania"
	max_stages = 3
	spread_text = "Airborne"
	cure_text = REAGENT_ADRANOL
	cures = list(REAGENT_ID_ADRANOL)
	cure_chance = 10
	agent = "TAP-DAnC3"
	viable_mobtypes = list(/mob/living/carbon/human)
	permeability_mod = 0.75
	desc = "If left untreated the subject... Won't stop dancing!"
	severity = MINOR

	var/list/dance = list(2,4,8,2,4,8,2,4,8,2,4,8,1,4,1,4,1,4,2,4,8,2)

/datum/disease/choreomania/stage_act()
	if(!..())
		return FALSE
	switch(stage)
		if(2)
			if(prob(1))
				to_chat(affected_mob, span_notice("You feel like dancing like a maniac, maniac..."))
			if(prob(1))
				affected_mob.emote("whistle")
		if(3)
			if(prob(1))
				to_chat(affected_mob, span_notice("You feel like dancing like a maniac, maniac..."))
			if(prob(1))
				to_chat(affected_mob, span_notice("You really want to start a conga line!"))
			if(prob(2))
				for(var/D in dance)
					affected_mob.dir = D
					animate(affected_mob, pixel_x = 5, time = 5)
					sleep(3)
					animate(affected_mob, pixel_x = -5, time = 5)
					animate(pixel_x = affected_mob.default_pixel_x, pixel_y = affected_mob.default_pixel_x, time = 2)
					sleep(3)
	return
