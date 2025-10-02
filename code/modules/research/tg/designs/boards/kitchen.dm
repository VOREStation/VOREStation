// Cooking Appliances
/datum/design_techweb/board/microwave
	name = "microwave board circuit"
	id = "microwave_board"
	// req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/microwave
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_KITCHEN
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/oven
	name = "oven board circuit"
	id = "oven_board"
	// req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/oven
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_KITCHEN
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/fryer
	name = "deep fryer board circuit"
	id = "fryer_board"
	// req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/fryer
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_KITCHEN
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/cerealmaker
	name = "cereal maker board circuit"
	id = "cerealmaker_board"
	// req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/cerealmaker
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_KITCHEN
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/candymaker
	name = "candy machine board circuit"
	id = "candymachine_board"
	// req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/candymachine
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_KITCHEN
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/microwave/advanced
	name = "deluxe microwave circuit"
	id = "deluxe microwave"
	// req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 5, TECH_BLUESPACE = 4)
	build_path = /obj/item/circuitboard/microwave/advanced
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_KITCHEN
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_SCIENCE
