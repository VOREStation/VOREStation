
/datum/techweb_node/augmentation
	id = TECHWEB_NODE_AUGMENTATION
	starting_node = TRUE
	display_name = "Augmentation"
	description = "For those who prefer shiny metal over squishy flesh."
	prereq_ids = list(TECHWEB_NODE_ROBOTICS)
	design_ids = list(
		// External
		"pros_torso_m",
		"pros_torso_f",
		"pros_head",
		"pros_l_arm",
		"pros_l_hand",
		"pros_r_arm",
		"pros_r_hand",
		"pros_l_leg",
		"pros_l_foot",
		"pros_r_leg",
		"pros_r_foot",
		// Internal
		"pros_cell",
		"pros_eyes",
		"pros_hydraulic",
		"pros_reagcycler",
		"pros_heatsink",
		"pros_diagnostic",
		"pros_heart",
		"pros_lung",
		"pros_liver",
		"pros_kidney",
		"pros_spleen",
		"pros_larynx",
		"pros_stomach",
		// Robots
		"robot_exoskeleton",
		"robot_torso",
		"robot_head",
		"robot_l_arm",
		"robot_r_arm",
		"robot_l_leg",
		"robot_r_leg",
		// Robot Internals
		"binary_communication_device",
		"radio",
		"actuator",
		"diagnosis_unit",
		"camera",
		"armour",
		"platform_armour",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)

/datum/techweb_node/cybernetics
	id = TECHWEB_NODE_CYBERNETICS
	display_name = "Cybernetics"
	description = "Sapient robots with preloaded tool modules and programmable laws."
	prereq_ids = list(TECHWEB_NODE_AUGMENTATION)
	design_ids = list(
		"mmi_ai_shell",
		"borg_rename_module",
		"borg_reset_module",
		"borg_restart_module",
		"borg_sizeshift_module",
		"borg_vtec_module",
		"borg_jetpack_module",
		"dronecontrol",
		"robocontrol",
		"mmi",
		"posibrain",
		"dronebrain",
		// "cyborgrecharger",
		// "advanced_l_arm",
		// "advanced_r_arm",
		// "advanced_l_leg",
		// "advanced_r_leg",
		// "borg_upgrade_rename",
		// "borg_upgrade_restart",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	announce_channels = list(CHANNEL_SCIENCE)

// Implants root node
/datum/techweb_node/passive_implants
	id = TECHWEB_NODE_PASSIVE_IMPLANTS
	display_name = "Passive Implants"
	description = "Implants designed to operate seamlessly without active user input, enhancing various physiological functions or providing continuous benefits."
	prereq_ids = list(TECHWEB_NODE_AUGMENTATION)
	design_ids = list(
		"implant_backup",
		// "skill_station",
		// "implant_trombone",
		// "implant_chem",
		// "implant_tracking",
		// "implant_exile",
		// "implant_beacon",
		// "implant_bluespace",
		// "implantcase",
		// "implanter",
		// "locator",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	announce_channels = list(CHANNEL_SECURITY, CHANNEL_MEDICAL)

/datum/techweb_node/cyber_implants
	id = TECHWEB_NODE_CYBER_IMPLANTS
	display_name = "Cybernetic Implants"
	description = "Advanced technological enhancements integrated into the body, offering improved physical capabilities."
	prereq_ids = list(TECHWEB_NODE_PASSIVE_IMPLANTS, TECHWEB_NODE_CYBERNETICS)
	design_ids = list(
		"implant_chem",
		// "ci-breather",
		// "ci-nutriment",
		// "ci-thrusters",
		// "ci-herculean",
		// "ci-connector",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
	announce_channels = list(CHANNEL_SCIENCE, CHANNEL_MEDICAL)

/datum/techweb_node/combat_implants
	id = TECHWEB_NODE_COMBAT_IMPLANTS
	display_name = "Combat Implants"
	description = "To make sure that you can wake the f*** up, samurai."
	prereq_ids = list(TECHWEB_NODE_CYBER_IMPLANTS)
	design_ids = list(
		"implant_free",
		"blade_implant",
		"armblade_implant",
		"sword_implant",
		"dartbow_implant",
		"taser_implant",
		"laser_implant",
		"surge_implant",
		"thermal_implant",
		// "ci-reviver",
		// "ci-antidrop",
		// "ci-antistun",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_4_POINTS)
	announce_channels = list(CHANNEL_SCIENCE, CHANNEL_MEDICAL)

/datum/techweb_node/integrated_toolsets
	id = TECHWEB_NODE_INTERGRATED_TOOLSETS
	display_name = "Integrated Toolsets"
	description = "Decades of contraband smuggling by assistants have led to the development of a full toolbox that fits seamlessly into your arm."
	prereq_ids = list(TECHWEB_NODE_COMBAT_IMPLANTS, TECHWEB_NODE_EXP_TOOLS)
	design_ids = list(
		"research_implant",
		"tool_implant",
		"surgical_implant",
		// "ci-nutrimentplus",
		// "ci-toolset",
		// "ci-surgery",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_5_POINTS)
	announce_channels = list(CHANNEL_SCIENCE, CHANNEL_MEDICAL)
