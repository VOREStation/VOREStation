GLOBAL_LIST_EMPTY(global_used_pois)
SUBSYSTEM_DEF(points_of_interest)
	name = "Points of Interest"
	wait = 1 SECONDS
	priority = FIRE_PRIORITY_POIS
	init_order = INIT_ORDER_POIS
	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT //POIs can be loaded mid-round.
	var/list/obj/effect/landmark/poi_loader/poi_queue = list()

/datum/controller/subsystem/points_of_interest/Initialize()
	while (poi_queue.len)
		load_next_poi()
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
	load_poi(poi_to_load)

/datum/controller/subsystem/points_of_interest/proc/get_turfs_to_clean(obj/effect/landmark/poi_loader/poi_to_load)
	return block(locate(poi_to_load.x, poi_to_load.y, poi_to_load.z), locate((poi_to_load.x + poi_to_load.size_x - 1), (poi_to_load.y + poi_to_load.size_y - 1), poi_to_load.z))

/datum/controller/subsystem/points_of_interest/proc/annihilate_bounds(obj/effect/landmark/poi_loader/poi_to_load)
	//var/deleted_atoms = 0
	//admin_notice(span_danger("Annihilating objects in poi loading location."), R_DEBUG)
	var/list/turfs_to_clean = get_turfs_to_clean(poi_to_load)
	if(turfs_to_clean.len)
		for(var/x in 1 to 2) // Requires two passes to get everything.
			for(var/turf/T in turfs_to_clean)
				for(var/atom/movable/AM in T)
					//++deleted_atoms
					qdel(AM)
	//admin_notice(span_danger("Annihilated [deleted_atoms] objects."), R_DEBUG)

/datum/controller/subsystem/points_of_interest/proc/load_poi(obj/effect/landmark/poi_loader/poi_to_load)
	if(!poi_to_load)
		return
	var/turf/T = get_turf(poi_to_load)
	if(!isturf(T))
		to_world_log("[log_info_line(poi_to_load)] not on a turf! Cannot place poi template.")
		return

	// Choose a poi
	if(!poi_to_load.poi_type)
		return

	if(!(GLOB.global_used_pois.len) || !(GLOB.global_used_pois[poi_to_load.poi_type]))
		GLOB.global_used_pois[poi_to_load.poi_type] = list()
		var/list/poi_list = GLOB.global_used_pois[poi_to_load.poi_type]
		for(var/map in SSmapping.map_templates)
			var/template = SSmapping.map_templates[map]
			if(istype(template, poi_to_load.poi_type))
				poi_list += template

	var/datum/map_template/template_to_use = null

	var/list/our_poi_list = GLOB.global_used_pois[poi_to_load.poi_type]

	if(!our_poi_list.len)
		return
	else
		template_to_use = pick(our_poi_list)

	if(!template_to_use)
		return

	//admin_notice(span_danger("Chosen Predefined PoI Map: [chosen_type.name]"), R_DEBUG)

	if(poi_to_load.remove_from_pool)
		GLOB.global_used_pois[poi_to_load.poi_type] -= template_to_use

	// Annihilate movable atoms
	annihilate_bounds(poi_to_load)
	// Actually load it
	template_to_use.load(T)
	qdel(poi_to_load)
