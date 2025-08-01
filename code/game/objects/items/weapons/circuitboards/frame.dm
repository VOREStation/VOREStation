#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

//Circuitboards for frames (mostly wall based frames).  Most of these don't fit into other categories.

//Display

/obj/item/circuitboard/guestpass
	name = T_BOARD("guestpass console")
	build_path = /obj/machinery/computer/guestpass
	board_type = new /datum/frame/frame_types/guest_pass_console
	matter = list(MAT_STEEL = 50, MAT_GLASS = 50)

/obj/item/circuitboard/status_display
	name = T_BOARD("status display")
	build_path = /obj/machinery/status_display
	board_type = new /datum/frame/frame_types/display
	matter = list(MAT_STEEL = 50, MAT_GLASS = 50)

/obj/item/circuitboard/ai_status_display
	name = T_BOARD("ai status display")
	build_path = /obj/machinery/ai_status_display
	board_type = new /datum/frame/frame_types/display
	matter = list(MAT_STEEL = 50, MAT_GLASS = 50)

/obj/item/circuitboard/newscaster
	name = T_BOARD("newscaster")
	build_path = /obj/machinery/newscaster
	board_type = new /datum/frame/frame_types/newscaster
	matter = list(MAT_STEEL = 50, MAT_GLASS = 50)

/obj/item/circuitboard/atm
	name = T_BOARD("atm")
	build_path = /obj/machinery/atm
	board_type = new /datum/frame/frame_types/atm
	matter = list(MAT_STEEL = 50, MAT_GLASS = 50)

/obj/item/circuitboard/request
	name = T_BOARD("request console")
	build_path = /obj/machinery/requests_console
	board_type = new /datum/frame/frame_types/supply_request_console
	matter = list(MAT_STEEL = 50, MAT_GLASS = 50)

//Alarm

/obj/item/circuitboard/firealarm
	name = T_BOARD("fire alarm")
	build_path = /obj/machinery/firealarm
	board_type = new /datum/frame/frame_types/fire_alarm
	matter = list(MAT_STEEL = 50, MAT_GLASS = 50)

/obj/item/circuitboard/airalarm
	name = T_BOARD("air alarm")
	build_path = /obj/machinery/alarm
	board_type = new /datum/frame/frame_types/air_alarm
	matter = list(MAT_STEEL = 50, MAT_GLASS = 50)

/obj/item/circuitboard/intercom
	name = T_BOARD("intercom")
	build_path = /obj/item/radio/intercom
	board_type = new /datum/frame/frame_types/intercom
	matter = list(MAT_STEEL = 50, MAT_GLASS = 50)


/obj/item/circuitboard/intercom/Destroy()
	if(istype(loc, /obj/item/radio/intercom))
		var/obj/item/radio/intercom/my_machine = loc
		my_machine.circuit = null
	. = ..()

/obj/item/circuitboard/keycard_auth
	name = T_BOARD("keycard authenticator")
	build_path = /obj/machinery/keycard_auth
	board_type = new /datum/frame/frame_types/keycard_authenticator
	matter = list(MAT_STEEL = 50, MAT_GLASS = 50)

/obj/item/circuitboard/geiger
	name = T_BOARD("geiger counter")
	build_path = /obj/item/geiger/wall
	board_type = new /datum/frame/frame_types/geiger
	matter = list(MAT_STEEL = 50, MAT_GLASS = 50)

/obj/item/circuitboard/electrochromic
	name = T_BOARD("electrochromic button")
	build_path = /obj/machinery/button/windowtint
	board_type = new /datum/frame/frame_types/button
	matter = list(MAT_STEEL = 50, MAT_GLASS = 50)

//Computer

/obj/item/circuitboard/holopad
	name = T_BOARD("holopad")
	build_path = /obj/machinery/hologram/holopad
	board_type = new /datum/frame/frame_types/holopad
	matter = list(MAT_STEEL = 50, MAT_GLASS = 50)

/obj/item/circuitboard/scanner_console
	name = T_BOARD("body scanner console")
	build_path = /obj/machinery/body_scanconsole
	board_type = new /datum/frame/frame_types/medical_console
	origin_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)

/obj/item/circuitboard/sleeper_console
	name = T_BOARD("sleeper console")
	build_path = /obj/machinery/sleep_console
	board_type = new /datum/frame/frame_types/medical_console
	origin_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)

//Machine

