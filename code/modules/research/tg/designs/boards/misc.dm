/datum/design_techweb/board
	name = "NULL ENTRY Board"
	desc = "I promise this doesn't give you syndicate goodies!"
	build_type = IMPRINTER
	materials = DEFAULT_CIRCUIT_MATERIALS
	category = list(
		RND_CATEGORY_MACHINE
	)

/datum/design_techweb/board/arcademachine
	SET_CIRCUIT_DESIGN_NAMEDESC("battle arcade machine")
	id = "arcademachine"
	// req_tech = list(TECH_DATA = 1)
	build_path = /obj/item/circuitboard/arcade/battle
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_ENTERTAINMENT
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/oriontrail
	SET_CIRCUIT_DESIGN_NAMEDESC("orion trail arcade machine")
	id = "oriontrail"
	// req_tech = list(TECH_DATA = 1)
	build_path = /obj/item/circuitboard/arcade/orion_trail
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_ENTERTAINMENT
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/clawmachine
	SET_CIRCUIT_DESIGN_NAMEDESC("grab-a-gift arcade machine")
	id = "clawmachine"
	// req_tech = list(TECH_DATA = 1)
	build_path = /obj/item/circuitboard/arcade/clawmachine
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_ENTERTAINMENT
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/seccamera
	SET_CIRCUIT_DESIGN_NAMEDESC("security camera monitor")
	id = "seccamera"
	build_path = /obj/item/circuitboard/security
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SECURITY

/datum/design_techweb/board/engcamera
	SET_CIRCUIT_DESIGN_NAMEDESC("engineering camera monitor")
	id = "engcamera"
	build_path = /obj/item/circuitboard/security/engineering
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design_techweb/board/crgcamera
	SET_CIRCUIT_DESIGN_NAMEDESC("mining camera monitor")
	id = "crgcamera"
	build_path = /obj/item/circuitboard/security/mining
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_CARGO

/datum/design_techweb/board/xenobiocamera
	SET_CIRCUIT_DESIGN_NAMEDESC("xenobiology camera monitor")
	id = "xenobiocamera"
	build_path = /obj/item/circuitboard/security/xenobio
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/secdata
	SET_CIRCUIT_DESIGN_NAMEDESC("security records console")
	id = "sec_data"
	build_path = /obj/item/circuitboard/secure_data
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/prisonmanage
	SET_CIRCUIT_DESIGN_NAMEDESC("prisoner management console")
	id = "prisonmanage"
	build_path = /obj/item/circuitboard/prisoner
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/med_data
	SET_CIRCUIT_DESIGN_NAMEDESC("medical records console")
	id = "med_data"
	build_path = /obj/item/circuitboard/med_data
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/med_pcu
	SET_CIRCUIT_DESIGN_NAMEDESC("medical records PCU")
	id = "med_pcu"
	build_path = /obj/item/circuitboard/med_data/pcu
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

// TODO - non-pcu skill console, id = "skill_data"

