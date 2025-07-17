// Main Mecha Tree
/datum/techweb_node/mech_assembly
	id = TECHWEB_NODE_MECH_ASSEMBLY
	starting_node = TRUE
	display_name = "Exosuit Assembly"
	description = "Development of mechanical exosuits designed to contend with artificial gravity while transporting cargo."
	prereq_ids = list(TECHWEB_NODE_ROBOTICS)
	design_ids = list(
		"exo_int_hull_standard",
		"mech_recharger",
		"exo_int_armor_standard",
		"exo_int_lifesup_standard",
		"exo_int_electric_standard",
		"exo_int_actuator_standard",
		"ripley_main",
		"ripley_peri",
		"ripley_chassis",
		"ripley_torso",
		"ripley_left_arm",
		"ripley_right_arm",
		"ripley_left_leg",
		"ripley_right_leg",
		"hydraulic_clamp",
		"mech_cable_layer",
		"mech_wrench",
		"mech_crowbar",
		"mech_wirecutter",
		"mech_screwdriver",
		"mech_welder",
		"mech_inflatables",
		"mech_hardpoint_clamp",
		"mech_storage",
		"vehicle_chassis_spacebike",
		"vehicle_chassis_quadbike",
		"vehicle_chassis_snowmobile",
		"gopher_main",
		"gopher_peri",
		"gopher_chassis",
		"gopher_torso",
		"gopher_left_arm",
		"gopher_right_arm",
		"gopher_left_leg",
		"gopher_right_leg",
		"polecat_main",
		"polecat_peri",
		"polecat_targ",
		"polecat_chassis",
		"polecat_torso",
		"polecat_left_arm",
		"polecat_right_arm",
		"polecat_left_leg",
		"polecat_right_leg",
		"polecat_armour",
		"weasel_main",
		"weasel_peri",
		"weasel_targ",
		"weasel_chassis",
		"weasel_torso",
		"weasel_left_arm",
		"weasel_right_arm",
		"weasel_right_leg",
		"weasel_head",
	)

