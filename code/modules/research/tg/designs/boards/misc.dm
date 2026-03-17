/datum/design_techweb/board
	name = "NULL ENTRY Board"
	desc = "I promise this doesn't give you syndicate goodies!"
	build_type = IMPRINTER
	materials = DEFAULT_CIRCUIT_MATERIALS
	category = list(
		RND_CATEGORY_MACHINE
	)

/datum/design_techweb/board/arcademachine
	name = "battle arcade machine"
	desc = "Allows for the construction of circuit boards used to build a new arcade machine."
	id = "arcademachine"
	// req_tech = list(TECH_DATA = 1)
	build_path = /obj/item/circuitboard/arcade/battle
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_ENTERTAINMENT
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/oriontrail
	name = "orion trail arcade machine"
	desc = "Allows for the construction of circuit boards used to build a new arcade machine."
	id = "oriontrail"
	// req_tech = list(TECH_DATA = 1)
	build_path = /obj/item/circuitboard/arcade/orion_trail
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_ENTERTAINMENT
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/clawmachine
	name = "grab-a-gift arcade machine"
	desc = "Allows for the construction of circuit boards used to build a new arcade machine."
	id = "clawmachine"
	// req_tech = list(TECH_DATA = 1)
	build_path = /obj/item/circuitboard/arcade/clawmachine
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_ENTERTAINMENT
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/seccamera
	name = "security camera monitor"
	desc = "Allows for the construction of circuit boards used to build a security camera monitor."
	id = "seccamera"
	build_path = /obj/item/circuitboard/security
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SECURITY

/datum/design_techweb/board/engcamera
	name = "engineering camera monitor"
	desc = "Allows for the construction of circuit boards used to build a engineering camera monitor."
	id = "engcamera"
	build_path = /obj/item/circuitboard/security/engineering
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design_techweb/board/crgcamera
	name = "mining camera monitor"
	desc = "Allows for the construction of circuit boards used to build a mining camera monitor."
	id = "crgcamera"
	build_path = /obj/item/circuitboard/security/mining
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_CARGO

/datum/design_techweb/board/xenobiocamera
	name = "xenobio camera monitor"
	desc = "Allows for the construction of circuit boards used to build a xenobio camera monitor."
	id = "xenobiocamera"
	build_path = /obj/item/circuitboard/security/xenobio
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/secdata
	name = "security records console"
	desc = "Allows for the construction of circuit boards used to build a security records console."
	id = "sec_data"
	build_path = /obj/item/circuitboard/secure_data
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/prisonmanage
	name = "prisoner management console"
	desc = "Allows for the construction of circuit boards used to build a prisoner management console."
	id = "prisonmanage"
	build_path = /obj/item/circuitboard/prisoner
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/med_data
	name = "medical records console"
	desc = "Allows for the construction of circuit boards used to build a medical records console."
	id = "med_data"
	build_path = /obj/item/circuitboard/med_data
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/med_pcu
	name = "medical records PCU"
	desc = "Allows for the construction of circuit boards used to build a medical records pcu."
	id = "med_pcu"
	build_path = /obj/item/circuitboard/med_data/pcu
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

// TODO - non-pcu skill console, id = "skill_data"

