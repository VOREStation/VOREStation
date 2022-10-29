/datum/map
	var/list/lateload_gb_north = list()
	var/list/lateload_gb_south = list()
	var/list/lateload_gb_east = list()
	var/list/lateload_gb_west = list()

/datum/controller/subsystem/mapping/loadLateMaps()
	if(using_map.name == "RascalsPass")
		var/list/gbn_load = using_map.lateload_gb_north
		var/list/gbs_load = using_map.lateload_gb_south
		var/list/gbe_load = using_map.lateload_gb_east
		var/list/gbw_load = using_map.lateload_gb_west


		if(LAZYLEN(gbn_load)) //Just copied from gateway picking, this is so we can have a kind of OM map version of the same concept.
			var/picklist = pick(gbn_load)
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
		if(LAZYLEN(gbs_load)) //Just copied from gateway picking, this is so we can have a kind of OM map version of the same concept.
			var/picklist = pick(gbs_load)

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

		if(LAZYLEN(gbe_load)) //Just copied from gateway picking, this is so we can have a kind of OM map version of the same concept.
			var/picklist = pick(gbe_load)

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

		if(LAZYLEN(gbw_load)) //Just copied from gateway picking, this is so we can have a kind of OM map version of the same concept.
			var/picklist = pick(gbw_load)

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
    . = ..()
	/datum/map_template/tether_lateload
    allow_duplicates = FALSE
    var/associated_map_datum

/datum/map_template/tether_lateload/on_map_loaded(z)
    if(!associated_map_datum || !ispath(associated_map_datum))
        log_game("Extra z-level [src] has no associated map datum")
        return

    new associated_map_datum(using_map, z)

/datum/map_z_level/tether_lateload
    z = 0

/datum/map_z_level/tether_lateload/New(var/datum/map/map, mapZ)
    if(mapZ && !z)
        z = mapZ
    return ..(map)