/obj/item/circuitboard/photocopier
	name = T_BOARD("photocopier")
	build_path = /obj/machinery/photocopier
	board_type = new /datum/frame/frame_types/photocopier
	matter = list(MAT_STEEL = 50, MAT_GLASS = 50)
	req_components = list(
							/obj/item/stock_parts/scanning_module = 1,
							/obj/item/stock_parts/motor = 1,
							/obj/item/stock_parts/micro_laser = 1,
							/obj/item/stock_parts/matter_bin = 1)

/obj/item/circuitboard/fax
	name = T_BOARD("fax")
	build_path = /obj/machinery/photocopier/faxmachine
	board_type = new /datum/frame/frame_types/fax
	matter = list(MAT_STEEL = 50, MAT_GLASS = 50)
	req_components = list(
							/obj/item/stock_parts/scanning_module = 1,
							/obj/item/stock_parts/motor = 1,
							/obj/item/stock_parts/micro_laser = 1,
							/obj/item/stock_parts/matter_bin = 1)

/obj/item/circuitboard/conveyor
	name = T_BOARD("conveyor")
	build_path = /obj/machinery/conveyor
	board_type = new /datum/frame/frame_types/conveyor
	req_components = list(
							/obj/item/stock_parts/gear = 2,
							/obj/item/stock_parts/motor = 2,
							/obj/item/stack/cable_coil = 5)

/obj/item/circuitboard/recharger
	name = T_BOARD("recharger")
	build_path = /obj/machinery/recharger
	board_type = new /datum/frame/frame_types/recharger
	req_components = list(
							/obj/item/stock_parts/capacitor = 1,
							/obj/item/stack/cable_coil = 5)

/obj/item/circuitboard/recharger/wrecharger
	name = T_BOARD("wall recharger")
	build_path = /obj/machinery/recharger/wallcharger
	board_type = new /datum/frame/frame_types/wall_charger

/obj/item/circuitboard/cell_charger
	name = T_BOARD("heavy-duty cell charger")
	build_path = /obj/machinery/cell_charger
	board_type = new /datum/frame/frame_types/cell_charger
	req_components = list(
							/obj/item/stock_parts/capacitor = 1,
							/obj/item/stack/cable_coil = 5)

/obj/item/circuitboard/washing
	name = T_BOARD("washing machine")
	build_path = /obj/machinery/washing_machine
	board_type = new /datum/frame/frame_types/washing_machine
	matter = list(MAT_STEEL = 50, MAT_GLASS = 50)
	req_components = list(
							/obj/item/stock_parts/motor = 1,
							/obj/item/stock_parts/gear = 2)

/obj/item/circuitboard/grinder
	name = T_BOARD("reagent grinder")
	build_path = /obj/machinery/reagentgrinder
	board_type = new /datum/frame/frame_types/grinder
	req_components = list(
							/obj/item/stock_parts/motor = 1,
							/obj/item/stock_parts/gear = 1,
							/obj/item/reagent_containers/glass/beaker/large = 1)

/obj/item/circuitboard/distiller
	build_path = /obj/machinery/portable_atmospherics/powered/reagent_distillery
	board_type = new /datum/frame/frame_types/reagent_distillery
	req_components = list(
							/obj/item/stock_parts/capacitor = 1,
							/obj/item/stock_parts/micro_laser = 1,
							/obj/item/stock_parts/motor = 2,
							/obj/item/stock_parts/gear = 1)

/obj/item/circuitboard/teleporter_hub
	name = T_BOARD("teleporter hub")
	build_path = /obj/machinery/teleport/hub
	board_type = "teleporter_hub"
//	origin_tech = list(TECH_DATA = 2, TECH_BLUESPACE = 4)
	req_components = list(
							/obj/item/stock_parts/scanning_module = 4,
							/obj/item/stock_parts/micro_laser = 4,
							/obj/item/stack/cable_coil = 10)

/obj/item/circuitboard/teleporter_station
	name = T_BOARD("teleporter station")
	build_path = /obj/machinery/teleport/station
	board_type = "teleporter_station"
//	origin_tech = list(TECH_DATA = 2, TECH_BLUESPACE = 3)
	req_components = list(
							/obj/item/stock_parts/console_screen = 1,
							/obj/item/stock_parts/capacitor = 2,
							/obj/item/stack/cable_coil = 10)

