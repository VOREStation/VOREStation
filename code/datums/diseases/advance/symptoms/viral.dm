/*
//////////////////////////////////////
Viral adaptation

	Moderate stealth boost.
	Major Increases to resistance.
	Reduces stage speed.
	No change to transmission
	Critical Level.

BONUS
	Extremely useful for buffing viruses

//////////////////////////////////////
*/
/datum/symptom/viraladaptation
	name = "Viral Self-Adaptation"
	desc = "The virus mimics the function of normal body cells, becoming harder to spot and to eradicate, but reducing it's speed."
	stealth = 3
	resistance = 5
	stage_speed = -3
	transmission = 0
	level = 4
	severity = 0

/*
//////////////////////////////////////
Viral evolution

	Moderate stealth reductopn.
	Major decreases to resistance.
	increases stage speed.
	increase to transmission
	Critical Level.

BONUS
	Extremely useful for buffing viruses

//////////////////////////////////////
*/
/datum/symptom/viralevolution
	name = "Viral Evolutionary Acceleration"
	desc = "The virus quickly adapts to spread as fast as possible both outside and inside a host. This, however, makes the virus easier to spot, and les able to fight off a cure."
	stealth = -2
	resistance = -3
	stage_speed = 5
	transmission = 3
	level = 4

/datum/symptom/viralpower
	name = "Viral Power Multiplier"
	desc = "The vrus has more powerful symptoms. May have unpredictable effects."
	stealth = 2
	resistance = 2
	stage_speed = 2
	transmission = 2
	level = -1
	var/maxpower
	var/powerbudget
	var/scramble = FALSE
	var/used = FALSE

	threshold_descs = list(
		"Transmission 8" = "Constantly scrambles the power of all symptoms.",
		"Stage Speed 8" = "Doubles the power boost."
	)

/datum/symptom/viralpower/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.speed >= 8)
		power = 2
	if(A.transmission >= 8)
		scramble = TRUE

/datum/symptom/viralpower/Activate(datum/disease/advance/A)
	if(!..())
		return
	if(!used)
		for(var/datum/symptom/S as() in A.symptoms)
			if(S == src)
				return
			S.power += power
			maxpower += S.power
		if(scramble)
			powerbudget += power
			maxpower += power
			power = 0
		used = TRUE
	if(scramble)
		var/datum/symptom/S = pick(A.symptoms)
		if(S == src)
			return
		if(powerbudget && (prob(50) || powerbudget == maxpower))
			S.power += 1
			powerbudget -= 1
		else if(S.power >= 2)
			S.power -= 1
			powerbudget += 1