/datum/design_techweb/board/skill_pcu
	SET_CIRCUIT_DESIGN_NAMEDESC("employment records PCU")
	id = "skill_pcu"
	build_path = /obj/item/circuitboard/skills/pcu
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_COMMAND
	)
	departmental_flags = DEPARTMENT_BITFLAG_COMMAND | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/operating
	SET_CIRCUIT_DESIGN_NAMEDESC("patient monitoring console")
	id = "operating"
	build_path = /obj/item/circuitboard/operating
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/scan_console
	SET_CIRCUIT_DESIGN_NAMEDESC("DNA console")
	id = "scan_console"
	build_path = /obj/item/circuitboard/scan_consolenew
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/clonecontrol
	SET_CIRCUIT_DESIGN_NAMEDESC("cloning control console")
	id = "clonecontrol"
	// req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	build_path = /obj/item/circuitboard/cloning
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/jukebox
	SET_CIRCUIT_DESIGN_NAMEDESC("jukebox")
	id = "jukebox"
	// req_tech = list(TECH_MAGNET = 2, TECH_DATA = 1)
	build_type = AUTOLATHE | IMPRINTER // Simple circuit
	build_path = /obj/item/circuitboard/jukebox
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_BAR
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/teleconsole
	SET_CIRCUIT_DESIGN_NAMEDESC("teleporter control console")
	id = "teleconsole"
	// req_tech = list(TECH_DATA = 3, TECH_BLUESPACE = 2)
	build_path = /obj/item/circuitboard/teleporter
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_TELEPORT
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/biogenerator
	SET_CIRCUIT_DESIGN_NAMEDESC("biogenerator")
	id = "biogenerator"
	// req_tech = list(TECH_DATA = 2)
	build_path = /obj/item/circuitboard/biogenerator
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_BOTANY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/comconsole
	SET_CIRCUIT_DESIGN_NAMEDESC("communications console")
	id = "comconsole"
	build_path = /obj/item/circuitboard/communications
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_COMMAND
	)
	departmental_flags = DEPARTMENT_BITFLAG_COMMAND | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/idcardconsole
	SET_CIRCUIT_DESIGN_NAMEDESC("ID card modification console")
	id = "idcardconsole"
	build_path = /obj/item/circuitboard/card
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_COMMAND
	)
	departmental_flags = DEPARTMENT_BITFLAG_COMMAND | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/emp_data
	SET_CIRCUIT_DESIGN_NAMEDESC("employment records console")
	id = "emp_data"
	build_path = /obj/item/circuitboard/skills
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_COMMAND
	)
	departmental_flags = DEPARTMENT_BITFLAG_COMMAND | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/id_restorer
	SET_CIRCUIT_DESIGN_NAMEDESC("ID restoration console")
	id = "idrestore_console"
	build_path = /obj/item/circuitboard/id_restorer
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_COMPUTER_COMMAND
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/keycard_auth
	SET_CIRCUIT_DESIGN_NAMEDESC("keycard authenticator")
	id = "keycard_auth"
	build_path = /obj/item/circuitboard/keycard_auth
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_COMPUTER_COMMAND
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/status_display
	SET_CIRCUIT_DESIGN_NAMEDESC("status display")
	id = "status_display"
	build_path = /obj/item/circuitboard/status_display
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/ai_status_display
	SET_CIRCUIT_DESIGN_NAMEDESC("AI status display")
	id = "ai_status_display"
	build_path = /obj/item/circuitboard/ai_status_display
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/newscaster
	SET_CIRCUIT_DESIGN_NAMEDESC("newscaster")
	id = "newscaster"
	build_type = AUTOLATHE | IMPRINTER // Simple circuit
	build_path = /obj/item/circuitboard/newscaster
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/telescreen_entertainment
	SET_CIRCUIT_DESIGN_NAMEDESC("entertainment camera monitor")
	id = "telescreen_entertainment"
	build_path = /obj/item/circuitboard/security/telescreen/entertainment
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/washing
	SET_CIRCUIT_DESIGN_NAMEDESC("washing machine")
	id = "washing"
	build_path = /obj/item/circuitboard/washing
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/timeclock
	SET_CIRCUIT_DESIGN_NAMEDESC("timeclock")
	id = "timeclock"
	build_type = AUTOLATHE | IMPRINTER // Simple circuit
	build_path = /obj/item/circuitboard/timeclock
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/stationalert_engineering
	SET_CIRCUIT_DESIGN_NAMEDESC("station alert console (engineering)")
	id = "stationalert_engineering"
	build_path = /obj/item/circuitboard/stationalert_engineering
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/stationalert_security
	SET_CIRCUIT_DESIGN_NAMEDESC("station alert console (security)")
	id = "stationalert_security"
	build_path = /obj/item/circuitboard/stationalert_security
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SECURITY | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/stationalert_all
	SET_CIRCUIT_DESIGN_NAMEDESC("station alert console (all)")
	id = "stationalert_all"
	build_path = /obj/item/circuitboard/stationalert_all
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_COMMAND
	)
	departmental_flags = DEPARTMENT_BITFLAG_COMMAND | DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/vr_sleeper
	SET_CIRCUIT_DESIGN_NAMEDESC("virtual reality sleeper")
	id = "vr_sleeper"
	build_path = /obj/item/circuitboard/vr_sleeper
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_MACHINE_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/space_heater
	SET_CIRCUIT_DESIGN_NAMEDESC("space heater")
	id = "space_heater"
	build_type = AUTOLATHE | IMPRINTER // Simple circuit
	build_path = /obj/item/circuitboard/space_heater
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_MACHINE_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE


/datum/design_techweb/board/account_console
	SET_CIRCUIT_DESIGN_NAMEDESC("account database console")
	id = "account_console"
	build_type = AUTOLATHE | IMPRINTER // Simple circuit
	build_path = /obj/item/circuitboard/account_console
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_MACHINE_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_COMMAND
