/datum/persistent/storage
	name = "storage"
	entries_expire_at = 1
	has_admin_data = TRUE

	// Don't use these for storage persistence. If someone takes some sheets out and puts them back in mixed in with
	// new sheets, how do you know the age of the stack? If you want sheets to 'decay', see go_missing_chance
	entries_decay_at = 0
	entry_decay_weight = 0
	// // // //

	var/min_storage = 0
	var/max_storage = 0
	var/store_per_type = FALSE // If true, will store up to max_storage for each type stored
	var/target_type = null // Path of the thing that this expects to put stuff into

	var/go_missing_chance = 0 // Chance an item will fail to be spawned in from persistence and need to be restocked

/datum/persistent/storage/SetFilename()
	if(name)
		filename = "data/persistent/storage/[lowertext(using_map.name)]-[lowertext(name)].json"

/datum/persistent/storage/IsValidEntry(var/atom/entry)
	return ..() && istype(entry, target_type)

/datum/persistent/storage/CompileEntry(var/atom/entry)
	. = ..()
	var/stored = max_storage
	var/list/item_list = get_storage_list(entry)
	var/list/storage_list = list()
	for(var/item in item_list)
		if(islist(max_storage))
			if(!is_path_in_list(item, stored))
				stored[item] = stored["default"]
			storage_list[item] = min(stored[item], storage_list[item] + item_list[item]) // Can't store more than max_storage

		else
			storage_list[item] = min(stored, storage_list[item] + item_list[item]) // Can't store more than max_storage

			// stored gets reduced by qty stored, if greater than stored,
			// previous assignment will handle overage, and we set to 0
			if(!store_per_type)
				stored = max(stored - item_list[item], 0)

	LAZYADDASSOC(., "items", storage_list)

// Usage: returns list with structure:
//	list(
//		[type1] = [stored_quantity],
//		[type2] = [stored_quantity]
//	)
/datum/persistent/storage/proc/get_storage_list(var/atom/entry)
	return list() // Subtypes define list structure

/datum/persistent/storage/proc/find_specific_instance(var/turf/T)
	return locate(target_type) in T

/datum/persistent/storage/CheckTurfContents(var/turf/T, var/list/token)
	return istype(find_specific_instance(T), target_type)

/datum/persistent/storage/proc/generate_items(var/list/L)
	. = list()
	for(var/path in L)
		// byond's json implementation is "questionable", and uses types as keys and values without quotes sometimes even though they aren't valid json
		var/real_path = istext(path) ? text2path(path) : path
		for(var/i in 1 to L[path])
			if(prob(go_missing_chance))
				continue
			var/atom/A = create_item(real_path)
			if(!QDELETED(A))
				. += A

/datum/persistent/storage/proc/create_item(var/path)
	return new path()

/datum/persistent/storage/GetAdminDataStringFor(var/thing, var/can_modify, var/mob/user)
	var/atom/T = thing
	if(!istype(T))
		return "<td><Missing entry><td>"
	else
		. = "<td colspan = 2>[T.name]</td><td>[T.x],[T.y],[T.z]</td><td>"
