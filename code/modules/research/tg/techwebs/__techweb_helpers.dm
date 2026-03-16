/proc/count_unique_techweb_nodes()
	var/static/list/L = typesof(/datum/techweb_node)
	return L.len

/proc/count_unique_techweb_designs()
	var/static/list/L = typesof(/datum/design_techweb)
	return L.len

/proc/node_boost_error(id, message)
	warning("Invalid boost information for node \[[id]\]: [message]")
	SSresearch.invalid_node_boost[id] = message

///Returns an associative list of techweb node datums with values of the nodes it unlocks.
/proc/techweb_item_unlock_check(obj/item/I)
	if(SSresearch.techweb_unlock_items[I.type])
		return SSresearch.techweb_unlock_items[I.type] //It should already be formatted in node datum = list(point type = value)

/proc/techweb_item_point_check(obj/item/I)
	if(SSresearch.techweb_point_items[I.type])
		return SSresearch.techweb_point_items[I.type]

	//cursed pointer usage lay here
	var/list/type_pointer = list() //yes this is a pointer.
	var/point_value = SEND_SIGNAL(I, COMSIG_TECHWEB_POINT_CHECK)
	SEND_SIGNAL(I, COMSIG_TECHWEB_TYPE_CHECK, type_pointer)
	if(point_value && LAZYLEN(type_pointer))
		return list(type_pointer["type"] = point_value)
	return FALSE

/proc/techweb_item_generate_points(obj/item/thing, datum/techweb/target_techweb)
	if(!istype(thing))
		return
	var/list/point_value = techweb_item_point_check(thing)
	//If it has a point value and we haven't deconstructed it OR we've deconstructed it but it's a repeatable.
	if(point_value && (!target_techweb.deconstructed_items[thing.type] || (target_techweb.deconstructed_items[thing.type] && (thing.type in SSresearch.techweb_repeatable_items))))
		if(SSresearch.techweb_point_items[thing.type]) //Don't add things that have the deconstructable_research component
			target_techweb.deconstructed_items[thing.type] = TRUE
		target_techweb.add_point_list(point_value)

/proc/techweb_point_display_generic(pointlist)
	var/list/ret = list()
	for(var/i in pointlist)
		if(i in SSresearch.point_types)
			ret += "[SSresearch.point_types[i]]: [pointlist[i]]"
		else
			ret += "ERRORED POINT TYPE: [pointlist[i]]"
	return ret.Join("<BR>")

/proc/techweb_point_display_rdconsole(pointlist, last_pointlist)
	var/list/ret = list()
	for(var/i in pointlist)
		var/research_line = "[(i in SSresearch.point_types) || "ERRORED POINT TYPE"]: [pointlist[i]]"
		if(last_pointlist[i] > 0)
			research_line += " (+[(last_pointlist[i]) * ((SSresearch.flags & SS_TICKER)? (600 / (world.tick_lag * SSresearch.wait)) : (600 / SSresearch.wait))]/ minute)"
		ret += research_line
	return ret.Join("<BR>")