/obj/item/circuitboard/body_scanner
	name = T_BOARD("body scanner")
	build_path = /obj/machinery/bodyscanner
	board_type = new /datum/frame/frame_types/medical_pod
	origin_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)
	req_components = list(
							/obj/item/stock_parts/scanning_module = 3,
							/obj/item/stack/material/glass/reinforced = 2)

/obj/item/circuitboard/medical_kiosk
	name = T_BOARD("medical kiosk")
	build_path = /obj/machinery/medical_kiosk
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)
	req_components = list(
							/obj/item/stock_parts/scanning_module = 3,
							/obj/item/stack/material/glass/reinforced = 2)

/obj/item/circuitboard/sleeper
	name = T_BOARD("sleeper")
	build_path = /obj/machinery/sleeper
	board_type = new /datum/frame/frame_types/medical_pod
	origin_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)
	req_components = list(
							/obj/item/stock_parts/manipulator = 1,
							/obj/item/stock_parts/scanning_module = 1,
							/obj/item/reagent_containers/glass/beaker = 3,
							/obj/item/reagent_containers/syringe = 3,
							/obj/item/stack/material/glass/reinforced = 2)

/obj/item/circuitboard/vr_sleeper
	name = T_BOARD("VR sleeper")
	build_path = /obj/machinery/vr_sleeper
	board_type = new /datum/frame/frame_types/medical_pod
	origin_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)
	req_components = list(
							/obj/item/stock_parts/scanning_module = 1,
							/obj/item/stack/material/glass/reinforced = 2)

/obj/item/circuitboard/dna_analyzer
	name = T_BOARD("dna analyzer")
	build_path = /obj/machinery/dnaforensics
	board_type = new /datum/frame/frame_types/dna_analyzer
	origin_tech = list(TECH_MAGNET = 4, TECH_BIO = 2, TECH_DATA = 2)
	req_components = list(
							/obj/item/stock_parts/scanning_module = 2,
							/obj/item/stock_parts/micro_laser = 1,
							/obj/item/stock_parts/console_screen = 1)

/obj/item/circuitboard/mass_driver
	name = T_BOARD("mass driver")
	build_path = /obj/machinery/mass_driver
	board_type = new /datum/frame/frame_types/mass_driver
	req_components = list(
							/obj/item/stock_parts/gear = 2,
							/obj/item/stock_parts/motor = 2,
							/obj/item/stock_parts/capacitor = 1,
							/obj/item/stock_parts/spring = 1,
							/obj/item/stack/cable_coil = 5)

/obj/item/circuitboard/arf_generator
	name = T_BOARD("atmospheric field generator")
	build_path = /obj/machinery/atmospheric_field_generator
	board_type = new /datum/frame/frame_types/arfgs
	origin_tech = list(TECH_MAGNET = 4, TECH_POWER = 4, TECH_BIO = 3)
	req_components = list(
							/obj/item/stock_parts/micro_laser/high = 2,	//field emitters
							/obj/item/stock_parts/scanning_module = 1,	//atmosphere sensor
							/obj/item/stock_parts/capacitor/adv = 1,		//for the JUICE
							/obj/item/stack/cable_coil = 10)


/obj/item/circuitboard/injector_maker
	name = T_BOARD("Ready-to-Use Medicine 3000")
	build_path = /obj/machinery/injector_maker
	board_type = new /datum/frame/frame_types/injector_maker
	origin_tech = list(TECH_BIO = 3, TECH_ENGINEERING = 2, TECH_MATERIAL = 2)
	req_components = list(
							/obj/item/stock_parts/matter_bin = 2,
							/obj/item/stock_parts/manipulator = 1,
							/obj/item/stock_parts/micro_laser = 1,
							/obj/item/stock_parts/console_screen = 1
	)

// Smart centrifuge
/obj/item/circuitboard/smart_centrifuge
	name = T_BOARD("smart centrifuge")
	build_path = /obj/machinery/smart_centrifuge
	board_type = new /datum/frame/frame_types/machine
	matter = list(MAT_STEEL = 50, MAT_GLASS = 50)
	origin_tech = list(TECH_MAGNET = 3, TECH_DATA = 2, TECH_MATERIAL = 3)
	req_components = list(
							/obj/item/stock_parts/scanning_module = 1,
							/obj/item/stock_parts/motor = 1,
							/obj/item/stock_parts/gear = 3,
							/obj/item/stack/material/glass/reinforced = 1)

