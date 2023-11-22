/datum/event2/meta/virus
	name = "viral infection"
	event_class = "virus"
	departments = list(DEPARTMENT_MEDICAL, DEPARTMENT_EVERYONE)
	chaos = 40
	chaotic_threshold = EVENT_CHAOS_THRESHOLD_HIGH_IMPACT
	event_type = /datum/event2/event/virus

/datum/event2/meta/virus/superbug
	name = "viral superbug"
	chaos = 60
	event_type = /datum/event2/event/virus/superbug

/datum/event2/meta/virus/outbreak
	name = "viral outbreak"
	chaos = 60
	event_type = /datum/event2/event/virus/outbreak

/datum/event2/meta/virus/get_weight()
	var/list/virologists = metric.get_people_with_alt_title(/datum/job/doctor, /datum/alt_title/virologist)
	virologists += metric.get_people_with_job(/datum/job/cmo)

	return virologists.len * 25



/datum/event2/event/virus
	announce_delay_lower_bound = 1 MINUTE
	announce_delay_upper_bound = 3 MINUTES
	var/number_of_viruses = 1
	var/virus_power = 2 // Ranges from 1 to 3, with 1 being the weakest.
	var/list/candidates = list()

// A single powerful virus.
/datum/event2/event/virus/superbug
	virus_power = 3

// A lot of weaker viruses.
/datum/event2/event/virus/outbreak
	virus_power = 1
	number_of_viruses = 3



/datum/event2/event/virus/set_up()
	for(var/mob/living/carbon/human/H in player_list)
		if(H.client && !H.isSynthetic() && H.stat != DEAD && !player_is_antag(H.mind) && !H.absorbed)
			candidates += H
	candidates = shuffle(candidates)

/datum/event2/event/virus/announce()
	command_announcement.Announce("Confirmed outbreak of level 7 biohazard aboard \the [location_name()]. \
	All personnel must contain the outbreak.", "Biohazard Alert", new_sound = 'sound/AI/outbreak7.ogg')

/datum/event2/event/virus/start()
	if(!candidates.len)
		log_debug("Virus event could not find any valid targets to infect. Aborting.")
		abort()
		return

	for(var/i = 1 to number_of_viruses)
		var/mob/living/carbon/human/H = LAZYACCESS(candidates, 1)
		if(!H)
			return
		var/datum/disease2/disease/D = new()
		D.makerandom(virus_power)
		log_debug("Virus event is now infecting \the [H] with a new random virus.")
		infect_mob(H, D)
		candidates -= H
