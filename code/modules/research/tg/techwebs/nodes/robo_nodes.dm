/datum/techweb_node/robotics
	id = TECHWEB_NODE_ROBOTICS
	starting_node = TRUE
	display_name = "Robotics"
	description = "Programmable machines that make our lives lazier."
	design_ids = list(
		"paicard",
		"pai_cell",
		"pai_processor",
		"pai_board",
		"pai_capacitor",
		"pai_projector",
		"pai_emitter",
		"pai_speech_synthesizer",
		"mechfab",
		"prosfab",
		// "botnavbeacon",
		// "mechfab",
	)

/datum/techweb_node/ai
	id = TECHWEB_NODE_AI
	display_name = "Artificial Intelligence"
	description = "Exploration of AI systems, more intelligent than the entire crew put together."
	prereq_ids = list(TECHWEB_NODE_ROBOTICS)
	design_ids = list(
		"aicore",
		"aifixer",
		"aiupload",
		"intellicore",
		"asimov",
		"freeform",
		"reset",
		"safeguard",
		"protectstation",
		"paladin",
		"nanotrasen",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	announce_channels = list(CHANNEL_SCIENCE)

/datum/techweb_node/ai_laws
	id = TECHWEB_NODE_AI_LAWS
	display_name = "Advanced AI Upgrades"
	description = "Delving into sophisticated AI directives, with hopes that they won't lead to humanity's extinction."
	prereq_ids = list(TECHWEB_NODE_AI)
	design_ids = list(
		"onehuman",
		"notele",
		"noengine",
		"quarantine",
		"oxygen",
		"purge",
		"freeformcore",
		"tyrant",
		"laws_predator_vr",
		"laws_protective_shell_vr",
		"laws_scientific_pursuer_vr",
		"laws_guard_dog_vr",
		"laws_pleasurebot_vr",
		"laws_consuming_eradicator_vr",
		"corp",
		"robocop",
		"antimov",
		"nanotrasen_aggressive",
		"maintenance",
		"peacekeeper",
		"reporter",
		"live_and_let_live",
		"balance",

	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
	announce_channels = list(CHANNEL_SCIENCE, CHANNEL_COMMAND)
