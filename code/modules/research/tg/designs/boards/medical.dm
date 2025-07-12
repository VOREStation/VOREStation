
/datum/design_techweb/board/clonepod
	name = "clone pod circuit"
	id = "clonepod"
	// req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	build_path = /obj/item/circuitboard/clonepod
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/clonescanner
	name = "cloning scanner circuit"
	id = "clonescanner"
	// req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	build_path = /obj/item/circuitboard/clonescanner
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/chem_master
	name = "ChemMaster 3000 circuit"
	id = "chemmaster"
	// req_tech = list(TECH_DATA = 3, TECH_MAGNET = 2)
	build_path = /obj/item/circuitboard/chem_master
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/crewconsole
	name = "crew monitoring console circuit"
	id = "crewconsole"
	// req_tech = list(TECH_DATA = 3, TECH_MAGNET = 2, TECH_BIO = 2)
	build_path = /obj/item/circuitboard/crew
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/pandemic
	name = "PanD.E.M.I.C 2200 circuit"
	id = "pandemic"
	// req_tech = list(TECH_DATA = 2, TECH_BIO = 2)
	build_path = /obj/item/circuitboard/pandemic
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/transhuman_clonepod
	name = "grower pod circuit"
	id = "transhuman_clonepod"
	// req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	build_path = /obj/item/circuitboard/transhuman_clonepod
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/transhuman_resleever
	name = "Resleeving pod circuit"
	id = "transhuman_resleever"
	// req_tech = list(TECH_ENGINEERING = 4, TECH_BIO = 4)
	build_path = /obj/item/circuitboard/transhuman_resleever
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/resleeving_control
	name = "Resleeving control console circuit"
	id = "resleeving_control"
	// req_tech = list(TECH_DATA = 5)
	build_path = /obj/item/circuitboard/resleeving_control
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/body_designer
	name = "Body design console circuit"
	id = "body_designer"
	// req_tech = list(TECH_DATA = 5)
	build_path = /obj/item/circuitboard/body_designer
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/rtg
	name = "vitals monitor circuit"
	id = "vitals"
	// req_tech = list(TECH_DATA = 3, TECH_BIO = 4, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/machine/vitals_monitor
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE
