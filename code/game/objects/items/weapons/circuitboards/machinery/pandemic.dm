#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/circuitboard/pandemic
	name = T_BOARD("pandemic")
	build_path = /obj/machinery/computer/pandemic
	board_type = new /datum/frame/frame_types/computer
	origin_tech = list(TECH_DATA = 2, TECH_BIO = 2)
	req_components = list(
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/stock_parts/scanning_module = 1,
		/obj/item/stock_parts/manipulator = 1
		/obj/item/stack/cable_coil = 5,
		/obj/item/stock_parts/capacitor = 1
	)
