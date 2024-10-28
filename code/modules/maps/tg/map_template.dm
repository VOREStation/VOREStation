/datum/map_template
	var/name = "Default Template Name"
	var/desc = "Some text should go here. Maybe."
	var/template_group = null // If this is set, no more than one template in the same group will be spawned, per submap seeding.
	var/width = 0
	var/height = 0
	var/mappath = null
	var/loaded = 0 // Times loaded this round
	var/annihilate = FALSE // If true, all (movable) atoms at the location where the map is loaded will be deleted before the map is loaded in.

	var/cost = null /* The map generator has a set 'budget' it spends to place down different submaps. It will pick available submaps randomly until
	it runs out. The cost of a submap should roughly corrispond with several factors such as size, loot, difficulty, desired scarcity, etc.
	Set to -1 to force the submap to always be made. */
	var/allow_duplicates = FALSE // If false, only one map template will be spawned by the game. Doesn't affect admins spawning then manually.
	var/discard_prob = 0 // If non-zero, there is a chance that the map seeding algorithm will skip this template when selecting potential templates to use.

/datum/map_template/New(path = null, rename = null)
	if(path)
		mappath = path
	if(mappath)
		spawn(1)
			preload_size(mappath)
	if(rename)
		name = rename

/datum/map_template/proc/preload_size(path)
	var/datum/bapi_parsed_map/map = load_map_bapi(path, 1, 1, 1, crop_map=FALSE, measure_only=TRUE)
	var/list/bounds = map.parsed_bounds
	if(bounds)
		width = bounds[MAP_MAXX] // Assumes all templates are rectangular, have a single Z level, and begin at 1,1,1
		height = bounds[MAP_MAXY]
	return bounds

/datum/map_template/proc/initTemplateBounds(var/list/bounds)
	if (SSatoms.initialized == INITIALIZATION_INSSATOMS)
		return // let proper initialisation handle it later

	var/prev_shuttle_queue_state = SSshuttles.block_init_queue
	SSshuttles.block_init_queue = TRUE
	var/machinery_was_awake = SSmachines.suspend() // Suspend machinery (if it was not already suspended)

	var/list/atom/atoms = list()
	var/list/area/areas = list()
	var/list/obj/structure/cable/cables = list()
	var/list/obj/machinery/atmospherics/atmos_machines = list()
	var/list/turf/turfs = block(locate(bounds[MAP_MINX], bounds[MAP_MINY], bounds[MAP_MINZ]),
	                   			locate(bounds[MAP_MAXX], bounds[MAP_MAXY], bounds[MAP_MAXZ]))
	for(var/turf/B as anything in turfs)
		atoms += B
		areas |= B.loc
		for(var/A in B)
			atoms += A
			if(istype(A, /obj/structure/cable))
				cables += A
			else if(istype(A, /obj/machinery/atmospherics))
				atmos_machines += A
	atoms |= areas

	admin_notice(span_danger("Initializing newly created atom(s) in submap."), R_DEBUG)
	SSatoms.InitializeAtoms(atoms)

	admin_notice(span_danger("Initializing atmos pipenets and machinery in submap."), R_DEBUG)
	SSmachines.setup_atmos_machinery(atmos_machines)

	admin_notice(span_danger("Rebuilding powernets due to submap creation."), R_DEBUG)
	SSmachines.setup_powernets_for_cables(cables)

	// Ensure all machines in loaded areas get notified of power status
	for(var/area/A as anything in areas)
		A.power_change()

	if(machinery_was_awake)
		SSmachines.wake() // Wake only if it was awake before we tried to suspended it.
	SSshuttles.block_init_queue = prev_shuttle_queue_state
	SSshuttles.process_init_queues() // We will flush the queue unless there were other blockers, in which case they will do it.

	admin_notice(span_danger("Submap initializations finished."), R_DEBUG)

/datum/map_template/proc/load_new_z(var/centered = FALSE)
	var/x = 1
	var/y = 1

	if(centered)
		x = round((world.maxx - width)/2)
		y = round((world.maxy - height)/2)

	var/datum/bapi_parsed_map/map = load_map_bapi(mappath, x, y, no_changeturf = TRUE)
	var/list/bounds = map.bounds
	if(!bounds)
		return FALSE

//	repopulate_sorted_areas()

	//initialize things that are normally initialized after map load
	initTemplateBounds(bounds)
	log_game("Z-level [name] loaded at at [x],[y],[world.maxz]")
	on_map_loaded(world.maxz) //VOREStation Edit
	return TRUE

/datum/map_template/proc/load(turf/T, centered = FALSE)
	var/old_T = T
	if(centered)
		T = locate(T.x - round((width)/2) , T.y - round((height)/2) , T.z) // %180 catches East/West (90,270) rotations on true, North/South (0,180) rotations on false
	if(!T)
		return
	if(T.x+width > world.maxx)
		return
	if(T.y+height > world.maxy)
		return

	if(annihilate)
		annihilate_bounds(old_T, centered)

	var/datum/bapi_parsed_map/map = load_map_bapi(mappath, T.x, T.y, T.z, crop_map = TRUE)
	var/list/bounds = map.bounds
	if(!bounds)
		return

