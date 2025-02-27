/datum/symptom/genetic
	name = "Basic Genetic (does nothing)"
	stealth = 0
	resistance = 0
	stage_speed = 0
	transmission = 0
	level = -1
	base_message_chance = 20
	symptom_delay_min = 1
	symptom_delay_max = 1
	var/passive_message = ""

/datum/symptom/genetic/Start(datum/disease/advance/A)
	if(!..())
		return FALSE
	return TRUE

/datum/symptom/genetic/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/carbon/human/H = A.affected_mob
	switch(A.stage)
		if(4, 5)
			if(passive_message && prob(2))
				to_chat(H, passive_message)
