/datum/disease/advance/random
	name = "Experimental Disease"
	var/randomname = TRUE
	var/datum/symptom/setsymptom = null
	var/max_symptoms_override

/datum/disease/advance/random/minor
	name = "Minor Experimental Disease"
	max_symptoms_override = 4

/datum/disease/advance/random/New(max_symptoms, max_level = 6, min_level = 1, list/guaranteed_symptoms = setsymptom)
	if(!max_symptoms)
		max_symptoms = (2 + rand(1, (VIRUS_SYMPTOM_LIMIT - 2)))
	if(max_symptoms_override)
		max_symptoms = (max_symptoms_override - rand(0, 2))
	if(guaranteed_symptoms)
		if(islist(guaranteed_symptoms))
			max_symptoms -= length(guaranteed_symptoms)
		else
			guaranteed_symptoms = list(guaranteed_symptoms)
			max_symptoms -= 1

	var/list/datum/symptom/possible_symptoms = list()
	for(var/datum/symptom/symptom as anything in subtypesof(/datum/symptom))
		if(symptom in guaranteed_symptoms)
			continue
		if(initial(symptom.level) > max_level || initial(symptom.level) < min_level)
			continue
		if(initial(symptom.level) <= -1)
			continue
		possible_symptoms += symptom
	for(var/i in 1 to max_symptoms)
		var/datum/symptom/chosen_symptom = pick_n_take(possible_symptoms)
		if(chosen_symptom)
			symptoms += new chosen_symptom
	for(var/guaranteed_symptom in guaranteed_symptoms)
		symptoms += new guaranteed_symptom

/datum/disease/advance/random/macrophage
	name = "Unknown Disease"
	setsymptom = /datum/symptom/macrophage

/datum/disease/advance/random/blob
	name = "Blob Spores"
	setsymptom = /datum/symptom/blobspores

// Cold

/datum/disease/advance/cold/New(process = 1, datum/disease/advance/D, copy = 0)
	if(!D)
		name = "Cold"
		symptoms = list(new /datum/symptom/sneeze)
	..(process, D, copy)


// Flu

/datum/disease/advance/flu/New(process = 1, datum/disease/advance/D, copy = 0)
	if(!D)
		name = "Flu"
		symptoms = list(new /datum/symptom/cough)
	..(process, D, copy)

// Macrophages

/datum/disease/advance/macrophage/New(process = 1, datum/disease/advance/D, copy = 0)
	if(!D)
		name = "Macrophages"
		symptoms = list(new /datum/symptom/macrophage)
	..(process, D, copy)

// Blob Spores

/datum/disease/advance/blobspores/New(process = 1, datum/disease/advance/D, copy = 0)
	if(!D)
		name = "Blob Spores"
		symptoms = list(new /datum/symptom/blobspores)
	..(process, D, copy)
