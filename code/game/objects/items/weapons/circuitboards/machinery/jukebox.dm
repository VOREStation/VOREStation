#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/circuitboard/jukebox
	name = T_BOARD("jukebox")
	build_path = /obj/machinery/media/jukebox
	board_type = new /datum/frame/frame_types/machine
	req_components = list(
							/obj/item/stock_parts/capacitor = 1,
							/obj/item/stock_parts/console_screen = 1,
							/obj/item/stack/cable_coil = 5)
