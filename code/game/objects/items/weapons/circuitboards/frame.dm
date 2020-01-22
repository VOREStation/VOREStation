#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

//Circuitboards for frames (mostly wall based frames).  Most of these don't fit into other categories.

//Display

/obj/item/weapon/circuitboard/guestpass
	name = T_BOARD("guestpass console")
	build_path = /obj/machinery/computer/guestpass
	board_type = new /datum/frame/frame_types/guest_pass_console
	matter = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)

/obj/item/weapon/circuitboard/status_display
	name = T_BOARD("status display")
	build_path = /obj/machinery/status_display
	board_type = new /datum/frame/frame_types/display
	matter = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)

/obj/item/weapon/circuitboard/ai_status_display
	name = T_BOARD("ai status display")
	build_path = /obj/machinery/ai_status_display
	board_type = new /datum/frame/frame_types/display
	matter = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)

/obj/item/weapon/circuitboard/newscaster
	name = T_BOARD("newscaster")
	build_path = /obj/machinery/newscaster
	board_type = new /datum/frame/frame_types/newscaster
	matter = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)

/obj/item/weapon/circuitboard/atm
	name = T_BOARD("atm")
	build_path = /obj/machinery/atm
	board_type = new /datum/frame/frame_types/atm
	matter = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)

/obj/item/weapon/circuitboard/request
	name = T_BOARD("request console")
	build_path = /obj/machinery/requests_console
	board_type = new /datum/frame/frame_types/supply_request_console
	matter = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)

//Alarm

/obj/item/weapon/circuitboard/firealarm
	name = T_BOARD("fire alarm")
	build_path = /obj/machinery/firealarm
	board_type = new /datum/frame/frame_types/fire_alarm
	matter = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)

/obj/item/weapon/circuitboard/airalarm
	name = T_BOARD("air alarm")
	build_path = /obj/machinery/alarm
	board_type = new /datum/frame/frame_types/air_alarm
	matter = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)

/obj/item/weapon/circuitboard/intercom
	name = T_BOARD("intercom")
	build_path = /obj/item/device/radio/intercom
	board_type = new /datum/frame/frame_types/intercom
	matter = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)

/obj/item/weapon/circuitboard/keycard_auth
	name = T_BOARD("keycard authenticator")
	build_path = /obj/machinery/keycard_auth
	board_type = new /datum/frame/frame_types/keycard_authenticator
	matter = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)

//Computer

/obj/item/weapon/circuitboard/holopad
	name = T_BOARD("holopad")
	build_path = /obj/machinery/hologram/holopad
	board_type = new /datum/frame/frame_types/holopad
	matter = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)

/obj/item/weapon/circuitboard/scanner_console
	name = T_BOARD("body scanner console")
	build_path = /obj/machinery/body_scanconsole
	board_type = new /datum/frame/frame_types/medical_console
	origin_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)

/obj/item/weapon/circuitboard/sleeper_console
	name = T_BOARD("sleeper console")
	build_path = /obj/machinery/sleep_console
	board_type = new /datum/frame/frame_types/medical_console
	origin_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)

//Machine

/obj/item/weapon/circuitboard/photocopier
	name = T_BOARD("photocopier")
	build_path = /obj/machinery/photocopier
	board_type = new /datum/frame/frame_types/photocopier
	matter = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)
	req_components = list(
							/obj/item/weapon/stock_parts/scanning_module = 1,
							/obj/item/weapon/stock_parts/motor = 1,
							/obj/item/weapon/stock_parts/micro_laser = 1,
							/obj/item/weapon/stock_parts/matter_bin = 1)

/obj/item/weapon/circuitboard/fax
	name = T_BOARD("fax")
	build_path = /obj/machinery/photocopier/faxmachine
	board_type = new /datum/frame/frame_types/fax
	matter = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)
	req_components = list(
							/obj/item/weapon/stock_parts/scanning_module = 1,
							/obj/item/weapon/stock_parts/motor = 1,
							/obj/item/weapon/stock_parts/micro_laser = 1,
							/obj/item/weapon/stock_parts/matter_bin = 1)

/obj/item/weapon/circuitboard/conveyor
	name = T_BOARD("conveyor")
	build_path = /obj/machinery/conveyor
	board_type = new /datum/frame/frame_types/conveyor
	req_components = list(
							/obj/item/weapon/stock_parts/gear = 2,
							/obj/item/weapon/stock_parts/motor = 2,
							/obj/item/stack/cable_coil = 5)

/obj/item/weapon/circuitboard/microwave
	name = T_BOARD("microwave")
	build_path = /obj/machinery/microwave
	board_type = new /datum/frame/frame_types/microwave
	matter = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)
	req_components = list(
							/obj/item/weapon/stock_parts/console_screen = 1,
							/obj/item/weapon/stock_parts/motor = 1,
							/obj/item/weapon/stock_parts/capacitor = 1)

/obj/item/weapon/circuitboard/recharger
	name = T_BOARD("recharger")
	build_path = /obj/machinery/recharger
	board_type = new /datum/frame/frame_types/recharger
	req_components = list(
							/obj/item/weapon/stock_parts/capacitor = 1,
							/obj/item/stack/cable_coil = 5)

/obj/item/weapon/circuitboard/recharger/wrecharger
	name = T_BOARD("wall recharger")
	build_path = /obj/machinery/recharger/wallcharger
	board_type = new /datum/frame/frame_types/wall_charger

