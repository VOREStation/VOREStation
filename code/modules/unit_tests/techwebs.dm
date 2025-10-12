/datum/unit_test/techwebs_must_all_be_valid

/datum/unit_test/techwebs_must_all_be_valid/Run()
	var/failed = FALSE
	var/list/unique_nodes = list()

	// Each node in the web
	for(var/node_id in SSresearch.techweb_nodes)
		var/datum/techweb_node/node = SSresearch.techweb_nodes[node_id]
		if(node.id == /datum/techweb_node/error_node::id)
			continue

		// Must have a description
		if(node.description == /datum/techweb_node::description)
			TEST_NOTICE(src, "TECHWEB NODE - [node.type] did not have a description set.")
			failed = TRUE

		// Nodes must always be unique
		if(node.id in unique_nodes)
			TEST_NOTICE(src, "TECHWEB NODE - [node.type] used an id already in use by another node: \"[node.id]\"")
			failed = TRUE
		unique_nodes += node.id

		// Must have an announcement channel
		if(!node.announce_channels?.len)
			TEST_NOTICE(src, "TECHWEB NODE - [node.type] did not have any announce_channels set.")
			failed = TRUE

		// Must have costs set
		if(!node.starting_node && !node.research_costs?.len)
			TEST_NOTICE(src, "TECHWEB NODE - [node.type] did not have any research_costs set.")
			failed = TRUE

		// Must have valid prereqs
		if(node.prereq_ids.len)
			for(var/req in node.prereq_ids)
				if(!SSresearch.techweb_nodes[req])
					TEST_NOTICE(src, "TECHWEB NODE - [node.type] has a non-existant prereq_id: \"[req]\"")
					failed = TRUE

		// Must have valid designs
		if(!node.design_ids)
			TEST_NOTICE(src, "TECHWEB NODE - [node.type] does not have any design_ids.")
			failed = TRUE
		else
			for(var/design in node.design_ids)
				if(!SSresearch.techweb_designs[design])
					TEST_NOTICE(src, "TECHWEB NODE - [node.type] has a non-existant design_id: \"[design]\"")
					failed = TRUE

	// Each design
	for(var/design_id in SSresearch.techweb_designs)
		var/datum/design_techweb/design = SSresearch.techweb_designs[design_id]
		if(design.id == DESIGN_ID_IGNORE)
			continue

		// Must all be accessible by science
		if(!(design.departmental_flags & DEPARTMENT_BITFLAG_SCIENCE))
			TEST_NOTICE(src, "TECHWEB DESIGN - [design.type] was not flagged for science department, all designs must be accessible by science.")
			failed = TRUE

	if(failed)
		TEST_FAIL("All techweb entries must be valid")
