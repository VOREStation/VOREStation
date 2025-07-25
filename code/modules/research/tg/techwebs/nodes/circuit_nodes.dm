/datum/techweb_node/programming
	id = TECHWEB_NODE_PROGRAMMING
	starting_node = TRUE
	display_name = "Programming"
	description = "Dedicate an entire shift to program a fridge to greet you when opened."
	prereq_ids = list(TECHWEB_NODE_ROBOTICS)
	design_ids = list(
		"ic_printer",
		"wirer",
		"debugger",
		"assembly-small",
		"assembly-medium",
		"assembly-large",
		"assembly-device",
		"circuit-bug",
	)

/datum/techweb_node/circuit_shells
	id = TECHWEB_NODE_CIRCUIT_SHELLS
	display_name = "Advanced Circuit Shells"
	description = "Adding brains to more things."
	prereq_ids = list(TECHWEB_NODE_PROGRAMMING)
	design_ids = list(
		"assembly-implant",
		"ic_printer_upgrade_adv",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)

/datum/techweb_node/programmed_robot
	id = TECHWEB_NODE_PROGRAMMED_ROBOT
	display_name = "Programmed Robot"
	description = "Grants access to movable shells, allowing for remote operations and pranks."
	prereq_ids = list(TECHWEB_NODE_CIRCUIT_SHELLS)
	design_ids = list(
		"assembly-drone",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_2_POINTS)
