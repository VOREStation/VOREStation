/datum/job/bartender
	pto_type = PTO_CIVILIAN
	alt_titles = list("Barkeeper" = /datum/alt_title/barkeeper, "Barista" = /datum/alt_title/barista, "Mixologist" = /datum/alt_title/mixologist)

/datum/alt_title/barkeeper
	title = "Barkeeper"

/datum/alt_title/mixologist
	title = "Mixologist"


/datum/job/chef
	total_positions = 2 //IT TAKES A LOT TO MAKE A STEW
	spawn_positions = 2 //A PINCH OF SALT AND LAUGHTER, TOO
	pto_type = PTO_CIVILIAN
	alt_titles = list("Cook" = /datum/alt_title/cook, "Kitchen Worker" = /datum/alt_title/kitchen_worker)

/datum/alt_title/kitchen_worker
	title = "Kitchen Worker"
	title_blurb = "A Kitchen Worker has the same duties, though they may be less experienced."


/datum/job/hydro
	spawn_positions = 2
	pto_type = PTO_CIVILIAN
	alt_titles = list("Gardener" = /datum/alt_title/gardener, "Hydroponicist" = /datum/alt_title/hydroponicist, "Farmer" = /datum/alt_title/farmer)

/datum/alt_title/hydroponicist
	title = "Hydroponicist"

/datum/alt_title/farmer
	title = "Farmer"


/datum/job/qm
	pto_type = PTO_CARGO
	dept_time_required = 20
	alt_titles = list("Supply Chief" = /datum/alt_title/supply_chief, "Logistics Manager" = /datum/alt_title/logistics_manager)

/datum/alt_title/logistics_manager
	title = "Logistics Manager"


/datum/job/cargo_tech
	total_positions = 3
	spawn_positions = 3
	pto_type = PTO_CARGO
	alt_titles = list("Supply Courier" = /datum/alt_title/supply_courier, "Cargo Loader" = /datum/alt_title/cargo_loader, "Disposals Sorter" = /datum/alt_title/disposal_sorter)

/datum/alt_title/supply_courier
	title = "Supply Courier"
	title_blurb = "A Supply Courier is usually tasked with devlivering packages or cargo directly to whoever requires it."

/datum/alt_title/cargo_loader
	title = "Cargo Loader"
	title_blurb = "A Cargo Loader is usually tasked with more menial labor within Supply department, such as loading and unloading supply shuttle."

/datum/alt_title/disposal_sorter
	title = "Disposals Sorter"
	title_blurb = "A Disposals Sorter is usually tasked with operating disposals delivery system, sorting the trash and tagging parcels for delivery."


/datum/job/mining
	total_positions = 4
	spawn_positions = 4
	pto_type = PTO_CARGO
	alt_titles = list("Drill Technician" = /datum/alt_title/drill_tech, "Deep Space Miner" = /datum/alt_title/deep_space_miner, "Prospector" = /datum/alt_title/prospector)

/datum/alt_title/deep_space_miner
	title = "Deep Space Miner"
	title_blurb = "A Deep Space Miner specializes primarily in mining operations in zero-g environments, mostly in asteroid and debris fields."

/datum/alt_title/prospector
	title = "Prospector"


/datum/job/janitor //Lots of janitor substations on station.
	total_positions = 3
	spawn_positions = 3
	alt_titles = list("Custodian" = /datum/alt_title/custodian, "Sanitation Technician" = /datum/alt_title/sanitation_tech, "Maid" = /datum/alt_title/maid)
	pto_type = PTO_CIVILIAN

/datum/alt_title/sanitation_tech
	title = "Sanitation Technician"

/datum/alt_title/maid
	title = "Maid"


/datum/job/librarian
	total_positions = 2
	spawn_positions = 2
	alt_titles = list("Journalist" = /datum/alt_title/journalist, "Writer" = /datum/alt_title/writer, "Historian" = /datum/alt_title/historian, "Professor" = /datum/alt_title/professor)
	pto_type = PTO_CIVILIAN

/datum/alt_title/historian
	title = "Historian"
	title_blurb = "The Historian uses the Library as a base of operation to record any important events occuring on station."

/datum/alt_title/professor
	title = "Professor"
	title_blurb = "The Professor uses the Library as a base of operations to share their vast knowledge with the crew."


/datum/job/lawyer
	disallow_jobhop = TRUE
	pto_type = PTO_CIVILIAN
	alt_titles = list("Internal Affairs Liaison" = /datum/alt_title/ia_liaison, "Internal Affairs Informant" = /datum/alt_title/ia_informant,
						"Internal Affairs Investigator" = /datum/alt_title/ia_investigator)

/datum/alt_title/ia_liaison
	title = "Internal Affairs Liaison"

/datum/alt_title/ia_informant
	title = "Internal Affairs Informant"

/datum/alt_title/ia_investigator
	title = "Internal Affairs Investigator"


/datum/job/chaplain
	pto_type = PTO_CIVILIAN
	alt_titles = list("Missionary" = /datum/alt_title/missionary, "Preacher" = /datum/alt_title/preacher, "Counselor" = /datum/alt_title/counselor, "Guru" = /datum/alt_title/guru)

/datum/alt_title/guru
	title = "Guru"
	title_blurb = "The Guru primarily tries to offer spiritual guidance to those who come seeking it."

/datum/alt_title/missionary
	title = "Missionary"

/datum/alt_title/preacher
	title = "Preacher"



//////////////////////////////////
//			Entertainer
//////////////////////////////////

/datum/job/entertainer
	title = "Entertainer"
	flag = ENTERTAINER
	departments = list(DEPARTMENT_CIVILIAN)
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Head of Personnel"
	selection_color = "#515151"
	access = list(access_entertainment)
	minimal_access = list(access_entertainment)
	pto_type = PTO_CIVILIAN

	outfit_type = /decl/hierarchy/outfit/job/assistant
	job_description = "An entertainer does just that, entertains! Put on plays, play music, sing songs, tell stories, or read your favorite fanfic."
	alt_titles = list("Performer" = /datum/alt_title/performer, "Musician" = /datum/alt_title/musician, "Stagehand" = /datum/alt_title/stagehand)

// Entertainer Alt Titles
/datum/alt_title/performer
	title = "Performer"
	title_blurb = "A Performer is someone who performs! Acting, dancing, wrestling, etc!"

/datum/alt_title/musician
	title = "Musician"
	title_blurb = "A Musician is someone who makes music! Singing, playing instruments, slam poetry, it's your call!"

/datum/alt_title/stagehand
	title = "Stagehand"
	title_blurb = "A Stagehand typically performs everything the rest of the entertainers don't. Operate lights, shutters, windows, or narrate through your voicebox!"