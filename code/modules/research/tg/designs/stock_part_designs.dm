// Matter Bins
/datum/design_techweb/basic_matter_bin
	name = "Basic Matter Bin"
	desc = "A tier 1 stock part used in the construction of various devices."
	id = "basic_matter_bin"
	build_type = PROTOLATHE | AUTOLATHE
	materials = list(MAT_STEEL = 80)
	build_path = /obj/item/stock_parts/matter_bin
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_1
	)
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/adv_matter_bin
	name = "Advanced Matter Bin"
	desc = "A tier 2 stock part used in the construction of various devices."
	id = "adv_matter_bin"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 80)
	build_path = /obj/item/stock_parts/matter_bin/adv
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_2
	)
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/super_matter_bin
	name = "Super Matter Bin"
	desc = "A tier 3 stock part used in the construction of various devices."
	id = "super_matter_bin"
	// req_tech = list(TECH_MATERIAL = 5)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 80)
	build_path = /obj/item/stock_parts/matter_bin/super
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_3
	)
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/hyper_matter_bin
	name = "Hyper Matter Bin"
	desc = "A tier 4 stock part used in the construction of various devices."
	id = "hyper_matter_bin"
	// req_tech = list(TECH_MATERIAL = 6, TECH_ARCANE = 2)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 200, MAT_VERDANTIUM = 60, MAT_DURASTEEL = 75)
	build_path = /obj/item/stock_parts/matter_bin/hyper
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_4
	)
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/omni_matter_bin
	name = "Omni Matter Bin"
	desc = "A tier 5 stock part used in the construction of various devices."
	id = "omni_matter_bin"
	// req_tech = list(TECH_MATERIAL = 7, TECH_PRECURSOR = 2)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 2000, MAT_PLASTEEL = 100, MAT_MORPHIUM = 100, MAT_DURASTEEL = 100)
	build_path = /obj/item/stock_parts/matter_bin/omni
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_5
	)
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

// Micro-manipulators
/datum/design_techweb/micro_mani
	name = "Micro Manipulator"
	desc = "A tier 1 stock part used in the construction of various devices."
	id = "micro_manipulator"
	build_type = PROTOLATHE | AUTOLATHE
	materials = list(MAT_STEEL = 30)
	build_path = /obj/item/stock_parts/manipulator
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_1
	)
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/nano_mani
	name = "Nano Manipulator"
	desc = "A tier 2 stock part used in the construction of various devices."
	id = "nano_mani"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 30)
	build_path = /obj/item/stock_parts/manipulator/nano
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_2
	)
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/pico_mani
	name = "Pico Manipulator"
	desc = "A tier 3 stock part used in the construction of various devices."
	id = "pico_mani"
	// req_tech = list(TECH_MATERIAL = 5, TECH_DATA = 2)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 30)
	build_path = /obj/item/stock_parts/manipulator/pico
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_3
	)
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/hyper_mani
	name = "Hyper Manipulator"
	desc = "A tier 4 stock part used in the construction of various devices."
	id = "hyper_mani"
	// req_tech = list(TECH_MATERIAL = 6, TECH_DATA = 3, TECH_ARCANE = 2)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 200, MAT_VERDANTIUM = 50, MAT_DURASTEEL = 50)
	build_path = /obj/item/stock_parts/manipulator/hyper
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_4
	)
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/omni_mani
	name = "Omni Manipulator"
	desc = "A tier 5 stock part used in the construction of various devices."
	id = "omni_mani"
	// req_tech = list(TECH_MATERIAL = 7, TECH_DATA = 4, TECH_PRECURSOR = 2)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 2000, MAT_PLASTEEL = 500, MAT_MORPHIUM = 100, MAT_DURASTEEL = 100)
	build_path = /obj/item/stock_parts/manipulator/omni
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_5
	)
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

