/datum/map
	var/list/lateload_gb_north = list()
	var/list/lateload_gb_south = list()
	var/list/lateload_gb_east = list()
	var/list/lateload_gb_west = list()

/datum/controller/subsystem/mapping/loadLateMaps()
	if(using_map.type != /datum/map/groundbase)
		return ..()

	var/list/workload = list(using_map.lateload_gb_north, using_map.lateload_gb_south, using_map.lateload_gb_east, using_map.lateload_gb_west)

	for(var/list/current_sector in workload)
		if(LAZYLEN(current_sector)) //Just copied from gateway picking, this is so we can have a kind of OM map version of the same concept.
			var/picklist = pick(current_sector)
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

	return ..()
