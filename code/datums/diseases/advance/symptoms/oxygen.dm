/*
//////////////////////////////////////

Self-Respiration

	Slightly hidden.
	Lowers resistance significantly.
	Decreases stage speed significantly.
	Decreases transmittablity tremendously.
	Fatal Level.

Bonus
	The body generates dexalin.

//////////////////////////////////////
*/

/datum/symptom/oxygen
	name = "Self-Respiration"
	stealth = 1
	resistance = -3
	stage_speed = -3
	transmission = -4
	level = 8
	severity = -1
	base_message_chance = 5
	symptom_delay_min = 1 SECONDS
	symptom_delay_max = 1 SECONDS
	var/regenerate_blood = FALSE

	threshold_descs = list(
		"Resistance 8" = "Additionally regenerates lost blood."
	)

/datum/symptom/oxygen/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.resistance >= 8)
		regenerate_blood = TRUE

/datum/symptom/oxygen/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/carbon/human/H = A.affected_mob
	switch(A.stage)
		if(4, 5)
			H.dna.SetSEState(NOBREATHBLOCK, 1)
			domutcheck(H, null, TRUE)
			H.oxyloss = max(0, H.oxyloss - 7)
			H.losebreath = max(0, H.losebreath - 4)
			if(regenerate_blood && H.vessel.get_reagent_amount(REAGENT_ID_BLOOD) < H.species.blood_volume)
				H.add_chemical_effect(CE_BLOODRESTORE, 1)
		else
			if(prob(base_message_chance) && H.stat != DEAD)
				to_chat(H, span_notice("[pick("Your lungs feel great.", "You realize you haven't been breathing.", "You don't feel the need to breathe.", "Something smells rotten.", "You feel peckish.")]"))
	return

/datum/symptom/oxygen/OnStageChange(new_stage, datum/disease/advance/A)
	if(!..())
		return FALSE
	var/mob/living/carbon/human/H = A.affected_mob
	if(A.stage <= 3)
		H.dna.SetSEState(NOBREATHBLOCK, 0)
		domutcheck(H, null, TRUE)
	return TRUE

/datum/symptom/oxygen/End(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/carbon/human/H = A.affected_mob
	H.dna.SetSEState(NOBREATHBLOCK, 0)
	domutcheck(H, null, TRUE)
