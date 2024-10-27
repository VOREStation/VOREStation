#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/circuitboard/smes
	name = T_BOARD("superconductive magnetic energy storage")
	build_path = /obj/machinery/power/smes/buildable
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_POWER = 6, TECH_ENGINEERING = 4)
	req_components = list(/obj/item/smes_coil = 1, /obj/item/stack/cable_coil = 30)

/obj/item/circuitboard/smes/construct(var/obj/machinery/power/smes/buildable/S)
	if(..(S))
		S.output_attempt = 0 //built SMES default to off

/obj/item/circuitboard/batteryrack
	name = T_BOARD("battery rack PSU")
	build_path = /obj/machinery/power/smes/batteryrack
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 2)
	req_components = list(/obj/item/stock_parts/capacitor/ = 3, /obj/item/stock_parts/matter_bin/ = 1)

/obj/item/circuitboard/grid_checker
	name = T_BOARD("power grid checker")
	build_path = /obj/machinery/power/grid_checker
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_POWER = 4, TECH_ENGINEERING = 3)
	req_components = list(/obj/item/stock_parts/capacitor = 3, /obj/item/stack/cable_coil = 10)

/obj/item/circuitboard/breakerbox
	name = T_BOARD("breaker box")
	build_path = /obj/machinery/power/breakerbox
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 3)
	req_components = list(
		/obj/item/stock_parts/spring = 1,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stack/cable_coil = 10)