// Capacitors
/datum/design_techweb/basic_capacitor
	name = "Basic Capacitor"
	desc = "A tier 1 stock part used in the construction of various devices."
	id = "basic_capacitor"
	build_type = PROTOLATHE | AUTOLATHE
	materials = list(MAT_STEEL = 50, MAT_GLASS = 50)
	build_path = /obj/item/stock_parts/capacitor
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_1
	)
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/adv_capacitor
	name = "Advanced Capacitor"
	desc = "A tier 2 stock part used in the construction of various devices."
	id = "adv_capacitor"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 50, MAT_GLASS = 50)
	build_path = /obj/item/stock_parts/capacitor/adv
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_2
	)
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/super_capacitor
	name = "Super Capacitor"
	desc = "A tier 3 stock part used in the construction of various devices."
	id = "super_capacitor"
	build_type = PROTOLATHE
	// req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4)
	materials = list(MAT_STEEL = 50, MAT_GLASS = 50, MAT_GOLD = 20)
	build_path = /obj/item/stock_parts/capacitor/super
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_3
	)
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/hyper_capacitor
	name = "Hyper Capacitor"
	desc = "A tier 4 stock part used in the construction of various devices."
	id = "hyper_capacitor"
	build_type = PROTOLATHE
	// req_tech = list(TECH_POWER = 6, TECH_MATERIAL = 5, TECH_BLUESPACE = 1, TECH_ARCANE = 1)
	materials = list(MAT_STEEL = 200, MAT_GLASS = 100, MAT_VERDANTIUM = 30, MAT_DURASTEEL = 25)
	build_path = /obj/item/stock_parts/capacitor/hyper
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_4
	)
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/omni_capacitor
	name = "Omni Capacitor"
	desc = "A tier 5 stock part used in the construction of various devices."
	id = "omni_capacitor"
	build_type = PROTOLATHE
	// req_tech = list(TECH_POWER = 7, TECH_MATERIAL = 6, TECH_BLUESPACE = 3, TECH_PRECURSOR = 1)
	materials = list(MAT_STEEL = 2000, MAT_DIAMOND = 1000, MAT_GLASS = 1000, MAT_MORPHIUM = 100, MAT_DURASTEEL = 100)
	build_path = /obj/item/stock_parts/capacitor/omni
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_5
	)
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

// Sensors
/datum/design_techweb/basic_sensor
	name = "Basic Sensor"
	desc = "A tier 1 stock part used in the construction of various devices."
	id = "basic_sensor"
	build_type = PROTOLATHE | AUTOLATHE
	materials = list(MAT_STEEL = 50, MAT_GLASS = 20)
	build_path = /obj/item/stock_parts/scanning_module
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_1
	)
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/adv_sensor
	name = "Advanced Sensor"
	desc = "A tier 2 stock part used in the construction of various devices."
	id = "adv_sensor"
	build_type = PROTOLATHE | AUTOLATHE
	materials = list(MAT_STEEL = 50, MAT_GLASS = 20)
	build_path = /obj/item/stock_parts/scanning_module/adv
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_2
	)
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/phasic_sensor
	name = "Phasic Sensor"
	desc = "A tier 3 stock part used in the construction of various devices."
	id = "phasic_sensor"
	build_type = PROTOLATHE
	// req_tech = list(TECH_MAGNET = 5, TECH_MATERIAL = 3)
	materials = list(MAT_STEEL = 50, MAT_GLASS = 20, MAT_SILVER = 10)
	build_path = /obj/item/stock_parts/scanning_module/phasic
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_3
	)
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/hyper_sensor
	name = "Hyper Sensor"
	desc = "A tier 4 stock part used in the construction of various devices."
	id = "hyper_sensor"
	build_type = PROTOLATHE
	// req_tech = list(TECH_MAGNET = 6, TECH_MATERIAL = 4, TECH_ARCANE = 1)
	materials = list(MAT_STEEL = 50, MAT_GLASS = 20, MAT_SILVER = 50, MAT_VERDANTIUM = 40, MAT_DURASTEEL = 50)
	build_path = /obj/item/stock_parts/scanning_module/hyper
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_4
	)
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/omni_sensor
	name = "Omni Sensor"
	desc = "A tier 5 stock part used in the construction of various devices."
	id = "omni_sensor"
	build_type = PROTOLATHE
	// req_tech = list(TECH_MAGNET = 7, TECH_MATERIAL = 5, TECH_PRECURSOR = 1)
	materials = list(MAT_STEEL = 1000, MAT_PLASTEEL = 500, MAT_GLASS = 750, MAT_SILVER = 500, MAT_MORPHIUM = 60, MAT_DURASTEEL = 100)
	build_path = /obj/item/stock_parts/scanning_module/omni
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_5
	)
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE


// Micro-lasers
/datum/design_techweb/basic_micro_laser
	name = "Basic Micro Laser"
	desc = "A tier 1 stock part used in the construction of various devices."
	id = "basic_micro_laser"
	build_type = PROTOLATHE | AUTOLATHE
	materials = list(MAT_STEEL = 10, MAT_GLASS = 20)
	build_path = /obj/item/stock_parts/micro_laser
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_1
	)
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/high_micro_laser
	name = "High-powered Micro Laser"
	desc = "A tier 2 stock part used in the construction of various devices."
	id = "high_micro_laser"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 10, MAT_GLASS = 20)
	build_path = /obj/item/stock_parts/micro_laser/high
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_2
	)
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/ultra_micro_laser
	name = "Ultra-powered Micro Laser"
	desc = "A tier 3 stock part used in the construction of various devices."
	id = "ultra_micro_laser"
	// req_tech = list(TECH_MAGNET = 5, TECH_MATERIAL = 5)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 10, MAT_GLASS = 20, MAT_URANIUM = 10)
	build_path = /obj/item/stock_parts/micro_laser/ultra
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_3
	)
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/hyper_micro_laser
	name = "Hyper-powered Micro Laser"
	desc = "A tier 4 stock part used in the construction of various devices."
	id = "hyper_micro_laser"
	// req_tech = list(TECH_MAGNET = 6, TECH_MATERIAL = 6, TECH_ARCANE = 2)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 200, MAT_GLASS = 20, MAT_URANIUM = 30, MAT_VERDANTIUM = 50, MAT_DURASTEEL = 100)
	build_path = /obj/item/stock_parts/micro_laser/hyper
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_4
	)
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/omni_micro_laser
	name = "Omni-powered Micro Laser"
	desc = "A tier 5 stock part used in the construction of various devices."
	id = "omni_micro_laser"
	// req_tech = list(TECH_MAGNET = 7, TECH_MATERIAL = 7, TECH_PRECURSOR = 2)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 500, MAT_URANIUM = 2000, MAT_MORPHIUM = 50, MAT_DURASTEEL = 100)
	build_path = /obj/item/stock_parts/micro_laser/omni
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_5
	)
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