/datum/design_techweb/board/skill_pcu
	name = "employment records PCU"
	desc = "Allows for the construction of circuit boards used to build a employment records pcu."
	id = "skill_pcu"
	build_path = /obj/item/circuitboard/skills/pcu
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_COMMAND
	)
	departmental_flags = DEPARTMENT_BITFLAG_COMMAND | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/operating
	name = "patient monitoring console"
	desc = "Allows for the construction of circuit boards used to build a patient monitoring console."
	id = "operating"
	build_path = /obj/item/circuitboard/operating
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/scan_console
	name = "DNA console"
	desc = "Allows for the construction of circuit boards used to build a DNA console."
	id = "scan_console"
	build_path = /obj/item/circuitboard/scan_consolenew
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/clonecontrol
	name = "cloning control console circuit"
	id = "clonecontrol"
	// req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	build_path = /obj/item/circuitboard/cloning
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/jukebox
	name = "jukebox circuit"
	id = "jukebox"
	// req_tech = list(TECH_MAGNET = 2, TECH_DATA = 1)
	build_path = /obj/item/circuitboard/jukebox
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_BAR
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/teleconsole
	name = "teleporter control console circuit"
	id = "teleconsole"
	// req_tech = list(TECH_DATA = 3, TECH_BLUESPACE = 2)
	build_path = /obj/item/circuitboard/teleporter
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_TELEPORT
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/biogenerator
	name = "biogenerator circuit"
	id = "biogenerator"
	// req_tech = list(TECH_DATA = 2)
	build_path = /obj/item/circuitboard/biogenerator
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_BOTANY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/comconsole
	name = "communications console circuit"
	id = "comconsole"
	build_path = /obj/item/circuitboard/communications
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_COMMAND
	)
	departmental_flags = DEPARTMENT_BITFLAG_COMMAND | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/idcardconsole
	name = "ID card modification console circuit"
	id = "idcardconsole"
	build_path = /obj/item/circuitboard/card
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_COMMAND
	)
	departmental_flags = DEPARTMENT_BITFLAG_COMMAND | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/emp_data
	name = "employment records console circuit"
	id = "emp_data"
	build_path = /obj/item/circuitboard/skills
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_COMMAND
	)
	departmental_flags = DEPARTMENT_BITFLAG_COMMAND | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/id_restorer
	name = "ID restoration console circuit"
	desc = "The circuit board for a ID restoration console."
	id = "idrestore_console"
	build_path = /obj/item/circuitboard/id_restorer
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_COMPUTER_COMMAND
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/keycard_auth
	name = "keycard authenticator circuit"
	desc = "The circuit board for a keycard authenticator."
	id = "keycard_auth"
	build_path = /obj/item/circuitboard/keycard_auth
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_COMPUTER_COMMAND
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/status_display
	name = "status display circuit"
	desc = "The circuit board for a status display."
	id = "status_display"
	build_path = /obj/item/circuitboard/status_display
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/ai_status_display
	name = "AI status display circuit"
	desc = "The circuit board for a AI status display."
	id = "ai_status_display"
	build_path = /obj/item/circuitboard/ai_status_display
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/newscaster
	name = "newscaster circuit"
	desc = "The circuit board for a newscaster."
	id = "newscaster"
	build_path = /obj/item/circuitboard/newscaster
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/telescreen_entertainment
	name = "entertainment camera monitor circuit"
	desc = "The circuit board for a entertainment camera monitor."
	id = "telescreen_entertainment"
	build_path = /obj/item/circuitboard/security/telescreen/entertainment
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/washing
	name = "washing machine circuit"
	desc = "The circuit board for a washing machine."
	id = "washing"
	build_path = /obj/item/circuitboard/washing
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/timeclock
	name = "timeclock circuit"
	desc = "The circuit board for a timeclock."
	id = "timeclock"
	build_path = /obj/item/circuitboard/timeclock
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/stockexchange
	name = "stock exchange console circuit"
	desc = "A console that connects to the galactic stock market."
	id = "stockexchange"
	build_path = /obj/item/circuitboard/stockexchange
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_CARGO
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/stationalert_engineering
	name = "station alert console circuit (engineering)"
	desc = "Used to access engineering's automated alert system."
	id = "stationalert_engineering"
	build_path = /obj/item/circuitboard/stationalert_engineering
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/stationalert_security
	name = "station alert console circuit (security)"
	desc = "Used to access security's automated alert system."
	id = "stationalert_security"
	build_path = /obj/item/circuitboard/stationalert_security
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SECURITY | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/stationalert_all
	name = "station alert console circuit (all)"
	desc = "Used to access the station's automated alert system."
	id = "stationalert_all"
	build_path = /obj/item/circuitboard/stationalert_all
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_COMMAND
	)
	departmental_flags = DEPARTMENT_BITFLAG_COMMAND | DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/mining_equipment_vendor
	name = "mining equipment vendor circuit"
	desc = "An equipment vendor for miners, points collected at an ore redemption machine can be spent here."
	id = "mining_equipment_vendor"
	build_path = /obj/item/circuitboard/mining_equipment_vendor
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_CARGO
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/survey_equipment_vendor
	name = "exploration equipment vendor circuit"
	desc = "An equipment vendor for explorers, points collected with a survey scanner can be spent here."
	id = "survey_equipment_vendor"
	build_path = /obj/item/circuitboard/exploration_equipment_vendor
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_CARGO
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/artifact_harvester
	name = "exotic particle harvester circuit"
	id = "artifact_harvester"
	build_path = /obj/item/circuitboard/artifact_harvester
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_MACHINE_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/artifact_scanpad
	name = "anomaly scanner pad circuit"
	id = "artifact_scanpad"
	build_path = /obj/item/circuitboard/artifact_scanpad
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_MACHINE_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/gyrotron
	name = "gyrotron circuit"
	id = "gyrotron"
	build_path = /obj/item/circuitboard/gyrotron
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design_techweb/board/supermatter_core_manager
	name = "supermatter core control circuit"
	id = "supermatter_core_manager"
	build_path = /obj/item/circuitboard/air_management/supermatter_core
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design_techweb/board/supermatter_injector_control
	name = "supermatter injector control circuit"
	id = "supermatter_injector_control"
	build_path = /obj/item/circuitboard/air_management/injector_control
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design_techweb/board/scanner_console
	name = "body scanner console circuit"
	id = "scanner_console"
	build_path = /obj/item/circuitboard/scanner_console
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_MACHINE_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/body_scanner
	name = "body scanner circuit"
	id = "body_scanner"
	build_path = /obj/item/circuitboard/body_scanner
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_MACHINE_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/sleeper_console
	name = "sleeper console circuit"
	id = "sleeper_console"
	build_path = /obj/item/circuitboard/sleeper_console
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_MACHINE_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/sleeper
	name = "sleeper circuit"
	id = "sleeper"
	build_path = /obj/item/circuitboard/sleeper
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_MACHINE_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE
