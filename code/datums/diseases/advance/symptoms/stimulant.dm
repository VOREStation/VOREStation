/*
//////////////////////////////////////

Overactve Adrenal Gland

	No change to stealth.
	Slightly decreases resistance.
	Increases stage speed.
	Decreases transmittablity considerably.
	Moderate Level.

Bonus
	The host produces hyperzine and gets very jittery

//////////////////////////////////////
*/

/datum/symptom/stimulant
	name = "Hyperactivity"
	desc = "The virus causes restlessness, nervousness and hyperactivity, increasing the rate at which the host needs to eat, but making them harder to tire out"
	stealth = -4
	resistance = 0
	stage_speed = 2
	transmission = -3
	level = 8
	severity = 1
	symptom_delay_min = 1
	symptom_delay_max = 1

	var/clearacc = FALSE

	threshold_descs = list(
		"Resistance 8" = "This virus causes an even greater rate of nutriment loss, able to cause starvation, but it's energy gain greatly increases.",
		"Stage 8" = "The virus causes extreme nervousness and paranoia, resulting in occasional hallucinations, and extreme restlessness, but great overall energy."
	)

/datum/symptom/stimulant/severityset(datum/disease/advance/A)
	. = ..()
	if(A.resistance >= 8)
		severity -= 1
	if(A.stage_rate >= 8)
		severity -= 1

/datum/symptom/stimulant/Start(datum/disease/advance/A)
	if(!..())
		return
	power = initial(power)
	if(A.resistance >= 8)
		power += 2
	if(A.stage_rate >= 8)
		power += 1
		clearacc = TRUE

/datum/symptom/stimulant/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/carbon/human/H = A.affected_mob
	if(H.stat == DEAD)
		return
	switch(A.stage)
		if(2 to 3)
			if(prob(power) && H.stat)
				H.jitteriness += (2 * power)
				H.emote("twitch")
				to_chat(H, span_notice("[pick("you feel energetic!", "You feel well-rested.", "You feel great!")]"))
		if(4 to 5)
			H.drowsyness = max(0, H.drowsyness - 10 * power)
			H.AdjustSleeping(-10 * power)
			H.AdjustStunned(-10 * power)
			if(prob(power) && prob(50))
				if(H.stat)
					H.emote("twitch")
					H.make_jittery(2 * power)
					H.reagents.add_reagent(REAGENT_ID_HYPERZINE, 5)
				to_chat(H, span_notice("[pick("You feel nevervous...", "You feel anxious.", "You feel like everything is moving in slow motion.")]"))
			if(H.nutrition > 150 - (30 * power))
				H.nutrition = max(150 - (30 * power), H.nutrition - (2 * power))
			if(prob(25))
				H.make_jittery(2 * power)
			if(clearacc)
				if(prob(power) && prob(50))
					if(H.stat)
						H.emote("scream")
					H.hallucination = min(20, H.hallucination + (5 * power))
