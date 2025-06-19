/datum/persistent/filth/trash
	name = "trash"
	saves_dirt = FALSE
	has_admin_data = FALSE

/datum/persistent/filth/trash/CheckTurfContents(var/turf/T, var/list/tokens)
	var/too_much_trash = 0
	for(var/obj/item/trash/trash in T)
		if(istype(T, /obj/item/trash/spitwad) || istype(T, /obj/item/trash/spitgum))
			return FALSE
		too_much_trash++
		if(too_much_trash >= 5)
			return FALSE
	return TRUE

/datum/persistent/filth/trash/GetEntryAge(var/atom/entry)
	var/obj/item/trash/trash = entry
	return trash.age

/datum/persistent/filth/trash/GetEntryPath(var/atom/entry)
	return entry.type
