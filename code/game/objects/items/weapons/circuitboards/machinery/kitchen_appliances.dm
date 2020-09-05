/obj/item/weapon/circuitboard/microwave
	name = T_BOARD("microwave")
	desc = "The circuitboard for a microwave."
	build_path = /obj/machinery/microwave
	board_type = new /datum/frame/frame_types/microwave
	contain_parts = 0
	matter = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)
	req_components = list(
							/obj/item/weapon/stock_parts/console_screen = 1,
							/obj/item/weapon/stock_parts/capacitor = 3, // Original Capacitor count was 1
							/obj/item/weapon/stock_parts/motor = 1,
							/obj/item/weapon/stock_parts/scanning_module = 1,
							/obj/item/weapon/stock_parts/matter_bin = 2)

/obj/item/weapon/circuitboard/oven
	name = T_BOARD("oven")
	desc = "The circuitboard for an oven."
	build_path = /obj/machinery/appliance/cooker/oven
	board_type = new /datum/frame/frame_types/oven
	matter = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)
	req_components = list(
							/obj/item/weapon/stock_parts/capacitor = 3,
							/obj/item/weapon/stock_parts/scanning_module = 1,
							/obj/item/weapon/stock_parts/matter_bin = 2)

/obj/item/weapon/circuitboard/fryer
	name = T_BOARD("deep fryer")
	desc = "The circuitboard for a deep fryer."
	build_path = /obj/machinery/appliance/cooker/fryer
	board_type = new /datum/frame/frame_types/fryer
	req_components = list(
							/obj/item/weapon/stock_parts/capacitor = 3,
							/obj/item/weapon/stock_parts/scanning_module = 1,
							/obj/item/weapon/stock_parts/matter_bin = 2)
							
/obj/item/weapon/circuitboard/grill
	name = T_BOARD("grill")
	desc = "The circuitboard for an industrial grill."
	build_path = /obj/machinery/appliance/cooker/grill
	board_type = new /datum/frame/frame_types/grill
	req_components = list(
							/obj/item/weapon/stock_parts/capacitor = 3,
							/obj/item/weapon/stock_parts/scanning_module = 1,
							/obj/item/weapon/stock_parts/matter_bin = 2)

/obj/item/weapon/circuitboard/cerealmaker
	name = T_BOARD("cereal maker")
	desc = "The circuitboard for a cereal maker."
	build_path = /obj/machinery/appliance/mixer/cereal
	board_type = new /datum/frame/frame_types/cerealmaker
	req_components = list(
							/obj/item/weapon/stock_parts/capacitor = 3,
							/obj/item/weapon/stock_parts/scanning_module = 1,
							/obj/item/weapon/stock_parts/matter_bin = 2)

/obj/item/weapon/circuitboard/candymachine
	name = T_BOARD("candy machine")
	desc = "The circuitboard for a candy machine."
	build_path = /obj/machinery/appliance/mixer/candy
	board_type = new /datum/frame/frame_types/candymachine
	req_components = list(
							/obj/item/weapon/stock_parts/capacitor = 3,
							/obj/item/weapon/stock_parts/scanning_module = 1,
							/obj/item/weapon/stock_parts/matter_bin = 2)

/obj/item/weapon/circuitboard/microwave/advanced
	name = T_BOARD("deluxe microwave")
	build_path = /obj/machinery/microwave/advanced
	board_type = new /datum/frame/frame_types/microwave
	matter = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)
	req_components = list(
							/obj/item/weapon/stock_parts/console_screen = 1,
							/obj/item/weapon/stock_parts/motor = 1,
							/obj/item/weapon/stock_parts/capacitor = 1)