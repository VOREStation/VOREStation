// Handles map-related tasks, mostly here to ensure it does so after the MC initializes.
SUBSYSTEM_DEF(mapping)
	name = "Mapping"
	init_order = INIT_ORDER_MAPPING
	flags = SS_NO_FIRE

	/// If true, loading times for individual submaps will be printed to the log.
	var/verbose_loading_time_logs = FALSE
	var/list/map_templates = list()
	var/dmm_suite/maploader = null
	var/list/shelter_templates = list()
	/// A list of all static submap landmarks.
	var/list/static_submap_landmarks = list()
	/// A list of all static submap engine landmarks. Beware of unintended duplicates.
	var/list/engine_submap_landmarks = list()

/datum/controller/subsystem/mapping/Recover()
	flags |= SS_NO_INIT // Make extra sure we don't initialize twice.
	shelter_templates = SSmapping.shelter_templates

/datum/controller/subsystem/mapping/Initialize(timeofday)
	if(subsystem_initialized)
		return
	world.max_z_changed() // This is to set up the player z-level list, maxz hasn't actually changed (probably)
	maploader = new()
	load_map_templates()

	if(config.generate_map)
		// Load the engine and other submaps.
		load_static_submaps(static_submap_landmarks)

		// Map-gen is still very specific to the map, however putting it here should ensure it loads in the correct order.
		using_map.perform_map_generation()
<<<<<<< HEAD
	
	loadEngine()
	preloadShelterTemplates() // VOREStation EDIT: Re-enable Shelter Capsules
=======
	else
		// The engine should still be placed even if other things aren't.
		load_static_submaps(engine_submap_landmarks)

	// preloadShelterTemplates() // Re-enable this later once shelter capsules are ported upstream
>>>>>>> 0a3633915d2... Merge pull request #8357 from Neerti/static_poi_loader_fix
	// Mining generation probably should be here too
	// TODO - Other stuff related to maps and areas could be moved here too.  Look at /tg
	// Lateload Code related to Expedition areas.
	if(using_map) // VOREStation Edit: Re-enable this.
		loadLateMaps()
	..()

/datum/controller/subsystem/mapping/proc/log_mapload(msg)
	to_world_log("  [name]: [msg]")

/datum/controller/subsystem/mapping/proc/load_map_templates()
	for(var/datum/map_template/template as anything in subtypesof(/datum/map_template))
		if(!(initial(template.mappath))) // If it's missing the actual path its probably a base type or being used for inheritence.
			continue
		template = new template()
		map_templates[template.name] = template
	return TRUE

/// Loads submaps at a specific point on the main map, using landmarks.
/datum/controller/subsystem/mapping/proc/load_static_submaps(list/submap_paths)
	log_mapload("Going to load [submap_paths.len] static PoI\s.")
	for(var/thing in submap_paths)
		var/obj/effect/landmark/submap_position/P = thing
		
		var/turf/T = get_turf(P)
		if(!istype(T))
			log_mapload("[log_info_line(src)] not on a turf! Cannot place PoI template.")
			continue
		
		var/datum/map_template/template = P.get_submap_template()
		if(!istype(template))
			log_mapload("[log_info_line(src)] was not given a submap template, but was instead given [log_info_line(template)].")
			return
		
		log_mapload("[P.name] chose '[template.name]' to load.")
		admin_notice("[P.name] chose '[template.name]' to load.", R_DEBUG)
		
		P.moveToNullspace()
		var/time_started = REALTIMEOFDAY
		if(P.annihilate_bounds)
			template.annihilate_bounds(T)

		template.load(T)
		var/time_ended = (REALTIMEOFDAY - time_started) / 10
		if(verbose_loading_time_logs)
			log_mapload("[template.name] loaded in [time_ended] second\s.")
		qdel(P)

