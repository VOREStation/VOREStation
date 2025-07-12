/datum/design_techweb/board
	name = "NULL ENTRY Board"
	desc = "I promise this doesn't give you syndicate goodies!"
	build_type = IMPRINTER
	materials = list(MAT_GLASS = 2000)

/datum/design_techweb/board/arcademachine
	name = "battle arcade machine"
	desc = "Allows for the construction of circuit boards used to build a new arcade machine."
	id = "arcademachine"
	// req_tech = list(TECH_DATA = 1)
	build_path = /obj/item/circuitboard/arcade/battle
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_ENTERTAINMENT
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design_techweb/board/oriontrail
	name = "orion trail arcade machine"
	desc = "Allows for the construction of circuit boards used to build a new arcade machine."
	id = "oriontrail"
	// req_tech = list(TECH_DATA = 1)
	build_path = /obj/item/circuitboard/arcade/orion_trail
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_ENTERTAINMENT
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design_techweb/board/clawmachine
	name = "grab-a-gift arcade machine"
	desc = "Allows for the construction of circuit boards used to build a new arcade machine."
	id = "clawmachine"
	// req_tech = list(TECH_DATA = 1)
	build_path = /obj/item/circuitboard/arcade/clawmachine
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_ENTERTAINMENT
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design_techweb/board/seccamera
	name = "security camera monitor"
	desc = "Allows for the construction of circuit boards used to build a security camera monitor."
	id = "seccamera"
	build_path = /obj/item/circuitboard/security
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design_techweb/board/secdata
	name = "security records console"
	desc = "Allows for the construction of circuit boards used to build a security records console."
	id = "sec_data"
	build_path = /obj/item/circuitboard/secure_data
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design_techweb/board/prisonmanage
	name = "prisoner management console"
	desc = "Allows for the construction of circuit boards used to build a prisoner management console."
	id = "prisonmanage"
	build_path = /obj/item/circuitboard/prisoner
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design_techweb/board/med_data
	name = "medical records console"
	desc = "Allows for the construction of circuit boards used to build a medical records console."
	id = "med_data"
	build_path = /obj/item/circuitboard/med_data
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design_techweb/board/operating
	name = "patient monitoring console"
	desc = "Allows for the construction of circuit boards used to build a patient monitoring console."
	id = "operating"
	build_path = /obj/item/circuitboard/operating
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design_techweb/board/scan_console
	name = "DNA console"
	desc = "Allows for the construction of circuit boards used to build a DNA console."
	id = "scan_console"
	build_path = /obj/item/circuitboard/scan_consolenew
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL
