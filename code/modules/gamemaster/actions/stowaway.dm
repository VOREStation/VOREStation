/datum/gm_action/stowaway
	name = "stowaway pod"
	departments = list(DEPARTMENT_EVERYONE, DEPARTMENT_SECURITY)
	chaotic = 10
	observers_used = TRUE
	var/area/target_area	// Chosen target area
	var/area/target_turf	// Chosen target turf in target_area
	var/list/area/excluded = list(
		/area/submap,
		/area/shuttle,
		/area/crew_quarters,
		/area/holodeck,
		/area/engineering/engine_room
	)

	var/list/area/included = list(
		/area/maintenance
		)

/datum/gm_action/stowaway/set_up()
	severity = pickweight(EVENT_LEVEL_MUNDANE = 20,
	EVENT_LEVEL_MODERATE = 5,
	EVENT_LEVEL_MAJOR = 1
	)

	var/list/area/grand_list_of_areas = get_station_areas(excluded)

	for(var/area/Incl in included)
		for(var/area/A in grand_list_of_areas)
			if(!istype(A, Incl))
				grand_list_of_areas -= A

	// Okay, now lets try and pick a target! Lets try 10 times, otherwise give up
	for(var/i in 1 to 10)
		var/area/A = pick(grand_list_of_areas)
		if(is_area_occupied(A))
			log_debug("[name] event: Rejected [A] because it is occupied.")
			continue
		// A good area, great! Lets try and pick a turf
		var/list/turfs = list()
		for(var/turf/simulated/floor/F in A)
			if(turf_clear(F))
				turfs += F
		if(turfs.len == 0)
			log_debug("[name] event: Rejected [A] because it has no clear turfs.")
			continue
		target_area = A
		target_turf = pick(turfs)

	if(!target_area)
		log_debug("[name] event: Giving up after too many failures to pick target area")
		return

/datum/gm_action/stowaway/start()
	if(!target_turf)
		return
	..()

	var/obj/structure/ghost_pod/ghost_activated/human/HP = new (target_turf)

	if(severity == EVENT_LEVEL_MUNDANE || istype(ticker.mode, /datum/game_mode/extended))
		HP.make_antag = MODE_STOWAWAY

	else if(severity == EVENT_LEVEL_MODERATE)
		HP.make_antag = MODE_RENEGADE
		HP.occupant_type = "renegade [HP.occupant_type]"

	else if(severity == EVENT_LEVEL_MAJOR)
		HP.make_antag = MODE_INFILTRATOR
		HP.occupant_type = "volatile [HP.occupant_type]"

	say_dead_object("A <span class='notice'>[HP.occupant_type]</span> pod is now available in \the [target_area].", HP)

/datum/gm_action/stowaway/get_weight()
	return -20 + (metric.count_people_in_department(DEPARTMENT_SECURITY) * 15 + metric.count_people_in_department(DEPARTMENT_SYNTHETIC) * 5 + metric.count_people_in_department(DEPARTMENT_EVERYONE) * 1)

/datum/gm_action/stowaway/announce()
	spawn(rand(15 MINUTES, 30 MINUTES))
		if(prob(20) && severity >= EVENT_LEVEL_MODERATE && atc && !atc.squelched)
			atc.msg("Attention civilian vessels in [using_map.starsys_name] shipping lanes, caution is advised as [pick("an unidentified vessel", "a known criminal's vessel", "a derelict vessel")] has been detected passing multiple local stations.")
