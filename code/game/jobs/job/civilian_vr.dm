/datum/job/bartender
	pto_type = PTO_CIVILIAN
	alt_titles = list(JOB_ALT_BARKEEPR = /datum/alt_title/barkeeper, JOB_ALT_BARMAID = /datum/alt_title/barmaid, JOB_ALT_BARISTA = /datum/alt_title/barista, JOB_ALT_MIXOLOGIST = /datum/alt_title/mixologist)

/datum/alt_title/barkeeper
	title = JOB_ALT_BARKEEPR

/datum/alt_title/barmaid
	title = JOB_ALT_BARMAID

/datum/alt_title/mixologist
	title = JOB_ALT_MIXOLOGIST


/datum/job/chef
	total_positions = 2 //IT TAKES A LOT TO MAKE A STEW
	spawn_positions = 2 //A PINCH OF SALT AND LAUGHTER, TOO
	pto_type = PTO_CIVILIAN
	alt_titles = list(JOB_ALT_SOUSCHEF = /datum/alt_title/souschef, JOB_ALT_COOK = /datum/alt_title/cook, JOB_ALT_KITCHEN_WORKER = /datum/alt_title/kitchen_worker)

/datum/alt_title/souschef
	title = JOB_ALT_SOUSCHEF

/datum/alt_title/kitchen_worker
	title = JOB_ALT_KITCHEN_WORKER
	title_blurb = "A " + JOB_ALT_KITCHEN_WORKER + " has the same duties, though they may be less experienced."


/datum/job/hydro
	spawn_positions = 2
	pto_type = PTO_CIVILIAN
	alt_titles = list(JOB_ALT_HYDROPONICIST = /datum/alt_title/hydroponicist, JOB_ALT_CULTIVATOR = /datum/alt_title/cultivator, JOB_ALT_FARMER = /datum/alt_title/farmer,
						JOB_ALT_GARDENER = /datum/alt_title/gardener, JOB_ALT_FLORIST = /datum/alt_title/florsit, JOB_ALT_RANCHER = /datum/alt_title/rancher)

/datum/alt_title/hydroponicist
	title = JOB_ALT_HYDROPONICIST

/datum/alt_title/cultivator
	title = JOB_ALT_CULTIVATOR

/datum/alt_title/farmer
	title = JOB_ALT_FARMER

/datum/alt_title/florsit
	title = JOB_ALT_FLORIST
	title_blurb = "A " + JOB_ALT_FLORIST + " may be less professional than their counterparts, and are more likely to tend to the public gardens if they aren't needed elsewhere."

/datum/alt_title/rancher
	title = JOB_ALT_RANCHER
	title_blurb = "A " + JOB_ALT_RANCHER + " is tasked with the care, feeding, raising, and harvesting of livestock."


/datum/job/qm
	pto_type = PTO_CARGO
	dept_time_required = 20
	alt_titles = list(JOB_ALT_SUPPLY_CHIEF = /datum/alt_title/supply_chief, JOB_ALT_LOGISTICS_MANAGER = /datum/alt_title/logistics_manager, JOB_ALT_CARGO_SUPERVISOR = /datum/alt_title/cargo_supervisor)

/datum/alt_title/logistics_manager
	title = JOB_ALT_LOGISTICS_MANAGER

/datum/alt_title/cargo_supervisor
	title = JOB_ALT_CARGO_SUPERVISOR

/datum/job/qm/get_request_reasons()
	return list("Training crew")


/datum/job/cargo_tech
	total_positions = 3
	spawn_positions = 3
	pto_type = PTO_CARGO
	alt_titles = list(JOB_ALT_CARGO_LOADER = /datum/alt_title/cargo_loader, JOB_ALT_CARGO_HANDLER = /datum/alt_title/cargo_handler, JOB_ALT_SUPPLY_COURIER = /datum/alt_title/supply_courier,
					JOB_ALT_DISPOSALS_SORTER = /datum/alt_title/disposal_sorter)

/datum/alt_title/supply_courier
	title = JOB_ALT_SUPPLY_COURIER
	title_blurb = "A " + JOB_ALT_SUPPLY_COURIER + " is usually tasked with devlivering packages or cargo directly to whoever requires it."

