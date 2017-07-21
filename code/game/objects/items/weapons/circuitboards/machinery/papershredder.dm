#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/weapon/circuitboard/papershredder
	name = T_BOARD("papershredder")
	build_path = /obj/machinery/papershredder
	board_type = new /datum/frame/frame_types/machine
	matter = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)
	req_components = list(
							/obj/item/weapon/stock_parts/motor = 1,
							/obj/item/weapon/stock_parts/gear = 2,
							/obj/item/weapon/stock_parts/micro_laser = 1)
