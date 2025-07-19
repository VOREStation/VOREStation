/datum/techweb_node/scene_tools
	id = TECHWEB_NODE_SCENE_TOOLS
	starting_node = TRUE
	display_name = "Scene Tools"
	description = "Devices made for rest and recreation purposes."
	design_ids = list(
		// TODO: Leash & Collar
		// Compliance
		// Mouse Ray
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)

/datum/techweb_node/sizeplay
	id = TECHWEB_NODE_SIZEPLAY
	display_name = "Scene Tools - Sizeplay"
	description = "A variety of tools capable of changing the size of living organisms. See the world from a new perspective!"
	prereq_ids = list(TECHWEB_NODE_SCENE_TOOLS, TECHWEB_NODE_PASSIVE_IMPLANTS)
	design_ids = list(
		"implant_size",
		"sizegun",
		"bluespacebracelet",
		"deluxebluespacebracelet",
		"bluespacecollar",
		"gradsizegun",
		"hfjumpsuit",
		"bluespace_jumpsuit",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
	announce_channels = list(CHANNEL_COMMON)
	discount_experiments = list(
		/datum/experiment/scanning/people/big_or_smol = TECHWEB_TIER_3_POINTS
	)

/datum/techweb_node/illegal
	id = TECHWEB_NODE_ILLEGAL_SCENETOOLS
	display_name = "Scene Tools - Highly Illegal"
	description = "Risky recreational devices that are distinctly outlawed."
	prereq_ids = list(TECHWEB_NODE_SCENE_TOOLS, TECHWEB_NODE_SEC_EQUIP)
	design_ids = list(
		"chameleon",
		"bodysnatcher",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
