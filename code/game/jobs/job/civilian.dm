//Food

//////////////////////////////////
//			Bartender
//////////////////////////////////

/datum/job/bartender
	title = JOB_BARTENDER
	flag = BARTENDER
	departments = list(DEPARTMENT_CIVILIAN)
	department_flag = CIVILIAN
	faction = FACTION_STATION
	total_positions = 2
	spawn_positions = 2
	supervisors = "the " + JOB_HEAD_OF_PERSONNEL
	selection_color = "#515151"
	access = list(access_hydroponics, access_bar, access_kitchen)
	minimal_access = list(access_bar)

	outfit_type = /decl/hierarchy/outfit/job/service/bartender
	job_description = "A " + JOB_BARTENDER + " mixes drinks for the crew. They generally have permission to charge for drinks or deny service to unruly patrons."
	alt_titles = list(JOB_ALT_BARISTA = /datum/alt_title/barista)

// Bartender Alt Titles
/datum/alt_title/barista
	title = JOB_ALT_BARISTA
	title_blurb = "A " + JOB_ALT_BARISTA + " mans the Cafe, serving primarily non-alcoholic drinks to the crew. They generally have permission to charge for drinks \
					or deny service to unruly patrons."
	title_outfit = /decl/hierarchy/outfit/job/service/bartender/barista

//////////////////////////////////
//			   Chef
//////////////////////////////////

/datum/job/chef
	title = JOB_CHEF
	flag = CHEF
	departments = list(DEPARTMENT_CIVILIAN)
	department_flag = CIVILIAN
	faction = FACTION_STATION
	total_positions = 2
	spawn_positions = 2
	supervisors = "the "+ JOB_HEAD_OF_PERSONNEL
	selection_color = "#515151"
	access = list(access_hydroponics, access_bar, access_kitchen)
	minimal_access = list(access_kitchen)

	outfit_type = /decl/hierarchy/outfit/job/service/chef
	job_description = "A " + JOB_CHEF + " cooks food for the crew. They generally have permission to charge for food or deny service to unruly diners."
	alt_titles = list(JOB_ALT_COOK = /datum/alt_title/cook)

// Chef Alt Titles
/datum/alt_title/cook
	title = JOB_ALT_COOK
	title_blurb = "A " + JOB_ALT_COOK + " has the same duties, though they may be less experienced."

//////////////////////////////////
//			Botanist
//////////////////////////////////

/datum/job/hydro
	title = JOB_BOTANIST
	flag = BOTANIST
	departments = list(DEPARTMENT_CIVILIAN)
	department_flag = CIVILIAN
	faction = FACTION_STATION
	total_positions = 2
	spawn_positions = 2
	supervisors = "the " + JOB_HEAD_OF_PERSONNEL
	selection_color = "#515151"
	access = list(access_hydroponics, access_bar, access_kitchen)
	minimal_access = list(access_hydroponics)

	outfit_type = /decl/hierarchy/outfit/job/service/gardener
	job_description = "A " + JOB_BOTANIST+ " grows plants for the " + JOB_CHEF + " and " + JOB_BARTENDER + "."
	alt_titles = list(JOB_ALT_GARDENER = /datum/alt_title/gardener)

//Botanist Alt Titles
/datum/alt_title/gardener
	title = JOB_ALT_GARDENER
	title_blurb = "A " + JOB_ALT_GARDENER + " may be less professional than their counterparts, and are more likely to tend to the public gardens if they aren't needed elsewhere."

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
	supervisors = "the " + JOB_HEAD_OF_PERSONNEL
	selection_color = "#9b633e"
	economic_modifier = 5
	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mining, access_mining_station, access_RC_announce)
	minimal_access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mining, access_mining_station, access_RC_announce)
	banned_job_species = list("digital", SPECIES_PROMETHEAN)

	ideal_character_age = 40

	outfit_type = /decl/hierarchy/outfit/job/cargo/qm
	job_description = "The " + JOB_QUARTERMASTER + " manages the Supply department, checking cargo orders and ensuring supplies get to where they are needed."
	alt_titles = list(JOB_ALT_SUPPLY_CHIEF = /datum/alt_title/supply_chief)

// Quartermaster Alt Titles
/datum/alt_title/supply_chief
	title = JOB_ALT_SUPPLY_CHIEF

//////////////////////////////////
//			Cargo Tech
//////////////////////////////////
/datum/job/cargo_tech
	title = JOB_CARGO_TECHNICIAN
	flag = CARGOTECH
	departments = list(DEPARTMENT_CARGO)
	department_flag = CIVILIAN
	faction = FACTION_STATION
	total_positions = 2
	spawn_positions = 2
	supervisors = "the " + JOB_QUARTERMASTER + " and the " + JOB_HEAD_OF_PERSONNEL
	selection_color = "#7a4f33"
	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_mining, access_mining_station)
	minimal_access = list(access_maint_tunnels, access_cargo, access_cargo_bot, access_mailsorting)

	outfit_type = /decl/hierarchy/outfit/job/cargo/cargo_tech
	job_description = "A " + JOB_CARGO_TECHNICIAN + " fills and delivers cargo orders. They are encouraged to return delivered crates to the Cargo Shuttle, \
						because Central Command gives a partial refund."

