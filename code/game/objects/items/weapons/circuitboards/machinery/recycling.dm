#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/weapon/circuitboard/recycler_crusher
	name = T_BOARD("recycler - crusher")
	build_path = /obj/machinery/recycling/crusher
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_MATERIAL = 2)
	matter = list(MAT_STEEL = 50, MAT_GLASS = 50)
	req_components = list(
		/obj/item/stack/cable_coil = 2,
		/obj/item/weapon/stock_parts/motor = 1,
		/obj/item/weapon/stock_parts/gear = 1,
		/obj/item/weapon/stock_parts/matter_bin = 1,
		/obj/item/weapon/stock_parts/manipulator = 1
		)

/obj/item/weapon/circuitboard/recycler_sorter
	name = T_BOARD("recycler - sorter")
	build_path = /obj/machinery/recycling/sorter
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_MATERIAL = 2)
	matter = list(MAT_STEEL = 50, MAT_GLASS = 50)
	req_components = list(
		/obj/item/stack/cable_coil = 2,
		/obj/item/weapon/stock_parts/motor = 1,
		/obj/item/weapon/stock_parts/gear = 3
	)

/obj/item/weapon/circuitboard/recycler_stamper
	name = T_BOARD("recycler - stamper")
	build_path = /obj/machinery/recycling/stamper
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_MATERIAL = 2)
	matter = list(MAT_STEEL = 50, MAT_GLASS = 50)
	req_components = list(
		/obj/item/stack/cable_coil = 2,
		/obj/item/weapon/stock_parts/gear = 2,
		/obj/item/weapon/stock_parts/motor = 2
	)
