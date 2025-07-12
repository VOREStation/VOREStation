/datum/techweb_node/basic_arms
	id = TECHWEB_NODE_BASIC_ARMS
	starting_node = TRUE
	display_name = "Basic Arms"
	description = "Ballistics can be unpredictable in space."
	design_ids = list(
		// "toy_armblade",
		// "toygun",
		// "c38_rubber",
		// "c38_rubber_mag",
		// "c38_sec",
		// "c38_mag",
		// "capbox",
		// "foam_dart",
		// "sec_beanbag_slug",
		// "sec_dart",
		// "sec_Islug",
		// "sec_rshot",
	)

/datum/techweb_node/sec_equip
	id = TECHWEB_NODE_SEC_EQUIP
	display_name = "Security Equipment"
	description = "All the essentials to subdue a mime."
	prereq_ids = list(TECHWEB_NODE_BASIC_ARMS)
	design_ids = list(
		"seccamera",
		"sec_data",
		"prisonmanage",
		// "mining",
		// "rdcamera",
		// "security_photobooth",
		// "photobooth",
		// "scanner_gate",
		// "pepperspray",
		// "dragnet_beacon",
		// "inspector",
		// "evidencebag",
		// "zipties",
		// "seclite",
		// "electropack",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	announce_channels = list(CHANNEL_SECURITY)
