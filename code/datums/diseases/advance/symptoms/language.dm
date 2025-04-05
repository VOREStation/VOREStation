/*
//////////////////////////////////////

Lingual Disocation

	Improves stealth.
	Increases resistance.
	Decreases stage speed.
	Slightly decreases transmissibility.
	Moderate Level.

Bonus
	Randomly changes the language of the mob.

//////////////////////////////////////
*/

/datum/symptom/language
	name = "Lingual Disocation"
	desc = "The virus attack the broca area of the brain, messing with the host's speech."
	stealth = 0
	resistance = 2
	stage_speed = 1
	transmission = 1
	level = 1
	severity = 1
	symptom_delay_min = 20 SECONDS
	symptom_delay_max = 50 SECONDS

	var/gibberish = FALSE

	threshold_descs = list(
		"Resistance 5" = "The host might end up speaking a completely made up language."
	)

/datum/symptom/language/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.resistance)
		gibberish = TRUE

/datum/symptom/language/Activate(var/datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/L = A.affected_mob
	if(L.stat == DEAD)
		return

	if(gibberish && prob(10))
		L.apply_default_language(LANGUAGE_GIBBERISH)
	else
		L.apply_default_language(pick(L.languages))
