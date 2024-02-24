/obj/item/weapon/circuitboard/firework_launcher
	name = T_BOARD("firework launcher")
	board_type = new /datum/frame/frame_types/machine
	build_path = /obj/machinery/firework_launcher
	origin_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 2)
	req_components = list (
							/obj/item/weapon/stock_parts/micro_laser = 2
	)