// Cooking Appliances
/datum/design_techweb/board/microwave
	SET_CIRCUIT_DESIGN_NAMEDESC("microwave")
	id = "microwave_board"
	// req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/microwave
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_KITCHEN
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/oven
	SET_CIRCUIT_DESIGN_NAMEDESC("oven")
	id = "oven_board"
	// req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/oven
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_KITCHEN
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/fryer
	SET_CIRCUIT_DESIGN_NAMEDESC("deep fryer")
	id = "fryer_board"
	// req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/fryer
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_KITCHEN
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/range
	SET_CIRCUIT_DESIGN_NAMEDESC("grill")
	id = "range"
	build_path = /obj/item/circuitboard/grill
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_KITCHEN
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/cerealmaker
	SET_CIRCUIT_DESIGN_NAMEDESC("cereal maker")
	id = "cerealmaker_board"
	// req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/cerealmaker
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_KITCHEN
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/candymaker
	SET_CIRCUIT_DESIGN_NAMEDESC("candy machine")
	id = "candymachine_board"
	// req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/candymachine
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_KITCHEN
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/honey_extractor
	SET_CIRCUIT_DESIGN_NAMEDESC("honey extractor")
	id = "honey_extractor"
	build_path = /obj/item/circuitboard/honey_extractor
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_BOTANY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_SCIENCE
