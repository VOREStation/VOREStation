GLOBAL_LIST_EMPTY(archive_diseases)

GLOBAL_LIST_INIT(advance_cures, list(
	list(REAGENT_ID_WATER, REAGENT_ID_NUTRIMENT, REAGENT_ID_IRON),
	list(REAGENT_ID_ETHANOL, REAGENT_ID_RADIUM, REAGENT_ID_POTASSIUM, REAGENT_ID_LITHIUM),
	list(REAGENT_ID_SODIUMCHLORIDE, REAGENT_ID_NICOTINE, REAGENT_ID_BLISS),
	list(REAGENT_ID_ANTITOXIN, REAGENT_ID_ETHYLREDOXRAZINE, REAGENT_ID_FUEL, REAGENT_ID_CLEANER),
	list(REAGENT_ID_SPACEACILLIN, REAGENT_ID_MINDBREAKER, REAGENT_ID_CRYOXADONE),
	list(REAGENT_ID_TRAMADOL, REAGENT_ID_KELOTANE, REAGENT_INAPROVALINE),
	list(REAGENT_ID_LEPORAZINE, REAGENT_ID_HOLYWATER, REAGENT_ID_ALKYSINE),
	list(REAGENT_ID_PAROXETINE, REAGENT_ID_RADIUM, REAGENT_ID_PHORON),
	list(REAGENT_ID_ADRANOL, REAGENT_ID_MUTAGEN, REAGENT_ID_ARITHRAZINE),
	list(REAGENT_ID_LIPOZINE, REAGENT_ID_LUBE, REAGENT_ID_SACID),
	list(REAGENT_ID_ASUSTENANCE, REAGENT_ID_CORDRADAXON, REAGENT_ID_OXYCODONE),
))

/datum/disease/advance
	name = DEVELOPER_WARNING_NAME
	desc = "An engineered disease which can contain a multitude of symptoms."
	form = "Advance Disease"
	agent = "advance microbes"
	max_stages = 5
	disease_flags = CURABLE|CAN_CARRY|CAN_RESIST|CAN_NOT_POPULATE
	spread_text = "Unknown"
	viable_mobtypes = list(/mob/living/carbon/human)

	var/last_modified_by = "no CKEY"
	var/resistance
	var/stealth
	var/stage_rate
	var/transmission
	var/severity
	var/speed

	var/mutability = 1
	var/keepid = FALSE
	var/archivecure

	var/list/symptoms = list()

	var/s_processing = FALSE
	var/id = ""

/datum/disease/advance/New(process = TRUE, datum/disease/advance/D)
	if(istype(D))
		for(var/datum/symptom/S in D.symptoms)
			symptoms += new S.type
	else
		D = null

	Refresh()
	..(process, D)
	return

/datum/disease/advance/Destroy()
	if(s_processing)
		for(var/datum/symptom/S in symptoms)
			S.End(src)
	return ..()

/datum/disease/advance/stage_act()
	if(!..())
		return FALSE
	if(symptoms && length(symptoms))

		if(!s_processing)
			s_processing = TRUE
			for(var/datum/symptom/S in symptoms)
				S.Start(src)

		for(var/datum/symptom/S in symptoms)
			S.Activate(src)
	else
		CRASH("We do not have any symptoms during stage_act()!")
	return TRUE

/datum/disease/advance/IsSame(datum/disease/advance/D)
	if(!istype(D, /datum/disease/advance))
		return FALSE

	if(GetDiseaseID() != D.GetDiseaseID())
		return FALSE
	return TRUE

/datum/disease/advance/cure(resistance = TRUE)
	if(affected_mob)
		var/id = "[GetDiseaseID()]"
		if(resistance && !(id in affected_mob.GetResistances()))
			affected_mob.GetResistances()[id] = id
		remove_virus()
	qdel(src)

/datum/disease/advance/Copy()
	var/datum/disease/advance/A = ..()
	QDEL_LIST(A.symptoms)
	for(var/datum/symptom/S as anything in symptoms)
		A.symptoms += S.Copy()
	A.virus_modifiers = virus_modifiers
	A.spread_flags = spread_flags
	A.disease_flags = disease_flags
	A.resistance = resistance
	A.stealth = stealth
	A.stage_rate = stage_rate
	A.transmission = transmission
	A.severity = severity
	A.speed = speed
	A.mutability = mutability
	A.keepid = keepid
	A.id = id
	A.Refresh()
	return A

/datum/disease/advance/proc/Mix(datum/disease/advance/D)
	if(!(IsSame(D)))
		var/list/possible_symptoms = shuffle(D.symptoms)
		for(var/datum/symptom/S in possible_symptoms)
			AddSymptom(S.Copy())

/datum/disease/advance/proc/HasSymptom(datum/symptom/S)
	for(var/datum/symptom/symp in symptoms)
		if(symp.id == S.id)
			return 1
	return 0

/datum/disease/advance/proc/GenerateSymptomsBySeverity(sev_min, sev_max, amount = 1)

	var/list/generated = list()

	var/list/possible_symptoms = list()
	for(var/symp in GLOB.list_symptoms)
		var/datum/symptom/S = new symp
		if(S.severity >= sev_min && S.severity <= sev_max)
			if(!HasSymptom(S))
				possible_symptoms += S

	if(!length(possible_symptoms))
		return generated

	for(var/i = 1 to amount)
		generated += pick_n_take(possible_symptoms)

	return generated

/datum/disease/advance/proc/GenerateSymptoms(level_min, level_max, amount_get = 0)

	var/list/generated = list()

	// Generate symptoms. By default, we only choose non-deadly symptoms.
	var/list/possible_symptoms = list()
	for(var/symp in GLOB.list_symptoms)
		var/datum/symptom/S = new symp
		if(S.level >= level_min && S.level <= level_max)
			if(!HasSymptom(S))
				possible_symptoms += S

	if(!length(possible_symptoms))
		return generated

	// Random chance to get more than one symptom
	var/number_of = amount_get
	if(!amount_get)
		number_of = 1
		while(prob(20))
			number_of += 1

	for(var/i = 1; number_of >= i && length(possible_symptoms); i++)
		generated += pick_n_take(possible_symptoms)

	return generated

/datum/disease/advance/proc/Refresh(new_name = FALSE, archive = FALSE)
	GenerateProperties()
	AssignProperties()
	if(s_processing && length(symptoms))
		for(var/datum/symptom/S in symptoms)
			S.Start(src)
			S.OnStageChange(src)

	if(!keepid)
		id = null

	if(!GLOB.archive_diseases[GetDiseaseID()])
		if(new_name)
			AssignName()
		GLOB.archive_diseases[GetDiseaseID()] = src // So we don't infinite loop
		GLOB.archive_diseases[GetDiseaseID()] = new /datum/disease/advance(0, src, 1)
	else
		var/datum/disease/advance/A = GLOB.archive_diseases[GetDiseaseID()]
		var/actual_name = A.name
		if(actual_name != DEVELOPER_WARNING_NAME)
			name = actual_name


/datum/disease/advance/proc/GenerateProperties()
	resistance = 0
	stealth = 0
	stage_rate = 0
	transmission = 0
	severity = 0

	var/c1sev
	var/c2sev
	var/c3sev

	for(var/datum/symptom/S as anything in symptoms)
		resistance += S.resistance
		stealth += S.stealth
		stage_rate += S.stage_speed
		transmission += S.transmission
	for(var/datum/symptom/S as anything in symptoms)
		S.severityset(src)
		if(S.neutered)
			continue
		switch(S.severity)
			if(-INFINITY to 0)
				c1sev += S.severity
			if(1 to 2)
				c2sev = max(c2sev, min(3, (S.severity + c2sev)))
			if(3 to 4)
				c2sev = max(c2sev, min(4, (S.severity + c2sev)))
			if(5 to INFINITY)
				if(c3sev >= 5)
					c3sev += (S.severity -3)
				else
					c3sev += S.severity

	severity += (max(c2sev, c3sev) + c1sev)

/datum/disease/advance/proc/AssignProperties()

	if(global_flag_check(virus_modifiers, DORMANT) || stealth >= 2)
		visibility_flags |= HIDDEN_SCANNER
	else
		visibility_flags &= ~HIDDEN_SCANNER

	SetSpread()
	permeability_mod = max(CEILING(0.4 * transmission, 1), 1)
	cure_chance = clamp(7.5 - (0.5 * resistance), 5, 10)
	stage_prob = max(stage_rate, 2)
	SetDanger(severity)
	GenerateCure()
	symptoms = sortList(symptoms, GLOBAL_PROC_REF(cmp_advdisease_symptomid_asc))

/datum/disease/advance/proc/SetSpread()
	if(global_flag_check(virus_modifiers, FALTERED))
		spread_flags = DISEASE_SPREAD_FALTERED
		spread_text = "Intentional Injection"
	if(global_flag_check(virus_modifiers, DORMANT))
		spread_flags = DISEASE_SPREAD_NON_CONTAGIOUS
		spread_text = "None"
	else
		switch(transmission)
			if(-INFINITY to 5)
				spread_flags = DISEASE_SPREAD_BLOOD
				spread_text = "Blood"
			if(6 to 10)
				spread_flags = DISEASE_SPREAD_BLOOD | DISEASE_SPREAD_FLUIDS
				spread_text = "Fluids"
			if(11 to INFINITY)
				spread_flags = DISEASE_SPREAD_BLOOD | DISEASE_SPREAD_FLUIDS | DISEASE_SPREAD_CONTACT
				spread_text = "On Contact"

/datum/disease/advance/proc/SetDanger(level_sev)

	switch(level_sev)

		if(-INFINITY to -2)
			danger = DISEASE_BENEFICIAL
		if(-1)
			danger = DISEASE_POSITIVE
		if(0)
			danger = DISEASE_NONTHREAT
		if(1)
			danger = DISEASE_MINOR
		if(2)
			danger = DISEASE_MEDIUM
		if(3)
			danger = DISEASE_HARMFUL
		if(4)
			danger = DISEASE_DANGEROUS
		if(5)
			danger = DISEASE_BIOHAZARD
		if(6 to INFINITY)
			danger = DISEASE_PANDEMIC
		else
			danger = "Unknown"

/datum/disease/advance/proc/GenerateCure()
	if(GLOB.archive_diseases[id])
		var/datum/disease/advance/archived = GLOB.archive_diseases[id]
		cures = archived.cures
		cure_text = archived.cure_text
	else
		var/res = clamp(resistance - (length(symptoms) / 2), 1, length(GLOB.advance_cures))
		cures = list(pick(GLOB.advance_cures[res]))
		var/datum/reagent/cure_reag = SSchemistry.chemical_reagents[cures[1]]
		if(!cure_reag) // Something went terribly wrong, return to sippy
			cure_reag = /datum/reagent/water
		cure_text = cure_reag.name
		archivecure = res
	return

// Randomly generate a symptom, has a chance to lose or gain a symptom.
/datum/disease/advance/proc/Evolve(min_level, max_level, ignore_mutable = FALSE)
	if(global_flag_check(virus_modifiers, IMMUTABLE) && !ignore_mutable)
		return
	var/s = safepick(GenerateSymptoms(min_level, max_level, 1))
	if(s)
		AddSymptom(s)
		Refresh(TRUE)
	return

// Randomly generates a symptom from a given list, has a chance to lose or gain a symptom.
/datum/disease/advance/proc/PickyEvolve(list/datum/symptom/D, ignore_mutable = FALSE)
	if(global_flag_check(virus_modifiers, IMMUTABLE) && !ignore_mutable)
		return
	var/s = safepick(D)
	if(s)
		AddSymptom(new s)
		Refresh(TRUE)
	return

// Randomly remove a symptom.
/datum/disease/advance/proc/Devolve(ignore_mutable = FALSE)
	if(global_flag_check(virus_modifiers, IMMUTABLE) && !ignore_mutable)
		return
	if(length(symptoms) > 1)
		var/s = safepick(symptoms)
		if(s)
			RemoveSymptom(s)
			Refresh(TRUE)
	return

// Randomly neuter a symptom.
/datum/disease/advance/proc/Neuter(ignore_mutable = FALSE)
	if(global_flag_check(virus_modifiers, IMMUTABLE) && !ignore_mutable)
		return
	if(symptoms.len)
		var/s = safepick(symptoms)
		if(s)
			NeuterSymptom(s)

// Falter the disease, making it non-spreadable.
/datum/disease/advance/proc/Falter()
	if(global_flag_check(virus_modifiers, FALTERED))
		return
	else
		virus_modifiers |= FALTERED
		spread_flags = DISEASE_SPREAD_BLOOD
		spread_text = "Intentional Injection"

// Name the disease.
/datum/disease/advance/proc/AssignName(new_name = "Unknown")
	Refresh()
	var/datum/disease/advance/A = GLOB.archive_diseases[GetDiseaseID()]
	A.name = new_name
	for(var/datum/disease/advance/AD in GLOB.active_diseases)
		AD.Refresh()

// Return a unique ID of the disease.
/datum/disease/advance/GetDiseaseID()
	if(!id)
		var/list/L = list()
		for(var/datum/symptom/S in symptoms)
			if(S.neutered)
				L += "[S.id]N"
			else
				L += S.id
		L = sortList(L) // Sort the list so it doesn't matter which order the symptoms are in.
		var/result = jointext(L, ":")
		id = result
	return id

/datum/disease/advance/proc/Finalize()
	for(var/datum/symptom/S in symptoms)
		S.OnAdd(src)

// Add a symptom, if it is over the limit (with a small chance to be able to go over)
// we take a random symptom away and add the new one.
/datum/disease/advance/proc/AddSymptom(datum/symptom/S)

	if(HasSymptom(S))
		return

	if(length(symptoms) < (VIRUS_SYMPTOM_LIMIT - 1) + rand(-1, 1))
		symptoms += S
	else
		RemoveSymptom(pick(symptoms))
		symptoms += S
	Refresh()

// Simply removes the symptom.
/datum/disease/advance/proc/RemoveSymptom(datum/symptom/S)
	symptoms -= S
	return

// Neuters a symptom, allowing it only for stats.
/datum/disease/advance/proc/NeuterSymptom(datum/symptom/S)
	if(!S.neutered)
		S.neutered = TRUE
		S.name += " (neutered)"
		S.OnRemove(src)

/datum/disease/advance/try_infect(mob/living/infectee, make_copy = TRUE)
	var/list/advance_diseases = list()
	var/channel = check_channel()
	for(var/datum/disease/advance/disease in infectee.GetViruses())
		var/other_channel = disease.check_channel()
		if(global_flag_check(disease_flags, DORMANT) || global_flag_check(disease.disease_flags, DORMANT))
			continue
		if(IsSame(disease))
			return FALSE
		if(channel == other_channel)
			advance_diseases += disease
	if(advance_diseases.len > 0)
		sortList(advance_diseases, GLOBAL_PROC_REF(cmp_advdisease_resistance_asc))
		for(var/i in 1 to advance_diseases.len)
			var/datum/disease/advance/competition = advance_diseases[i]
			if(transmission > (competition.resistance * 2))
				competition.cure(FALSE)
			else
				return FALSE
	else if(length(infectee.GetActiveViruses()) >= DISEASE_LIMIT)
		return FALSE
	infect(infectee, make_copy)
	return TRUE

/datum/disease/advance/proc/check_channel()
	switch(severity)
		if(-INFINITY to 0)
			return 1
		if(1 to 4)
			return 2
		if(5 to INFINITY)
			return 3
		else
			return 2

// Mix a list of advance diseases and return the mixed result.
/proc/Advance_Mix(list/D_list)

	var/list/diseases = list()

	for(var/datum/disease/advance/A in D_list)
		if(global_flag_check(A.virus_modifiers, IMMUTABLE))
			return
		diseases += A.Copy()

	if(!length(diseases))
		return null
	if(length(diseases) <= 1)
		return pick(diseases) // Just return the only entry.

	var/i = 0
	// Mix our diseases until we are left with only one result.
	while(i < 20 && length(diseases) > 1)

		i++

		var/datum/disease/advance/D1 = pick(diseases)
		diseases -= D1

		var/datum/disease/advance/D2 = pick(diseases)
		D2.Mix(D1)

	// Should be only 1 entry left, but if not let's only return a single entry
	var/datum/disease/advance/to_return = pick(diseases)
	to_return.disease_flags &= ~DORMANT
	to_return.Refresh(new_name = TRUE)
	return to_return

/proc/SetViruses(datum/reagent/R, list/data)
	if(data)
		var/list/preserve = list()
		if(istype(data) && data["viruses"])
			for(var/datum/disease/A in data["viruses"])
				preserve += A.Copy()
			R.data = data.Copy()
		if(length(preserve))
			R.data["viruses"] = preserve

/client/proc/AdminCreateVirus()
	set category = "Fun.Event Kit"
	set name = "Create Advanced Virus"
	set desc = "Create an advanced virus and release it."

	if(!is_admin(usr))
		return FALSE

	var/i = VIRUS_SYMPTOM_LIMIT
	var/mob/living/carbon/human/H = null

	var/datum/disease/advance/D = new(0, null)
	D.symptoms = list()

	var/list/symptoms = list()
	symptoms += "Done"
	symptoms += GLOB.list_symptoms.Copy()
	do
		if(src)
			var/symptom = tgui_input_list(src, "Choose a symptom to add ([i] remaining)", "Choose a Symptom", symptoms)
			if(isnull(symptom))
				return
			else if(istext(symptom))
				i = 0
			else if(ispath(symptom))
				var/datum/symptom/S = new symptom
				if(!D.HasSymptom(S))
					D.symptoms += S
					i -= 1
	while(i > 0)

	if(length(D.symptoms) > 0)

		var/new_name = tgui_input_text(src, "Name your new disease.", "New Name")
		if(!new_name)
			return FALSE
		D.AssignName(new_name)
		D.Finalize()

		for(var/datum/disease/advance/AD in GLOB.active_diseases)
			AD.Refresh()

		H = tgui_input_list(src, "Choose infectee", "Infectees", GLOB.human_mob_list)

		if(isnull(H))
			return FALSE

		if(!H.HasDisease(D))
			H.ForceContractDisease(D)

		var/list/name_symptoms = list()
		for(var/datum/symptom/S in D.symptoms)
			name_symptoms += S.name
		message_admins("[key_name_admin(src)] has triggered a custom virus outbreak of [D.name]! It has these symptoms: [english_list(name_symptoms)]")
		log_admin("[key_name_admin(src)] infected [key_name_admin(H)] with [D.name]. It has these symptoms: [english_list(name_symptoms)]")

		return TRUE

/datum/disease/advance/infect(mob/living/infectee, make_copy = TRUE)
	var/datum/disease/advance/A = make_copy ? Copy() : src
	if(!initial && !global_flag_check(A.virus_modifiers, IMMUTABLE) && (spread_flags & DISEASE_SPREAD_FLUIDS))
		var/minimum = 1
		if(prob(clamp(35-(A.resistance + A.stealth - A.speed), 0, 50) * (A.mutability)))
			if(infectee.job == JOB_CLOWN || infectee.job == JOB_MIME || prob(1))
				minimum = 0
			else
				minimum = clamp(A.severity - 1, 1, 7)
			A.Evolve(minimum, clamp(A.severity + 4, minimum, 9))
			A.id = GetDiseaseID()
			A.keepid = TRUE
	else
		A.initial = FALSE
	infectee.addDisease(A)
	A.affected_mob = infectee
	GLOB.active_diseases += A

	log_admin("[key_name(src)] has contracted the virus \"[A]\"")

/*
*	Generates a random name for a disease, depending on where it comes from
*/
/datum/disease/advance/proc/random_disease_name(var/atom/diseasesource)

	if(length(symptoms) == 1)
		var/datum/symptom/main_symptom = symptoms[1]
		if(istype(main_symptom) && length(main_symptom.name))
			return main_symptom.name

	// Prefixes. These need a space right after.
	var/list/prefixes = list("Spacer's ", "Space ", "Infectious ","Viral ", "The ", "[capitalize(prob(50) ? pick(GLOB.first_names_male) : pick(GLOB.first_names_female))]'s ", "[capitalize(pick(GLOB.last_names))]'s ", "Acute ")
	var/list/bodies = list(pick("[capitalize(prob(50) ? pick(GLOB.first_names_male) : pick(GLOB.first_names_female))]", "[pick(GLOB.last_names)]"), "Space", "Disease", "Noun", "Cold", "Germ", "Virus")
	// These might need some space before the word, depends on what you want to add.
	var/list/suffixes = list("ism", "itis", "osis", "itosis", " #[rand(1,10000)]", "-[rand(1,100)]", "s", "y", " Virus", " Bug", " Infection", " Disease", " Complex", " Syndrome", " Sickness")

	if(stealth >=2)
		prefixes += "Crypto "
	switch(max(resistance - (symptoms.len / 2), 1))
		if(1)
			suffixes += "-alpha"
		if(2)
			suffixes += "-beta"
		if(3)
			suffixes += "-gamma"
		if(4)
			suffixes += "-delta"
		if(5)
			suffixes += "-epsilon"
		if(6)
			suffixes += pick("-zeta", "-eta", "-theta", "-iota")
		if(7)
			suffixes += pick("-kappa", "-lambda")
		if(8)
			suffixes += pick("-mu", "-nu", "-xi", "-omicron")
		if(9)
			suffixes += pick("-pi", "-rho", "-sigma", "-tau")
		if(10)
			suffixes += pick("-upsilon", "-phi", "-chi", "-psi")
		if(11 to INFINITY)
			suffixes += "-omega"
			prefixes += "Robust "
	switch(transmission - symptoms.len)
		if(-INFINITY to 2)
			prefixes += "Bloodborne "
		if(3)
			prefixes += list("Mucous ", "Kissing ")
		if(4)
			prefixes += "Contact "
			suffixes += " Flu"
		if(5 to INFINITY)
			prefixes += "Airborne "
			suffixes += " Plague"
	switch(severity)
		if(-INFINITY to 0)
			prefixes += "Altruistic "
		if(1 to 2)
			prefixes += "Benign "
		if(3 to 4)
			prefixes += "Malignant "
		if(5)
			prefixes += "Deadly "
			bodies += "Death"
		if(6 to INFINITY)
			prefixes += "Morbid "
			bodies += "Death"
	if(diseasesource)
		if(ishuman(diseasesource))
			var/mob/living/carbon/human/H = diseasesource
			prefixes += pick("[H.name]'s ", "[H.job]'s ", "[H.get_species()]'s ")
			bodies += pick("[H.name]", "[H.job]", "[H.get_species()]")
			if(H.get_species() == SPECIES_UNATHI || H.get_species() == SPECIES_TAJARAN)
				prefixes += list("Vermin ", "Zoo", "Maintenance ")
				bodies += list("Rat", "Maint")
		if(ismouse(diseasesource) && !istype(diseasesource, /mob/living/simple_mob/animal/passive/mouse/white/virology))
			prefixes += list("Vermin ", "Zoo", "Maintenance ")
			bodies += list("Rat", "Maint")
		else switch(diseasesource.type)
			if(/mob/living/simple_mob/animal/passive/mouse/white/virology)
				prefixes += list("Fleming's ", "Standard ")
				bodies += list("Freebie")
			if(/obj/effect/decal/cleanable/blood, /obj/effect/decal/cleanable/vomit/old)
				prefixes += list("Bloody ", "Maintenance ")
				bodies += list("Maint")
			if(/obj/item/reagent_containers/syringe/old)
				prefixes += list("Junkie ", "Maintenance ")
				bodies += list("Needle", "Maint")
	for(var/datum/symptom/S in symptoms)
		if(!S.neutered)
			prefixes += S.prefixes
			bodies += S.bodies
			suffixes += S.suffixes
	switch(rand(1, 3))
		if(1)
			return "[pick(prefixes)][pick(bodies)]"
		if(2)
			return "[pick(prefixes)][pick(bodies)][pick(suffixes)]"
		if(3)
			return "[pick(bodies)][pick(suffixes)]"
