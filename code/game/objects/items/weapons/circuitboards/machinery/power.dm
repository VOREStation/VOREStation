#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/weapon/circuitboard/smes
	name = T_BOARD("superconductive magnetic energy storage")
	build_path = /obj/machinery/power/smes/buildable
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_POWER = 6, TECH_ENGINEERING = 4)
	req_components = list(/obj/item/weapon/smes_coil = 1, /obj/item/stack/cable_coil = 30)

/obj/item/weapon/circuitboard/smes/construct(var/obj/machinery/power/smes/buildable/S)
	if(..(S))
		S.output_attempt = 0 //built SMES default to off

/obj/item/weapon/circuitboard/batteryrack
	name = T_BOARD("battery rack PSU")
	build_path = /obj/machinery/power/smes/batteryrack
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 2)
	req_components = list(/obj/item/weapon/cell = 3)

/obj/item/weapon/circuitboard/ghettosmes
	name = T_BOARD("makeshift PSU")
	desc = "An APC circuit repurposed into some power storage device controller"
	build_path = /obj/machinery/power/smes/batteryrack/makeshift
	board_type = new /datum/frame/frame_types/machine
	req_components = list(/obj/item/weapon/cell = 3)

/obj/item/weapon/circuitboard/grid_checker
	name = T_BOARD("power grid checker")
	build_path = /obj/machinery/power/grid_checker
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_POWER = 4, TECH_ENGINEERING = 3)
	req_components = list(/obj/item/weapon/stock_parts/capacitor = 3, /obj/item/stack/cable_coil = 10)

/obj/item/weapon/circuitboard/breakerbox
	name = T_BOARD("breaker box")
	build_path = /obj/machinery/power/breakerbox
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 3)
	req_components = list(
		/obj/item/weapon/stock_parts/spring = 1,
		/obj/item/weapon/stock_parts/manipulator = 1,
		/obj/item/stack/cable_coil = 10)
