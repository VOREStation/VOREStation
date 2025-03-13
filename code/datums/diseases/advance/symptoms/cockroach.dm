/datum/symptom/cockroach
	name = "SBG Syndrome"
	desc = "Causes bluespace synchronicity with nearby air channels, making the roaches infesting the station's scrubber crawl from the host's face."
	stealth = 1
	resistance = 2
	stage_speed = 3
	transmission = 1
	level = 0
	severity = 0
	symptom_delay_min = 15 SECONDS
	symptom_delay_max = 40 SECONDS

	var/death_roaches = FALSE

	threshold_descs = list(
		"Stage Speed 8" = "Increases roach speed",
		"Transmission 8" = "When the host dies, more roaches spawn."
	)

/datum/symptom/cockroach/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.stage_rate >= 8)
		symptom_delay_min = 5
		symptom_delay_max = 15
	if(A.transmission >= 8)
		death_roaches = TRUE

/datum/symptom/cockroach/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/M = A.affected_mob
	if(M.stat == DEAD)
		return
	switch(A.stage)
		if(2)
			if(prob(base_message_chance))
				to_chat(M, span_notice("You feel a tingle under your skin."))
		if(3)
			if(prob(base_message_chance))
				to_chat(M, span_notice("Your pores feel drafty."))
			if(prob(5))
				to_chat(M, span_notice("You feel attuned to the atmosphere."))
		if(4)
			if(prob(base_message_chance))
				to_chat(M, span_notice("You feel in tune with the station."))
		if(5)
			if(prob(base_message_chance))
				M.visible_message(span_danger("[M] squirms as a cockroach crawl from their pores!"), span_userdanger("A cockroach crawls out of your face!!"))
				new /mob/living/simple_mob/animal/passive/cockroach(M.loc)
			if(prob(base_message_chance))
				to_chat(M, span_notice("You feel something crawling in your pipes!"))

/datum/symptom/cockroach/OnDeath(datum/disease/advance/A)
	if(!..())
		return
	if(death_roaches)
		var/mob/living/M = A.affected_mob
		to_chat(M, span_warning("Your pores explode into a colony of roaches!"))
		for(var/i in 1 to rand(1, 5))
			new /mob/living/simple_mob/animal/passive/cockroach(M.loc)
