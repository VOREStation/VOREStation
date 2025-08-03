#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/circuitboard/pointdefense
	name = T_BOARD("point defense battery")
	board_type = new /datum/frame/frame_types/machine
	desc = "Control systems for a Kuiper pattern point defense battery. Aim away from vessel."
	build_path = /obj/machinery/pointdefense
	origin_tech = list(TECH_ENGINEERING = 3, TECH_COMBAT = 2)
	req_components = list(
		/obj/item/mecha_parts/mecha_equipment/weapon/energy/laser = 1,
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/capacitor = 2,
	)

/obj/item/circuitboard/pointdefense_control
	name = T_BOARD("fire assist mainframe")
	board_type = new /datum/frame/frame_types/machine
	desc = "A control computer to synchronize point defense batteries."
	build_path = /obj/machinery/pointdefense_control
	origin_tech = list(TECH_ENGINEERING = 3, TECH_COMBAT = 2)
	req_components = list()
