#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

// The circuit boards

/obj/item/weapon/circuitboard/telesci_console
	name = T_BOARD("Telepad Control Console")
	build_path = /obj/machinery/computer/telescience
	origin_tech = list(TECH_DATA = 3, TECH_BLUESPACE = 3, TECH_PHORON = 4)

/obj/item/weapon/circuitboard/telesci_pad
	name = T_BOARD("Telepad")
	board_type = new /datum/frame/frame_types/machine
	build_path = /obj/machinery/telepad
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4, TECH_PHORON = 4, TECH_BLUESPACE = 5)
	req_components = list(
							/obj/item/weapon/ore/bluespace_crystal = 1,
							/obj/item/weapon/stock_parts/capacitor = 2,
							/obj/item/stack/cable_coil = 5,
							/obj/item/weapon/stock_parts/console_screen = 1)

// The Designs

/datum/design/circuit/telesci_console
	name = "Telepad Control Console"
	id = "telesci_console"
	req_tech = list(TECH_DATA = 3, TECH_BLUESPACE = 3, TECH_PHORON = 4)
	build_path = /obj/item/weapon/circuitboard/telesci_console
	sort_string = "HAAEA"

/datum/design/circuit/telesci_pad
	name = "Telepad"
	id = "telesci_pad"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4, TECH_PHORON = 4, TECH_BLUESPACE = 5)
	build_path = /obj/item/weapon/circuitboard/telesci_pad
	sort_string = "HAAEB"

/datum/design/item/telesci_gps
	name = "GPS device"
	id = "telesci_gps"
	req_tech = list(TECH_MATERIAL = 2, TECH_BLUESPACE = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 500, "glass" = 1000)
	build_path = /obj/item/device/gps/advanced
	sort_string = "HAAEB"

/datum/design/item/bluespace_crystal
	name = "Artificial Bluespace Crystal"
	id = "bluespace_crystal"
	req_tech = list(TECH_BLUESPACE = 3, TECH_PHORON = 4)
	materials = list("diamond" = 1500, "phoron" = 1500)
	build_path = /obj/item/weapon/ore/bluespace_crystal/artificial
	sort_string = "HAAEC"
