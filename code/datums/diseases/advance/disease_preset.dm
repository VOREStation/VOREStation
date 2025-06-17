/datum/disease/advance/random
	var/randomname = TRUE
	var/datum/symptom/setsymptom = null
	var/max_symptoms_override

/datum/disease/advance/random/minor
	max_symptoms_override = 4

/datum/disease/advance/random/New(max_symptoms, max_level = 6, min_level = 1, list/guaranteed_symptoms = setsymptom, var/atom/infected)
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
	Finalize()

	if(randomname)
		var/randname = random_disease_name(infected)
		AssignName(randname)
		name = randname

/mob/living/carbon/human/proc/give_random_dormant_disease(biohazard = 25, min_symptoms = 2, max_symptoms = 4, min_level = 4, max_level = 9, list/guaranteed_symptoms = list())
	. = FALSE
	var/sickrisk = 1

	if(isSynthetic() || HAS_TRAIT(src, STRONG_IMMUNITY_TRAIT)) // Don't bother
		return

	switch(get_species())
		if(SPECIES_UNATHI, SPECIES_TAJARAN) // Mice devourers
			sickrisk = 0.5
		if(SPECIES_XENOCHIMERA)
			// Ronoake Syndrome will go here :)
			return
		if(SPECIES_PROMETHEAN) // Too clean
			return

	if(prob(min(100, (biohazard * sickrisk))))
		var/symptom_amt = rand(min_symptoms, max_symptoms)
		var/datum/disease/advance/dormant_disease = new /datum/disease/advance/random(symptom_amt, max_level, min_level, guaranteed_symptoms, infected = src)
		dormant_disease.virus_modifiers |= DORMANT
		dormant_disease.spread_flags = DISEASE_SPREAD_NON_CONTAGIOUS
		dormant_disease.spread_text = "None"
		dormant_disease.visibility_flags |= HIDDEN_SCANNER
		ForceContractDisease(dormant_disease, TRUE)
		return TRUE

/datum/disease/advance/random/macrophage
	setsymptom = /datum/symptom/macrophage

/datum/disease/advance/random/blob
	name = "Blob Spores"
	setsymptom = /datum/symptom/blobspores

// Cold

/datum/disease/advance/cold/New(process = 1, datum/disease/advance/D, copy = 0)
	if(!D)
		name = "Engineered Cold"
		symptoms = list(new /datum/symptom/sneeze)
	..(process, D, copy)


// Flu

/datum/disease/advance/flu/New(process = 1, datum/disease/advance/D, copy = 0)
	if(!D)
		name = "Engineered Flu"
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
