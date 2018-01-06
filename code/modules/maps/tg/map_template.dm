var/list/global/map_templates = list()

// Called when the world starts, in world.dm
/proc/load_map_templates()
	for(var/T in subtypesof(/datum/map_template))
		var/datum/map_template/template = T
		if(!(initial(template.mappath))) // If it's missing the actual path its probably a base type or being used for inheritence.
			continue
		template = new T()
		map_templates[template.name] = template
	return TRUE

/datum/map_template
	var/name = "Default Template Name"
	var/desc = "Some text should go here. Maybe."
	var/width = 0
	var/height = 0
	var/mappath = null
	var/loaded = 0 // Times loaded this round
	var/annihilate = FALSE // If true, all (movable) atoms at the location where the map is loaded will be deleted before the map is loaded in.

	var/cost = null // The map generator has a set 'budget' it spends to place down different submaps. It will pick available submaps randomly until \
	it runs out. The cost of a submap should roughly corrispond with several factors such as size, loot, difficulty, desired scarcity, etc. \
	Set to -1 to force the submap to always be made.
	var/allow_duplicates = FALSE // If false, only one map template will be spawned by the game. Doesn't affect admins spawning then manually.

	var/static/dmm_suite/maploader = new

/datum/map_template/New(path = null, rename = null)
	if(path)
		mappath = path
	if(mappath)
		spawn(1)
			preload_size(mappath)
	if(rename)
		name = rename

/datum/map_template/proc/preload_size(path)
	var/bounds = maploader.load_map(file(path), 1, 1, 1, cropMap=FALSE, measureOnly=TRUE)
	if(bounds)
		width = bounds[MAP_MAXX] // Assumes all templates are rectangular, have a single Z level, and begin at 1,1,1
		height = bounds[MAP_MAXY]
	return bounds

/datum/map_template/proc/initTemplateBounds(var/list/bounds)
	var/list/obj/machinery/atmospherics/atmos_machines = list()
	var/list/atom/atoms = list()
	var/list/area/areas = list()
//	var/list/turf/turfs = list()

	for(var/L in block(locate(bounds[MAP_MINX], bounds[MAP_MINY], bounds[MAP_MINZ]),
	                   locate(bounds[MAP_MAXX], bounds[MAP_MAXY], bounds[MAP_MAXZ])))
		var/turf/B = L
		atoms += B
		for(var/A in B)
			atoms += A
//			turfs += B
			areas |= get_area(B)
			if(istype(A, /obj/machinery/atmospherics))
				atmos_machines += A

	var/i = 0

// Apparently when areas get initialize()'d they initialize their turfs as well.
// If this is ever changed, uncomment the block of code below.

//	admin_notice("<span class='danger'>Initializing newly created simulated turfs in submap.</span>", R_DEBUG)
//	for(var/turf/simulated/T in turfs)
//		T.initialize()
//		i++
//	admin_notice("<span class='danger'>[i] turf\s initialized.</span>", R_DEBUG)
//	i = 0

	SScreation.initialize_late_atoms()

	admin_notice("<span class='danger'>Initializing newly created area(s) in submap.</span>", R_DEBUG)
	for(var/area/A in areas)
		A.initialize()
		i++
	admin_notice("<span class='danger'>[i] area\s initialized.</span>", R_DEBUG)
	i = 0

	admin_notice("<span class='danger'>Initializing atmos pipenets and machinery in submap.</span>", R_DEBUG)
	for(var/obj/machinery/atmospherics/machine in atmos_machines)
		machine.initialize()
		i++

	for(var/obj/machinery/atmospherics/machine in atmos_machines)
		machine.build_network()

	for(var/obj/machinery/atmospherics/unary/U in machines)
		if(istype(U, /obj/machinery/atmospherics/unary/vent_pump))
			var/obj/machinery/atmospherics/unary/vent_pump/T = U
			T.broadcast_status()
		else if(istype(U, /obj/machinery/atmospherics/unary/vent_scrubber))
			var/obj/machinery/atmospherics/unary/vent_scrubber/T = U
			T.broadcast_status()
	admin_notice("<span class='danger'>[i] pipe\s initialized.</span>", R_DEBUG)

	admin_notice("<span class='danger'>Rebuilding powernets due to submap creation.</span>", R_DEBUG)
	SSmachines.makepowernets()

	admin_notice("<span class='danger'>Submap initializations finished.</span>", R_DEBUG)

