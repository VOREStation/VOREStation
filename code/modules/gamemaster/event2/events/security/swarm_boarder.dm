// This is just porting the event to the new new event system, it's not been balanced in any way
// so don't @ me if these things are grossly OP.
/datum/event2/meta/swarm_boarder
	event_class = "swarm boarder"
	departments = list(DEPARTMENT_EVERYONE, DEPARTMENT_SECURITY, DEPARTMENT_ENGINEERING)
	chaos = 60
	chaotic_threshold = EVENT_CHAOS_THRESHOLD_HIGH_IMPACT
	enabled = FALSE // Turns out they are in fact grossly OP.
	var/safe_for_extended = FALSE

/datum/event2/meta/swarm_boarder/get_weight()
	if(istype(ticker.mode, /datum/game_mode/extended) && !safe_for_extended)
		return 0

	var/security = metric.count_people_in_department(DEPARTMENT_SECURITY)
	var/engineering = metric.count_people_in_department(DEPARTMENT_ENGINEERING)
	var/everyone = metric.count_people_in_department(DEPARTMENT_EVERYONE) - (engineering + security)

	var/ghost_activity = metric.assess_all_dead_mobs() / 100

	return ( (security * 20) + (engineering * 10) + (everyone * 2) ) * ghost_activity

/datum/event2/meta/swarm_boarder/normal
	name = "swarmer shell - normal"
	event_type = /datum/event2/event/ghost_pod_spawner/swarm_boarder

/datum/event2/meta/swarm_boarder/melee
	name = "swarmer shell - melee"
	event_type = /datum/event2/event/ghost_pod_spawner/swarm_boarder/melee

/datum/event2/meta/swarm_boarder/gunner
	name = "swarmer shell - gunner"
	event_type = /datum/event2/event/ghost_pod_spawner/swarm_boarder/gunner




/datum/event2/event/ghost_pod_spawner/swarm_boarder
	announce_delay_lower_bound = 5 MINUTES
	announce_delay_upper_bound = 15 MINUTES
	pod_type = /obj/structure/ghost_pod/ghost_activated/swarm_drone/event
	desired_turf_areas = list(/area/maintenance)
	var/announce_odds = 80

/datum/event2/event/ghost_pod_spawner/swarm_boarder/melee
	pod_type = /obj/structure/ghost_pod/ghost_activated/swarm_drone/event/melee

/datum/event2/event/ghost_pod_spawner/swarm_boarder/gunner
	pod_type = /obj/structure/ghost_pod/ghost_activated/swarm_drone/event/gunner

/datum/event2/event/ghost_pod_spawner/swarm_boarder/announce()
	if(prob(announce_odds))
		if(SSatc.is_squelched())
			SSatc.msg("Attention civilian vessels in [using_map.starsys_name] shipping lanes, caution \
			is advised as [pick("an unidentified vessel", "a known criminal's vessel", "a derelict vessel")] \
			has been detected passing multiple local stations.")
