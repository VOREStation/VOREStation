// Parts root node
/datum/techweb_node/parts
	id = TECHWEB_NODE_PARTS
	starting_node = TRUE
	display_name = "Essential Stock Parts"
	description = "Foundational components that form the backbone of station operations, encompassing a range of essential equipment necessary for day-to-day functionality."
	design_ids = list(
		"basic_matter_bin",
		"basic_capacitor",
		"basic_sensor",
		"basic_micro_laser",
		"micro_manipulator",
		"parts_bundle_t1",
		"basic_cell",
		"high_cell",
		// "basic_battery",
		// "basic_scanning",
		// "high_battery",
		// "miniature_power_cell",
		// "condenser",
		// "igniter",
		// "infrared_emitter",
		// "prox_sensor",
		// "signaler",
		// "timer",
		// "voice_analyzer",
		// "health_sensor",
		// "sflash",
	)

/datum/techweb_node/parts_upg
	id = TECHWEB_NODE_PARTS_UPG
	display_name = "Upgraded Parts"
	description = "Offering enhanced capabilities beyond their basic counterparts."
	prereq_ids = list(TECHWEB_NODE_PARTS, TECHWEB_NODE_ENERGY_MANIPULATION)
	design_ids = list(
		"adv_matter_bin",
		"nano_mani",
		"adv_capacitor",
		"adv_sensor",
		"high_micro_laser",
		"parts_bundle_t2",
		"super_cell",
		"rped",
		// "super_battery",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_2_POINTS)
	announce_channels = list(CHANNEL_ENGINEERING)

// Engineering root node
/datum/techweb_node/construction
	id = TECHWEB_NODE_CONSTRUCTION
	starting_node = TRUE
	display_name = "Construction"
	description = "Tools and essential machinery used for station maintenance and expansion."
	design_ids = list(
		"tscanner",
		// "circuit_imprinter_offstation",
		// "circuit_imprinter",
		// "solarcontrol",
		// "solar_panel",
		// "solar_tracker",
		// "power_control",
		// "airalarm_electronics",
		// "airlock_board",
		// "firealarm_electronics",
		// "firelock_board",
		// "trapdoor_electronics",
		// "blast",
		// "ignition",
		// "big_manipulator",
		// "tile_sprayer",
		// "airlock_painter",
		// "decal_painter",
		// "rwd",
		// "cable_coil",
		// "welding_helmet",
		// "welding_tool",
		// "mini_welding_tool",
		// "multitool",
		// "wrench",
		// "crowbar",
		// "screwdriver",
		// "wirecutters",
		// "light_bulb",
		// "light_tube",
		// "crossing_signal",
		// "guideway_sensor",
		// "manuunloader",
		// "manusmelter",
		// "manucrusher",
		// "manucrafter",
		// "manulathe",
		// "manusorter",
		// "manurouter",
		// "mailsorter",
	)

/datum/techweb_node/energy_manipulation
	id = TECHWEB_NODE_ENERGY_MANIPULATION
	display_name = "Energy Manipulation"
	description = "Harnessing the raw power of lightning arcs through sophisticated energy control methods."
	prereq_ids = list(TECHWEB_NODE_CONSTRUCTION)
	design_ids = list(
		"inducersci",
		"inducerind",
		"upgradedtscanner",
		// "apc_control",
		// "powermonitor",
		// "smes",
		// "portable_smes",
		// "power_connector",
		// "emitter",
		// "grounding_rod",
		// "tesla_coil",
		// "cell_charger",
		// "recharger",
		// "welding_goggles",
		// "tray_goggles",
		// "geigercounter",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	announce_channels = list(CHANNEL_ENGINEERING)

/datum/techweb_node/exp_tools
	id = TECHWEB_NODE_EXP_TOOLS
	display_name = "Experimental Tools"
	description = "Enhances the functionality and versatility of station tools."
	prereq_ids = list(TECHWEB_NODE_ENERGY_MANIPULATION)
	design_ids = list(
		"jawslife",
		"handdrill",
		"expwelder",
		// "flatpacker",
		// "rangedanalyzer",
		// "rtd_loaded",
		// "mech_rcd",
		// "rcd_loaded",
		// "rcd_ammo",
		// "weldingmask",
		// "magboots",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_2_POINTS)
	announce_channels = list(CHANNEL_ENGINEERING)
