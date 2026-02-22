/datum/unit_test/techwebs_must_all_be_valid

/datum/unit_test/techwebs_must_all_be_valid/Run()
	var/failed = FALSE
	var/list/unique_nodes = list()

	// Each node in the web
	var/list/used_designs = list()
	for(var/node_id in SSresearch.techweb_nodes)
		var/datum/techweb_node/node = SSresearch.techweb_nodes[node_id]
		if(node.id == /datum/techweb_node/error_node::id)
			continue

		// Nodes must always be unique
		if(node.id in unique_nodes)
			TEST_NOTICE(src, "TECHWEB NODE - [node.type] used an id already in use by another node: \"[node.id]\"")
			failed = TRUE
		unique_nodes += node.id

		// Must have a description
		if(node.description == /datum/techweb_node::description)
			TEST_NOTICE(src, "TECHWEB NODE - [node.type] did not have a description set.")
			failed = TRUE

		// Must have an announcement channel
		if(!node.starting_node && !node.announce_channels?.len)
			TEST_NOTICE(src, "TECHWEB NODE - [node.type] did not have any announce_channels set.")
			failed = TRUE
		if(node.starting_node && node.announce_channels?.len)
			TEST_NOTICE(src, "TECHWEB NODE - [node.type] starting node has announcement channels, it should not.")
			failed = TRUE

		// Must have costs set
		if(!node.starting_node && !node.research_costs?.len)
			TEST_NOTICE(src, "TECHWEB NODE - [node.type] did not have any research_costs set.")
			failed = TRUE

		// Must have category set
		if(!length(node.category))
			TEST_NOTICE(src, "TECHWEB NODE - [node.type] did not have a category set.")
			failed = TRUE

		// Must have valid designs
		if(!length(node.design_ids))
			TEST_NOTICE(src, "TECHWEB NODE - [node.type] does not have any design_ids.")
			failed = TRUE
		else
			for(var/design in node.design_ids)
				if(design in used_designs)
					TEST_NOTICE(src, "TECHWEB NODE - [node.type] has an already in use design_id: \"[design]\"")
					failed = TRUE

				used_designs += design
				if(!(design in SSresearch.techweb_designs))
					TEST_NOTICE(src, "TECHWEB NODE - [node.type] has a non-existant design_id: \"[design]\"")
					failed = TRUE

		// Must have valid prereqs
		if(node.prereq_ids.len)
			for(var/req in node.prereq_ids)
				if(!(req in SSresearch.techweb_nodes))
					TEST_NOTICE(src, "TECHWEB NODE - [node.type] has a non-existant prereq_id: \"[req]\"")
					failed = TRUE

	// We can't check for for some stuff in here if we haven't already checked and made sure the nodes are valid first
	if(!failed)
		for(var/node_id in SSresearch.techweb_nodes)
			var/datum/techweb_node/node = SSresearch.techweb_nodes[node_id]

			// Check that our cost and make sure it's more expensive than our prior tier, unless they have a required experiment.
			if(!node.required_experiments.len && node.prereq_ids.len)
				if(!node.starting_node)
					var/current_cost = node.research_costs.len ? INFINITY : 0
					for(var/check_cost_type in node.research_costs)
						// Get the LOWEST cost of us
						if(node.research_costs[check_cost_type] < current_cost)
							current_cost = node.research_costs[check_cost_type]

					for(var/prereq_node_id in node.prereq_ids)
						var/datum/techweb_node/prereq_node = SSresearch.techweb_nodes[prereq_node_id]
						var/prereq_currentcost = prereq_node.research_costs ? INFINITY : 0
						if(prereq_node.starting_node)
							continue

						for(var/req_cost_type in prereq_node.research_costs)
							// Get the LOWEST cost of prereq
							if(prereq_node.research_costs[req_cost_type] < prereq_currentcost)
								prereq_currentcost = prereq_node.research_costs[req_cost_type]

						if(prereq_currentcost > current_cost)
							TEST_NOTICE(src, "TECHWEB NODE - [node.type] costs less to make then the previous node, must always be at least the same or more expensive. ours lowest is \[[current_cost]\], prereq lowest is \[[prereq_currentcost]\]. Lesser costs than the previous node is only allowed if the node has a required experiment.")
							failed = TRUE

					// forbid designs with RND_CATEGORY_INITIAL in non-starting nodes
					for(var/design_id in node.design_ids)
						var/datum/design_techweb/design = SSresearch.techweb_designs[design_id]
						if((RND_CATEGORY_INITIAL in design.category))
							TEST_NOTICE(src, "TECHWEB NODE - [node.type]'s [design_id] is flagged as RND_CATEGORY_INITIAL in a non-starting techweb node.")
							failed = TRUE
				else
					// if we have prereqs we did something wrong
					if(length(node.prereq_ids))
						TEST_NOTICE(src, "TECHWEB NODE - [node.type] is a starting node, but has prereq_ids assigned.")
						failed = TRUE

					// starting nodes need to have all design inside it flagged with RND_CATEGORY_INITIAL
					for(var/design_id in node.design_ids)
						var/datum/design_techweb/design = SSresearch.techweb_designs[design_id]
						if(!(RND_CATEGORY_INITIAL in design.category))
							TEST_NOTICE(src, "TECHWEB NODE - [node.type]'s [design_id] was part of a starting node, but is not category tagged RND_CATEGORY_INITIAL.")
							failed = TRUE

	// Each design
	var/used_design_paths = list()
	for(var/design_id in SSresearch.techweb_designs)
		var/datum/design_techweb/design = SSresearch.techweb_designs[design_id]
		if(design.id == DESIGN_ID_IGNORE)
			continue

		// Must all be accessible by science
		if(!(design.departmental_flags & DEPARTMENT_BITFLAG_SCIENCE))
			TEST_NOTICE(src, "TECHWEB DESIGN - [design.type] was not flagged for science department, all designs must be accessible by science.")
			failed = TRUE

		// Designs SHOULD be accessible, only a warning
		if(!(design.id in used_designs))
			TEST_NOTICE(src, "TECHWEB DESIGN - WARNING [design.type] is orphaned and not accessible from any techweb node. Is this intended?")

		// Design must produce something
		if(!design.build_path)
			TEST_NOTICE(src, "TECHWEB DESIGN - [design.type] did not have a build_path.")
			failed = TRUE

		// Design must be a unique path produced
		if(design.build_path in used_design_paths)
			TEST_NOTICE(src, "TECHWEB DESIGN - [design.type] had a build_path that was already used by another design: \"[design.build_path]\"")
			failed = TRUE

		used_design_paths += design.build_path

	if(failed)
		TEST_FAIL("All techweb entries must be valid")
