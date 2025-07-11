
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
		// "robocontrol",
		// "borgupload",
		// "cyborgrecharger",
		// "mmi_posi",
		// "mmi",
		// "mmi_m",
		// "advanced_l_arm",
		// "advanced_r_arm",
		// "advanced_l_leg",
		// "advanced_r_leg",
		// "borg_upgrade_rename",
		// "borg_upgrade_restart",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	announce_channels = list(CHANNEL_SCIENCE)
