/obj/item/circuitboard/machine/fishing_portal_generator

/obj/item/circuitboard/machine/fishing_portal_generator
	name = T_BOARD("fishing portal generator")
	build_path = /obj/machinery/fishing_portal_generator
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_MAGNET = 2, TECH_DATA = 1)
	req_components = list(
							/obj/item/stock_parts/capacitor = 1,
							/obj/item/stock_parts/console_screen = 1,
							/obj/item/stack/cable_coil = 5)