/datum/techweb_node/mech_equipment
	id = TECHWEB_NODE_MECH_EQUIPMENT
	display_name = "Expedition Equipment"
	description = "Specialized exosuit gear tailored for navigating space and celestial bodies, ensuring durability and functionality in the harshest conditions."
	prereq_ids = list(TECHWEB_NODE_MECH_ASSEMBLY)
	design_ids = list(
		"exo_int_lifesup_reinforced",
		"exo_int_electric_efficient",
		"firefighter_chassis",
		"mechacontrol",
		"mech_jetpack",
		"extinguisher",
		"mech_tracker",
		"mech_passenger",
		"mech_speedboost_ripley",
		"mech_rcd",
		"mech_phoron_generator",
		"mech_energy_relay",
		"mech_runningboard",
		"mech_generator_nuclear",
		// "mecha_camera",
		// "mech_radio",
		// "botpad",
		// "botpad_remote",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	announce_channels = list(CHANNEL_SCIENCE)

/datum/techweb_node/mech_medical
	id = TECHWEB_NODE_MECH_MEDICAL
	display_name = "Medical Exosuit"
	description = "Advanced robotic unit equipped with syringe guns and healing beams, revolutionizing medical assistance in hazardous environments."
	prereq_ids = list(TECHWEB_NODE_MECH_ASSEMBLY, TECHWEB_NODE_CHEM_SYNTHESIS)
	design_ids = list(
		"odysseus_main",
		"odysseus_peri",
		"odysseus_chassis",
		"odysseus_torso",
		"odysseus_head",
		"odysseus_left_arm",
		"odysseus_right_arm",
		"odysseus_left_leg",
		"odysseus_right_leg",
		"mech_medigun",
		"mech_syringe_gun",
		"mech_med_analyzer",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_2_POINTS)

/datum/techweb_node/mech_mining
	id = TECHWEB_NODE_MECH_MINING
	display_name = "Mining Exosuit"
	description = "Robust exosuit engineered to withstand lava and storms for continuous off-station mining operations."
	prereq_ids = list(TECHWEB_NODE_MECH_EQUIPMENT, TECHWEB_NODE_MINING)
	design_ids = list(
		"mech_drill",
		"micro_drill",
		"ore_scoop",
		"mech_diamond_drill",
		"mech_ground_drill",
		"mech_ore_scanner",
		"mech_ore_scanner_adv",
		// "clarke_chassis",
		// "clarke_torso",
		// "clarke_head",
		// "clarke_left_arm",
		// "clarke_right_arm",
		// "clarke_main",
		// "clarke_peri",
		// "mecha_kineticgun",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_2_POINTS)
	announce_channels = list(CHANNEL_SCIENCE, CHANNEL_SUPPLY)

/datum/techweb_node/mech_combat
	id = TECHWEB_NODE_MECH_COMBAT
	display_name = "Combat Exosuits"
	description = "Modular armor upgrades and specialized equipment for security exosuits."
	prereq_ids = list(TECHWEB_NODE_MECH_EQUIPMENT)
	design_ids = list(
		"exo_int_hull_durable",
		"mech_ccw_armor",
		"mech_proj_armor",
		"mech_repair_droid",
		"mech_med_droid",
		"mech_rad_droid",
		"mech_shocker",
		"mech_taser",
		"micro_taser",
		"mech_taser-r",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_2_POINTS)
	required_experiments = list(/datum/experiment/scanning/random/mecha_equipped_scan)
	announce_channels = list(CHANNEL_SCIENCE)

/datum/techweb_node/mech_assault
	id = TECHWEB_NODE_MECH_ASSAULT
	display_name = "Assault Exosuits"
	description = "Heavy battle exosuits boasting robust armor but sacrificing speed for enhanced durability."
	prereq_ids = list(TECHWEB_NODE_MECH_COMBAT)
	design_ids = list(
		"exo_int_armor_reinforced",
		"exo_int_armor_durand",
		"durand_main",
		"durand_peri",
		"durand_targ",
		"durand_chassis",
		"durand_torso",
		"durand_head",
		"durand_left_arm",
		"durand_right_arm",
		"durand_left_leg",
		"durand_right_leg",
		"durand_armour",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
	announce_channels = list(CHANNEL_SCIENCE)

/datum/techweb_node/mech_light
	id = TECHWEB_NODE_MECH_LIGHT
	display_name = "Light Combat Exosuits"
	description = "Agile combat exosuits equipped with overclocking capabilities for temporary speed boosts, prioritizing speed over durability on the battlefield."
	prereq_ids = list(TECHWEB_NODE_MECH_COMBAT)
	design_ids = list(
		"exo_int_hull_light",
		"exo_int_armor_lightweight",
		"exo_int_armor_gygax",
		"exo_int_actuator_overclock",
		"exo_int_armor_dgygax",
		"gygax_main",
		"gygax_peri",
		"gygax_targ",
		"gygax_medical",
		"serenity_chassis",
		"gygax_chassis",
		"gygax_torso",
		"gygax_head",
		"gygax_left_arm",
		"gygax_right_arm",
		"gygax_left_leg",
		"gygax_right_leg",
		"gygax_armour",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
	announce_channels = list(CHANNEL_SCIENCE)

/datum/techweb_node/mech_fighter
	id = TECHWEB_NODE_MECH_FIGHTER
	display_name = "Fighters"
	description = "Pew-pew fighter spaceships."
	prereq_ids = list(TECHWEB_NODE_MECH_LIGHT)
	design_ids = list(
		"pinnace_main",
		"pinnace_flight",
		"pinnace_targeting",
		"pinnace_cockpit_control",
		"pinnace_chassis",
		"pinnace_core",
		"pinnace_cockpit",
		"pinnace_main_engine",
		"pinnace_left_engine",
		"pinnace_right_engine",
		"pinnace_left_wing",
		"pinnace_right_wing",
		"baron_main",
		"baron_flight",
		"baron_targeting",
		"baron_cockpit_control",
		"baron_chassis",
		"baron_core",
		"baron_cockpit",
		"baron_main_engine",
		"baron_left_engine",
		"baron_right_engine",
		"baron_left_wing",
		"baron_right_wing",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_4_POINTS)
	announce_channels = list(CHANNEL_SCIENCE)

/datum/techweb_node/mech_infiltrator
	id = TECHWEB_NODE_MECH_INFILTRATOR
	display_name = "Infiltration Exosuits"
	description = "Advanced exosuit with phasing capabilities, allowing it to move through walls and obstacles, ideal for covert and special operations."
	prereq_ids = list(TECHWEB_NODE_MECH_LIGHT, TECHWEB_NODE_ANOMALY_RESEARCH)
	design_ids = list(
		"exo_int_armor_phazon",
		"janus_chassis",
		"janus_torso",
		"janus_head",
		"janus_left_arm",
		"janus_right_arm",
		"janus_left_leg",
		"janus_right_leg",
		"janus_coil",
		"janus_module",
		"mech_cloaking",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_4_POINTS)
	announce_channels = list(CHANNEL_SCIENCE)

// Mecha Equipment
/datum/techweb_node/mech_energy_guns
	id = TECHWEB_NODE_MECH_ENERGY_GUNS
	display_name = "Exosuit Energy Guns"
	description = "Scaled-up versions of electric weapons optimized for exosuit deployment."
	prereq_ids = list(TECHWEB_NODE_MECH_COMBAT, TECHWEB_NODE_ELECTRIC_WEAPONS)
	design_ids = list(
		"mech_laser",
		"micro_laser",
		"mech_laser_rigged",
		"mech_laser_heavy-r",
		"mech_laser_heavy",
		"micro_laser_heavy",
		"mech_laser_gamma",
		"mech_phase",
		"mech_ion",
		"mech_ion-r",
		"mech_laser_xray",
		"mech_laser_xray-r",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_4_POINTS)
	announce_channels = list(CHANNEL_SCIENCE)

/datum/techweb_node/mech_firearms
	id = TECHWEB_NODE_MECH_FIREARMS
	display_name = "Exosuit Firearms"
	description = "Mounted ballistic weaponry, enhancing combat capabilities for mechanized units."
	prereq_ids = list(TECHWEB_NODE_MECH_ENERGY_GUNS, TECHWEB_NODE_EXOTIC_AMMO)
	design_ids = list(
		"mech_lmg",
		"mech_lmg-r",
		"mecha_flare_gun",
		"mech_scattershot",
		"micro_scattershot",
		"mech_scattershot-r",
		"mech_flamer_full",
		"mech_flamer_rigged",
		"mech_lmg_flamer",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_5_POINTS)
	announce_channels = list(CHANNEL_SCIENCE)

/datum/techweb_node/mech_heavy_arms
	id = TECHWEB_NODE_MECH_HEAVY_ARMS
	display_name = "Heavy Exosuit Firearms"
	description = "High-impact weaponry integrated into mechs, optimized for maximum firepower."
	prereq_ids = list(TECHWEB_NODE_MECH_FIREARMS, TECHWEB_NODE_EXOTIC_AMMO)
	design_ids = list(
		"mech_grenade_launcher",
		"micro_flashbang_launcher",
		"mech_grenade_launcher-rig",
		"clusterbang_launcher",
		"mech_grenade_launcher_conc",
		"mech_grenade_launcher_frag",
		"exo_int_armor_blast",
		"exo_int_armor_marauder",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_5_POINTS)
	announce_channels = list(CHANNEL_SCIENCE)

/datum/techweb_node/mech_equip_bluespace
	id = TECHWEB_NODE_MECH_EQUIP_BLUESPACE
	display_name = "Bluespace Exosuit Equipment"
	description = "An array of equipment empowered by bluespace, providing unmatched mobility and utility."
	prereq_ids = list(TECHWEB_NODE_MECH_INFILTRATOR, TECHWEB_NODE_BLUESPACE_TRAVEL)
	design_ids = list(
		"mech_gravcatapult",
		"mech_teleporter",
		"mech_wormhole_gen",
		"mech_storage_bs",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_5_POINTS)
	announce_channels = list(CHANNEL_SCIENCE)
