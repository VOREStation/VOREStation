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

/datum/design_techweb/board/ore_silo
	name = "Ore Silo circuit"
	desc = "The circuit board for an ore silo."
	id = "ore_silo"
	build_path = /obj/item/circuitboard/machine/ore_silo
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_CARGO
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/request_console
	name = "request console circuit"
	desc = "The circuit board for a request console."
	id = "request"
	build_path = /obj/item/circuitboard/request
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_COMPUTER_CARGO
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

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

/datum/design_techweb/board/stockexchange
	name = "stock exchange console circuit"
	desc = "A console that connects to the galactic stock market."
	id = "stockexchange"
	build_path = /obj/item/circuitboard/stockexchange
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_CARGO
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_SCIENCE