//////////////////////////////////
//			Shaft Miner
//////////////////////////////////

/datum/job/mining
	title = JOB_SHAFT_MINER
	flag = MINER
	departments = list(DEPARTMENT_CARGO)
	department_flag = CIVILIAN
	faction = FACTION_STATION
	total_positions = 3
	spawn_positions = 3
	supervisors = "the " + JOB_QUARTERMASTER + " and the " + JOB_HEAD_OF_PERSONNEL
	selection_color = "#7a4f33"
	economic_modifier = 5
	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_mining, access_mining_station)
	minimal_access = list(access_mining, access_mining_station, access_mailsorting)

	outfit_type = /decl/hierarchy/outfit/job/cargo/mining
	job_description = "A " + JOB_SHAFT_MINER + " mines and processes minerals to be delivered to departments that need them."
	alt_titles = list(JOB_ALT_DRILL_TECHNICIAN = /datum/alt_title/drill_tech)

/datum/alt_title/drill_tech
	title = JOB_ALT_DRILL_TECHNICIAN
	title_blurb = "A " + JOB_ALT_DRILL_TECHNICIAN + " specializes in operating and maintaining the machinery needed to extract ore from veins deep below the surface."

//Service
//////////////////////////////////
//			Janitor
//////////////////////////////////
/datum/job/janitor
	title = JOB_JANITOR
	flag = JANITOR
	departments = list(DEPARTMENT_CIVILIAN)
	department_flag = CIVILIAN
	faction = FACTION_STATION
	total_positions = 2
	spawn_positions = 2
	supervisors = "the " + JOB_HEAD_OF_PERSONNEL
	selection_color = "#515151"
	access = list(access_janitor, access_maint_tunnels)
	minimal_access = list(access_janitor, access_maint_tunnels)

	outfit_type = /decl/hierarchy/outfit/job/service/janitor
	job_description = "A " + JOB_JANITOR + " keeps the station clean, as long as it doesn't interfere with active crime scenes."
	alt_titles = list(JOB_ALT_CUSTODIAN = /datum/alt_title/custodian)

// Janitor Alt Titles
/datum/alt_title/custodian
	title = JOB_ALT_CUSTODIAN

//More or less assistants
//////////////////////////////////
//			Librarian
//////////////////////////////////
/datum/job/librarian
	title = JOB_LIBRARIAN
	flag = LIBRARIAN
	departments = list(DEPARTMENT_CIVILIAN)
	department_flag = CIVILIAN
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 1
	supervisors = "the " + JOB_HEAD_OF_PERSONNEL
	selection_color = "#515151"
	access = list(access_library, access_maint_tunnels)
	minimal_access = list(access_library)

	outfit_type = /decl/hierarchy/outfit/job/librarian
	job_description = "The " + JOB_LIBRARIAN + " curates the book selection in the Library, so the crew might enjoy it."
	alt_titles = list(JOB_ALT_JOURNALIST = /datum/alt_title/journalist, JOB_ALT_WRITER = /datum/alt_title/writer)

// Librarian Alt Titles
/datum/alt_title/journalist
	title = JOB_ALT_JOURNALIST
	title_outfit = /decl/hierarchy/outfit/job/librarian/journalist
	title_blurb = "The " + JOB_ALT_JOURNALIST + " uses the Library as a base of operations, from which they can report the news and goings-on on the station with their camera."

/datum/alt_title/writer
	title = JOB_ALT_WRITER
	title_blurb = "The " + JOB_ALT_WRITER + " uses the Library as a quiet place to write whatever it is they choose to write."

//////////////////////////////////
//		Internal Affairs Agent
//////////////////////////////////

//var/global/lawyer = 0//Checks for another lawyer //This changed clothes on 2nd lawyer, both IA get the same dreds.
/datum/job/lawyer
	title = JOB_INTERNAL_AFFAIRS_AGENT
	flag = LAWYER
	departments = list(DEPARTMENT_CIVILIAN)
	department_flag = CIVILIAN
	faction = FACTION_STATION
	total_positions = 2
	spawn_positions = 2
	supervisors = "company officials and Corporate Regulations"
	selection_color = "#515151"
	economic_modifier = 7
	access = list(access_lawyer, access_sec_doors, access_maint_tunnels, access_heads)
	minimal_access = list(access_lawyer, access_sec_doors, access_heads)
	minimal_player_age = 7
	banned_job_species = list(SPECIES_PROMETHEAN, SPECIES_UNATHI, SPECIES_DIONA, SPECIES_TESHARI, SPECIES_ZADDAT, "digital")

	outfit_type = /decl/hierarchy/outfit/job/internal_affairs_agent
	job_description = "An " + JOB_INTERNAL_AFFAIRS_AGENT + " makes sure that the crew is following Standard Operating Procedure. They also \
						handle complaints against crew members, and can have issues brought to the attention of Central Command, \
						assuming their paperwork is in order."

/*
/datum/job/lawyer/equip(var/mob/living/carbon/human/H)
	. = ..()
	if(.)
		H.implant_loyalty(H)
*/
