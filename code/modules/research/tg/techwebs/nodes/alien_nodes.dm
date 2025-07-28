
/datum/techweb_node/alientech
	id = TECHWEB_NODE_ALIENTECH
	display_name = "Precursor Technology"
	description = "Things used by the precursors."
	prereq_ids = list(TECHWEB_NODE_BLUESPACE_TRAVEL)
	design_ids = list(
		"anobattery-basic",
		"anobattery-moderate",
		"anobattery-advanced",
		"anobattery-exotic",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_2_POINTS)

/datum/techweb_node/alien_engi
	id = TECHWEB_NODE_ALIEN_ENGI
	display_name = "Precursor Engineering"
	description = "Precursor engineering tools"
	prereq_ids = list(TECHWEB_NODE_ALIENTECH, TECHWEB_NODE_EXP_TOOLS)
	design_ids = list(
		"hybridcrowbar",
		"hybridwrench",
		"hybridscrewdriver",
		"hybridwirecutters",
		"hybridwelder",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_2_POINTS)
	announce_channels = list(CHANNEL_ENGINEERING)
