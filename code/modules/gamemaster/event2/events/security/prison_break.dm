
// Type for inheritence.
// It has a null name, so it won't be ran.
/datum/event2/meta/prison_break
	chaos = 10
	chaotic_threshold = EVENT_CHAOS_THRESHOLD_LOW_IMPACT
	// The weight system can check if people are in these areas.
	// This isn't the same list as what the event itself will break, as the event will also
	// break open areas inbetween the holding area and the public hallway, like the brig area verses
	// the prison area.
	var/list/relevant_areas = list()
	var/list/irrelevant_areas = list()

/datum/event2/meta/prison_break/get_weight()
	// First, don't do this if nobody can fix the doors.
	var/door_fixers = metric.count_people_in_department(DEPARTMENT_ENGINEERING) + metric.count_people_in_department(DEPARTMENT_SYNTHETIC)
	if(!door_fixers)
		return 0
	var/list/afflicted_departments = departments.Copy()
	var/afflicted_crew = 0

	afflicted_departments -= DEPARTMENT_SYNTHETIC
	for(var/D in afflicted_departments)
		afflicted_crew += metric.count_people_in_department(D)

	// Don't do it if nobody is around to ""appreciate"" it.
	if(!afflicted_crew)
		return 0

	var/trapped = get_odds_from_trapped_mobs()

	return 10 + (door_fixers * 20) + (afflicted_crew * 10) + trapped

// This is overriden to have specific events trigger more often based on who is trapped in where, if applicable.
/datum/event2/meta/prison_break/proc/get_odds_from_trapped_mobs()
	return 0

/datum/event2/meta/prison_break/proc/is_mob_in_relevant_area(mob/living/L)
	var/area/A = get_area(L)
	if(!A)
		return FALSE
	if(is_type_in_list(A, relevant_areas) && !is_type_in_list(A, irrelevant_areas))
		return TRUE
	return FALSE

/datum/event2/meta/prison_break/brig
	name = "prison break - brig"
	departments = list(DEPARTMENT_SECURITY, DEPARTMENT_SYNTHETIC)
	event_type = /datum/event2/event/prison_break/brig
	relevant_areas = list(
		/area/security/prison,
		/area/security/security_cell_hallway,
		/area/security/security_processing,
		/area/security/interrogation
	)

/datum/event2/meta/prison_break/brig/get_odds_from_trapped_mobs()
	. = 0
	for(var/mob/living/L in player_list)
		if(is_mob_in_relevant_area(L))
			// Don't count them if they're in security.
			if(!(L in metric.count_people_in_department(DEPARTMENT_SECURITY)))
				. += 40


/datum/event2/meta/prison_break/armory
	name = "prison break - armory"
	departments = list(DEPARTMENT_SECURITY, DEPARTMENT_SYNTHETIC)
	chaos = 40 // Potentially free guns.
	chaotic_threshold = EVENT_CHAOS_THRESHOLD_MEDIUM_IMPACT
	event_type = /datum/event2/event/prison_break/armory

/datum/event2/meta/prison_break/bridge
	name = "prison break - bridge"
	departments = list(DEPARTMENT_COMMAND, DEPARTMENT_SYNTHETIC)
	chaos = 40 // Potentially free spare ID.
	chaotic_threshold = EVENT_CHAOS_THRESHOLD_MEDIUM_IMPACT
	event_type = /datum/event2/event/prison_break/bridge

/datum/event2/meta/prison_break/xenobio
	name = "prison break - xenobio"
	departments = list(DEPARTMENT_RESEARCH, DEPARTMENT_SYNTHETIC)
	chaos = 20 // This one is more likely to actually kill someone.
	chaotic_threshold = EVENT_CHAOS_THRESHOLD_MEDIUM_IMPACT
	event_type = /datum/event2/event/prison_break/xenobio
	relevant_areas = list(/area/rnd/xenobiology)
	irrelevant_areas = list(
		/area/rnd/xenobiology/xenoflora,
		/area/rnd/xenobiology/xenoflora_storage
	)

/datum/event2/meta/prison_break/xenobio/get_odds_from_trapped_mobs()
	. = 0
	for(var/mob/living/simple_mob/slime/xenobio/X in living_mob_list)
		if(is_mob_in_relevant_area(X))
			. += 5


/datum/event2/meta/prison_break/virology
	name = "prison break - virology"
	departments = list(DEPARTMENT_MEDICAL, DEPARTMENT_SYNTHETIC)
	event_type = /datum/event2/event/prison_break/virology
	relevant_areas = list(
		/area/medical/virology,
		/area/medical/virologyaccess
	)

/datum/event2/meta/prison_break/virology/get_odds_from_trapped_mobs()
	. = 0
	for(var/mob/living/L in player_list)
		if(is_mob_in_relevant_area(L))
			// Don't count them if they're in medical.
			if(!(L in metric.count_people_in_department(DEPARTMENT_MEDICAL)))
				. += 40




/datum/event2/event/prison_break
	start_delay_lower_bound = 3 MINUTES
	start_delay_upper_bound = 4 MINUTES
	length_lower_bound = 40 SECONDS
	length_upper_bound = 1 MINUTE
	var/area_display_name = null // A string used to describe the area being messed with.
	var/containment_display_desc = null
	var/list/areas_to_break = list()
	var/list/area_types_to_break = null // Area types to include.
	var/list/area_types_to_ignore = null // Area types to exclude, usually due to undesired inclusion from inheritence.
	var/ignore_blast_doors = FALSE

/datum/event2/event/prison_break/brig
	area_display_name = "Brig"
	containment_display_desc = "imprisonment"
	area_types_to_break = list(
		/area/security/prison,
		/area/security/brig,
		/area/security/security_cell_hallway,
		/area/security/security_processing,
		/area/security/interrogation
	)

/datum/event2/event/prison_break/armory
	area_display_name = "Armory"
	containment_display_desc = "protection"
	area_types_to_break = list(
		/area/security/brig,
		/area/security/warden,
		/area/security/evidence_storage,
		/area/security/security_equiptment_storage,
		/area/security/armoury,
		/area/security/tactical
	)

/datum/event2/event/prison_break/bridge
	area_display_name = "Bridge"
	containment_display_desc = "isolation"
	area_types_to_break = list(
		/area/bridge,
		/area/bridge_hallway
	)

/datum/event2/event/prison_break/xenobio
	area_display_name = "Xenobiology"
	containment_display_desc = "containment"
	area_types_to_break = list(/area/rnd/xenobiology)
	area_types_to_ignore = list(
		/area/rnd/xenobiology/xenoflora,
		/area/rnd/xenobiology/xenoflora_storage
	)

/datum/event2/event/prison_break/virology
	area_display_name = "Virology"
	containment_display_desc = "quarantine"
	area_types_to_break = list(
		/area/medical/virology,
		/area/medical/virologyaccess
	)


/datum/event2/event/prison_break/set_up()
	for(var/area/A in world)
		if(is_type_in_list(A, area_types_to_break) && !is_type_in_list(A, area_types_to_ignore))
			areas_to_break += A

	if(!areas_to_break.len)
		log_debug("Prison Break event failed to find any areas to break. Aborting.")
		abort()
		return

/datum/event2/event/prison_break/announce()
	var/my_department = "[location_name()] Firewall Subroutines"
	var/message = "An unknown malicious program has been detected in the [area_display_name] \
	lighting and airlock control systems at [stationtime2text()]. Systems will be fully compromised \
	within approximately three minutes. Direct intervention is required immediately. Disabling the \
	main breaker in the APCs will protect the APC's room from being compromised."

	for(var/obj/machinery/message_server/MS in machines)
		MS.send_rc_message(DEPARTMENT_ENGINEERING, my_department, "[message]<br>", "", "", 2)

	// Nobody reads the requests consoles so lets use the radio as well.
	global_announcer.autosay(message, my_department, DEPARTMENT_ENGINEERING)

	for(var/mob/living/silicon/ai/A in player_list)
		to_chat(A, span("danger", "Malicious program detected in the [area_display_name] lighting and airlock control systems by [my_department]. \
		Disabling the main breaker in the APCs will protect the APC's room from being compromised."))

	var/time_to_flicker = start_delay - 10 SECONDS
	addtimer(CALLBACK(src, PROC_REF(flicker_area)), time_to_flicker)


/datum/event2/event/prison_break/proc/flicker_area()
	for(var/area/A in areas_to_break)
		var/obj/machinery/power/apc/apc = A.get_apc()
		if(istype(apc) && apc.operating)	//If the apc's off, it's a little hard to overload the lights.
			for(var/obj/machinery/light/L in A)
				L.flicker(10)

/datum/event2/event/prison_break/start()
	for(var/area/A in areas_to_break)
		spawn(0) // So we don't block the ticker.
			A.prison_break(TRUE, TRUE, !ignore_blast_doors) // Naming `open_blast_doors` causes mysterious runtimes.

// There's between 40 seconds and one minute before the whole station knows.
// If there's a baddie engineer, they can choose to keep their early announcement to themselves and get a minute to exploit it.
/datum/event2/event/prison_break/end()
	command_announcement.Announce("[pick("Gr3y.T1d3 virus","Malignant trojan")] was detected \
	in \the [location_name()] [area_display_name] [containment_display_desc] subroutines. Secure any compromised \
	areas immediately. AI involvement is recommended.", "[capitalize(containment_display_desc)] Alert")

	global_announcer.autosay(
		"It is now safe to reactivate the APCs' main breakers inside [area_display_name].",
		"[location_name()] Firewall Subroutines",
		DEPARTMENT_ENGINEERING
	)
