
#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/circuitboard/fluidpump
	name = T_BOARD("fluid pump")
	build_path = /obj/machinery/pump
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_DATA = 1)
	req_components = list(
							/obj/item/stock_parts/matter_bin = 2,
							/obj/item/stock_parts/motor = 2,
							/obj/item/stock_parts/manipulator = 1)