//	if(!SSmapping.loading_ruins) //Will be done manually during mapping ss init
//		repopulate_sorted_areas()

	//initialize things that are normally initialized after map load
	initTemplateBounds(bounds)

	log_game("[name] loaded at at [T.x],[T.y],[T.z]")
	loaded++
	return TRUE

/datum/map_template/proc/get_affected_turfs(turf/T, centered = FALSE)
	var/turf/placement = T
	if(centered)
		var/turf/corner = locate(placement.x - round((width)/2), placement.y - round((height)/2), placement.z) // %180 catches East/West (90,270) rotations on true, North/South (0,180) rotations on false
		if(corner)
			placement = corner
	return block(placement, locate(placement.x+(width)-1, placement.y+(height)-1, placement.z))

/datum/map_template/proc/annihilate_bounds(turf/origin, centered = FALSE)
	var/deleted_atoms = 0
	admin_notice(span_danger("Annihilating objects in submap loading locatation."), R_DEBUG)
	var/list/turfs_to_clean = get_affected_turfs(origin, centered)
	if(turfs_to_clean.len)
		for(var/turf/T in turfs_to_clean)
			for(var/atom/movable/AM in T)
				++deleted_atoms
				qdel(AM)
	admin_notice(span_danger("Annihilated [deleted_atoms] objects."), R_DEBUG)


//for your ever biggening badminnery kevinz000
//❤ - Cyberboss
/proc/load_new_z_level(var/file, var/name)
	var/datum/map_template/template = new(file, name)
	template.load_new_z()

// Very similar to the /tg/ version.
/proc/seed_submaps(var/list/z_levels, var/budget = 0, var/whitelist = /area/space, var/desired_map_template_type = null)
	set background = TRUE

	if(!z_levels || !z_levels.len)
		admin_notice("seed_submaps() was not given any Z-levels.", R_DEBUG)
		return

	for(var/zl in z_levels)
		var/turf/T = locate(1, 1, zl)
		if(!T)
			admin_notice("Z level [zl] does not exist - Not generating submaps", R_DEBUG)
			return

	var/overall_sanity = 100 // If the proc fails to place a submap more than this, the whole thing aborts.
	var/list/potential_submaps = list() // Submaps we may or may not place.
	var/list/priority_submaps = list() // Submaps that will always be placed.

	// Lets go find some submaps to make.
	for(var/map in SSmapping.map_templates)
		var/datum/map_template/MT = SSmapping.map_templates[map]
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
			admin_notice("Submap loader had no submaps to pick from with [budget] left to spend.", R_DEBUG)
			break

		CHECK_TICK

		// Can we afford it?
		if(chosen_template.cost > budget)
			priority_submaps -= chosen_template
			potential_submaps -= chosen_template
			continue

		// Is single use template already placed
		if(!chosen_template.allow_duplicates && chosen_template.loaded)
			priority_submaps -= chosen_template
			potential_submaps -= chosen_template
			continue

		// Did we already place down a very similar submap?
		if(chosen_template.template_group && (chosen_template.template_group in template_groups_used))
			priority_submaps -= chosen_template
			potential_submaps -= chosen_template
			continue

		// If so, try to place it.
		var/specific_sanity = 100 // A hundred chances to place the chosen submap.
		while(specific_sanity > 0)
			specific_sanity--

			chosen_template.preload_size(chosen_template.mappath)
			var/width_border = SUBMAP_MAP_EDGE_PAD + round((chosen_template.width) / 2)
			var/height_border = SUBMAP_MAP_EDGE_PAD + round((chosen_template.height) / 2)																									//VOREStation Edit
			var/z_level = pick(z_levels)
			var/turf/T = locate(rand(width_border, world.maxx - width_border), rand(height_border, world.maxy - height_border), z_level)
			var/valid = TRUE

			for(var/turf/check in chosen_template.get_affected_turfs(T,TRUE))
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

			if(specific_sanity < 0)
				// I have no idea how this function has a race condition for the sanity check, but forcing the inner check loop to end like this fixes it...
				// If a template doesn't allow duplicates, it tries to double place a template. this fixes that.
				break
			if(!chosen_template.allow_duplicates)
				specific_sanity = -1 // force end the placement loop

			// Do loading here.
			chosen_template.load(T, centered = TRUE) // This is run before the main map's initialization routine, so that can initilize our submaps for us instead.

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
			pretty_submap_list += span_bold("[submap_name]")

	if(!overall_sanity)
		admin_notice("Submap loader gave up with [budget] left to spend.", R_DEBUG)
	else
		admin_notice("Submaps loaded.", R_DEBUG)
	admin_notice("Loaded: [english_list(pretty_submap_list)]", R_DEBUG)

/area/template_noop
	name = "Area Passthrough"

/turf/template_noop
	name = "Turf Passthrough"
	icon_state = "template_void"
