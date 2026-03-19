
/datum/design_techweb/board/clonepod
	SET_CIRCUIT_DESIGN_NAMEDESC("clone pod")
	id = "clonepod"
	// req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	build_path = /obj/item/circuitboard/clonepod
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/clonescanner
	SET_CIRCUIT_DESIGN_NAMEDESC("cloning scanner")
	id = "clonescanner"
	// req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	build_path = /obj/item/circuitboard/clonescanner
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/chem_master
	SET_CIRCUIT_DESIGN_NAMEDESC("ChemMaster 3000")
	id = "chemmaster"
	// req_tech = list(TECH_DATA = 3, TECH_MAGNET = 2)
	build_path = /obj/item/circuitboard/chem_master
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/crewconsole
	SET_CIRCUIT_DESIGN_NAMEDESC("crew monitoring console")
	id = "crewconsole"
	// req_tech = list(TECH_DATA = 3, TECH_MAGNET = 2, TECH_BIO = 2)
	build_path = /obj/item/circuitboard/crew
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/pandemic
	SET_CIRCUIT_DESIGN_NAMEDESC("PanD.E.M.I.C 2200")
	id = "pandemic"
	// req_tech = list(TECH_DATA = 2, TECH_BIO = 2)
	build_path = /obj/item/circuitboard/pandemic
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/transhuman_clonepod
	SET_CIRCUIT_DESIGN_NAMEDESC("grower pod")
	id = "transhuman_clonepod"
	// req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	build_path = /obj/item/circuitboard/transhuman_clonepod
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/transhuman_resleever
	SET_CIRCUIT_DESIGN_NAMEDESC("Resleeving pod")
	id = "transhuman_resleever"
	// req_tech = list(TECH_ENGINEERING = 4, TECH_BIO = 4)
	build_path = /obj/item/circuitboard/transhuman_resleever
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/resleeving_control
	SET_CIRCUIT_DESIGN_NAMEDESC("Resleeving control console")
	id = "resleeving_control"
	// req_tech = list(TECH_DATA = 5)
	build_path = /obj/item/circuitboard/resleeving_control
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/body_designer
	SET_CIRCUIT_DESIGN_NAMEDESC("Body design console")
	id = "body_designer"
	// req_tech = list(TECH_DATA = 5)
	build_path = /obj/item/circuitboard/body_designer
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/vitals_monitor
	SET_CIRCUIT_DESIGN_NAMEDESC("vitals monitor")
	id = "vitals"
	// req_tech = list(TECH_DATA = 3, TECH_BIO = 4, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/machine/vitals_monitor
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/smart_centrifuge
	SET_CIRCUIT_DESIGN_NAMEDESC("smart centrifuge")
	id = "smart_centrifuge"
	// req_tech = list(TECH_MAGNET = 2, TECH_DATA = 1, TECH_MATERIAL = 2)
	build_path = /obj/item/circuitboard/smart_centrifuge
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/chem_analyzer
	SET_CIRCUIT_DESIGN_NAMEDESC("chem analyzer PRO")
	id = "chem_analyzer"
	// req_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	build_path = /obj/item/circuitboard/chemical_analyzer
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/medical_kiosk
	SET_CIRCUIT_DESIGN_NAMEDESC("Medical Kiosk")
	id = "medical_kiosk"
	build_path = /obj/item/circuitboard/medical_kiosk
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_MEDICAL

/datum/design_techweb/board/scanner_console
	SET_CIRCUIT_DESIGN_NAMEDESC("body scanner console")
	id = "scanner_console"
	build_path = /obj/item/circuitboard/scanner_console
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_MACHINE_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/body_scanner
	SET_CIRCUIT_DESIGN_NAMEDESC("body scanner")
	id = "body_scanner"
	build_path = /obj/item/circuitboard/body_scanner
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_MACHINE_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/sleeper_console
	SET_CIRCUIT_DESIGN_NAMEDESC("sleeper console")
	id = "sleeper_console"
	build_path = /obj/item/circuitboard/sleeper_console
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_MACHINE_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/sleeper
	SET_CIRCUIT_DESIGN_NAMEDESC("sleeper")
	id = "sleeper"
	build_path = /obj/item/circuitboard/sleeper
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_MACHINE_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/bioprinter
	SET_CIRCUIT_DESIGN_NAMEDESC("bioprinter")
	id = "bioprinter"
	build_path = /obj/item/circuitboard/bioprinter
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_MACHINE_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE
