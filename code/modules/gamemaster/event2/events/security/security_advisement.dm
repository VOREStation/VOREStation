/datum/event2/meta/security_screening
	name = "security screening"
	departments = list(DEPARTMENT_SECURITY, DEPARTMENT_EVERYONE)
	chaotic_threshold = EVENT_CHAOS_THRESHOLD_HIGH_IMPACT // So this won't get called in the middle of a crisis.
	event_type = /datum/event2/event/security_screening

/datum/event2/meta/security_screening/get_weight()
	. = 0
	var/sec = GLOB.metric.count_people_in_department(DEPARTMENT_SECURITY)
	if(!sec < 2)
		return 0 // Can't screen with no security.
	. += sec * 10
	. += GLOB.metric.count_people_in_department(DEPARTMENT_EVERYONE) * 2

	// Having ""suspecious"" people present makes this more likely to be picked.
	var/suspicious_people = 0
	suspicious_people += GLOB.metric.count_all_of_specific_species(SPECIES_PROMETHEAN) * 20
	suspicious_people += GLOB.metric.count_all_of_specific_species(SPECIES_UNATHI) * 10
	suspicious_people += GLOB.metric.count_all_of_specific_species(SPECIES_ZADDAT) * 10
	suspicious_people += GLOB.metric.count_all_of_specific_species(SPECIES_SKRELL) * 5 // Not sure why skrell are so high.
	suspicious_people += GLOB.metric.count_all_of_specific_species(SPECIES_TAJARAN) * 5
	suspicious_people += GLOB.metric.count_all_of_specific_species(SPECIES_TESHARI) * 5
	suspicious_people += GLOB.metric.count_all_of_specific_species(SPECIES_HUMAN_VATBORN) * 5
	suspicious_people += GLOB.metric.count_all_FBPs_of_kind(FBP_DRONE) * 20
	suspicious_people += GLOB.metric.count_all_FBPs_of_kind(FBP_POSI) * 10
	if(!suspicious_people)
		return 0
	. += suspicious_people

/datum/event2/event/security_screening
	var/victim = null
	var/list/species_weights = list(
		SPECIES_SKRELL = 9,
		SPECIES_UNATHI = 15,
		SPECIES_HUMAN_VATBORN = 6,
		SPECIES_TESHARI = 2,
		SPECIES_TAJARAN = 3,
		SPECIES_DIONA = 1,
		SPECIES_ZADDAT = 25,
		SPECIES_PROMETHEAN = 30
	)

	var/list/synth_weights = list(
		FBP_CYBORG = 15,
		FBP_DRONE = 30,
		FBP_POSI = 25
	)

/datum/event2/event/security_screening/set_up()
	var/list/end_weights = list()

	// First pass makes popular things more likely to get picked, e.g. 5 prommies vs 1 drone.
	for(var/species_name in species_weights)
		var/give_weight = 0
		for(var/datum/data/record/R in GLOB.data_core.general)
			if(R.fields["species"] == species_name)
				give_weight += species_weights[species_name]

		end_weights[species_name] = give_weight

	for(var/bot_type in synth_weights)
		var/give_weight = 0
		for(var/datum/data/record/R in GLOB.data_core.general)
			if(R.fields["brain_type"] == bot_type)
				give_weight += synth_weights[bot_type]

		end_weights[bot_type] = give_weight

	// Second pass eliminates things that don't exist on the station.
	// It's possible to choose something like drones when all the drones are AFK. This prevents that from happening.
	while(end_weights.len) // Keep at it until we find someone or run out of possibilities.
		var/victim_chosen = pickweight(end_weights)

		if(victim_chosen in synth_weights)
			if(GLOB.metric.count_all_FBPs_of_kind(victim_chosen) > 0)
				victim = victim_chosen
				break
		else
			if(GLOB.metric.count_all_of_specific_species(victim_chosen) > 0)
				victim = victim_chosen
				break
		if(!victim)
			end_weights -= victim_chosen

	if(!victim)
		log_debug("Security Screening event failed to find anyone to screen. Aborting.")
		abort()
		return

/datum/event2/event/security_screening/announce()
	command_announcement.Announce("[pick("A nearby Navy vessel", "A Solar official", "A Vir-Gov official", "A NanoTrasen board director")] has \
	requested the screening of [pick("every other", "every", "suspicious", "willing")] [victim] \
	personnel onboard \the [location_name()].", "Security Advisement")
