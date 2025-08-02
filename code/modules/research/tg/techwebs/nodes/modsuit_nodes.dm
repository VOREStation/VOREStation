/datum/techweb_node/mod_suit
	id = TECHWEB_NODE_MOD_SUIT
	starting_node = TRUE
	display_name = "RIG Suit"
	description = "Specialized back mounted power suits with various different modules."
	prereq_ids = list(TECHWEB_NODE_ROBOTICS)
	design_ids = list(
		"rigmodule_belt_basic",
		"zero_rig_module",
		"rig_device_pen",
		"rig_device_paperdispenser",
		// "suit_storage_unit",
		// "mod_shell",
		// "mod_chestplate",
		// "mod_helmet",
		// "mod_gauntlets",
		// "mod_boots",
		// "mod_plating_standard",
		// "mod_plating_civilian",
		// "mod_paint_kit",
		// "mod_storage",
		// "mod_plasma",
		// "mod_flashlight",
	)

/datum/techweb_node/mod_equip
	id = TECHWEB_NODE_MOD_EQUIP
	display_name = "RIG Suit Equipment"
	description = "More advanced modules, to improve RIG suits."
	prereq_ids = list(TECHWEB_NODE_MOD_SUIT)
	design_ids = list(
		"rig_siphon",
		"rig_device_flash",
		"rig_device_plasmacutter",
		"rig_device_healthanalyzer",
		"rig_gun_sizegun",
		"rig_siphon",
		"rig_component_datajack",
		// "modlink_scryer",
		// "mod_clamp",
		// "mod_tether",
		// "mod_welding",
		// "mod_safety",
		// "mod_mouthhole",
		// "mod_longfall",
		// "mod_thermal_regulator",
		// "mod_sign_radio",
		// "mod_mister_janitor",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	announce_channels = list(CHANNEL_SCIENCE)

/datum/techweb_node/mod_medical
	id = TECHWEB_NODE_MOD_MEDICAL
	display_name = "Medical RIG Suit"
	description = "Medical RIGsuits for quick rescue purposes."
	prereq_ids = list(TECHWEB_NODE_MOD_SUIT, TECHWEB_NODE_CHEM_SYNTHESIS)
	design_ids = list(
		"medical_rig_module",
		"rig_component_chemicals",
		"rig_component_rescuepharm",
		// "mod_plating_medical",
		// "mod_quick_carry",
		// "mod_injector",
		// "mod_organizer",
		// "mod_patienttransport",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
	required_experiments = list(/datum/experiment/scanning/points/basic_med_rig)
	announce_channels = list(CHANNEL_SCIENCE, CHANNEL_MEDICAL)

/datum/techweb_node/mod_engi
	id = TECHWEB_NODE_MOD_ENGI
	display_name = "Engineering RIG Suits"
	description = "Engineering suits, for powered engineers."
	prereq_ids = list(TECHWEB_NODE_MOD_EQUIP)
	design_ids = list(
		"eva_rig_module",
		"rig_device_rcd",
		"rig_component_meson",
		"rig_component_radshield",
		"rig_component_atmosshield",
		"rig_component_aicontainer",
		"rig_component_faradayshield",
		// "mod_plating_engineering",
		// "mod_t_ray",
		// "mod_magboot",
		// "mod_constructor",
		// "mod_mister_atmos",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
	required_experiments = list(/datum/experiment/scanning/points/basic_engi_rig)
	announce_channels = list(CHANNEL_SCIENCE, CHANNEL_ENGINEERING)

/datum/techweb_node/mod_security
	id = TECHWEB_NODE_MOD_SECURITY
	display_name = "Security RIG Suits"
	description = "Security suits for space crime handling."
	prereq_ids = list(TECHWEB_NODE_MOD_EQUIP)
	design_ids = list(
		"hazard_rig_module",
		"rig_grenade_metalfoam",
		"rig_grenade_flashbang",
		"rig_grenade_cleanfoam",
		"rig_gun_taser",
		"rig_gun_tempgun",
		"rig_component_voice",
		"rig_gun_egun",
		"rig_component_sprinter",
		"rig_component_pat",
		// "mod_mirage_grenade",
		// "mod_plating_security",
		// "mod_stealth",
		// "mod_mag_harness",
		// "mod_pathfinder",
		// "mod_holster",
		// "mod_sonar",
		// "mod_projectile_dampener",
		// "mod_criminalcapture",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
	required_experiments = list(/datum/experiment/scanning/points/basic_sec_rig)
	announce_channels = list(CHANNEL_SCIENCE, CHANNEL_SECURITY)

/datum/techweb_node/mod_engi_adv
	id = TECHWEB_NODE_MOD_ENGI_ADV
	display_name = "Advanced Engineering RIG Suit"
	description = "Advanced Engineering suits, for advanced powered engineers."
	prereq_ids = list(TECHWEB_NODE_MOD_ENGI)
	design_ids = list(
		"advanced_eva_rig_module",
		"rig_component_radshield_adv",
		"rig_component_atmosshield_adv",
		"rig_component_faradayshield_adv",
		"rig_thrusters",
		// "mod_plating_atmospheric",
		// "mod_jetpack",
		// "mod_rad_protection",
		// "mod_emp_shield",
		// "mod_storage_expanded",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_4_POINTS)
	announce_channels = list(CHANNEL_SCIENCE, CHANNEL_ENGINEERING)

/datum/techweb_node/mod_anomaly
	id = TECHWEB_NODE_MOD_ANOMALY
	display_name = "Anomalock RIG Suit"
	description = "Modules for RIGsuits that are designed to research anomalies."
	prereq_ids = list(TECHWEB_NODE_MOD_ENGI_ADV, TECHWEB_NODE_ANOMALY_RESEARCH)
	design_ids = list(
		"ami_rig_module",
		"rig_component_teleport",
		"rig_device_excdrill",
		"rig_device_anomscanner",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_4_POINTS)
	required_experiments = list(/datum/experiment/scanning/points/basic_sci_rig)
	announce_channels = list(CHANNEL_SCIENCE)

/datum/techweb_node/mod_supply
	id = TECHWEB_NODE_MOD_SUPPLY
	display_name = "Industrial RIG Suit"
	description = "Modules for RIGsuits that are designed to mine for ores."
	prereq_ids = list(TECHWEB_NODE_MOD_ENGI_ADV, TECHWEB_NODE_MINING)
	design_ids = list(
		"industrial_rig_module",
		"rig_device_drill",
		"rig_device_orescanner",
		"rig_component_material",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_4_POINTS)
	required_experiments = list(/datum/experiment/scanning/points/basic_min_rig)
	announce_channels = list(CHANNEL_SCIENCE, CHANNEL_SUPPLY)
