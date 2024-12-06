GLOBAL_LIST_EMPTY(current_pending_diseases)
/datum/event/disease_outbreak
	var/datum/disease/chosen_disease
	var/list/disease_blacklist = list(
		/datum/disease/advance,
		/datum/disease/food_poisoning,
		/datum/disease/gbs // Terrible. It's only in the code to scare people.
	)
	var/static/list/transmissable_symptoms = list()
	var/static/list/diseases_minor = list()
	var/static/list/diseases_moderate_major = list()

/datum/event/disease_outbreak/setup()
	if(isemptylist(diseases_minor) && isemptylist(diseases_moderate_major))
		populate_diseases()
	if(isemptylist(transmissable_symptoms))
		populate_symptoms()
	var/datum/disease/virus
	if(prob(50))
		switch(severity)
			if(EVENT_LEVEL_MODERATE)
				virus = pick(diseases_minor)
			if(EVENT_LEVEL_MAJOR)
				virus = pick(diseases_moderate_major)
			else
				stack_trace("Disease Outbreak: Invalid Event Level [severity]. Expected: 1-2")
				virus = /datum/disease/cold
		chosen_disease = new virus
	else
		if(severity == EVENT_LEVEL_MAJOR)
			chosen_disease = create_virus(severity * pick(2,3))	//50% chance for a major disease instead of a moderate one
		else
			chosen_disease = create_virus(severity * 2)

	chosen_disease.carrier = TRUE

/datum/event/disease_outbreak/start()
	GLOB.current_pending_diseases += chosen_disease

	var/list/candidates = list()
	for(var/mob/living/carbon/human/G in human_mob_list)
		if(G.mind && G.stat != DEAD && G.is_client_active(5) && !player_is_antag(G.mind))
			var/area/A = get_area(G)
			if(!A)
				continue
			if(!(A.z in using_map.station_levels))
				continue
			if(A.flags & RAD_SHIELDED)
				continue
			if(isbelly(G.loc))
				continue
			if(G.species.virus_immune)
				continue
			candidates += G

	var/chosen_infect = rand(3, 5)

	while(chosen_infect)
		if(!isemptylist(candidates))
			var/mob/living/carbon/human/H = pick(candidates)
			H.ForceContractDisease(chosen_disease)
			candidates -= H
		chosen_infect--

//Creates a virus with a harmful effect, guaranteed to be spreadable by contact or airborne
/datum/event/disease_outbreak/proc/create_virus(max_severity = 6)
	var/datum/disease/advance/A = new /datum/disease/advance
	A.symptoms = A.GenerateSymptomsBySeverity(max_severity - 1, max_severity, 2) //Choose "Payload" symptoms
	A.AssignProperties(A.GenerateProperties())
	var/list/symptoms_to_try = transmissable_symptoms.Copy()
	while(length(symptoms_to_try))
		if(A.spread_text != "Blood")
			break
		if(length(A.symptoms) < VIRUS_SYMPTOM_LIMIT)	//Ensure the virus is spreadable by adding symptoms that boost transmission
			var/datum/symptom/TS = pick_n_take(symptoms_to_try)
			A.AddSymptom(new TS)
		else
			popleft(A.symptoms)	//We have a full symptom list but are still not transmittable. Try removing one of the "payloads"

		A.AssignProperties(A.GenerateProperties())
	A.name = pick(alphabet_uppercase) + num2text(rand(1,9)) + pick(alphabet_uppercase) + num2text(rand(1,9)) + pick("v", "V", "-" + num2text(game_year), "")
	A.Refresh()
	return A

/datum/event/disease_outbreak/proc/populate_diseases()
	for(var/candidate in subtypesof(/datum/disease))
		var/datum/disease/CD = new candidate
		if(is_type_in_list(CD, disease_blacklist))
			continue
		switch(CD.severity)
			if(NONTHREAT, MINOR)
				diseases_minor += candidate
			if(MEDIUM, HARMFUL, DANGEROUS, BIOHAZARD)
				diseases_moderate_major += candidate

/datum/event/disease_outbreak/proc/populate_symptoms()
	for(var/candidate in subtypesof(/datum/symptom))
		var/datum/symptom/CS = candidate
		if(initial(CS.transmittable) > 1)
			transmissable_symptoms += candidate
