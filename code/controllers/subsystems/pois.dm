SUBSYSTEM_DEF(points_of_interest)
	name = "Points of Interest"
	wait = 2 SECONDS
	priority = FIRE_PRIORITY_POIS
	init_order = INIT_ORDER_POIS
	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT //POIs can be loaded mid-round.
	var/list/obj/effect/landmark/poi_loader/poi_queue = list()
	var/obj/effect/landmark/poi_loader/currentrun //Will do currentrun.load_poi()
	var/runcomplete = FALSE

/datum/controller/subsystem/points_of_interest/Initialize()
	to_world_log("Initializing POIs")
	admin_notice(span_danger("Initializing POIs"), R_DEBUG)
	return SS_INIT_SUCCESS

/datum/controller/subsystem/points_of_interest/fire(resumed = FALSE)
	if(currentrun && runcomplete) //We have finished our current task. Let's clear it and move on to the next.
		clear_run()
		if(LAZYLEN(poi_queue))
			load_next_poi()
		return
	else if(currentrun && !runcomplete) //Currently processing a PoI
		return
	else //We had no POI currently running. Let's look to see if we need to spawn one.
		if(LAZYLEN(poi_queue))
			clear_run()
			load_next_poi()


/// We clear our current run.
/datum/controller/subsystem/points_of_interest/proc/clear_run()
	currentrun = null
	runcomplete = FALSE

/// We select and fire the next PoI in the list.
/datum/controller/subsystem/points_of_interest/proc/load_next_poi()
	var/next_poi = poi_queue[1]
	currentrun = next_poi
	poi_queue -= next_poi
	//We then fire it!
	currentrun.load_poi()
