// Symptoms are the effects that engineered advanced diseases do.

GLOBAL_LIST_INIT(list_symptoms, subtypesof(/datum/symptom))

/datum/symptom
	// Buffs/Debuffs the symptom has to the overall engineered disease.
	var/name = ""
	var/desc = "ERR://355. PanDEMIC was not able to initialize description!" // Someone forgot the description
	var/threshold_descs = list()
	var/stealth = 0
	var/resistance = 0
	var/stage_speed = 0
	var/transmission = 0
	// The type level of the symptom. Higher is harder to generate.
	var/level = 0
	// The severity level of the symptom. Higher is more dangerous.
	var/severity = 0
	// The hash tag for our diseases, we will add it up with our other symptoms to get a unique id! ID MUST BE UNIQUE!!!
	var/id = ""
	var/supress_warning = FALSE
	var/next_activaction = 0
	var/symptom_delay_min = 1 SECONDS
	var/symptom_delay_max = 1 SECONDS
	var/naturally_occuring = TRUE // If this symptom can roll from random diseases

	var/base_message_chance = 10
	var/power = 1
	// If the symptom is neutered or not. If it is, it will only affect stats
	var/neutered = FALSE
	var/stopped = FALSE // Used for Viral Suspended Animaton, stops a symptom but doesn't neuter it.

/datum/symptom/New()
	var/list/S = GLOB.list_symptoms
	for(var/i = 1; i <= length(S); i++)
		if(type == S[i])
			id = "[i]"
			return
	CRASH("We couldn't assign an ID!")

/datum/symptom/proc/Copy()
	var/datum/symptom/new_symp = new type
	new_symp.name = name
	new_symp.id = id
	new_symp.neutered = neutered
	return new_symp

// Called when processing of the advance disease, which holds this symptom, starts.
/datum/symptom/proc/Start(datum/disease/advance/A)
	if(neutered)
		return FALSE
	next_activaction = world.time + rand(symptom_delay_min, symptom_delay_max)
	return TRUE

/datum/symptom/proc/severityset(datum/disease/advance/A)
	severity = initial(severity)

// Called when the advance disease is going to be deleted or when the advance disease stops processing.
/datum/symptom/proc/End(datum/disease/advance/A)
	if(neutered)
		return FALSE
	return TRUE

// Called when the disease activates. It's what makes your diseases work!
/datum/symptom/proc/Activate(datum/disease/advance/A)
	if(!A)
		return FALSE
	if(isbelly(A.affected_mob.loc)) // So you can eat people to "isolate" them. Or get eaten by a macrophage.
		return FALSE
	if(neutered || stopped)
		return FALSE
	if(world.time < next_activaction)
		return FALSE
	else
		next_activaction = world.time + rand(symptom_delay_min, symptom_delay_max)
		return TRUE

// Called when the host dies
/datum/symptom/proc/OnDeath(datum/disease/advance/A)
	return !neutered

// Called when the stage changes
/datum/symptom/proc/OnStageChange(datum/disease/advance/A)
	if(neutered || stopped)
		return FALSE
	return TRUE

/datum/symptom/proc/OnAdd(datum/disease/advance/A)
	return

/datum/symptom/proc/OnRemove(datum/disease/advance/A)
	return

/datum/symptom/proc/generate_threshold_desc()
	return

/datum/symptom/proc/get_symptom_data()
	var/list/data = list()
	data["name"] = name
	data["desc"] = desc
	data["stealth"] = stealth
	data["resistance"] = resistance
	data["stage_speed"] = stage_speed
	data["transmission"] = transmission
	data["neutered"] = neutered
	data["level"] = level
	data["threshold_desc"] = threshold_descs
	return data
