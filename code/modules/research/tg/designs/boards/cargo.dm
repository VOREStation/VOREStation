/datum/design_techweb/board/ordercomp
	SET_CIRCUIT_DESIGN_NAMEDESC("supply ordering console")
	id = "ordercomp"
	build_path = /obj/item/circuitboard/supplycomp
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_CARGO
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/supplycomp
	SET_CIRCUIT_DESIGN_NAMEDESC("supply control console")
	id = "supplycomp"
	// req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/circuitboard/supplycomp/control
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_CARGO
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/miningdrill
	SET_CIRCUIT_DESIGN_NAMEDESC("mining drill head")
	id = "mining drill head"
	// req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_path = /obj/item/circuitboard/miningdrill
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_CARGO
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/miningdrillbrace
	SET_CIRCUIT_DESIGN_NAMEDESC("mining drill brace")
	id = "mining drill brace"
	// req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_path = /obj/item/circuitboard/miningdrillbrace
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_CARGO
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/ore_silo
	SET_CIRCUIT_DESIGN_NAMEDESC("Ore Silo")
	id = "ore_silo"
	build_path = /obj/item/circuitboard/machine/ore_silo
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_CARGO
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/request_console
	SET_CIRCUIT_DESIGN_NAMEDESC("request console")
	id = "request"
	build_path = /obj/item/circuitboard/request
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_COMPUTER_CARGO
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/mining_equipment_vendor
	SET_CIRCUIT_DESIGN_NAMEDESC("mining equipment vendor")
	id = "mining_equipment_vendor"
	build_path = /obj/item/circuitboard/mining_equipment_vendor
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_CARGO
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/survey_equipment_vendor
	SET_CIRCUIT_DESIGN_NAMEDESC("exploration equipment vendor")
	id = "survey_equipment_vendor"
	build_path = /obj/item/circuitboard/exploration_equipment_vendor
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_CARGO
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/stockexchange
	SET_CIRCUIT_DESIGN_NAMEDESC("stock exchange console")
	id = "stockexchange"
	build_path = /obj/item/circuitboard/stockexchange
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_CARGO
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_SCIENCE
