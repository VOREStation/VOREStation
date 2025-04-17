SUBSYSTEM_DEF(points_of_interest)
	name = "Points of Interest"
	wait = 1 SECONDS
	priority = FIRE_PRIORITY_POIS
	init_order = INIT_ORDER_POIS
	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT //POIs can be loaded mid-round.
	var/list/obj/effect/landmark/poi_loader/poi_queue = list()

/datum/controller/subsystem/points_of_interest/Initialize()
	to_world_log("Initializing POIs")
	admin_notice(span_danger("Initializing POIs"), R_DEBUG)
	return SS_INIT_SUCCESS

/datum/controller/subsystem/points_of_interest/fire(resumed = FALSE)
	while (poi_queue.len)
		load_next_poi()

		if (MC_TICK_CHECK)
			return

/// We select and fire the next PoI in the list.
/datum/controller/subsystem/points_of_interest/proc/load_next_poi()
	var/obj/effect/landmark/poi_loader/poi_to_load = poi_queue[1]
	poi_queue -= poi_to_load
	//We then fire it!
	poi_to_load.load_poi()
