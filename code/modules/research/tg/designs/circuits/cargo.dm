/datum/design_techweb/board/ordercomp
	name = "supply ordering console circuit"
	id = "ordercomp"
	build_path = /obj/item/circuitboard/supplycomp
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_CARGO
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/supplycomp
	name = "supply control console circuit"
	id = "supplycomp"
	// req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/circuitboard/supplycomp/control
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_CARGO
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/miningdrill
	name = "mining drill head circuit"
	id = "mining drill head"
	// req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_path = /obj/item/circuitboard/miningdrill
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_CARGO
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/miningdrillbrace
	name = "mining drill brace circuit"
	id = "mining drill brace"
	// req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_path = /obj/item/circuitboard/miningdrillbrace
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_CARGO
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_SCIENCE
