#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

// VOREStation specific circuit boards!

// Our own board so deconstructing and reconstructing gets the same machine back...
/obj/item/weapon/circuitboard/jukebox/vore
	name = T_BOARD("VORE jukebox")
	build_path = /obj/machinery/media/jukebox/vore

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
