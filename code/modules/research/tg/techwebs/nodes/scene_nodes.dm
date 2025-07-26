/datum/techweb_node/scene_tools
	id = TECHWEB_NODE_SCENE_TOOLS
	starting_node = TRUE
	display_name = "Potential Recreational Applications"
	description = "Devices made for rest and recreation purposes."
	design_ids = list(
		// TODO: Leash & Collar
		// Compliance
		// Mouse Ray
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)

/datum/techweb_node/sizeplay
	id = TECHWEB_NODE_SIZEPLAY
	display_name = "Scale Distortion Technology"
	description = "Isolating the active components of local Xenoflora and applying them in different ways has resulted in a variety of ways to adjust the scale of living things!"
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
	display_name = "Modified Sleeve Equipment"
	description = "It turns out that the neurological process used by the Sleevemate can be adjusted to be read AND write with moderate modification! The extra buffer memory on the modified version lets you perform both at once and swap the mind states of two participants!"
	prereq_ids = list(TECHWEB_NODE_SCENE_TOOLS, TECHWEB_NODE_SEC_EQUIP)
	design_ids = list(
		"bodysnatcher",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