// Cells
/datum/design_techweb/basic
	name = "Basic Cell"
	desc = "A tier 1 power cell."
	id = "basic_cell"
	build_type = PROTOLATHE | AUTOLATHE
	materials = list(MAT_STEEL = 700, MAT_GLASS = 50)
	build_path = /obj/item/cell
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_1
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/high
	name = "High-Capacity Cell"
	desc = "A tier 2 power cell."
	id = "high_cell"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 700, MAT_GLASS = 60)
	build_path = /obj/item/cell/high
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_2
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/super
	name = "Super-Capacity Cell"
	desc = "A tier 3 power cell."
	id = "super_cell"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 700, MAT_GLASS = 70)
	build_path = /obj/item/cell/super
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_3
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/hyper
	name = "Hyper-Capacity Cell"
	desc = "A tier 4 power cell."
	id = "hyper_cell"
	// req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 400, MAT_GOLD = 150, MAT_SILVER = 150, MAT_GLASS = 70)
	build_path = /obj/item/cell/hyper
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_4
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

// Special cells
/datum/design_techweb/device_cell
	name = "Device Cell"
	id = "device_cell"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 350, MAT_GLASS = 25)
	build_path = /obj/item/cell/device
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_1
	)

/datum/design_techweb/weapon_cell
	name = "Weapon Cell"
	id = "weapon_cell"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 700, MAT_GLASS = 50)
	build_path = /obj/item/cell/device/weapon
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_1
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY | DEPARTMENT_BITFLAG_SCIENCE

// RPEDs
/datum/design_techweb/RPED
	name = "Rapid Part Exchange Device"
	desc = "Special mechanical module made to store, sort, and apply standard machine parts."
	id = "rped"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 15000, MAT_GLASS = 5000)
	build_path = /obj/item/storage/part_replacer
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_EXCHANGERS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/ARPED
	name = "Advanced Rapid Part Exchange Device"
	desc = "Special mechanical module made to store, sort, and apply standard machine parts.  This one has a greatly upgraded storage capacity, \
	and the ability to manipulate beakers."
	id = "arped"
	build_type = PROTOLATHE
	// req_tech = list(TECH_ENGINEERING = 5, TECH_MATERIAL = 5)
	materials = list(MAT_STEEL = 30000, MAT_GLASS = 10000)
	build_path = /obj/item/storage/part_replacer/adv
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_EXCHANGERS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/PBRPED
	name = "Prototype Bluespace Rapid Part Exchange Device"
	desc = "Special mechanical module made to store, sort, and apply standard machine parts.  This one has a remarkably upgraded storage capacity, \
	and the ability to manipulate beakers."
	id = "pbrped"
	build_type = PROTOLATHE
	// req_tech = list(TECH_ENGINEERING = 7, TECH_MATERIAL = 7, TECH_BLUESPACE = 5)
	materials = list(MAT_STEEL = 30000, MAT_GLASS = 10000, MAT_SILVER = 5000, MAT_GOLD = 5000, MAT_DIAMOND = 1000)
	build_path = /obj/item/storage/part_replacer/adv/discount_bluespace
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_EXCHANGERS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/BRPED
	name = "Bluespace Rapid Part Exchange Device"
	desc = "Special mechanical module made to store, sort, and apply standard machine parts.  This one has a remarkably upgraded storage capacity, \
	the ability to manipulate beakers, and works at range."
	id = "brped"
	build_type = PROTOLATHE
	// req_tech = list(TECH_ENGINEERING = 7, TECH_MATERIAL = 7, TECH_BLUESPACE = 5, TECH_PRECURSOR = 1)
	materials = list(MAT_STEEL = 30000, MAT_GLASS = 10000, MAT_SILVER = 5000, MAT_GOLD = 5000, MAT_DIAMOND = 1000)
	build_path = /obj/item/storage/part_replacer/adv/bluespace
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_EXCHANGERS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE
