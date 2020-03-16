/var/global/list/event_viruses = list() // so that event viruses are kept around for admin logs, rather than being GCed

/datum/gm_action/viral_infection
	name = "viral infection"
	departments = list(DEPARTMENT_MEDICAL)
	chaotic = 5
	var/list/viruses = list()
	severity = 1

/datum/gm_action/viral_infection/set_up()
	severity = pickweight(EVENT_LEVEL_MUNDANE = 20,
		EVENT_LEVEL_MODERATE = 10,
		EVENT_LEVEL_MAJOR = 3
		)

	//generate 1-3 viruses. This way there's an upper limit on how many individual diseases need to be cured if many people are initially infected
	var/num_diseases = rand(1,3)
	for (var/i=0, i < num_diseases, i++)
		var/datum/disease2/disease/D = new /datum/disease2/disease

		var/strength = 1 //whether the disease is of the greater or lesser variety
		if (severity >= EVENT_LEVEL_MAJOR && prob(75))
			strength = 2
		D.makerandom(strength)
		viruses += D

/datum/gm_action/viral_infection/announce()
	var/level
	if (severity == EVENT_LEVEL_MUNDANE)
		return
	else if (severity == EVENT_LEVEL_MODERATE)
		level = pick("one", "two", "three", "four")
	else
		level = "five"

	spawn(rand(0, 3000))
		if(severity == EVENT_LEVEL_MAJOR || prob(60))
			command_announcement.Announce("Confirmed outbreak of level [level] biohazard aboard \the [station_name()]. All personnel must contain the outbreak.", "Biohazard Alert", new_sound = 'sound/AI/outbreak5.ogg')

/datum/gm_action/viral_infection/start()
	if(!viruses.len) return

	..()

	var/list/candidates = list()	//list of candidate keys
	for(var/mob/living/carbon/human/G in player_list)
		if(G.mind && G.stat != DEAD && G.is_client_active(5) && !player_is_antag(G.mind))
			var/turf/T = get_turf(G)
			if(T.z in using_map.station_levels)
				candidates += G
	if(!candidates.len)	return
	candidates = shuffle(candidates)//Incorporating Donkie's list shuffle

	var/list/used_viruses = list()
	var/list/used_candidates = list()
	severity = max(EVENT_LEVEL_MUNDANE, severity - 1)
	var/actual_severity = severity * rand(1, 3)
	while(actual_severity > 0 && candidates.len)
		var/datum/disease2/disease/D = pick(viruses)
		infect_mob(candidates[1], D.getcopy())
		used_candidates += candidates[1]
		candidates.Remove(candidates[1])
		actual_severity--
		used_viruses |= D

	event_viruses |= used_viruses
	var/list/used_viruses_links = list()
	var/list/used_viruses_text = list()
	for(var/datum/disease2/disease/D in used_viruses)
		used_viruses_links += "<a href='?src=\ref[D];info=1'>[D.name()]</a>"
		used_viruses_text += D.name()

	var/list/used_candidates_links = list()
	var/list/used_candidates_text = list()
	for(var/mob/M in used_candidates)
		used_candidates_links += key_name_admin(M)
		used_candidates_text += key_name(M)

	log_admin("Virus event affecting [english_list(used_candidates_text)] started; Viruses: [english_list(used_viruses_text)]")
	message_admins("Virus event affecting [english_list(used_candidates_links)] started; Viruses: [english_list(used_viruses_links)]")

/datum/gm_action/viral_infection/get_weight()
	return (metric.count_people_in_department(DEPARTMENT_MEDICAL) * 20)
