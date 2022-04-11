/datum/job/bartender
	pto_type = PTO_CIVILIAN
	alt_titles = list("Barkeeper" = /datum/alt_title/barkeeper, "Barmaid" = /datum/alt_title/barmaid, "Barista" = /datum/alt_title/barista, "Mixologist" = /datum/alt_title/mixologist)

/datum/alt_title/barkeeper
	title = "Barkeeper"

/datum/alt_title/barmaid
	title = "Barmaid"

/datum/alt_title/mixologist
	title = "Mixologist"


/datum/job/chef
	total_positions = 2 //IT TAKES A LOT TO MAKE A STEW
	spawn_positions = 2 //A PINCH OF SALT AND LAUGHTER, TOO
	pto_type = PTO_CIVILIAN
	alt_titles = list("Sous-chef" = /datum/alt_title/souschef,"Cook" = /datum/alt_title/cook, "Kitchen Worker" = /datum/alt_title/kitchen_worker)

/datum/alt_title/souschef
	title = "Sous-chef"

/datum/alt_title/kitchen_worker
	title = "Kitchen Worker"
	title_blurb = "A Kitchen Worker has the same duties, though they may be less experienced."


/datum/job/hydro
	spawn_positions = 2
	pto_type = PTO_CIVILIAN
	alt_titles = list("Hydroponicist" = /datum/alt_title/hydroponicist, "Cultivator" = /datum/alt_title/cultivator, "Farmer" = /datum/alt_title/farmer,
						"Gardener" = /datum/alt_title/gardener, "Florist" = /datum/alt_title/florsit)

/datum/alt_title/hydroponicist
	title = "Hydroponicist"

/datum/alt_title/cultivator
	title = "Cultivator"

/datum/alt_title/farmer
	title = "Farmer"

/datum/alt_title/florsit
	title = "Florist"
	title_blurb = "A Florist may be less professional than their counterparts, and are more likely to tend to the public gardens if they aren't needed elsewhere."


/datum/job/qm
	pto_type = PTO_CARGO
	dept_time_required = 20
	alt_titles = list("Supply Chief" = /datum/alt_title/supply_chief, "Logistics Manager" = /datum/alt_title/logistics_manager, "Cargo Supervisor" = /datum/alt_title/cargo_supervisor)

/datum/alt_title/logistics_manager
	title = "Logistics Manager"

/datum/alt_title/cargo_supervisor
	title = "Cargo Supervisor"


/datum/job/cargo_tech
	total_positions = 3
	spawn_positions = 3
	pto_type = PTO_CARGO
	alt_titles = list("Cargo Loader" = /datum/alt_title/cargo_loader, "Cargo Handler" = /datum/alt_title/cargo_handler, "Supply Courier" = /datum/alt_title/supply_courier,
					"Disposals Sorter" = /datum/alt_title/disposal_sorter)

/datum/alt_title/supply_courier
	title = "Supply Courier"
	title_blurb = "A Supply Courier is usually tasked with devlivering packages or cargo directly to whoever requires it."

/datum/alt_title/cargo_loader
	title = "Cargo Loader"
	title_blurb = "A Cargo Loader is usually tasked with more menial labor within Supply department, such as loading and unloading supply shuttle."

/datum/alt_title/cargo_handler
	title = "Cargo Handler"
	title_blurb = "A Cargo Loader is usually tasked with more menial labor within Supply department, such as loading and unloading supply shuttle."

/datum/alt_title/disposal_sorter
	title = "Disposals Sorter"
	title_blurb = "A Disposals Sorter is usually tasked with operating disposals delivery system, sorting the trash and tagging parcels for delivery."


/datum/job/mining
	total_positions = 4
	spawn_positions = 4
	pto_type = PTO_CARGO
	alt_titles = list("Deep Space Miner" = /datum/alt_title/deep_space_miner, "Drill Technician" = /datum/alt_title/drill_tech, "Prospector" = /datum/alt_title/prospector,
						"Excavator" = /datum/alt_title/excavator)

