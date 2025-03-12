//Cargo
//////////////////////////////////
//			Quartermaster
//////////////////////////////////
/datum/job/qm
	title = JOB_QUARTERMASTER
	flag = QUARTERMASTER
	departments = list(DEPARTMENT_CARGO)
	sorting_order = 1 // QM is above the cargo techs, but below the HoP.
	departments_managed = list(DEPARTMENT_CARGO)
	department_flag = CIVILIAN
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 1
	pto_type = PTO_CARGO
	supervisors = "the " + JOB_HEAD_OF_PERSONNEL
	selection_color = "#9b633e"
	economic_modifier = 5
	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mining, access_mining_station, access_RC_announce)
	minimal_access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mining, access_mining_station, access_RC_announce)
	banned_job_species = list("digital", SPECIES_PROMETHEAN)

	ideal_character_age = 40
	dept_time_required = 20

	outfit_type = /decl/hierarchy/outfit/job/cargo/qm
	job_description = "The " + JOB_QUARTERMASTER + " manages the Supply department, checking cargo orders and ensuring supplies get to where they are needed."
	alt_titles = list(JOB_ALT_SUPPLY_CHIEF = /datum/alt_title/supply_chief, JOB_ALT_LOGISTICS_MANAGER = /datum/alt_title/logistics_manager, JOB_ALT_CARGO_SUPERVISOR = /datum/alt_title/cargo_supervisor)

/datum/job/qm/get_request_reasons()
	return list("Training crew")

// Quartermaster Alt Titles
/datum/alt_title/supply_chief
	title = JOB_ALT_SUPPLY_CHIEF

/datum/alt_title/logistics_manager
	title = JOB_ALT_LOGISTICS_MANAGER

/datum/alt_title/cargo_supervisor
	title = JOB_ALT_CARGO_SUPERVISOR

//////////////////////////////////
//			Cargo Tech
//////////////////////////////////
/datum/job/cargo_tech
	title = JOB_CARGO_TECHNICIAN
	flag = CARGOTECH
	departments = list(DEPARTMENT_CARGO)
	department_flag = CIVILIAN
	faction = FACTION_STATION
	total_positions = 3
	spawn_positions = 3
	pto_type = PTO_CARGO
	supervisors = "the " + JOB_QUARTERMASTER + " and the " + JOB_HEAD_OF_PERSONNEL
	selection_color = "#7a4f33"
	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_mining, access_mining_station)
	minimal_access = list(access_maint_tunnels, access_cargo, access_cargo_bot, access_mailsorting)

	outfit_type = /decl/hierarchy/outfit/job/cargo/cargo_tech
	job_description = "A " + JOB_CARGO_TECHNICIAN + " fills and delivers cargo orders. They are encouraged to return delivered crates to the Cargo Shuttle, \
						because Central Command gives a partial refund."

	alt_titles = list(JOB_ALT_CARGO_LOADER = /datum/alt_title/cargo_loader, JOB_ALT_CARGO_HANDLER = /datum/alt_title/cargo_handler, JOB_ALT_SUPPLY_COURIER = /datum/alt_title/supply_courier,
					JOB_ALT_DISPOSALS_SORTER = /datum/alt_title/disposal_sorter, JOB_ALT_MAILMAN = /datum/alt_title/mailman)

/datum/alt_title/supply_courier
	title = JOB_ALT_SUPPLY_COURIER
	title_blurb = "A " + JOB_ALT_SUPPLY_COURIER + " is usually tasked with delivering packages or cargo directly to whoever requires it."

/datum/alt_title/cargo_loader
	title = JOB_ALT_CARGO_LOADER
	title_blurb = "A " + JOB_ALT_CARGO_LOADER + " is usually tasked with more menial labor within Supply department, such as loading and unloading supply shuttle."

/datum/alt_title/cargo_handler
	title = JOB_ALT_CARGO_HANDLER
	title_blurb = "A " + JOB_ALT_CARGO_HANDLER + " is usually tasked with more menial labor within Supply department, such as loading and unloading supply shuttle."

/datum/alt_title/disposal_sorter
	title = JOB_ALT_DISPOSALS_SORTER
	title_blurb = "A " + JOB_ALT_DISPOSALS_SORTER + " is usually tasked with operating disposals delivery system, sorting the trash and tagging parcels for delivery."

/datum/alt_title/mailman
	title = JOB_ALT_MAILMAN
	title_blurb = "A Mail Carrier is tasked with delivering packages or mail to whoever it might adress."
	title_outfit = /decl/hierarchy/outfit/job/cargo/cargo_tech/mailman

//////////////////////////////////
//			Shaft Miner
//////////////////////////////////

/datum/job/mining
	title = JOB_SHAFT_MINER
	flag = MINER
	departments = list(DEPARTMENT_CARGO)
	department_flag = CIVILIAN
	faction = FACTION_STATION
	total_positions = 4
	spawn_positions = 4
	pto_type = PTO_CARGO
	supervisors = "the " + JOB_QUARTERMASTER + " and the " + JOB_HEAD_OF_PERSONNEL
	selection_color = "#7a4f33"
	economic_modifier = 5
	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_mining, access_mining_station)
	minimal_access = list(access_mining, access_mining_station, access_mailsorting)

	outfit_type = /decl/hierarchy/outfit/job/cargo/mining
	job_description = "A " + JOB_SHAFT_MINER + " mines and processes minerals to be delivered to departments that need them."
	alt_titles = list(JOB_ALT_DEEP_SPACE_MINER = /datum/alt_title/deep_space_miner, JOB_ALT_DRILL_TECHNICIAN = /datum/alt_title/drill_tech, JOB_ALT_PROSPECTOR = /datum/alt_title/prospector,
						JOB_ALT_EXCAVATOR = /datum/alt_title/excavator)

/datum/job/mining/get_request_reasons()
	return list("Assembling expedition team")

/datum/alt_title/drill_tech
	title = JOB_ALT_DRILL_TECHNICIAN
	title_blurb = "A " + JOB_ALT_DRILL_TECHNICIAN + " specializes in operating and maintaining the machinery needed to extract ore from veins deep below the surface."

/datum/alt_title/deep_space_miner
	title = JOB_ALT_DEEP_SPACE_MINER
	title_blurb = "A " + JOB_ALT_DEEP_SPACE_MINER + " specializes primarily in mining operations in zero-g environments, mostly in asteroid and debris fields."

/datum/alt_title/prospector
	title = JOB_ALT_PROSPECTOR

/datum/alt_title/excavator
	title = JOB_ALT_EXCAVATOR
