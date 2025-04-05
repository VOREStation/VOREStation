/datum/symptom/radiation
	name = "Irradiant Cells"
	desc = "Causes the cells in the host's body to give off harmful radiation."
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

/datum/symptom/radconversion
	name = "Aptopic Culling"
	desc = "The virus causes infected cells to die off when exposed to radiation, causing open wounds to appear on the host's flesh. The end result of this process is the removal of radioactive contamination from the host."
	stealth = 1
	resistance = 1
	stage_speed = 1
	transmission = -2
	level = 8
	severity = 0
	symptom_delay_min = 1
	symptom_delay_max = 1

	var/toxheal = FALSE
	var/cellheal = FALSE

	threshold_descs = list(
		"Stage Speed 6" = "The disease also kills off contaminated cells, converting Toxin damage to Brute damage, at an efficient rate.",
		"Resistance 12" = "The disease also kills off genetically damaged cells, coverting Genetic damage to Burn damage, an inefficient rate."
	)

/datum/symptom/radconversion/severityset(datum/disease/advance/A)
	. = ..()
	if(A.stage_rate >= 6)
		severity -= 1
	if(A.resistance >= 12)
		severity -= 1

/datum/symptom/radconversion/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.stage_rate >= 6)
		toxheal = TRUE
	if(A.resistance >= 12)
		cellheal = TRUE

/datum/symptom/radconversion/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/carbon/human/H = A.affected_mob
	if(A.stage >= 4)
		if(H.radiation)
			H.radiation -= max(H.radiation * 0.05, min(10, H.radiation))
			H.take_overall_damage(2)
			if(prob(5))
				if(H.stat != DEAD)
					to_chat(H, span_userdanger("A tear opens in your flesh!"))
				blood_splatter(H.loc, H)
		if(H.getToxLoss() && toxheal)
			H.adjustToxLoss(-2)
			H.take_overall_damage(1)
			if(prob(5))
				if(H.stat != DEAD)
					to_chat(H, span_userdanger("A tear opens in your flesh!"))
				blood_splatter(H.loc, H)
		if(H.getCloneLoss() && cellheal)
			H.adjustCloneLoss(-1)
			H.take_overall_damage(burn = 2)
			if(prob(5) && H.stat != DEAD)
				to_chat(H, span_userdanger("A nasty rash appears on your skin!"))
	else if (prob(2) && ((H.getCloneLoss() && cellheal) || (H.getToxLoss() && toxheal) || H.radiation) && H.stat != DEAD)
		to_chat(H, span_notice("You feel a tingling sensation."))
