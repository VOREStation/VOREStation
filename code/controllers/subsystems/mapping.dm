// Handles map-related tasks, mostly here to ensure it does so after the MC initializes.
SUBSYSTEM_DEF(mapping)
	name = "Mapping"
	init_order = INIT_ORDER_MAPPING
	flags = SS_NO_FIRE

	var/list/map_templates = list()
	var/obj/effect/landmark/engine_loader/engine_loader
	var/list/shelter_templates = list()

/datum/controller/subsystem/mapping/Recover()
	flags |= SS_NO_INIT // Make extra sure we don't initialize twice.
	shelter_templates = SSmapping.shelter_templates

/datum/controller/subsystem/mapping/Initialize()
	if(subsystem_initialized)
		return
	world.max_z_changed() // This is to set up the player z-level list, maxz hasn't actually changed (probably)
	load_map_templates()

	loadEngine()
	preloadShelterTemplates() // VOREStation EDIT: Re-enable Shelter Capsules
	// Mining generation probably should be here too
	// TODO - Other stuff related to maps and areas could be moved here too.  Look at /tg
	// Lateload Code related to Expedition areas.
	if(using_map) // VOREStation Edit: Re-enable this.
		loadLateMaps()

	if(CONFIG_GET(flag/generate_map))  // VOREStation Edit: Re-order this.
		// Map-gen is still very specific to the map, however putting it here should ensure it loads in the correct order.
		using_map.perform_map_generation()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/mapping/proc/load_map_templates()
	for(var/datum/map_template/template as anything in subtypesof(/datum/map_template))
		if(!(initial(template.mappath))) // If it's missing the actual path its probably a base type or being used for inheritence.
			continue
		template = new template()
		map_templates[template.name] = template
	return TRUE

/datum/controller/subsystem/mapping/proc/loadEngine()
	if(!engine_loader)
		return // Seems this map doesn't need an engine loaded.

	var/turf/T = get_turf(engine_loader)
	if(!isturf(T))
		to_world_log("[log_info_line(engine_loader)] not on a turf! Cannot place engine template.")
		return

	// Choose an engine type
	var/datum/map_template/engine/chosen_type = null
	if (LAZYLEN(CONFIG_GET(str_list/engine_map)))
		var/chosen_name = pick(CONFIG_GET(str_list/engine_map))
		chosen_type = map_templates[chosen_name]
		if(!istype(chosen_type))
			error("Configured engine map [chosen_name] is not a valid engine map name!")
	if(!istype(chosen_type))
		var/list/engine_types = list()
		for(var/map in map_templates)
			var/datum/map_template/engine/MT = map_templates[map]
			if(istype(MT))
				engine_types += MT
		chosen_type = pick(engine_types)
	to_world_log("Chose Engine Map: [chosen_type.name]")
	admin_notice(span_danger("Chose Engine Map: [chosen_type.name]"), R_DEBUG)

	// Annihilate movable atoms
	engine_loader.annihilate_bounds()
	//CHECK_TICK //Don't let anything else happen for now
	// Actually load it
	chosen_type.load(T)

// VOREStation Edit Start: Enable This
/datum/controller/subsystem/mapping/proc/loadLateMaps()
	var/list/deffo_load = using_map.lateload_z_levels
	var/list/maybe_load = using_map.lateload_gateway
	var/list/also_load = using_map.lateload_overmap
	var/list/redgate_load = using_map.lateload_redgate

	for(var/list/maplist in deffo_load)
		if(!islist(maplist))
			error("Lateload Z level [maplist] is not a list! Must be in a list!")
			continue
		for(var/mapname in maplist)
			var/datum/map_template/MT = map_templates[mapname]
			if(!istype(MT))
				error("Lateload Z level \"[mapname]\" is not a valid map!")
				continue
			admin_notice("Lateload: [MT]", R_DEBUG)
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
				admin_notice("Gateway: [MT]", R_DEBUG)
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
				admin_notice("OM Adventure: [MT]", R_DEBUG)
				MT.load_new_z(centered = FALSE)

	if(LAZYLEN(redgate_load))
		var/picklist = pick(redgate_load)

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
				admin_notice("Redgate: [MT]", R_DEBUG)
				MT.load_new_z(centered = FALSE)

	// Convert ai_shell_allowed_levels to actual Zs
	for(var/i in 1 to length(using_map.ai_shell_allowed_levels))
		var/current = using_map.ai_shell_allowed_levels[i]
		if(isnum(current))
			continue
		using_map.ai_shell_allowed_levels[i] = GLOB.map_templates_loaded[current]

	// Convert overmap_z to actual Z
	if(using_map.use_overmap && !isnum(using_map.overmap_z))
		using_map.overmap_z = GLOB.map_templates_loaded[using_map.overmap_z]

	// Convert belter_belt_z to actual Z
	for(var/i in 1 to length(using_map.belter_belt_z))
		var/current = using_map.belter_belt_z[i]
		if(isnum(current))
			continue
		using_map.belter_belt_z[i] = GLOB.map_templates_loaded[current]

	// Convert belter_transit_z to actual Z
	for(var/i in 1 to length(using_map.belter_transit_z))
		var/current = using_map.belter_transit_z[i]
		if(isnum(current))
			continue
		using_map.belter_transit_z[i] = GLOB.map_templates_loaded[current]

	// Convert belter_docked_z to actual Z (Unnecessary atm)
	/*for(var/i in 1 to length(using_map.belter_docked_z))
		var/current = using_map.belter_docked_z[i]
		if(isnum(current))
			continue
		using_map.belter_docked_z[i] = GLOB.map_templates_loaded[current]*/

	// Convert mining_station_z to actual Z (Unnecessary atm)
	/*for(var/i in 1 to length(using_map.mining_station_z))
		var/current = using_map.mining_station_z[i]
		if(isnum(current))
			continue
		using_map.mining_station_z[i] = GLOB.map_templates_loaded[current]*/

	// Convert mining_outpost_z to actual Z (Unnecessary atm)
	/*for(var/i in 1 to length(using_map.mining_outpost_z))
		var/current = using_map.mining_outpost_z[i]
		if(isnum(current))
			continue
		using_map.mining_outpost_z[i] = GLOB.map_templates_loaded[current]*/

/datum/controller/subsystem/mapping/proc/preloadShelterTemplates()
	for(var/datum/map_template/shelter/shelter_type as anything in subtypesof(/datum/map_template/shelter))
		if(!(initial(shelter_type.mappath)))
			continue
		var/datum/map_template/shelter/S = new shelter_type()

		shelter_templates[S.shelter_id] = S
// VOREStation Edit End: Re-enable this

/datum/controller/subsystem/mapping/stat_entry(msg)
	if (!GLOB.Debug2)
		return // Only show up in stat panel if debugging is enabled.
	. = ..()

// VOREStation Edit: BAPI-dmm
/datum/controller/subsystem/mapping/Shutdown()
	// Force bapi to drop it's cached maps on server shutdown.
	_bapidmm_clear_map_data()
	fdel("data/baked_dmm_files/")
// VOREStation Edit End
