/*
//////////////////////////////////////

Vomiting

	Noticeable.
	No change to resistance.
	Slightly increases stage speed.
	Increases transmissibility.
	Medium Level.

Bonus
	Forces the affected mob to vomit

//////////////////////////////////////
*/

/datum/symptom/vomit
	name = "Vomiting"
	desc = "The virus causes nausea and irritates the stomach, causing occasional vomit."
	stealth = -2
	resistance = 0
	stage_speed = 1
	transmission = 2
	level = 3
	severity = 1
	base_message_chance = 100
	symptom_delay_min = 20 SECONDS
	symptom_delay_max = 60 SECONDS

	var/vomit_blood = FALSE
	var/proj_vomit = 1

	threshold_descs = list(
		"Stage Speed 5" = "Host will vomit blood.",
		"Transmission 6" = "Host will projectile vomit, increasing vomit range.",
		"Stealth 4" = "The symptom remans hidden until active."
	)

/datum/symptom/vomit/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.stealth >= 4)
		supress_warning = FALSE
	if(A.stage_rate >= 5)
		vomit_blood = TRUE
	if(A.transmission >= 6)
		proj_vomit = 5

/datum/symptom/vomit/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/M = A.affected_mob
	if(M.stat == DEAD)
		return
	switch(A.stage)
		if(1, 2, 3, 4)
			if(prob(base_message_chance) && !supress_warning)
				to_chat(M, span_warning(pick("You feel nauseated.", "You feel like you're going to throw up!")))
		else
			vomit(M)

/datum/symptom/vomit/proc/vomit(mob/living/carbon/M)
	M.vomit(20, vomit_blood, stun = 2, distance = proj_vomit)