/datum/alt_title/deep_space_miner
	title = "Deep Space Miner"
	title_blurb = "A Deep Space Miner specializes primarily in mining operations in zero-g environments, mostly in asteroid and debris fields."

/datum/alt_title/prospector
	title = "Prospector"

/datum/alt_title/excavator
	title = "Excavator"


/datum/job/janitor //Lots of janitor substations on station.
	total_positions = 3
	spawn_positions = 3
	pto_type = PTO_CIVILIAN
	alt_titles = list("Custodian" = /datum/alt_title/custodian, "Sanitation Technician" = /datum/alt_title/sanitation_tech,
					"Maid" = /datum/alt_title/maid, "Garbage Collector" = /datum/alt_title/garbage_collector)

/datum/alt_title/sanitation_tech
	title = "Sanitation Technician"

/datum/alt_title/maid
	title = "Maid"

/datum/alt_title/garbage_collector
	title = "Garbage Collector"
	title_blurb = "A Garbage Collector keeps the station clean, though focuses moreso on collecting larger trash, with wet cleaning being secondary task."


/datum/job/librarian
	total_positions = 2
	spawn_positions = 2
	alt_titles = list("Journalist" = /datum/alt_title/journalist, "Reporter" =  /datum/alt_title/reporter, "Writer" = /datum/alt_title/writer,
					"Historian" = /datum/alt_title/historian, "Archivist" = /datum/alt_title/archivist, "Professor" = /datum/alt_title/professor,
					"Academic" = /datum/alt_title/academic, "Philosopher" = /datum/alt_title/philosopher, "Curator" = /datum/alt_title/curator)
	pto_type = PTO_CIVILIAN

/datum/alt_title/reporter
	title = "Reporter"
	title_blurb = "The Reporter uses the Library as a base of operations, from which they can report the news and goings-on on the station with their camera."

/datum/alt_title/historian
	title = "Historian"
	title_blurb = "The Historian uses the Library as a base of operation to record any important events occuring on station."

/datum/alt_title/archivist
	title = "Archivist"
	title_blurb = "The Archivist uses the Library as a base of operation to record any important events occuring on station."

/datum/alt_title/professor
	title = "Professor"
	title_blurb = "The Professor uses the Library as a base of operations to share their vast knowledge with the crew."

/datum/alt_title/academic
	title = "Academic"
	title_blurb = "The Academic uses the Library as a base of operations to share their vast knowledge with the crew."

/datum/alt_title/philosopher
	title = "Philosopher"
	title_blurb = "The Philosopher uses the Library as a base of operation to ruminate on nature of life and other great questions, and share their opinions with the crew."

/datum/alt_title/curator
	title = "Curator"
	title_blurb = "The Curator uses the Library as a base of operation to gather the finest of art for display and preservation."

/datum/job/lawyer
	disallow_jobhop = TRUE
	pto_type = PTO_CIVILIAN
	alt_titles = list("Internal Affairs Liaison" = /datum/alt_title/ia_liaison, "Internal Affairs Delegate" = /datum/alt_title/ia_delegate,
						"Internal Affairs Investigator" = /datum/alt_title/ia_investigator)

/datum/alt_title/ia_liaison
	title = "Internal Affairs Liaison"

/datum/alt_title/ia_delegate
	title = "Internal Affairs Delegate"

/datum/alt_title/ia_investigator
	title = "Internal Affairs Investigator"


/datum/job/chaplain
	pto_type = PTO_CIVILIAN
	alt_titles = list("Missionary" = /datum/alt_title/missionary, "Preacher" = /datum/alt_title/preacher, "Priest" = /datum/alt_title/priest,
						"Nun" = /datum/alt_title/nun, "Monk" = /datum/alt_title/monk, "Counselor" = /datum/alt_title/counselor,
						"Guru" = /datum/alt_title/guru)

/datum/alt_title/guru
	title = "Guru"
	title_blurb = "The Guru primarily tries to offer spiritual guidance to those who come seeking it."

/datum/alt_title/missionary
	title = "Missionary"

