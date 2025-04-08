// Handles automagically upgrades to machines based on components placed on a machine during map init
/obj/machinery/Initialize(mapload)
	. = ..()
	// Handles automagically upgrades to machines based on components placed on a machine during map init
	if(mapload)
		spawn(100)
			// Sanity checks
			if(!QDELETED(src) && isturf(loc))
				handle_mapped_upgrades()
// This is meant to be overridden per machine
/obj/machinery/proc/handle_mapped_upgrades()
	return
// Each machine is a special snowflake... sadly.
/obj/machinery/power/smes/buildable/handle_mapped_upgrades()
	// Detect new coils placed by mappers
	var/list/parts_found = list()
	for(var/i = 1, i <= loc.contents.len, i++)
		var/obj/item/W = loc.contents[i]
		if(istype(W, /obj/item/smes_coil))
			parts_found.Add(W)
	// If any coils are on us, clear base coils and rebuild using these ones
	if(parts_found.len == 0)
		return
	while(TRUE)
		var/obj/item/smes_coil/C = locate(/obj/item/smes_coil) in component_parts
		if(isnull(C))
			break
		component_parts.Remove(C)
		C.forceMove(src.loc)
		qdel(C)
		cur_coils--
	// Rebuild from mapper's coils
	for(var/i = 1, i <= parts_found.len, i++)
		if (cur_coils < max_coils)
			var/obj/item/W = parts_found[i]
			cur_coils++
			component_parts.Add(W)
			W.forceMove(src)
	RefreshParts()