/** Loads submaps within a semi-random position inside of specific z-levels and inside of a specific area. */
/** `z_levels` is a list of z-levels that this proc will place submaps onto. */
/** `budget` is used to 'spend' on submaps, higher numbers means more submaps can get chosen. */
/** `whitelist` is used to restrict the submap to being loaded inside of a specific area, and disallows overlapping with other areas. */
/** `desired_map_template_type` limits submaps that are loaded to a specific subtype of the path supplied, to prevent loading wilderness PoIs in space, for example.*/
/datum/controller/subsystem/mapping/proc/seed_area_submaps(list/z_levels, budget, whitelist = /area/space, desired_map_template_type = null)
	set background = TRUE
	
	if(!z_levels || !z_levels.len)
		stack_trace("Submap area seeding was not given any z-levels.")
		return

	for(var/zl in z_levels)
		var/turf/T = locate(1, 1, zl)
		if(!T)
			stack_trace("Submap area seeding was given a non-existant z-level ([zl]).")
			return
	
	var/time_started_overall = REALTIMEOFDAY

	var/overall_sanity = 100 // If the proc fails to place a submap more than this, the whole thing aborts.
	var/list/potential_submaps = list() // Submaps we may or may not place.
	var/list/priority_submaps = list() // Submaps that will always be placed.

	// Lets go find some submaps to make.
	for(var/map in map_templates)
		var/datum/map_template/MT = map_templates[map]
		if(!MT.allow_duplicates && MT.loaded > 0) // This probably won't be an issue but we might as well.
			continue
		if(!istype(MT, desired_map_template_type)) // Not the type wanted.
			continue
		if(MT.discard_prob && prob(MT.discard_prob))
			continue
		if(MT.cost && MT.cost < 0) // Negative costs always get spawned.
			priority_submaps += MT
		else
			potential_submaps += MT

	CHECK_TICK

	var/list/loaded_submap_names = list()
	var/list/template_groups_used = list() // Used to avoid spawning three seperate versions of the same PoI.

	log_mapload("Going to seed submaps of subtype '[desired_map_template_type]' with a budget of [budget].")

	// Now lets start choosing some.
	while(budget > 0 && overall_sanity > 0)
		overall_sanity--
		var/datum/map_template/chosen_template = null

		if(potential_submaps.len)
			if(priority_submaps.len) // Do these first.
				chosen_template = pick(priority_submaps)
			else
				chosen_template = pick(potential_submaps)

		else // We're out of submaps.
			log_mapload("Submap loader had no submaps to pick from with [budget] left to spend.")
			break

		CHECK_TICK

		// Can we afford it?
		if(chosen_template.cost > budget)
			priority_submaps -= chosen_template
			potential_submaps -= chosen_template
			continue

		// Did we already place down a very similar submap?
		if(chosen_template.template_group && (chosen_template.template_group in template_groups_used))
			priority_submaps -= chosen_template
			potential_submaps -= chosen_template
			continue

		// If so, try to place it.
		var/time_started_submap = REALTIMEOFDAY
		var/specific_sanity = 100 // A hundred chances to place the chosen submap.
		while(specific_sanity > 0)
			specific_sanity--

			var/orientation
			if(chosen_template.fixed_orientation || !config.random_submap_orientation)
				orientation = 0
			else
				orientation = pick(list(0, 90, 180, 270))

			chosen_template.preload_size(chosen_template.mappath, orientation)
			var/width_border = TRANSITIONEDGE + SUBMAP_MAP_EDGE_PAD + round(((orientation%180) ? chosen_template.height : chosen_template.width) / 2) // %180 catches East/West (90,270) rotations on true, North/South (0,180) rotations on false
			var/height_border = TRANSITIONEDGE + SUBMAP_MAP_EDGE_PAD + round(((orientation%180) ? chosen_template.width : chosen_template.height) / 2)
			var/z_level = pick(z_levels)
			var/turf/T = locate(rand(width_border, world.maxx - width_border), rand(height_border, world.maxy - height_border), z_level)
			var/valid = TRUE

			for(var/turf/check in chosen_template.get_affected_turfs(T,TRUE,orientation))
				var/area/new_area = get_area(check)
				if(!(istype(new_area, whitelist)))
					valid = FALSE // Probably overlapping something important.
			//		to_world("Invalid due to overlapping with area [new_area.type] at ([check.x], [check.y], [check.z]), when attempting to place at ([T.x], [T.y], [T.z]).")
					break
				CHECK_TICK

			CHECK_TICK

			if(!valid)
				continue

			admin_notice("Submap \"[chosen_template.name]\" placed at ([T.x], [T.y], [T.z])\n", R_DEBUG)

			// Do loading here.
			chosen_template.load(T, centered = TRUE, orientation=orientation) // This is run before the main map's initialization routine, so that can initilize our submaps for us instead.

			var/time_ended_submap = (REALTIMEOFDAY - time_started_submap) / 10
			if(verbose_loading_time_logs)
				log_mapload("Loaded submap '[chosen_template.name]' in [time_ended_submap] second\s.")

			CHECK_TICK

			// For pretty maploading statistics.
			if(loaded_submap_names[chosen_template.name])
				loaded_submap_names[chosen_template.name] += 1
			else
				loaded_submap_names[chosen_template.name] = 1

			// To avoid two 'related' similar submaps existing at the same time.
			if(chosen_template.template_group)
				template_groups_used += chosen_template.template_group

			// To deduct the cost.
			if(chosen_template.cost >= 0)
				budget -= chosen_template.cost

			// Remove the submap from our options.
			if(chosen_template in priority_submaps) // Always remove priority submaps.
				priority_submaps -= chosen_template
			else if(!chosen_template.allow_duplicates)
				potential_submaps -= chosen_template

			break // Load the next submap.

	var/list/pretty_submap_list = list()
	for(var/submap_name in loaded_submap_names)
		var/count = loaded_submap_names[submap_name]
		if(count > 1)
			pretty_submap_list += "[count] <b>[submap_name]</b>"
		else
			pretty_submap_list += "<b>[submap_name]</b>"

	if(!overall_sanity)
		admin_notice("Submap loader gave up with [budget] left to spend.", R_DEBUG)
	else
		admin_notice("Submaps loaded.", R_DEBUG)
	
	var/time_ended_overall = (REALTIMEOFDAY - time_started_overall) / 10
	admin_notice("Loaded: [english_list(pretty_submap_list)] in [time_ended_overall] second\s.", R_DEBUG)
	log_mapload("Loaded: [english_list(loaded_submap_names)] in [time_ended_overall] second\s.")