/datum/alt_title/cargo_loader
	title = JOB_ALT_CARGO_LOADER
	title_blurb = "A " + JOB_ALT_CARGO_LOADER + " is usually tasked with more menial labor within Supply department, such as loading and unloading supply shuttle."

/datum/alt_title/cargo_handler
	title = JOB_ALT_CARGO_HANDLER
	title_blurb = "A " + JOB_ALT_CARGO_HANDLER + " is usually tasked with more menial labor within Supply department, such as loading and unloading supply shuttle."

/datum/alt_title/disposal_sorter
	title = JOB_ALT_DISPOSALS_SORTER
	title_blurb = "A " + JOB_ALT_DISPOSALS_SORTER + " is usually tasked with operating disposals delivery system, sorting the trash and tagging parcels for delivery."


/datum/job/mining
	total_positions = 4
	spawn_positions = 4
	pto_type = PTO_CARGO
	alt_titles = list(JOB_ALT_DEEP_SPACE_MINER = /datum/alt_title/deep_space_miner, JOB_ALT_DRILL_TECHNICIAN = /datum/alt_title/drill_tech, JOB_ALT_PROSPECTOR = /datum/alt_title/prospector,
						JOB_ALT_EXCAVATOR = /datum/alt_title/excavator)

/datum/alt_title/deep_space_miner
	title = JOB_ALT_DEEP_SPACE_MINER
	title_blurb = "A " + JOB_ALT_DEEP_SPACE_MINER + " specializes primarily in mining operations in zero-g environments, mostly in asteroid and debris fields."

/datum/alt_title/prospector
	title = JOB_ALT_PROSPECTOR

/datum/alt_title/excavator
	title = JOB_ALT_EXCAVATOR

/datum/job/mining/get_request_reasons()
	return list("Assembling expedition team")


/datum/job/janitor //Lots of janitor substations on station.
	total_positions = 3
	spawn_positions = 3
	pto_type = PTO_CIVILIAN
	alt_titles = list(JOB_ALT_CUSTODIAN = /datum/alt_title/custodian, JOB_ALT_SANITATION_TECHNICIAN = /datum/alt_title/sanitation_tech,
					JOB_ALT_MAID = /datum/alt_title/maid, JOB_ALT_GARBAGE_COLLECTOR = /datum/alt_title/garbage_collector)

/datum/alt_title/sanitation_tech
	title = JOB_ALT_SANITATION_TECHNICIAN

/datum/alt_title/maid
	title = JOB_ALT_MAID

/datum/alt_title/garbage_collector
	title = JOB_ALT_GARBAGE_COLLECTOR
	title_blurb = "A " + JOB_ALT_GARBAGE_COLLECTOR + " keeps the station clean, though focuses moreso on collecting larger trash, with wet cleaning being secondary task."


/datum/job/librarian
	total_positions = 2
	spawn_positions = 2
	alt_titles = list(JOB_ALT_JOURNALIST = /datum/alt_title/journalist, JOB_ALT_REPORTER =  /datum/alt_title/reporter, JOB_ALT_WRITER = /datum/alt_title/writer,
					JOB_ALT_HISTORIAN = /datum/alt_title/historian, JOB_ALT_ARCHIVIST = /datum/alt_title/archivist, JOB_ALT_PROFESSOR = /datum/alt_title/professor,
					JOB_ALT_ACADEMIC = /datum/alt_title/academic, JOB_ALT_PHILOSOPHER = /datum/alt_title/philosopher, JOB_ALT_CURATOR = /datum/alt_title/curator)
	pto_type = PTO_CIVILIAN

/datum/alt_title/reporter
	title = JOB_ALT_REPORTER
	title_blurb = "The " + JOB_ALT_REPORTER + " uses the Library as a base of operations, from which they can report the news and goings-on on the station with their camera."

/datum/alt_title/historian
	title = JOB_ALT_HISTORIAN
	title_blurb = "The " + JOB_ALT_HISTORIAN + " uses the Library as a base of operation to record any important events occurring on station."

/datum/alt_title/archivist
	title = JOB_ALT_ARCHIVIST
	title_blurb = "The " + JOB_ALT_ARCHIVIST + " uses the Library as a base of operation to record any important events occurring on station."

/datum/alt_title/professor
	title = JOB_ALT_PROFESSOR
	title_blurb = "The " + JOB_ALT_PROFESSOR + " uses the Library as a base of operations to share their vast knowledge with the crew."

/datum/alt_title/academic
	title = JOB_ALT_ACADEMIC
	title_blurb = "The " + JOB_ALT_ACADEMIC + " uses the Library as a base of operations to share their vast knowledge with the crew."

/datum/alt_title/philosopher
	title = JOB_ALT_PHILOSOPHER
	title_blurb = "The " + JOB_ALT_PHILOSOPHER + " uses the Library as a base of operation to ruminate on nature of life and other great questions, and share their opinions with the crew."

/datum/alt_title/curator
	title = JOB_ALT_CURATOR
	title_blurb = "The " + JOB_ALT_CURATOR + " uses the Library as a base of operation to gather the finest of art for display and preservation."

/datum/job/lawyer
	disallow_jobhop = TRUE
	pto_type = PTO_CIVILIAN
	alt_titles = list(JOB_ALT_INTERNAL_AFFAIRS_LIAISON = /datum/alt_title/ia_liaison, JOB_ALT_INTERNAL_AFFAIRS_DELEGATE = /datum/alt_title/ia_delegate,
						JOB_ALT_INTERNAL_AFFAIRS_INVESTIGATOR = /datum/alt_title/ia_investigator)

/datum/alt_title/ia_liaison
	title = JOB_ALT_INTERNAL_AFFAIRS_LIAISON

/datum/alt_title/ia_delegate
	title = JOB_ALT_INTERNAL_AFFAIRS_DELEGATE

/datum/alt_title/ia_investigator
	title = JOB_ALT_INTERNAL_AFFAIRS_INVESTIGATOR


/datum/job/chaplain
	pto_type = PTO_CIVILIAN
	alt_titles = list(JOB_ALT_MISSIONARY = /datum/alt_title/missionary, JOB_ALT_PREACHER = /datum/alt_title/preacher, JOB_ALT_PRIEST = /datum/alt_title/priest,
						JOB_ALT_NUN = /datum/alt_title/nun, JOB_ALT_MONK = /datum/alt_title/monk, JOB_ALT_COUNSELOR = /datum/alt_title/counselor,
						JOB_ALT_GURU = /datum/alt_title/guru)

/datum/alt_title/guru
	title = JOB_ALT_GURU
	title_blurb = "The " + JOB_ALT_GURU + " primarily tries to offer spiritual guidance to those who come seeking it."

/datum/alt_title/missionary
	title = JOB_ALT_MISSIONARY

/datum/alt_title/preacher
	title = JOB_ALT_PREACHER

/datum/alt_title/priest
	title = JOB_ALT_PRIEST

/datum/alt_title/nun
	title = JOB_ALT_NUN

/datum/alt_title/monk
	title = JOB_ALT_MONK


//////////////////////////////////
//		      	Pilot
//////////////////////////////////

/datum/job/pilot
	title = JOB_PILOT
	flag = PILOT
	departments = list(DEPARTMENT_CIVILIAN)
	department_flag = CIVILIAN
	faction = FACTION_STATION
	total_positions = 2
	spawn_positions = 2
	supervisors = "the " + JOB_HEAD_OF_PERSONNEL
	selection_color = "#515151"
	economic_modifier = 5
	minimal_player_age = 3
	pto_type = PTO_CIVILIAN
	access = list(access_eva, access_maint_tunnels, access_external_airlocks, access_pilot)
	minimal_access = list(access_eva, access_maint_tunnels, access_external_airlocks, access_pilot)
	outfit_type = /decl/hierarchy/outfit/job/pilot
	job_description = "A " + JOB_PILOT + " flies the various shuttles in the Virgo-Erigone System."
	alt_titles = list(JOB_ALT_COPILOT = /datum/alt_title/co_pilot, JOB_ALT_NAVIGATOR = /datum/alt_title/navigator, JOB_ALT_HELMSMAN = /datum/alt_title/helmsman)

/datum/alt_title/co_pilot
	title = JOB_ALT_COPILOT
	title_blurb = "A Co-" + JOB_ALT_COPILOT + " is there primarily to assist main pilot as well as learn from them"

/datum/alt_title/navigator
	title = JOB_ALT_NAVIGATOR

/datum/alt_title/helmsman
	title = JOB_ALT_HELMSMAN

/datum/job/pilot/get_request_reasons()
	return list("Assembling expedition team")

//////////////////////////////////
//			Entertainer
//////////////////////////////////

/datum/job/entertainer
	title = JOB_ENTERTAINER
	flag = ENTERTAINER
	departments = list(DEPARTMENT_CIVILIAN)
	department_flag = CIVILIAN
	faction = FACTION_STATION
	total_positions = 4
	spawn_positions = 4
	supervisors = "the " + JOB_HEAD_OF_PERSONNEL
	selection_color = "#515151"
	access = list(access_entertainment)
	minimal_access = list(access_entertainment)
	pto_type = PTO_CIVILIAN

	outfit_type = /decl/hierarchy/outfit/job/assistant/entertainer
	job_description = "An " + JOB_ENTERTAINER + " does just that, entertains! Put on plays, play music, sing songs, tell stories, or read your favorite fanfic."
	alt_titles = list(JOB_ALT_PERFORMER = /datum/alt_title/performer, JOB_ALT_MUSICIAN = /datum/alt_title/musician, JOB_ALT_STAGEHAND = /datum/alt_title/stagehand,
						JOB_ALT_ACTOR = /datum/alt_title/actor, JOB_ALT_DANCER = /datum/alt_title/dancer, JOB_ALT_SINGER = /datum/alt_title/singer,
						JOB_ALT_MAGICIAN = /datum/alt_title/magician, JOB_ALT_COMEDIAN = /datum/alt_title/comedian, JOB_ALT_ARTIST = /datum/alt_title/tragedian,
						JOB_ALT_ARTIST = /datum/alt_title/artist, JOB_ALT_GAME_MASTER = /datum/alt_title/game_master)

// Entertainer Alt Titles
/datum/alt_title/actor
	title = JOB_ALT_ACTOR
	title_blurb = "An " + JOB_ALT_ACTOR + " is someone who acts out a role! Whatever sort of character it is, get into it and impress people with power of comedy and tragedy!"

/datum/alt_title/performer
	title = JOB_ALT_PERFORMER
	title_blurb = "A " + JOB_ALT_PERFORMER + " is someone who performs! Whatever sort of performance will come to your mind, the world's a stage!"

/datum/alt_title/musician
	title = JOB_ALT_MUSICIAN
	title_blurb = "A " + JOB_ALT_MUSICIAN + " is someone who makes music with a wide variety of musical instruments!"

/datum/alt_title/stagehand
	title = JOB_ALT_STAGEHAND
	title_blurb = "A " + JOB_ALT_STAGEHAND + " typically performs everything the rest of the entertainers don't. Operate lights, shutters, windows, or narrate through your voicebox!"

/datum/alt_title/dancer
	title = JOB_ALT_DANCER
	title_blurb = "A " + JOB_ALT_DANCER + " is someone who impresses people through power of their own body! From waltz to breakdance, as long as crowd as cheering!"

/datum/alt_title/singer
	title = JOB_ALT_SINGER
	title_blurb = "A " + JOB_ALT_SINGER + " is someone with gift of melodious voice! Impress people with your vocal range!"

/datum/alt_title/magician
	title = JOB_ALT_MAGICIAN
	title_blurb = "A " + JOB_ALT_MAGICIAN + " is someone who awes those around them with impossible! Show off your repertoire of magic tricks, while keeping the secret hidden!"

/datum/alt_title/comedian
	title = JOB_ALT_COMEDIAN
	title_blurb = "A " + JOB_ALT_COMEDIAN + " will focus on making people laugh with the power of wit! Telling jokes, stand-up comedy, you are here to make others smile!"

/datum/alt_title/tragedian
	title = JOB_ALT_ARTIST
	title_blurb = "A " + JOB_ALT_ARTIST + " will focus on making people think about life and world around them! Life is a tragedy, and who's better to convey its emotions than you?"

/datum/alt_title/artist
	title = JOB_ALT_ARTIST
	title_blurb = "An " + JOB_ALT_ARTIST + "'s calling is to create beautiful arts! Whatever form may they take, create and have people astonished with your creativity."

/datum/alt_title/game_master
	title = JOB_ALT_GAME_MASTER
	title_blurb = "A " + JOB_ALT_GAME_MASTER + " provides recreation for the crew by hosting variety of games. From cards to roleplaying to something more personalized."

//////////////////////////////////
//			Entrepreneur
//////////////////////////////////

/datum/job/entrepreneur
	title = JOB_ENTREPRENEUR
	flag = ENTREPRENEUR
	departments = list(DEPARTMENT_CIVILIAN)
	department_flag = CIVILIAN
	faction = FACTION_STATION
	total_positions = 4
	spawn_positions = 4
	supervisors = "the " + JOB_HEAD_OF_PERSONNEL
	selection_color = "#515151"
	access = list()
	minimal_access = list()
	pto_type = PTO_CIVILIAN

	outfit_type = /decl/hierarchy/outfit/job/assistant/entrepreneur
	job_description = "An " + JOB_ENTREPRENEUR + " is basically a visitor that obtained special permission to offer personal services to people on station. \
						They will offer people these services and, potentially, even demand payment!"
	alt_titles = list(JOB_ALT_LAWYER = /datum/alt_title/lawyer, JOB_ALT_PRIVATE_EYE = /datum/alt_title/private_eye, JOB_ALT_BODYGUARD = /datum/alt_title/bodyguard,
						JOB_ALT_PERSONAL_PHYSICIAN = /datum/alt_title/personal_physician, JOB_ALT_DENTIST = /datum/alt_title/dentist, JOB_ALT_FITNESS_INSTRUCTOR = /datum/alt_title/fitness_instructor,
						JOB_ALT_YOGA_TEACHER = /datum/alt_title/yoga_teacher, JOB_ALT_MASSEUSE = /datum/alt_title/masseuse, JOB_ALT_TRADESPERSON = /datum/alt_title/tradesperson,
						JOB_ALT_STREAMER = /datum/alt_title/streamer, JOB_ALT_INFLUENCER = /datum/alt_title/influencer, JOB_ALT_PARANORMAL_INVESTIGATOR = /datum/alt_title/paranormal_investigator,
						JOB_ALT_PERSONAL_SECRETARY = /datum/alt_title/personal_secretary, JOB_ALT_STYLIST = /datum/alt_title/stylist, JOB_ALT_FISHER = /datum/alt_title/fisher,
						JOB_ALT_FORTUNE_TELLER = /datum/alt_title/fortune_teller, JOB_ALT_SPIRIT_HEALER = /datum/alt_title/spirit_healer)

/datum/alt_title/lawyer
	title = JOB_ALT_LAWYER
	title_blurb = "A " + JOB_ALT_LAWYER + " is knowledgable in various legal systems, including station's operations. They can try to offer their legal counsel, although nobody is really obliged to listen."
	title_outfit = /decl/hierarchy/outfit/job/assistant/entrepreneur/personal_secretary

/datum/alt_title/private_eye
	title = JOB_ALT_PRIVATE_EYE
	title_blurb = "A " + JOB_ALT_PRIVATE_EYE + " is a detective that has no credentials or equipment. But if someone wants something found without security's knowledge, they are the one to go to."
	title_outfit = /decl/hierarchy/outfit/job/assistant/entrepreneur/private_eye

/datum/alt_title/bodyguard
	title = JOB_ALT_BODYGUARD
	title_blurb = "A " + JOB_ALT_BODYGUARD + " offers service of personal protection. They may not be allowed any weapons, but their own body is weapon enough."
	title_outfit = /decl/hierarchy/outfit/job/assistant/entrepreneur/bodyguard

/datum/alt_title/personal_physician
	title = JOB_ALT_PERSONAL_PHYSICIAN
	title_blurb = "A " + JOB_ALT_PERSONAL_PHYSICIAN + " is a doctor dedicated less to Hippocratic Oath and more to the moneymaking grind. Their license may be expired, but the grindset never will be."
	title_outfit = /decl/hierarchy/outfit/job/assistant/entrepreneur/personal_physician

/datum/alt_title/dentist
	title = JOB_ALT_DENTIST
	title_blurb = "A " + JOB_ALT_DENTIST + " is a doctor that specializes in oral care. Company may not recognize them as a proper doctor, but surely their customers will."
	title_outfit = /decl/hierarchy/outfit/job/assistant/entrepreneur/dentist

/datum/alt_title/fitness_instructor
	title = JOB_ALT_FITNESS_INSTRUCTOR
	title_blurb = "A " + JOB_ALT_FITNESS_INSTRUCTOR + " dedicates themselves to improving the health of the crew through physical activity, and boy, do they need the help."
	title_outfit = /decl/hierarchy/outfit/job/assistant/entrepreneur/fitness_instructor

/datum/alt_title/yoga_teacher
	title = JOB_ALT_YOGA_TEACHER
	title_blurb = "A " + JOB_ALT_YOGA_TEACHER + " is similar to a fitness instructor, but rather than turning the round bodies into firm ones, they focus on helping people find balance and harmony."
	title_outfit = /decl/hierarchy/outfit/job/assistant/entrepreneur/yoga_teacher

/datum/alt_title/masseuse
	title = JOB_ALT_MASSEUSE
	title_blurb = "A " + JOB_ALT_MASSEUSE + " is master of physical therapy and working others' bodies with their hands."
	title_outfit = /decl/hierarchy/outfit/job/assistant/entrepreneur/masseuse

/datum/alt_title/tradesperson
	title = JOB_ALT_TRADESPERSON
	title_blurb = "A " + JOB_ALT_TRADESPERSON + " is someone attempting to make money via the most obvious act of all - buying and selling. Now if only customs allowed you to bring your goods along..."
	title_outfit = /decl/hierarchy/outfit/job/assistant/entrepreneur/tradesperson

/datum/alt_title/streamer
	title = JOB_ALT_STREAMER
	title_blurb = "A " + JOB_ALT_STREAMER + " is here to entertain. Not the crew! Their audience across exonet!"
	title_outfit = /decl/hierarchy/outfit/job/assistant/entrepreneur/streamer

/datum/alt_title/influencer
	title = JOB_ALT_INFLUENCER
	title_blurb = "An " + JOB_ALT_INFLUENCER + " has lucked out with some exonet following, and was given permission to go onstation to provide free exposure. Don't let it go to your head."
	title_outfit = /decl/hierarchy/outfit/job/assistant/entrepreneur/influencer

/datum/alt_title/paranormal_investigator
	title = JOB_ALT_PARANORMAL_INVESTIGATOR
	title_blurb = "A " + JOB_ALT_PARANORMAL_INVESTIGATOR + " looks beyond what is accepted by modern science, and searches for the true unknown. Aliens, alternate dimensions, ghosts... The truth is out there!"
	title_outfit = /decl/hierarchy/outfit/job/assistant/entrepreneur/paranormal_investigator

/datum/alt_title/personal_secretary
	title = JOB_ALT_PERSONAL_SECRETARY
	title_blurb = "A " + JOB_ALT_PERSONAL_SECRETARY + " offers services of general assistance. Although it's doubtful anyone will ever actually need those."
	title_outfit = /decl/hierarchy/outfit/job/assistant/entrepreneur/personal_secretary

/datum/alt_title/stylist
	title = JOB_ALT_STYLIST
	title_blurb = "A " + JOB_ALT_STYLIST + " offers fashion advice, as well as helps with adjusting appearance of the crew to better suit their beauty standards."
	title_outfit = /decl/hierarchy/outfit/job/assistant/entrepreneur/stylist

/datum/alt_title/fisher
	title = JOB_ALT_FISHER
	title_blurb = "A " + JOB_ALT_FISHER + " is a capable angler, who is good at obtaining large amounts of marine goods. Whether you generously give them to station or attempt to make a quick thaler by selling, it's up to you!"
	title_outfit = /decl/hierarchy/outfit/job/assistant/entrepreneur/fisher

/datum/alt_title/fortune_teller
	title = JOB_ALT_FORTUNE_TELLER
	title_blurb = "A " + JOB_ALT_FORTUNE_TELLER + " peers into the future, and offers these visions to others. Occasionally those visions may even come true!"
	title_outfit = /decl/hierarchy/outfit/job/assistant/entrepreneur/fortune_teller

/datum/alt_title/spirit_healer
	title = JOB_ALT_SPIRIT_HEALER
	title_blurb = "A " + JOB_ALT_SPIRIT_HEALER + " offers alternative forms of medicine. Rituals, magic rocks, seances... It totally works. What's that about placebo?"
	title_outfit = /decl/hierarchy/outfit/job/assistant/entrepreneur/spirit_healer
