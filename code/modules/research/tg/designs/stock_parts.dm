// Matter Bins
/datum/design_techweb/basic_matter_bin
	name = "Basic Matter Bin"
	desc = "A stock part used in the construction of various devices."
	id = "basic_matter_bin"
	build_type = PROTOLATHE | AUTOLATHE
	materials = list(MAT_STEEL = 80)
	build_path = /obj/item/stock_parts/matter_bin
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_1
	)
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

// Micro-manipulators
/datum/design_techweb/micro_mani
	name = "Micro Manipulator"
	desc = "A stock part used in the construction of various devices."
	id = "micro_manipulator"
	build_type = PROTOLATHE | AUTOLATHE
	materials = list(MAT_STEEL = 30)
	build_path = /obj/item/stock_parts/manipulator
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_1
	)
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

// Capacitors
/datum/design_techweb/basic_capacitor
	name = "Basic Capacitor"
	desc = "A stock part used in the construction of various devices."
	id = "basic_capacitor"
	build_type = PROTOLATHE | AUTOLATHE
	materials = list(MAT_STEEL = 50, MAT_GLASS = 50)
	build_path = /obj/item/stock_parts/capacitor
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_1
	)
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

// Sensors
/datum/design_techweb/basic_sensor
	name = "Basic Sensor"
	desc = "A stock part used in the construction of various devices."
	id = "basic_sensor"
	build_type = PROTOLATHE | AUTOLATHE
	materials = list(MAT_STEEL = 50, MAT_GLASS = 20)
	build_path = /obj/item/stock_parts/scanning_module
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_1
	)
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

// Micro-lasers
/datum/design_techweb/basic_micro_laser
	name = "Basic Micro Laser"
	desc = "A stock part used in the construction of various devices."
	id = "basic_micro_laser"
	build_type = PROTOLATHE | AUTOLATHE
	materials = list(MAT_STEEL = 10, MAT_GLASS = 20)
	build_path = /obj/item/stock_parts/micro_laser
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_1
	)
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE
