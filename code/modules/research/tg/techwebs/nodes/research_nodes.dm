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
		"tech_disk",
		"rdservercontrol",
		"doppler_array",
		// "experimentor",
		"destructive_analyzer",
		// "destructive_scanner",
		"artifact_harvester",
		"artifact_scanpad",
		// "laptop",
		// "portadrive_basic",
		// "portadrive_advanced",
		// "portadrive_super",
		"electropack",
	)

/datum/techweb_node/protolathe_boards
	id = TECHWEB_NODE_PROTOLATHE_BOARDS
	starting_node = TRUE
	display_name = "Protolathe Boards"
	description = "The fundamental technology required for production of more experimental protolathe boards."
	design_ids = list(
		"protolathe_science",
		"protolathe_service",
		"protolathe_medical",
		"protolathe_cargo",
		"protolathe_engineering",
		"protolathe_security",
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
		"ore_silo",
		"ore_holding",
		"sheet_holding",
		"bag_holding",
		"dufflebag_holding",
		"trashbag_holding",
		"pouch_holding",
		"belt_holding_med",
		"belt_holding_utility",
		"bluespacebeaker",
		"bsflare",
		"beacon",
		"beacon_locator",
		"chameleon",
		"shelter_capsule",
		"shelter_capsule_luxury",
		"shelter_capsule_recroom",
		"shelter_capsule_sauna",
		"shelter_capsule_luxurybar",
		"shelter_capsule_luxurycabin",
		"shelter_capsule_cafe",
		"shelter_capsule_luxuryalt",
		"shelter_capsule_kitchen",
		"shelter_capsule_pocketdorm",
		"shelter_capsule_luxuryrecroom",
		// "plumbing_receiver",
		// "adv_watering_can",
		// "bluespace_coffeepot",
		// "bluespacesyringe",
		// "light_replacer_blue",
		// "bluespacebodybag",
		// "gigabeacon",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_2_POINTS)
	discount_experiments = list(/datum/experiment/scanning/bluespace_crystal = TECHWEB_TIER_2_POINTS)
	announce_channels = list(CHANNEL_SCIENCE, CHANNEL_MEDICAL, CHANNEL_SERVICE, CHANNEL_SUPPLY)

/datum/techweb_node/bluespace_travel
	id = TECHWEB_NODE_BLUESPACE_TRAVEL
	display_name = "Bluespace Travel"
	description = "Facilitate teleportation methods based on bluespace principles to revolutionize logistical efficiency."
	prereq_ids = list(TECHWEB_NODE_APPLIED_BLUESPACE)
	design_ids = list(
		"telesci_console",
		"telesci_pad",
		"quantum_pad",
		"qpad_booster",
		"teleconsole",
		"translocator",
		"mini_translocator",
		// "tele_station",
		// "tele_hub",
		// "launchpad_console",
		// "launchpad",
		// "bluespace_pod",
		// "swapper",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
	announce_channels = list(CHANNEL_SCIENCE)

/datum/techweb_node/xenoarch
	id = TECHWEB_NODE_XENOARCHEOLOGY
	display_name = "Xenoarcheology Research"
	description = "Researching those who came before us, extracting artifacts of great value, and harnessing their powers."
	prereq_ids = list(TECHWEB_NODE_FUNDIMENTAL_SCI)
	design_ids = list(
		"ano_scanner",
		"xenoarch_multitool",
		"excavationdrill",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_2_POINTS)
	announce_channels = list(CHANNEL_SCIENCE)

/datum/techweb_node/xenobotany
	id = TECHWEB_NODE_XENOBOTANY
	display_name = "Xenobotany Research"
	description = "Researching exotic plants and the things they can be made to produce through mutation."
	prereq_ids = list(TECHWEB_NODE_FUNDIMENTAL_SCI)
	design_ids = list(
		"botany_extractor",
		"botany_editor",
		"botany_seedextractor",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_2_POINTS)
	announce_channels = list(CHANNEL_SCIENCE)

/datum/techweb_node/anomaly_research
	id = TECHWEB_NODE_ANOMALY_RESEARCH
	display_name = "Anomaly Research"
	description = "Delving into the study of mysterious anomalies to investigate methods to refine and harness their unpredictable energies."
	prereq_ids = list(TECHWEB_NODE_APPLIED_BLUESPACE)
	design_ids = list(
		"anomaly_neutralizer",
		"sci_anomaly_releaser",
		"reactive_armour",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
	announce_channels = list(CHANNEL_SCIENCE)

/datum/techweb_node/anomaly_harvesting
	id = TECHWEB_NODE_ANOMALY_HARVESTING
	display_name = "Anomaly Harvesting"
	description = "Harness the power of the mysterious anomalies, refining their energies into tangible materials."
	prereq_ids = list(TECHWEB_NODE_ANOMALY_RESEARCH)
	design_ids = list(
		"anomaly_harvester",
		"anomaly_scanner",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
	announce_channels = list(CHANNEL_SCIENCE)

/datum/techweb_node/applied_anomaly_harvesting
	id = TECHWEB_NODE_APPLIED_ANOMALY_HARVESTING
	display_name = "Applied Anomaly Harvesting"
	description = "Advanced research in the anomaly field, allowing sophisticated tools to aid in their study."
	prereq_ids = list(TECHWEB_NODE_ANOMALY_HARVESTING)
	design_ids = list(
		"anomaly_releaser",
		"anom_gun",
		"borg_anomgun_module"
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_4_POINTS)
	announce_channels = list(CHANNEL_SCIENCE)
	discount_experiments = list(/datum/experiment/scanning/points/anomaly = TECHWEB_TIER_3_POINTS)

/* Decided that we were not keen on this being able to be printed freely as we immediately saw undesirable behaviour
/datum/techweb_node/telekinetics
	id = TECHWEB_NODE_TELEKINETIC_RESEARCH
	display_name = "Applied Telekinetics Research"
	description = "Altering the physical behavior of objects to allow remote interaction and movement."
	prereq_ids = list(TECHWEB_NODE_APPLIED_BLUESPACE,TECHWEB_NODE_CYBER_IMPLANTS)
	design_ids = list(
		"tk_gloves",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_4_POINTS)
	announce_channels = list(CHANNEL_SCIENCE)
*/
