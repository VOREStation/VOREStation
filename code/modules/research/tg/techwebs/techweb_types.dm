/**
 * Global Science techweb for RND consoles
 */
/datum/techweb/science
	id = "SCIENCE"
	organization = "Nanotrasen"
	should_generate_points = TRUE

/datum/techweb/science/research_node(datum/techweb_node/node, force = FALSE, auto_adjust_cost = TRUE, get_that_dosh = TRUE, atom/research_source)
	. = ..()
	if(.)
		node.on_station_research(research_source)

/**
 * Admin techweb that has everything unlocked by default
 */
/datum/techweb/admin
	id = "ADMIN"
	organization = "Central Command"

/datum/techweb/admin/New()
	. = ..()
	for(var/i in SSresearch.techweb_nodes)
		var/datum/techweb_node/TN = SSresearch.techweb_nodes[i]
		research_node(TN, TRUE, TRUE, FALSE)
	for(var/i in SSresearch.point_types)
		research_points[i] = INFINITY
	hidden_nodes = list()