/datum/alt_title/preacher
	title = "Preacher"

/datum/alt_title/priest
	title = "Priest"

/datum/alt_title/nun
	title = "Nun"

/datum/alt_title/monk
	title = "Monk"


//////////////////////////////////
//		      	Pilot
//////////////////////////////////

/datum/job/pilot
	title = "Pilot"
	flag = PILOT
	departments = list(DEPARTMENT_CIVILIAN)
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 5
	spawn_positions = 5
	supervisors = "the Head of Personnel"
	selection_color = "#515151"
	economic_modifier = 5
	minimal_player_age = 3
	pto_type = PTO_CIVILIAN
	access = list(access_eva, access_maint_tunnels, access_external_airlocks, access_pilot)
	minimal_access = list(access_eva, access_maint_tunnels, access_external_airlocks, access_pilot)
	outfit_type = /decl/hierarchy/outfit/job/pilot
	job_description = "A Pilot flies the various shuttles in the Virgo-Erigone System."
	alt_titles = list("Co-Pilot" = /datum/alt_title/co_pilot, "Navigator" = /datum/alt_title/navigator, "Helmsman" = /datum/alt_title/helmsman)

/datum/alt_title/co_pilot
	title = "Co-Pilot"
	title_blurb = "A Co-Pilot is there primarily to assist main pilot as well as learn from them"

/datum/alt_title/navigator
	title = "Navigator"

/datum/alt_title/helmsman
	title = "Helmsman"

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

	outfit_type = /decl/hierarchy/outfit/job/assistant/entertainer
	job_description = "An entertainer does just that, entertains! Put on plays, play music, sing songs, tell stories, or read your favorite fanfic."
	alt_titles = list("Performer" = /datum/alt_title/performer, "Musician" = /datum/alt_title/musician, "Stagehand" = /datum/alt_title/stagehand,
						"Actor" = /datum/alt_title/actor, "Dancer" = /datum/alt_title/dancer, "Singer" = /datum/alt_title/singer,
						"Magician" = /datum/alt_title/magician, "Comedian" = /datum/alt_title/comedian, "Tragedian" = /datum/alt_title/tragedian,
						"Artist" = /datum/alt_title/artist)

// Entertainer Alt Titles
/datum/alt_title/actor
	title = "Actor"
	title_blurb = "An Actor is someone who acts out a role! Whatever sort of character it is, get into it and impress people with power of comedy and tragedy!"

/datum/alt_title/performer
	title = "Performer"
	title_blurb = "A Performer is someone who performs! Whatever sort of performance will come to your mind, the world's a stage!"

/datum/alt_title/musician
	title = "Musician"
	title_blurb = "A Musician is someone who makes music with a wide variety of musical instruments!"

/datum/alt_title/stagehand
	title = "Stagehand"
	title_blurb = "A Stagehand typically performs everything the rest of the entertainers don't. Operate lights, shutters, windows, or narrate through your voicebox!"

/datum/alt_title/dancer
	title = "Dancer"
	title_blurb = "A Dancer is someone who impresses people through power of their own body! From waltz to breakdance, as long as crowd as cheering!"

/datum/alt_title/singer
	title = "Singer"
	title_blurb = "A Singer is someone with gift of melodious voice! Impress people with your vocal range!"

/datum/alt_title/magician
	title = "Magician"
	title_blurb = "A Magician is someone who awes those around them with impossible! Show off your repertoire of magic tricks, while keeping the secret hidden!"

/datum/alt_title/comedian
	title = "Comedian"
	title_blurb = "A Comedian will focus on making people laugh with the power of wit! Telling jokes, stand-up comedy, you are here to make others smile!"

/datum/alt_title/tragedian
	title = "Tragedian"
	title_blurb = "A Tragedian will focus on making people think about life and world around them! Life is a tragedy, and who's better to convey its emotions than you?"

/datum/alt_title/artist
	title = "Artist"
	title_blurb = "An Artist's calling is to create beautiful arts! Whatever form may they take, create and have people astonished with your creativity."
