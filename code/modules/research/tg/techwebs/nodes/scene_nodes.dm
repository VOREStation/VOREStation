/datum/techweb_node/scene_tools
	id = TECHWEB_NODE_SCENE_TOOLS
	starting_node = TRUE
	display_name = "Scene Tools"
	description = "Fun things to spice up your sex life."
	design_ids = list(

 	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)

/datum/techweb_node/sizeplay
	id = TECHWEB_NODE_SIZEPLAY
	display_name = "Scene Tools - Sizeplay"
	description = "Fun tools to spice up your sex life with sizeplay!~"
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
