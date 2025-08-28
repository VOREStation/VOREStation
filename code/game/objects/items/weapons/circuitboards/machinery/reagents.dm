#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

// Chem analyzer pro
/obj/item/circuitboard/chemical_analyzer
	name = T_BOARD("chem analyzer PRO")
	build_path = /obj/machinery/chemical_analyzer
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	req_components = list(/obj/item/stock_parts/scanning_module = 1, /obj/item/stock_parts/matter_bin = 1)

// Smart centrifuge
/obj/item/circuitboard/smart_centrifuge
	name = T_BOARD("smart centrifuge")
	build_path = /obj/machinery/smart_centrifuge
	board_type = new /datum/frame/frame_types/machine
	matter = list(MAT_STEEL = 50, MAT_GLASS = 50)
	origin_tech = list(TECH_MAGNET = 3, TECH_DATA = 2, TECH_MATERIAL = 3)
	req_components = list(
							/obj/item/stock_parts/scanning_module = 1,
							/obj/item/stock_parts/motor = 1,
							/obj/item/stock_parts/gear = 3,
							/obj/item/stack/material/glass/reinforced = 1)
