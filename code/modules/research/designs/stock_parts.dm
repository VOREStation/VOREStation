/*
	Various Stock Parts
*/

/datum/design/item/stock_part
	build_type = PROTOLATHE
	time = 3 //Sets an independent time for stock parts, currently one third normal print time.

/datum/design/item/stock_part/AssembleDesignName()
	..()
	name = "Component design ([item_name])"

/datum/design/item/stock_part/AssembleDesignDesc()
	if(!desc)
		desc = "A stock part used in the construction of various devices."

// Matter Bins

/datum/design/item/stock_part/basic_matter_bin
	id = "basic_matter_bin"
	req_tech = list(TECH_MATERIAL = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 80)
	build_path = /obj/item/weapon/stock_parts/matter_bin
	sort_string = "AAAAA"

/datum/design/item/stock_part/adv_matter_bin
	id = "adv_matter_bin"
	req_tech = list(TECH_MATERIAL = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 80)
	build_path = /obj/item/weapon/stock_parts/matter_bin/adv
	sort_string = "AAAAB"

/datum/design/item/stock_part/super_matter_bin
	id = "super_matter_bin"
	req_tech = list(TECH_MATERIAL = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 80)
	build_path = /obj/item/weapon/stock_parts/matter_bin/super
	sort_string = "AAAAC"

/datum/design/item/stock_part/hyper_matter_bin
	id = "hyper_matter_bin"
	req_tech = list(TECH_MATERIAL = 6, TECH_ARCANE = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 200, MAT_VERDANTIUM = 60, MAT_DURASTEEL = 75)
	build_path = /obj/item/weapon/stock_parts/matter_bin/hyper
	sort_string = "AAAAD"

/datum/design/item/stock_part/omni_matter_bin
	id = "omni_matter_bin"
	req_tech = list(TECH_MATERIAL = 7, TECH_PRECURSOR = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 2000, MAT_PLASTEEL = 100, MAT_MORPHIUM = 100, MAT_DURASTEEL = 100)
	build_path = /obj/item/weapon/stock_parts/matter_bin/omni
	sort_string = "AAAAE"

// Micro-manipulators

/datum/design/item/stock_part/micro_mani
	id = "micro_mani"
	req_tech = list(TECH_MATERIAL = 1, TECH_DATA = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 30)
	build_path = /obj/item/weapon/stock_parts/manipulator
	sort_string = "AAABA"

/datum/design/item/stock_part/nano_mani
	id = "nano_mani"
	req_tech = list(TECH_MATERIAL = 3, TECH_DATA = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 30)
	build_path = /obj/item/weapon/stock_parts/manipulator/nano
	sort_string = "AAABB"

/datum/design/item/stock_part/pico_mani
	id = "pico_mani"
	req_tech = list(TECH_MATERIAL = 5, TECH_DATA = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 30)
	build_path = /obj/item/weapon/stock_parts/manipulator/pico
	sort_string = "AAABC"

/datum/design/item/stock_part/hyper_mani
	id = "hyper_mani"
	req_tech = list(TECH_MATERIAL = 6, TECH_DATA = 3, TECH_ARCANE = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 200, MAT_VERDANTIUM = 50, MAT_DURASTEEL = 50)
	build_path = /obj/item/weapon/stock_parts/manipulator/hyper
	sort_string = "AAABD"

/datum/design/item/stock_part/omni_mani
	id = "omni_mani"
	req_tech = list(TECH_MATERIAL = 7, TECH_DATA = 4, TECH_PRECURSOR = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 2000, MAT_PLASTEEL = 500, MAT_MORPHIUM = 100, MAT_DURASTEEL = 100)
	build_path = /obj/item/weapon/stock_parts/manipulator/omni
	sort_string = "AAABE"

// Capacitors

/datum/design/item/stock_part/basic_capacitor
	id = "basic_capacitor"
	req_tech = list(TECH_POWER = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)
	build_path = /obj/item/weapon/stock_parts/capacitor
	sort_string = "AAACA"

/datum/design/item/stock_part/adv_capacitor
	id = "adv_capacitor"
	req_tech = list(TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)
	build_path = /obj/item/weapon/stock_parts/capacitor/adv
	sort_string = "AAACB"

/datum/design/item/stock_part/super_capacitor
	id = "super_capacitor"
	req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50, "gold" = 20)
	build_path = /obj/item/weapon/stock_parts/capacitor/super
	sort_string = "AAACC"

/datum/design/item/stock_part/hyper_capacitor
	id = "hyper_capacitor"
	req_tech = list(TECH_POWER = 6, TECH_MATERIAL = 5, TECH_BLUESPACE = 1, TECH_ARCANE = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 200, MAT_GLASS = 100, MAT_VERDANTIUM = 30, MAT_DURASTEEL = 25)
	build_path = /obj/item/weapon/stock_parts/capacitor/hyper
	sort_string = "AAACD"

