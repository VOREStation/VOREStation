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
		"basic_cell",
		"high_cell",
		"device_cell",
		"weapon_cell",
		"high_mech_cell",
		// "basic_scanning",
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
		"super_cell",
		"super_mech_cell",
		"rped",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_2_POINTS)
	announce_channels = list(CHANNEL_ENGINEERING)

/datum/techweb_node/parts_adv
	id = TECHWEB_NODE_PARTS_ADV
	display_name = "Advanced Parts"
	description = "The most finely tuned and accurate stock parts."
	prereq_ids = list(TECHWEB_NODE_PARTS_UPG)
	design_ids = list(
		"super_matter_bin",
		"pico_mani",
		"super_capacitor",
		"phasic_sensor",
		"ultra_micro_laser",
		"hyper_cell",
		"hyper_device_cell",
		"arped",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
	required_experiments = list(/datum/experiment/scanning/points/machinery_tiered_scan/tier2_any)
	announce_channels = list(CHANNEL_ENGINEERING)

/datum/techweb_node/parts_hyper
	id = TECHWEB_NODE_PARTS_HYPER
	display_name = "Hyper Parts"
	description = "Integrating the latest in technology, these advanced components not only enhance functionality but also open up new possibilities for the station's technological capabilities."
	prereq_ids = list(TECHWEB_NODE_PARTS_ADV) //, TECHWEB_NODE_BLUESPACE_TRAVEL)
	design_ids = list(
		"pbrped",
		"hyper_mani",
		"hyper_matter_bin",
		"hyper_mani",
		"hyper_capacitor",
		"hyper_sensor",
		"hyper_micro_laser",
		"hyper_cell",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_4_POINTS)
	discount_experiments = list(/datum/experiment/scanning/points/machinery_tiered_scan/tier3_any = TECHWEB_TIER_4_POINTS)
	announce_channels = list(CHANNEL_ENGINEERING)

/datum/techweb_node/telecomms
	id = TECHWEB_NODE_TELECOMS
	display_name = "Telecommunications Technology"
	description = "A comprehensive suite of machinery for station-wide communication setups, ensuring seamless connectivity and operational coordination."
	prereq_ids = list(TECHWEB_NODE_PARTS_HYPER)
	design_ids = list(
		"tcom-server",
		"tcom-processor",
		"tcom-bus",
		"tcom-hub",
		"tcom-relay",
		"tcom-broadcaster",
		"tcom-receiver",
		"tcom-exonet_node",
		"message_monitor",
		"comm_monitor",
		"comm_server",
		"ntnet_relay",
		"s-ansible",
		"s-filter",
		"s-amplifier",
		"s-treatment",
		"s-analyzer",
		"s-crystal",
		"s-transmitter",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_5_POINTS)

/datum/techweb_node/parts_omni
	id = TECHWEB_NODE_PARTS_OMNI
	display_name = "Omni Parts"
	description = "The end-game of improving machines, these components represent the absolute cutting edge of science."
	prereq_ids = list(TECHWEB_NODE_PARTS_HYPER)
	design_ids = list(
		"brped",
		"omni_matter_bin",
		"omni_mani",
		"omni_capacitor",
		"omni_sensor",
		"omni_micro_laser",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_5_POINTS)
	discount_experiments = list(/datum/experiment/scanning/points/machinery_tiered_scan/tier4_any = TECHWEB_TIER_5_POINTS)
	announce_channels = list(CHANNEL_ENGINEERING)


// Engineering root node
/datum/techweb_node/construction
	id = TECHWEB_NODE_CONSTRUCTION
	starting_node = TRUE
	display_name = "Construction"
	description = "Tools and essential machinery used for station maintenance and expansion."
	design_ids = list(
		"tscanner",
		"rcon_console",
		"powermonitor",
		"solarcontrol",
		"circuit_imprinter",
		"airlock_cycling",
		"partslathe",
		"securedoor",
		// "circuit_imprinter_offstation",
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
		"batteryrack",
		"smes_cell",
		"grid_checker",
		"breakerbox",
		"tesla_coil",
		// "apc_control",
		// "powermonitor",
		// "smes",
		// "portable_smes",
		// "power_connector",
		// "emitter",
		// "grounding_rod",
		// "cell_charger",
		// "recharger",
		// "welding_goggles",
		// "tray_goggles",
		// "geigercounter",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	announce_channels = list(CHANNEL_ENGINEERING)

/datum/techweb_node/holographics
	id = TECHWEB_NODE_HOLOGRAPHICS
	display_name = "Holographics"
	description = "Use of holographic technology for signage and barriers."
	prereq_ids = list(TECHWEB_NODE_ENERGY_MANIPULATION)
	design_ids = list(
		"arf_generator",
		"shield_generator",
		"shield_diffuser",
		// "forcefield_projector",
		// "holosign",
		// "holosignsec",
		// "holosignengi",
		// "holosignatmos",
		// "holosignrestaurant",
		// "holosignbar",
		// "holobarrier_jani",
		// "holobarrier_med",
		// "holopad",
		// "vendatray",
		// "holodisk",
		// "modular_shield_generator",
		// "modular_shield_node",
		// "modular_shield_cable",
		// "modular_shield_relay",
		// "modular_shield_charger",
		// "modular_shield_well",
		// "modular_shield_console",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_2_POINTS)

/datum/techweb_node/exp_tools
	id = TECHWEB_NODE_EXP_TOOLS
	display_name = "Experimental Tools"
	description = "Enhances the functionality and versatility of station tools."
	prereq_ids = list(TECHWEB_NODE_ENERGY_MANIPULATION)
	design_ids = list(
		"jawslife",
		"handdrill",
		"expwelder",
		"advancedtscanner",
		"rapidpipedispenser",
		"protohypospray",
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

/datum/techweb_node/hud
	id = TECHWEB_NODE_HUD
	display_name = "Integrated HUDs"
	description = "Initially developed for assistants to learn the nuances of different professions through augmented reality."
	prereq_ids = list(TECHWEB_NODE_HOLOGRAPHICS, TECHWEB_NODE_CYBER_IMPLANTS)
	design_ids = list(
		"health_hud",
		"security_hud",
		"janitor_hud",
		"rig_component_medhud",
		"rig_component_sechud",
		"graviton_goggles",
		"omnihud",
		// "diagnostic_hud",
		// "mod_visor_diaghud",
		// "ci-medhud",
		// "ci-diaghud",
		// "ci-sechud",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
	announce_channels = list(CHANNEL_ENGINEERING, CHANNEL_SECURITY, CHANNEL_SCIENCE, CHANNEL_MEDICAL)

/datum/techweb_node/night_vision
	id = TECHWEB_NODE_NIGHT_VISION
	display_name = "Night Vision Technology"
	description = "There are whispers that Nanotrasen pushed for this technology to extend shift durations, ensuring productivity around the clock."
	prereq_ids = list(TECHWEB_NODE_HUD)
	design_ids = list(
		"rig_component_nvg",
		// "diagnostic_hud_night",
		// "health_hud_night",
		// "night_visision_goggles",
		// "nvgmesons",
		// "nv_scigoggles",
		// "security_hud_night",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_4_POINTS)
	announce_channels = list(CHANNEL_ENGINEERING, CHANNEL_SECURITY, CHANNEL_SCIENCE, CHANNEL_MEDICAL)

/datum/techweb_node/chemical_refinery
	id = TECHWEB_NODE_CHEM_REFINERY
	display_name = "Chemical Refining"
	description = "Reacting and distilling reagents into more complex and useful forms."
	prereq_ids = list(TECHWEB_NODE_CHEM_SYNTHESIS)
	design_ids = list(
		"industrial_reagent_filter",
		"industrial_reagent_furnace",
		"industrial_reagent_grinder",
		"industrial_reagent_hub",
		"industrial_reagent_pipe",
		"industrial_reagent_pump",
		"industrial_reagent_reactor",
		"industrial_reagent_vat",
		"industrial_reagent_waste_processor",
		"smart_centrifuge",
		"pump_relay",
		"fluid_pump"
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_2_POINTS)
	announce_channels = list(CHANNEL_ENGINEERING,CHANNEL_MEDICAL)

/datum/techweb_node/thermal_vision
	id = TECHWEB_NODE_THERMAL_VISION
	display_name = "Thermal Visor Technology"
	description = "Inspired by some form of big-game-hunter species, we have adapted the technology without the annoying colorization filter."
	prereq_ids = list(TECHWEB_NODE_HUD)
	design_ids = list(
		"rig_component_thermal",
		// "diagnostic_hud_night",
		// "health_hud_night",
		// "night_visision_goggles",
		// "nvgmesons",
		// "nv_scigoggles",
		// "security_hud_night",
	)

/datum/techweb_node/graviton_vision
	id = TECHWEB_NODE_GRAVITON_VISION
	display_name = "Graviton Visor Technology"
	description = "Our Graviton Scanning technology compressed into visors suitable for use in hardsuits. Quite handy."
	prereq_ids = list(TECHWEB_NODE_HUD)
	design_ids = list(
		"rig_component_graviton",
		// "diagnostic_hud_night",
		// "health_hud_night",
		// "night_visision_goggles",
		// "nvgmesons",
		// "nv_scigoggles",
		// "security_hud_night",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_4_POINTS)
	announce_channels = list(CHANNEL_SECURITY, CHANNEL_SCIENCE)

/datum/techweb_node/advanced_visor
	id = TECHWEB_NODE_ADVANCED_VISORS
	display_name = "Advanced Visor Technology"
	description = "With careful research over transparent electrochromic glass and display project we have compressed multiple visors into a single handy package."
	prereq_ids = list(TECHWEB_NODE_GRAVITON_VISION, TECHWEB_NODE_THERMAL_VISION, TECHWEB_NODE_HUD)
	design_ids = list(
		"rig_component_multi_visor",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_4_POINTS)
	announce_channels = list(CHANNEL_SECURITY, CHANNEL_SCIENCE)
