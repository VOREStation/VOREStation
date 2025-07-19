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
