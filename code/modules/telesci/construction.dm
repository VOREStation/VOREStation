#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

// The circuit boards

/obj/item/circuitboard/telesci_console
	name = T_BOARD("Telepad Control Console")
	build_path = /obj/machinery/computer/telescience

/obj/item/circuitboard/telesci_pad
	name = T_BOARD("Telepad")
	board_type = new /datum/frame/frame_types/machine
	build_path = /obj/machinery/telepad
	req_components = list(
							/obj/item/bluespace_crystal = 1,
							/obj/item/stock_parts/capacitor = 2,
							/obj/item/stack/cable_coil = 5,
							/obj/item/stock_parts/console_screen = 1)

// Bamfpads! Ported from /tg/
/obj/item/circuitboard/quantumpad
	name = T_BOARD("quantum pad")
	board_type = new /datum/frame/frame_types/machine
	build_path = /obj/machinery/power/quantumpad
	req_components = list(
		/obj/item/bluespace_crystal = 1,
		/obj/item/stock_parts/capacitor = 1,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stack/cable_coil = 5)
