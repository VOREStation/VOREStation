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
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY | DEPARTMENT_BITFLAG_SCIENCE

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
