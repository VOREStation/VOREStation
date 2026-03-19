/datum/design_techweb/board/atmosalerts
	SET_CIRCUIT_DESIGN_NAMEDESC("atmosphere alert console")
	id = "atmosalerts"
	build_path = /obj/item/circuitboard/atmos_alert
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/air_management
	SET_CIRCUIT_DESIGN_NAMEDESC("atmosphere monitoring console")
	id = "air_management"
	build_path = /obj/item/circuitboard/air_management
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/tank_management
	SET_CIRCUIT_DESIGN_NAMEDESC("tank monitoring console")
	id = "tank_management"
	build_path = /obj/item/circuitboard/air_management/tank_control
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/shutoff_monitor
	SET_CIRCUIT_DESIGN_NAMEDESC("Automatic shutoff valve monitor")
	id = "shutoff_monitor"
	// req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3)
	build_path = /obj/item/circuitboard/shutoff_monitor
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ATMOS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/gas_heater
	SET_CIRCUIT_DESIGN_NAMEDESC("gas heating system")
	id = "gasheater"
	// req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 1)
	build_path = /obj/item/circuitboard/unary_atmos/heater
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ATMOS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/gas_cooler
	SET_CIRCUIT_DESIGN_NAMEDESC("gas cooling system")
	id = "gascooler"
	// req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/unary_atmos/cooler
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ATMOS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/arf_generator
	SET_CIRCUIT_DESIGN_NAMEDESC("atmospheric field generator")
	id = "arf_generator"
	// req_tech = list(TECH_MAGNET = 4, TECH_POWER = 4, TECH_BIO = 3)
	build_path = /obj/item/circuitboard/arf_generator
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ATMOS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/atmoscontrol
	SET_CIRCUIT_DESIGN_NAMEDESC("central atmospherics computer")
	id = "atmoscontrol"
	build_path = /obj/item/circuitboard/atmoscontrol
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_MACHINE_ATMOS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/area_atmos
	SET_CIRCUIT_DESIGN_NAMEDESC("area air control console")
	id = "area_atmos"
	build_path = /obj/item/circuitboard/area_atmos
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ATMOS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE
