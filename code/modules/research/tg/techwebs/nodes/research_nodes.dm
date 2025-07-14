/datum/techweb_node/fundamental_sci
	id = TECHWEB_NODE_FUNDIMENTAL_SCI
	starting_node = TRUE
	display_name = "Fundamental Science"
	description = "Establishing the bedrock of scientific understanding, paving the way for deeper exploration and theoretical inquiry."
	design_ids = list(
		"experi_scanner",
		"rdserver",
		"rdconsole",
		"bomb_tester",
		// "rdservercontrol",
		// "tech_disk",
		// "doppler_array",
		// "experimentor",
		// "destructive_analyzer",
		// "destructive_scanner",
		// "laptop",
		// "portadrive_basic",
		// "portadrive_advanced",
		// "portadrive_super",
	)

/datum/techweb_node/bluespace_theory
	id = TECHWEB_NODE_BLUESPACE_THEORY
	display_name = "Bluespace Theory"
	description = "Basic studies into the mysterious alternate dimension known as bluespace."
	prereq_ids = list(TECHWEB_NODE_FUNDIMENTAL_SCI)
	design_ids = list(
		"bluespace_crystal",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	announce_channels = list(CHANNEL_SCIENCE)

/datum/techweb_node/applied_bluespace
	id = TECHWEB_NODE_APPLIED_BLUESPACE
	display_name = "Applied Bluespace Research"
	description = "With a heightened grasp of bluespace dynamics, sophisticated applications and technologies can be devised using data from bluespace crystal analyses."
	prereq_ids = list(TECHWEB_NODE_BLUESPACE_THEORY)
	design_ids = list(
		"ore_holding",
		"sheet_holding",
		"bag_holding",
		"dufflebag_holding",
		"trashbag_holding",
		"pouch_holding",
		"belt_holding_med",
		"belt_holding_utility",
		"bluespacebeaker",
		// "ore_silo",
		// "plumbing_receiver",
		// "adv_watering_can",
		// "bluespace_coffeepot",
		// "bluespacesyringe",
		// "light_replacer_blue",
		// "bluespacebodybag",
		// "gigabeacon",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_2_POINTS)
	// discount_experiments = list(/datum/experiment/scanning/points/bluespace_crystal = TECHWEB_TIER_2_POINTS)
	announce_channels = list(CHANNEL_SCIENCE, CHANNEL_MEDICAL, CHANNEL_SERVICE, CHANNEL_SUPPLY)
