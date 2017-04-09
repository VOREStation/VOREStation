#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/weapon/circuitboard/transhuman_clonepod
	name = T_BOARD("grower pod")
	board_type = new /datum/frame/frame_types/machine
	build_path = /obj/machinery/clonepod/transhuman
	origin_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	req_components = list(
							/obj/item/stack/cable_coil = 2,
							/obj/item/weapon/stock_parts/scanning_module = 2,
							/obj/item/weapon/stock_parts/manipulator = 2,
							/obj/item/weapon/stock_parts/console_screen = 1)

/obj/item/weapon/circuitboard/transhuman_synthprinter
	name = T_BOARD("SynthFab 3000")
	board_type = new /datum/frame/frame_types/machine
	build_path = /obj/machinery/transhuman/synthprinter
	origin_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	req_components = list(
							/obj/item/stack/cable_coil = 2,
							/obj/item/weapon/stock_parts/matter_bin = 1,
							/obj/item/weapon/stock_parts/scanning_module = 1,
							/obj/item/weapon/stock_parts/manipulator = 2)

/obj/item/weapon/circuitboard/transhuman_resleever
	name = T_BOARD("resleeving pod")
	board_type = new /datum/frame/frame_types/machine
	build_path = /obj/machinery/transhuman/resleever
	origin_tech = list(TECH_ENGINEERING = 4, TECH_BIO = 4)
	req_components = list(
							/obj/item/stack/cable_coil = 2,
							/obj/item/weapon/stock_parts/scanning_module = 2,
							/obj/item/weapon/stock_parts/manipulator = 2,
							/obj/item/weapon/stock_parts/console_screen = 1)

/obj/item/weapon/circuitboard/resleeving_control
	name = T_BOARD("resleeving control console")
	build_path = /obj/machinery/computer/transhuman/resleeving
	origin_tech = list(TECH_DATA = 5)


/obj/item/weapon/circuitboard/body_designer
	name = T_BOARD("body design console")
	build_path = /obj/machinery/computer/transhuman/designer
	origin_tech = list(TECH_DATA = 5)
