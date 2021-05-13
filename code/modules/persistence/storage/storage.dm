/datum/persistent/storage
	entries_expire_at = 1
	
	// Don't use these for storage persistence. If someone takes some sheets out and puts them back in mixed in with
	// new sheets, how do you know the age of the stack? If you want sheets to 'decay', see go_missing_chance
	entries_decay_at = 0
	entry_decay_weight = 0
	// // // //

	tokens_per_line = PERSISTENCE_VARIABLE_TOKEN_LENGTH
	var/max_storage = 0
	var/store_per_type = FALSE // If true, will store up to max_storage for each type stored
	var/target_type = null // Path of the thing that this expects to put stuff into

	var/go_missing_chance = 0 // Chance an item will fail to be spawned in from persistence and need to be restocked

/datum/persistent/storage/SetFilename()
	if(name)
		filename = "data/persistent/storage/[lowertext(using_map.name)]-[lowertext(name)].txt"

/datum/persistent/storage/LabelTokens(var/list/tokens)
	. = ..()
	.["items"] = list()
	for(var/T in tokens)
		var/list/L = assemble_token(T)
		if(LAZYLEN(L))
			.["items"][L[1]] = text2num(L[2])

/datum/persistent/storage/proc/assemble_token(var/T)
	var/list/subtok = splittext(T, " ")
	if(subtok.len != 2)
		return null
	
	subtok[1] = text2path(subtok[1])
	subtok[2] = text2num(subtok[2])

	// Ensure we've found a token describing the quantity of a path
	if(subtok.len != 2 || \
			!ispath(subtok[1]) || \
			!isnum(subtok[2]))
		return null
	
	return subtok

/datum/persistent/storage/IsValidEntry(var/atom/entry)
	return ..() && istype(entry, target_type)

/datum/persistent/storage/CompileEntry(var/atom/entry)
	. = ..()
	var/stored = max_storage
	var/list/item_list = get_storage_list(entry)
	var/list/storage_list = list()
	for(var/item in item_list)
		storage_list[item] = min(stored, storage_list[item] + item_list[item]) // Can't store more than max_storage
		
		// stored gets reduced by qty stored, if greater than stored,
		// previous assignment will handle overage, and we set to 0
		if(!store_per_type)
			stored = max(stored - item_list[item], 0) 
	
	for(var/item in storage_list)
		. += "[item] [storage_list[item]]"

// Usage: returns list with structure:
//  list(
//      [type1] = [stored_quantity],
//      [type2] = [stored_quantity]
//  )
/datum/persistent/storage/proc/get_storage_list(var/atom/entry)
    return list() // Subtypes define list structure

/datum/persistent/storage/proc/find_specific_instance(var/turf/T)
	return locate(target_type) in T

/datum/persistent/storage/CheckTurfContents(var/turf/T, var/list/tokens)
	return istype(find_specific_instance(T), target_type)

/datum/persistent/storage/proc/generate_items(var/list/L)
	. = list()
	for(var/path in L)
		for(var/i in 1 to L[path])
			if(prob(go_missing_chance))
				continue
			var/atom/A = create_item(path)
			if(!QDELETED(A))
				. += A

/datum/persistent/storage/proc/create_item(var/path)
	return new path()