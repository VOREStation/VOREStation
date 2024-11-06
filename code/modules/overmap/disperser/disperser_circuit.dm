#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/circuitboard/disperser
	name = T_BOARD("obstruction removal ballista control")
	build_path = /obj/machinery/computer/ship/disperser
	origin_tech = list(TECH_ENGINEERING = 2, TECH_COMBAT = 2, TECH_BLUESPACE = 2)

/obj/item/circuitboard/disperserfront
	name = T_BOARD("obstruction removal ballista beam generator")
	build_path = /obj/machinery/disperser/front
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_ENGINEERING = 2, TECH_COMBAT = 2, TECH_BLUESPACE = 2)
	req_components = list (
							/obj/item/stock_parts/manipulator/pico = 5
	)

/obj/item/circuitboard/dispersermiddle
	name = T_BOARD("obstruction removal ballista fusor")
	build_path = /obj/machinery/disperser/middle
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_ENGINEERING = 2, TECH_COMBAT = 2, TECH_BLUESPACE = 2)
	req_components = list (
							/obj/item/stock_parts/subspace/crystal = 10
	)

/obj/item/circuitboard/disperserback
	name = T_BOARD("obstruction removal ballista material deconstructor")
	build_path = /obj/machinery/disperser/back
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_ENGINEERING = 2, TECH_COMBAT = 2, TECH_BLUESPACE = 2)
	req_components = list (
							/obj/item/stock_parts/capacitor/super = 5
	)