/datum/design/item/stock_part/omni_capacitor
	id = "omni_capacitor"
	req_tech = list(TECH_POWER = 7, TECH_MATERIAL = 6, TECH_BLUESPACE = 3, TECH_PRECURSOR = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 2000, MAT_DIAMOND = 1000, MAT_GLASS = 1000, MAT_MORPHIUM = 100, MAT_DURASTEEL = 100)
	build_path = /obj/item/weapon/stock_parts/capacitor/omni
	sort_string = "AAACE"

// Sensors

/datum/design/item/stock_part/basic_sensor
	id = "basic_sensor"
	req_tech = list(TECH_MAGNET = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 20)
	build_path = /obj/item/weapon/stock_parts/scanning_module
	sort_string = "AAADA"

/datum/design/item/stock_part/adv_sensor
	id = "adv_sensor"
	req_tech = list(TECH_MAGNET = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 20)
	build_path = /obj/item/weapon/stock_parts/scanning_module/adv
	sort_string = "AAADB"

/datum/design/item/stock_part/phasic_sensor
	id = "phasic_sensor"
	req_tech = list(TECH_MAGNET = 5, TECH_MATERIAL = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 20, "silver" = 10)
	build_path = /obj/item/weapon/stock_parts/scanning_module/phasic
	sort_string = "AAADC"

/datum/design/item/stock_part/hyper_sensor
	id = "hyper_sensor"
	req_tech = list(TECH_MAGNET = 6, TECH_MATERIAL = 4, TECH_ARCANE = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 50, MAT_GLASS = 20, MAT_SILVER = 50, MAT_VERDANTIUM = 40, MAT_DURASTEEL = 50)
	build_path = /obj/item/weapon/stock_parts/scanning_module/hyper
	sort_string = "AAADD"

/datum/design/item/stock_part/omni_sensor
	id = "omni_sensor"
	req_tech = list(TECH_MAGNET = 7, TECH_MATERIAL = 5, TECH_PRECURSOR = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 1000, MAT_PLASTEEL = 500, MAT_GLASS = 750, MAT_SILVER = 500, MAT_MORPHIUM = 60, MAT_DURASTEEL = 100)
	build_path = /obj/item/weapon/stock_parts/scanning_module/omni
	sort_string = "AAADE"

// Micro-lasers

/datum/design/item/stock_part/basic_micro_laser
	id = "basic_micro_laser"
	req_tech = list(TECH_MAGNET = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 10, "glass" = 20)
	build_path = /obj/item/weapon/stock_parts/micro_laser
	sort_string = "AAAEA"

/datum/design/item/stock_part/high_micro_laser
	id = "high_micro_laser"
	req_tech = list(TECH_MAGNET = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 10, "glass" = 20)
	build_path = /obj/item/weapon/stock_parts/micro_laser/high
	sort_string = "AAAEB"

/datum/design/item/stock_part/ultra_micro_laser
	id = "ultra_micro_laser"
	req_tech = list(TECH_MAGNET = 5, TECH_MATERIAL = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 10, "glass" = 20, "uranium" = 10)
	build_path = /obj/item/weapon/stock_parts/micro_laser/ultra
	sort_string = "AAAEC"

/datum/design/item/stock_part/hyper_micro_laser
	id = "hyper_micro_laser"
	req_tech = list(TECH_MAGNET = 6, TECH_MATERIAL = 6, TECH_ARCANE = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 200, MAT_GLASS = 20, MAT_URANIUM = 30, MAT_VERDANTIUM = 50, MAT_DURASTEEL = 100)
	build_path = /obj/item/weapon/stock_parts/micro_laser/hyper
	sort_string = "AAAED"

/datum/design/item/stock_part/omni_micro_laser
	id = "omni_micro_laser"
	req_tech = list(TECH_MAGNET = 7, TECH_MATERIAL = 7, TECH_PRECURSOR = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 2000, MAT_GLASS = 500, MAT_URANIUM = 2000, MAT_MORPHIUM = 50, MAT_DURASTEEL = 100)
	build_path = /obj/item/weapon/stock_parts/micro_laser/omni
	sort_string = "AAAEE"


// RPEDs

/datum/design/item/stock_part/RPED
	name = "Rapid Part Exchange Device"
	desc = "Special mechanical module made to store, sort, and apply standard machine parts."
	id = "rped"
	req_tech = list(TECH_ENGINEERING = 3, TECH_MATERIAL = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 15000, "glass" = 5000)
	build_path = /obj/item/weapon/storage/part_replacer
	sort_string = "ABAAA"

/datum/design/item/stock_part/ARPED
	name = "Advanced Rapid Part Exchange Device"
	desc = "Special mechanical module made to store, sort, and apply standard machine parts.  This one has a greatly upgraded storage capacity."
	id = "arped"
	req_tech = list(TECH_ENGINEERING = 5, TECH_MATERIAL = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 30000, "glass" = 10000)
	build_path = /obj/item/weapon/storage/part_replacer/adv
	sort_string = "ABAAB"