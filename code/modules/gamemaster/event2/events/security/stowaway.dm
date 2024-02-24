// Base type used for inheritence.
/datum/event2/meta/stowaway
	event_class = "stowaway"
	departments = list(DEPARTMENT_SECURITY, DEPARTMENT_EVERYONE)
	chaos = 10
	chaotic_threshold = EVENT_CHAOS_THRESHOLD_LOW_IMPACT
	event_type = /datum/event2/event/ghost_pod_spawner/stowaway
	var/safe_for_extended = FALSE

/datum/event2/meta/stowaway/normal
	name = "stowaway - normal"
	safe_for_extended = TRUE

/datum/event2/meta/stowaway/renegade
	name = "stowaway - renegade"
	chaos = 30
	event_type = /datum/event2/event/ghost_pod_spawner/stowaway/renegade

/datum/event2/meta/stowaway/infiltrator
	name = "stowaway - infiltrator"
	chaos = 60
	chaotic_threshold = EVENT_CHAOS_THRESHOLD_MEDIUM_IMPACT
	event_type = /datum/event2/event/ghost_pod_spawner/stowaway/infiltrator

/datum/event2/meta/stowaway/get_weight()
	if(istype(ticker.mode, /datum/game_mode/extended) && !safe_for_extended)
		return 0

	var/security = metric.count_people_in_department(DEPARTMENT_SECURITY)
	var/everyone = metric.count_people_in_department(DEPARTMENT_EVERYONE) - security
	var/ghost_activity = metric.assess_all_dead_mobs() / 100

	return ( (security * 20) + (everyone * 2) ) * ghost_activity


/datum/event2/event/ghost_pod_spawner/stowaway
	pod_type = /obj/structure/ghost_pod/ghost_activated/human
	desired_turf_areas = list(/area/maintenance)
	announce_delay_lower_bound = 15 MINUTES
	announce_delay_upper_bound = 30 MINUTES
	var/antag_type = MODE_STOWAWAY
	var/announce_odds = 20

/datum/event2/event/ghost_pod_spawner/stowaway/renegade
	antag_type = MODE_RENEGADE
	announce_odds = 33

/datum/event2/event/ghost_pod_spawner/stowaway/infiltrator
	antag_type = MODE_INFILTRATOR
	announce_odds = 50

/datum/event2/event/ghost_pod_spawner/stowaway/post_pod_creation(obj/structure/ghost_pod/ghost_activated/human/pod)
	pod.make_antag = antag_type
	pod.occupant_type = "[pod.make_antag] [pod.occupant_type]"

	say_dead_object("[span("notice", pod.occupant_type)] pod is now available in \the [get_area(pod)].", pod)

/datum/event2/event/ghost_pod_spawner/stowaway/announce()
	if(prob(announce_odds))
		if(atc?.squelched)
			return
		atc.msg("Attention civilian vessels in [using_map.starsys_name] shipping lanes, caution is advised as \
		[pick("an unidentified vessel", "a known criminal's vessel", "a derelict vessel")] \
		has been detected passing multiple local stations.")
