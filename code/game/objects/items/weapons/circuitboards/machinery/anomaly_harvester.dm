#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/circuitboard/anomaly_harvester
	name = T_BOARD("anomaly harvester")
	build_path = /obj/machinery/anomaly_harvester
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_DATA = 1)
	req_components = list(
		/obj/item/stock_parts/matter_bin/adv = 2,
		/obj/item/stock_parts/manipulator/nano = 1,
		/obj/item/stock_parts/micro_laser/high = 1,
		/obj/item/stack/cable_coil = 5,
		/obj/item/stack/material/phoron = 5,
		/obj/item/stack/material/diamond = 1
	)
/*
/obj/item/circuitboard/anomaly_harvester/advanced
	name = T_BOARD("advanced anomaly harvester")
	build_path = /obj/machinery/anomaly_harvester
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_DATA = 1)
	req_components = list(
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stack/cable_coil = 5,
		/obj/item/stack/material/phoron = 5,
		/obj/item/stack/material/diamond = 1
	)
*/