// VOREStation Edit Start: Enable This
/datum/controller/subsystem/mapping/proc/loadLateMaps()
	var/list/deffo_load = using_map.lateload_z_levels
	var/list/maybe_load = using_map.lateload_gateway
	var/list/also_load = using_map.lateload_overmap


	for(var/list/maplist in deffo_load)
		if(!islist(maplist))
			error("Lateload Z level [maplist] is not a list! Must be in a list!")
			continue
		for(var/mapname in maplist)
			var/datum/map_template/MT = map_templates[mapname]
			if(!istype(MT))
				error("Lateload Z level \"[mapname]\" is not a valid map!")
				continue
			MT.load_new_z(centered = FALSE)
			CHECK_TICK

	if(LAZYLEN(maybe_load))
		var/picklist = pick(maybe_load)

		if(!picklist) //No lateload maps at all
			return

		if(!islist(picklist)) //So you can have a 'chain' of z-levels that make up one away mission
			error("Randompick Z level [picklist] is not a list! Must be in a list!")
			return

		for(var/map in picklist)
			if(islist(map))
				// TRIPLE NEST. In this situation we pick one at random from the choices in the list.
				//This allows a sort of a1,a2,a3,b1,b2,b3,c1,c2,c3 setup where it picks one 'a', one 'b', one 'c'
				map = pick(map)
			var/datum/map_template/MT = map_templates[map]
			if(!istype(MT))
				error("Randompick Z level \"[map]\" is not a valid map!")
			else
				MT.load_new_z(centered = FALSE)
	
	if(LAZYLEN(also_load)) //Just copied from gateway picking, this is so we can have a kind of OM map version of the same concept.
		var/picklist = pick(also_load)

		if(!picklist) //No lateload maps at all
			return

		if(!islist(picklist)) //So you can have a 'chain' of z-levels that make up one away mission
			error("Randompick Z level [picklist] is not a list! Must be in a list!")
			return

		for(var/map in picklist)
			if(islist(map))
				// TRIPLE NEST. In this situation we pick one at random from the choices in the list.
				//This allows a sort of a1,a2,a3,b1,b2,b3,c1,c2,c3 setup where it picks one 'a', one 'b', one 'c'
				map = pick(map)
			var/datum/map_template/MT = map_templates[map]
			if(!istype(MT))
				error("Randompick Z level \"[map]\" is not a valid map!")
			else
				MT.load_new_z(centered = FALSE)


/datum/controller/subsystem/mapping/proc/preloadShelterTemplates()
	for(var/datum/map_template/shelter/shelter_type as anything in subtypesof(/datum/map_template/shelter))
		if(!(initial(shelter_type.mappath)))
			continue
		var/datum/map_template/shelter/S = new shelter_type()

		shelter_templates[S.shelter_id] = S
// VOREStation Edit End: Re-enable this

/datum/controller/subsystem/mapping/stat_entry(msg)
	if (!Debug2)
		return // Only show up in stat panel if debugging is enabled.
	. = ..()