/datum/map_template/proc/load_new_z()
	var/x = round(world.maxx/2)
	var/y = round(world.maxy/2)

	var/list/bounds = maploader.load_map(file(mappath), x, y)
	if(!bounds)
		return FALSE

//	repopulate_sorted_areas()

	//initialize things that are normally initialized after map load
	initTemplateBounds(bounds)
	log_game("Z-level [name] loaded at at [x],[y],[world.maxz]")
	return TRUE

/datum/map_template/proc/load(turf/T, centered = FALSE, dont_init = FALSE)
	var/old_T = T
	if(centered)
		T = locate(T.x - round(width/2) , T.y - round(height/2) , T.z)
	if(!T)
		return
	if(T.x+width > world.maxx)
		return
	if(T.y+height > world.maxy)
		return

	if(annihilate)
		annihilate_bounds(old_T, centered)

	var/list/bounds = maploader.load_map(file(mappath), T.x, T.y, T.z, cropMap=TRUE)
	if(!bounds)
		return

//	if(!SSmapping.loading_ruins) //Will be done manually during mapping ss init
//		repopulate_sorted_areas()

	//initialize things that are normally initialized after map load
	if(!dont_init)
		initTemplateBounds(bounds)

	log_game("[name] loaded at at [T.x],[T.y],[T.z]")
	loaded++
	return TRUE

/datum/map_template/proc/get_affected_turfs(turf/T, centered = FALSE)
	var/turf/placement = T
	if(centered)
		var/turf/corner = locate(placement.x - round(width/2), placement.y - round(height/2), placement.z)
		if(corner)
			placement = corner
	return block(placement, locate(placement.x+width-1, placement.y+height-1, placement.z))

/datum/map_template/proc/annihilate_bounds(turf/origin, centered = FALSE)
	var/deleted_atoms = 0
	admin_notice("<span class='danger'>Annihilating objects in submap loading locatation.</span>", R_DEBUG)
	var/list/turfs_to_clean = get_affected_turfs(origin, centered)
	if(turfs_to_clean.len)
		for(var/turf/T in turfs_to_clean)
			for(var/atom/movable/AM in T)
				++deleted_atoms
				qdel(AM)
	admin_notice("<span class='danger'>Annihilated [deleted_atoms] objects.</span>", R_DEBUG)


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
	for(var/map in map_templates)
		var/datum/map_template/MT = map_templates[map]
		if(!MT.allow_duplicates && MT.loaded > 0) // This probably won't be an issue but we might as well.
			continue
		if(!istype(MT, desired_map_template_type)) // Not the type wanted.
			continue
		if(MT.cost && MT.cost < 0) // Negative costs always get spawned.
			priority_submaps += MT
		else
			potential_submaps += MT

	CHECK_TICK

	var/list/loaded_submap_names = list()

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
			continue

		// If so, try to place it.
		var/specific_sanity = 100 // A hundred chances to place the chosen submap.
		while(specific_sanity > 0)
			specific_sanity--
			var/width_border = TRANSITIONEDGE + SUBMAP_MAP_EDGE_PAD + round(chosen_template.width / 2)
			var/height_border = TRANSITIONEDGE + SUBMAP_MAP_EDGE_PAD + round(chosen_template.height / 2)
			var/z_level = pick(z_levels)
			var/turf/T = locate(rand(width_border, world.maxx - width_border), rand(height_border, world.maxy - height_border), z_level)
			var/valid = TRUE

			for(var/turf/check in chosen_template.get_affected_turfs(T,1))
				var/area/new_area = get_area(check)
				if(!(istype(new_area, whitelist)))
					valid = FALSE // Probably overlapping something important.
				//	world << "Invalid due to overlapping with area [new_area.type], when wanting area [whitelist]."
					break
				CHECK_TICK

			CHECK_TICK

			if(!valid)
				continue

			admin_notice("Submap \"[chosen_template.name]\" placed at ([T.x], [T.y], [T.z])", R_DEBUG)

			// Do loading here.
			chosen_template.load(T, centered = TRUE, dont_init = TRUE) // This is run before the main map's initialization routine, so that can initilize our submaps for us instead.

			CHECK_TICK

			if(loaded_submap_names[chosen_template.name])
				loaded_submap_names[chosen_template.name] += 1
			else
				loaded_submap_names[chosen_template.name] = 1

			if(chosen_template.cost >= 0)
				budget -= chosen_template.cost

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
	admin_notice("Loaded: [english_list(pretty_submap_list)]", R_DEBUG)