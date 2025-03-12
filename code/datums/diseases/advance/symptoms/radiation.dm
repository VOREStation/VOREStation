/datum/symptom/radiation
	name = "Iraddiant Cells"
	stealth = -1
	resistance = 2
	stage_speed = 1
	transmission = 2
	level = 7
	severity = 3
	symptom_delay_min = 10 SECONDS
	symptom_delay_max = 40 SECONDS
	threshold_descs = list(
		"Speed 8" = "Host takes radiation damage faster."
	)

/datum/symptom/radiation/severityset(datum/disease/advance/A)
	. = ..()
	if(A.stage_rate >= 8)
		severity += 1

/datum/symptom/radiation/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.stage_rate >= 8)
		power = 2

/datum/symptom/radiation/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/carbon/human/H = A.affected_mob
	if(H.stat == DEAD)
		return
	switch(A.stage)
		if(1)
			if(prob(10))
				to_chat(H, span_notice("You feel off..."))
		if(2, 3)
			if(prob(50))
				to_chat(H, span_danger("You feel like the atoms inside you are beginning to split..."))
		if(4, 5)
			radiate(H)

/datum/symptom/radiation/proc/radiate(mob/living/carbon/human/H)
	to_chat(H, span_danger("You feel a wave of pain throughout your body!"))
	H.radiation += 50 * power
	return TRUE