// Refinery machines
/obj/item/circuitboard/industrial_reagent_grinder
	name = T_BOARD("industrial chemical grinder")
	build_path = /obj/machinery/reagent_refinery/grinder
	board_type = new /datum/frame/frame_types/industrial_reagent_grinder
	req_components = list(
							/obj/item/stock_parts/capacitor = 1,
							/obj/item/stock_parts/motor = 2,
							/obj/item/stock_parts/gear = 2,
							/obj/item/reagent_containers/glass/beaker/large = 1)

/obj/item/circuitboard/industrial_reagent_pump
	name = T_BOARD("industrial chemical pump")
	build_path = /obj/machinery/reagent_refinery/pump
	board_type = new /datum/frame/frame_types/industrial_reagent_pump
	req_components = list(
							/obj/item/stock_parts/motor = 1,
							/obj/item/stack/material/glass/reinforced = 1)

/obj/item/circuitboard/industrial_reagent_filter
	name = T_BOARD("industrial chemical filter")
	build_path = /obj/machinery/reagent_refinery/filter
	board_type = new /datum/frame/frame_types/industrial_reagent_filter
	req_components = list(
							/obj/item/stock_parts/motor = 1,
							/obj/item/stock_parts/scanning_module = 1,
							/obj/item/stock_parts/motor = 1,
							/obj/item/stock_parts/gear = 1,
							/obj/item/stack/material/glass/reinforced = 1)

/obj/item/circuitboard/industrial_reagent_vat
	name = T_BOARD("industrial chemical vat")
	build_path = /obj/machinery/reagent_refinery/vat
	board_type = new /datum/frame/frame_types/industrial_reagent_vat
	req_components = list(
							/obj/item/stock_parts/motor = 1,
							/obj/item/stack/material/glass/reinforced = 1)

/obj/item/circuitboard/industrial_reagent_pipe
	name = T_BOARD("industrial chemical pipe")
	build_path = /obj/machinery/reagent_refinery/pipe
	board_type = new /datum/frame/frame_types/industrial_reagent_pipe
	req_components = list( /obj/item/stack/material/glass/reinforced = 1)

/obj/item/circuitboard/industrial_reagent_waste_processor
	name = T_BOARD("industrial chemical waste processor")
	build_path = /obj/machinery/reagent_refinery/waste_processor
	board_type = new /datum/frame/frame_types/industrial_reagent_waste_processor
	req_components = list(
							/obj/item/stock_parts/capacitor = 4,
							/obj/item/stock_parts/micro_laser = 4,
							/obj/item/stock_parts/manipulator = 1,
							/obj/item/stack/material/glass/reinforced = 1)

/obj/item/circuitboard/industrial_reagent_hub
	name = T_BOARD("industrial chemical hub")
	build_path = /obj/machinery/reagent_refinery/hub
	board_type = new /datum/frame/frame_types/industrial_reagent_hub
	req_components = list(
							/obj/item/stock_parts/motor = 1,
							/obj/item/stock_parts/manipulator = 1)

/obj/item/circuitboard/industrial_reagent_reactor
	name = T_BOARD("industrial chemical reactor")
	build_path = /obj/machinery/reagent_refinery/reactor
	board_type = new /datum/frame/frame_types/industrial_reagent_reactor
	req_components = list(
							/obj/item/stock_parts/motor = 1,
							/obj/item/stock_parts/capacitor = 4,
							/obj/item/stock_parts/micro_laser = 4,
							/obj/item/stock_parts/manipulator = 1,
							/obj/item/stack/material/glass/reinforced = 1)

/obj/item/circuitboard/industrial_reagent_furnace
	name = T_BOARD("industrial chemical sintering furnace")
	build_path = /obj/machinery/reagent_refinery/furnace
	board_type = new /datum/frame/frame_types/industrial_reagent_furnace
	req_components = list(
							/obj/item/stock_parts/motor = 2,
							/obj/item/stock_parts/capacitor = 4,
							/obj/item/stock_parts/scanning_module = 1,
							/obj/item/stock_parts/manipulator = 1,
							/obj/item/stock_parts/gear = 2)

/obj/item/circuitboard/pump_relay
	name = T_BOARD("pump relay")
	build_path = /obj/machinery/pump_relay
	board_type = new /datum/frame/frame_types/machine
	req_components = list(
							/obj/item/stock_parts/capacitor = 1,
							/obj/item/stock_parts/motor = 1)
