/proc/create_objects_in_loc(atom/loc, list/item_paths)
	if(!istype(loc))
		CRASH("Inappropriate loction given.")
	if(!istype(item_paths))
		CRASH("Inappropriate item path list given.")

	for(var/item_path in item_paths)
		for(var/i = 1 to max(1, item_paths[item_path]))
			new item_path(loc)

/// Copy the storage item list to the global cache of item storage filters. Returns the global list so that storage item's can_hold list var can be updated to point to it when called.
/proc/update_storage_filters(atom/source, list/can_hold)
	RETURN_TYPE(/list)
	if(!islist(can_hold))
		return can_hold
	var/typekey = source.type
	if(!islist(GLOB.storage_filters[typekey]))
		GLOB.storage_filters[typekey] = can_hold
	return GLOB.storage_filters[typekey]
