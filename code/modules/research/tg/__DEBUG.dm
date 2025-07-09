/client/verb/techweb_designs_without_owners()
	set name = "DEBUG: Techweb Designs Without Owners"
	set category = "Debug"

	var/list/designs = SSresearch.techweb_designs.Copy()

	for(var/node_id in SSresearch.techweb_nodes)
		var/datum/techweb_node/node = SSresearch.techweb_nodes[node_id]
		designs -= node.design_ids

	to_chat(src, json_encode(designs))
