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
	makepowernets()

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

/datum/map_template/proc/load(turf/T, centered = FALSE)
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