/client/verb/techweb_designs_without_owners()
	set name = "DEBUG: Techweb Designs Without Owners"
	set category = "Debug"

	var/list/designs = SSresearch.techweb_designs.Copy()

	for(var/node_id in SSresearch.techweb_nodes)
		var/datum/techweb_node/node = SSresearch.techweb_nodes[node_id]
		designs -= node.design_ids

	to_chat(src, json_encode(designs, JSON_PRETTY_PRINT))

/client/verb/techweb_designs_without_btype()
	set name = "DEBUG: Techweb Designs Without build_type"
	set category = "Debug"

	var/list/bad_designs = list()

	for(var/id in SSresearch.techweb_designs)
		var/datum/design_techweb/D = SSresearch.techweb_designs[id]
		if(D.build_type == null)
			bad_designs += id

	to_chat(src, json_encode(bad_designs, JSON_PRETTY_PRINT))

/proc/flag2department(flag)
	switch(flag)
		if(1<<0)
			return "DEPARTMENT_BITFLAG_SECURITY"
		if(1<<1)
			return "DEPARTMENT_BITFLAG_COMMAND"
		if(1<<2)
			return "DEPARTMENT_BITFLAG_SERVICE"
		if(1<<3)
			return "DEPARTMENT_BITFLAG_CARGO"
		if(1<<4)
			return "DEPARTMENT_BITFLAG_ENGINEERING"
		if(1<<5)
			return "DEPARTMENT_BITFLAG_SCIENCE"
		if(1<<6)
			return "DEPARTMENT_BITFLAG_MEDICAL"
		if(1<<7)
			return "DEPARTMENT_BITFLAG_SILICON"
		if(1<<8)
			return "DEPARTMENT_BITFLAG_ASSISTANT"
		if(1<<9)
			return "DEPARTMENT_BITFLAG_CAPTAIN"
	return "INVALID"


/client/verb/techweb_designs_list()
	set name = "DEBUG: Techweb Designs List"
	set category = "Debug"

	var/list/designs_by_flag = list()

	var/flag = 1

	for(var/i in 1 to 32)
		designs_by_flag["[flag]"] = list()

		for(var/id in SSresearch.techweb_designs)
			var/datum/design_techweb/D = SSresearch.techweb_designs[id]
			if(D.departmental_flags & flag)
				designs_by_flag["[flag]"] += "[D.name] ([D.id])"

		flag <<= 1

	for(var/flager in designs_by_flag)
		var/list/designs = designs_by_flag[flager]
		to_chat(src, "-- [flag2department(text2num(flager))] --")
		to_chat(src, json_encode(designs, JSON_PRETTY_PRINT))
