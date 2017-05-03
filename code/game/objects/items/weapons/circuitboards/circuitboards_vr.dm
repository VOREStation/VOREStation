#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

// VOREStation specific circuit boards!

// Board for the parts lathe in partslathe.dm
/obj/item/weapon/circuitboard/partslathe
	name = T_BOARD("parts lathe")
	build_path = /obj/machinery/partslathe
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 2)
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin = 2,
							/obj/item/weapon/stock_parts/manipulator = 2,
							/obj/item/weapon/stock_parts/console_screen = 1)

// Board for the algae oxygen generator in algae_generator.dm
/obj/item/weapon/circuitboard/algae_farm
	name = T_BOARD("algae oxygen generator")
	build_path = /obj/machinery/atmospherics/binary/algae_farm
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_ENGINEERING = 3, TECH_BIO = 2)
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin = 2,
							/obj/item/weapon/stock_parts/manipulator = 1,
							/obj/item/weapon/stock_parts/capacitor = 1,
							/obj/item/weapon/stock_parts/console_screen = 1)
