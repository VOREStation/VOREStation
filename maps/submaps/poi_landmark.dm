/// This stores information for SSmapping to load submaps when the SS inits.
/obj/effect/landmark/submap_position
	name = "Submap Position"
	var/submap_path = null
	/// Whether or not to delete everything inside the submap's bounds prior to loading it.
	var/annihilate_bounds = FALSE

INITIALIZE_IMMEDIATE(/obj/effect/landmark/submap_position)

/obj/effect/landmark/submap_position/Initialize(mapload)
	SSmapping.static_submap_landmarks += src
	return ..()

/obj/effect/landmark/submap_position/Destroy()
	SSmapping.static_submap_landmarks -= src
	return ..()

/obj/effect/landmark/submap_position/proc/get_submap_template()
	return new submap_path()

/// Used to load a load a random submap of a specific subtype.
/obj/effect/landmark/submap_position/random_subtype/get_submap_template()
	var/list/subtypes = subtypesof(submap_path)
	var/type_picked = pick(subtypes)
	var/datum/map_template/template = new type_picked()
	return template


/// Used to load a random submap from a list of submap paths.
/obj/effect/landmark/submap_position/random
	var/list/possible_submap_paths = list()

/obj/effect/landmark/submap_position/random/get_submap_template()
	var/chosen_path = pick(possible_submap_paths)
	return new chosen_path()


/// Used to load a random engine submap.
/obj/effect/landmark/submap_position/random/engine
	name = "Engine Submap Position"
	annihilate_bounds = TRUE

/obj/effect/landmark/submap_position/random/engine/Initialize(mapload)
	SSmapping.engine_submap_landmarks += src
	return ..()

/obj/effect/landmark/submap_position/Destroy()
	SSmapping.engine_submap_landmarks -= src
	return ..()

/obj/effect/landmark/submap_position/random/engine/get_submap_template()
	// Choose an engine type from the config.
	var/datum/map_template/engine/chosen_type = null
	if(LAZYLEN(config.engine_map))
		var/chosen_name = pick(config.engine_map)
		chosen_type = SSmapping.map_templates[chosen_name]
		if(!istype(chosen_type))
			stack_trace("Configured engine map [chosen_name] is not a valid engine map name.")
	
	// No config, pick a random one.
	if(!istype(chosen_type))
		var/list/engine_types = list()
		for(var/map in SSmapping.map_templates)
			var/datum/map_template/engine/MT = SSmapping.map_templates[map]
			if(istype(MT))
				engine_types += MT
		chosen_type = pick(engine_types)
	admin_notice("<span class='danger'>Chose Engine Map: [chosen_type.name]</span>", R_DEBUG)
	return chosen_type
