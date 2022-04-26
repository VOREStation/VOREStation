var/global/list/global_used_pois = list()



/obj/effect/landmark/poi_loader
	name = "PoI Loader"
	var/size_x
	var/size_y
	var/poi_type = null
	var/remove_from_pool = TRUE

/obj/effect/landmark/poi_loader/New()
INITIALIZE_IMMEDIATE(/obj/effect/landmark/poi_loader)

/obj/effect/landmark/poi_loader/Initialize()
	src.load_poi()
	return ..()

/obj/effect/landmark/poi_loader/proc/get_turfs_to_clean()
	return block(locate(src.x, src.y, src.z), locate((src.x + size_x - 1), (src.y + size_y - 1), src.z))

/obj/effect/landmark/poi_loader/proc/annihilate_bounds()
	var/deleted_atoms = 0
	//admin_notice("<span class='danger'>Annihilating objects in poi loading location.</span>", R_DEBUG)
	var/list/turfs_to_clean = get_turfs_to_clean()
	if(turfs_to_clean.len)
		for(var/x in 1 to 2) // Requires two passes to get everything.
			for(var/turf/T in turfs_to_clean)
				for(var/atom/movable/AM in T)
					++deleted_atoms
					qdel(AM)
	//admin_notice("<span class='danger'>Annihilated [deleted_atoms] objects.</span>", R_DEBUG)

/obj/effect/landmark/poi_loader/proc/load_poi()
	var/turf/T = get_turf(src)
	if(!isturf(T))
		to_world_log("[log_info_line(src)] not on a turf! Cannot place poi template.")
		return

	// Choose a poi
	if(!poi_type)
		return

	if(!(global_used_pois.len) || !(global_used_pois[poi_type]))
		global_used_pois[poi_type] = list()
		var/list/poi_list = global_used_pois[poi_type]
		for(var/map in SSmapping.map_templates)
			var/template = SSmapping.map_templates[map]
			if(istype(template, poi_type))
				poi_list += template

	var/datum/map_template/template_to_use = null

	if(!(global_used_pois[poi_type].len))
		return
	else
		template_to_use = pick(global_used_pois[poi_type])

	if(!template_to_use)
		return

	//admin_notice("<span class='danger'>Chosen Predefined PoI Map: [chosen_type.name]</span>", R_DEBUG)

	if(remove_from_pool)
		global_used_pois[poi_type] -= template_to_use

	// Annihilate movable atoms
	annihilate_bounds()
	//CHECK_TICK //Don't let anything else happen for now
	// Actually load it
	template_to_use.load(T)