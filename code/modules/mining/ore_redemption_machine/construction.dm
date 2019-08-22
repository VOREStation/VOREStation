#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/weapon/circuitboard/mining_equipment_vendor
	name = T_BOARD("Mining Equipment Vendor")
	board_type = new /datum/frame/frame_types/machine
	build_path = /obj/machinery/mineral/equipment_vendor
	origin_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 3)
	req_components = list(
							/obj/item/weapon/stock_parts/console_screen = 1,
							/obj/item/weapon/stock_parts/matter_bin = 3)

/obj/item/weapon/circuitboard/exploration_equipment_vendor
	name = T_BOARD("Exploration Equipment Vendor")
	board_type = new /datum/frame/frame_types/machine
	build_path = /obj/machinery/mineral/equipment_vendor/survey
	origin_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 2)
	req_components = list(
							/obj/item/weapon/stock_parts/console_screen = 1,
							/obj/item/weapon/stock_parts/matter_bin = 3)