/obj/item/weapon/circuitboard/cell_charger
	name = T_BOARD("heavy-duty cell charger")
	build_path = /obj/machinery/cell_charger
	board_type = new /datum/frame/frame_types/cell_charger
	req_components = list(
							/obj/item/weapon/stock_parts/capacitor = 1,
							/obj/item/stack/cable_coil = 5)

/obj/item/weapon/circuitboard/washing
	name = T_BOARD("washing machine")
	build_path = /obj/machinery/washing_machine
	board_type = new /datum/frame/frame_types/washing_machine
	matter = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)
	req_components = list(
							/obj/item/weapon/stock_parts/motor = 1,
							/obj/item/weapon/stock_parts/gear = 2)

/obj/item/weapon/circuitboard/grinder
	name = T_BOARD("reagent grinder")
	build_path = /obj/machinery/reagentgrinder
	board_type = new /datum/frame/frame_types/grinder
	req_components = list(
							/obj/item/weapon/stock_parts/motor = 1,
							/obj/item/weapon/stock_parts/gear = 1,
							/obj/item/weapon/reagent_containers/glass/beaker/large = 1)

/obj/item/weapon/circuitboard/distiller
	build_path = /obj/machinery/portable_atmospherics/powered/reagent_distillery
	board_type = new /datum/frame/frame_types/reagent_distillery
	req_components = list(
							/obj/item/weapon/stock_parts/capacitor = 1,
							/obj/item/weapon/stock_parts/micro_laser = 1,
							/obj/item/weapon/stock_parts/motor = 2,
							/obj/item/weapon/stock_parts/gear = 1)

/obj/item/weapon/circuitboard/teleporter_hub
	name = T_BOARD("teleporter hub")
	build_path = /obj/machinery/teleport/hub
	board_type = "teleporter_hub"
//	origin_tech = list(TECH_DATA = 2, TECH_BLUESPACE = 4)
	req_components = list(
							/obj/item/weapon/stock_parts/scanning_module = 4,
							/obj/item/weapon/stock_parts/micro_laser = 4,
							/obj/item/stack/cable_coil = 10)

/obj/item/weapon/circuitboard/teleporter_station
	name = T_BOARD("teleporter station")
	build_path = /obj/machinery/teleport/station
	board_type = "teleporter_station"
//	origin_tech = list(TECH_DATA = 2, TECH_BLUESPACE = 3)
	req_components = list(
							/obj/item/weapon/stock_parts/console_screen = 1,
							/obj/item/weapon/stock_parts/capacitor = 2,
							/obj/item/stack/cable_coil = 10)

/obj/item/weapon/circuitboard/body_scanner
	name = T_BOARD("body scanner")
	build_path = /obj/machinery/bodyscanner
	board_type = new /datum/frame/frame_types/medical_pod
	origin_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)
	req_components = list(
							/obj/item/weapon/stock_parts/scanning_module = 3,
							/obj/item/stack/material/glass/reinforced = 2)

/obj/item/weapon/circuitboard/sleeper
	name = T_BOARD("sleeper")
	build_path = /obj/machinery/sleeper
	board_type = new /datum/frame/frame_types/medical_pod
	origin_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)
	req_components = list(
							/obj/item/weapon/stock_parts/manipulator = 1,
							/obj/item/weapon/stock_parts/scanning_module = 1,
							/obj/item/weapon/reagent_containers/glass/beaker = 3,
							/obj/item/weapon/reagent_containers/syringe = 3,
							/obj/item/stack/material/glass/reinforced = 2)

/obj/item/weapon/circuitboard/vr_sleeper
	name = T_BOARD("VR sleeper")
	build_path = /obj/machinery/vr_sleeper
	board_type = new /datum/frame/frame_types/medical_pod
	origin_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)
	req_components = list(
							/obj/item/weapon/stock_parts/scanning_module = 1,
							/obj/item/stack/material/glass/reinforced = 2)

/obj/item/weapon/circuitboard/dna_analyzer
	name = T_BOARD("dna analyzer")
	build_path = /obj/machinery/dnaforensics
	board_type = new /datum/frame/frame_types/dna_analyzer
	origin_tech = list(TECH_MAGNET = 4, TECH_BIO = 2, TECH_DATA = 2)
	req_components = list(
							/obj/item/weapon/stock_parts/scanning_module = 2,
							/obj/item/weapon/stock_parts/micro_laser = 1,
							/obj/item/weapon/stock_parts/console_screen = 1)

/obj/item/weapon/circuitboard/mass_driver
	name = T_BOARD("mass driver")
	build_path = /obj/machinery/mass_driver
	board_type = new /datum/frame/frame_types/mass_driver
	req_components = list(
							/obj/item/weapon/stock_parts/gear = 2,
							/obj/item/weapon/stock_parts/motor = 2,
							/obj/item/weapon/stock_parts/capacitor = 1,
							/obj/item/weapon/stock_parts/spring = 1,
							/obj/item/stack/cable_coil = 5)

/obj/item/weapon/circuitboard/microwave/advanced
	name = T_BOARD("deluxe microwave")
	build_path = /obj/machinery/microwave/advanced
	board_type = new /datum/frame/frame_types/microwave
	matter = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)
	req_components = list(
							/obj/item/weapon/stock_parts/console_screen = 1,
							/obj/item/weapon/stock_parts/motor = 1,
							/obj/item/weapon/stock_parts/capacitor = 1)

