#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

//Stuff that doesn't fit into any category goes here

/obj/item/circuitboard/aicore
	name = T_BOARD("AI core")
	origin_tech = list(TECH_DATA = 4, TECH_BIO = 2)
	board_type = "other"

/obj/item/circuitboard/chem_master
	name = T_BOARD("ChemMaster 3000")
	build_path = /obj/machinery/chem_master
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_DATA = 3, TECH_MAGNET = 2)
	req_components = list(
							/obj/item/stock_parts/matter_bin = 2,
							/obj/item/stock_parts/manipulator = 2)
