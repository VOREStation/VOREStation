#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

//Circuitboards for frames (mostly wall based frames).  Most of these don't fit into other categories.

//Display

/obj/item/weapon/circuitboard/guestpass
	name = T_BOARD("guestpass console")
	build_path = /obj/machinery/computer/guestpass
	board_type = "guestpass"
	matter = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)

/obj/item/weapon/circuitboard/status_display
	name = T_BOARD("status display")
	build_path = /obj/machinery/status_display
	board_type = "display"
	matter = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)

/obj/item/weapon/circuitboard/ai_status_display
	name = T_BOARD("ai status display")
	build_path = /obj/machinery/ai_status_display
	board_type = "display"
	matter = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)

/obj/item/weapon/circuitboard/newscaster
	name = T_BOARD("newscaster")
	build_path = /obj/machinery/newscaster
	board_type = "newscaster"
	matter = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)

/obj/item/weapon/circuitboard/atm
	name = T_BOARD("atm")
	build_path = /obj/machinery/atm
	board_type = "atm"
	matter = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)

//Alarm

/obj/item/weapon/circuitboard/firealarm
	name = T_BOARD("fire alarm")
	build_path = /obj/machinery/firealarm
	board_type = "firealarm"
	matter = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)

/obj/item/weapon/circuitboard/airalarm
	name = T_BOARD("air alarm")
	build_path = /obj/machinery/alarm
	board_type = "airalarm"
	matter = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)

/obj/item/weapon/circuitboard/intercom
	name = T_BOARD("intercom")
	build_path = /obj/item/device/radio/intercom
	board_type = "intercom"
	matter = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)

/obj/item/weapon/circuitboard/keycard_auth
	name = T_BOARD("keycard authenticator")
	build_path = /obj/machinery/keycard_auth
	board_type = "keycard"
	matter = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)

//Computer

/obj/item/weapon/circuitboard/holopad
	name = T_BOARD("holopad")
	build_path = /obj/machinery/hologram/holopad
	board_type = "holopad"
	matter = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)

//Machine

/obj/item/weapon/circuitboard/photocopier
	name = T_BOARD("photocopier")
	build_path = /obj/machinery/photocopier
	board_type = "photocopier"
	matter = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)
	req_components = list(
							"/obj/item/weapon/stock_parts/scanning_module" = 1,
							"/obj/item/weapon/stock_parts/motor" = 1,
							"/obj/item/weapon/stock_parts/micro_laser" = 1,
							"/obj/item/weapon/stock_parts/matter_bin" = 1)

/obj/item/weapon/circuitboard/fax
	name = T_BOARD("fax")
	build_path = /obj/machinery/photocopier/faxmachine
	board_type = "fax"
	matter = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)
	req_components = list(
							"/obj/item/weapon/stock_parts/scanning_module" = 1,
							"/obj/item/weapon/stock_parts/motor" = 1,
							"/obj/item/weapon/stock_parts/micro_laser" = 1,
							"/obj/item/weapon/stock_parts/matter_bin" = 1)

/obj/item/weapon/circuitboard/conveyor
	name = T_BOARD("conveyor")
	build_path = /obj/machinery/conveyor
	board_type = "conveyor"
	req_components = list(
							"/obj/item/weapon/stock_parts/gear" = 2,
							"/obj/item/weapon/stock_parts/motor" = 2,
							"/obj/item/stack/cable_coil" = 5)

/obj/item/weapon/circuitboard/microwave
	name = T_BOARD("microwave")
	build_path = /obj/machinery/microwave
	board_type = "microwave"
	matter = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)
	req_components = list(
							"/obj/item/weapon/stock_parts/console_screen" = 1,
							"/obj/item/weapon/stock_parts/motor" = 1,
							"/obj/item/weapon/stock_parts/capacitor" = 1)

/obj/item/weapon/circuitboard/vending
	name = T_BOARD("vending")
	build_path = /obj/machinery/vending
	board_type = "vending"
	matter = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)
	req_components = list(
							"/obj/item/weapon/stock_parts/console_screen" = 1,
							"/obj/item/weapon/stock_parts/motor" = 2,
							"/obj/item/weapon/stock_parts/spring" = 2,
							"/obj/item/stack/material/glass/reinforced" = 2)

/obj/item/weapon/circuitboard/recharger
	name = T_BOARD("recharger")
	build_path = /obj/machinery/recharger
	board_type = "recharger"
	matter = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)
	req_components = list(
							"/obj/item/weapon/stock_parts/capacitor" = 1,
							"/obj/item/stack/cable_coil" = 5)

/obj/item/weapon/circuitboard/recharger/wrecharger
	name = T_BOARD("wall recharger")
	build_path = /obj/machinery/recharger/wallcharger
	board_type = "wrecharger"

/obj/item/weapon/circuitboard/washing
	name = T_BOARD("washing machine")
	build_path = /obj/machinery/washing_machine
	board_type = "washing"
	matter = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)
	req_components = list(
							"/obj/item/weapon/stock_parts/motor" = 1,
							"/obj/item/weapon/stock_parts/gear" = 2)

/obj/item/weapon/circuitboard/grinder
	name = T_BOARD("reagent grinder")
	build_path = /obj/machinery/reagentgrinder
	board_type = "grinder"
	matter = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)
	req_components = list(
							"/obj/item/weapon/stock_parts/motor" = 1,
							"/obj/item/weapon/stock_parts/gear" = 1,
							"/obj/item/weapon/reagent_containers/glass/beaker/large" = 1)

//for testing - If this is still in when I commit, someone shoot me. --leaving in for now, shouldn't be able to get these on station anyways.
/obj/item/weapon/storage/box/frame_parts
	display_contents_with_number = 1
	New()
		..()
		new /obj/item/weapon/circuitboard/guestpass( src )
		new /obj/item/weapon/circuitboard/status_display( src )
		new /obj/item/weapon/circuitboard/ai_status_display( src )
		new /obj/item/weapon/circuitboard/newscaster( src )
		new /obj/item/weapon/circuitboard/atm( src )
		new /obj/item/weapon/circuitboard/firealarm( src )
		new /obj/item/weapon/circuitboard/airalarm( src )
		new /obj/item/weapon/circuitboard/intercom( src )
		new /obj/item/weapon/circuitboard/keycard_auth( src )
		new /obj/item/weapon/circuitboard/holopad( src )
		new /obj/item/weapon/circuitboard/photocopier( src )
		new /obj/item/weapon/circuitboard/fax( src )
		new /obj/item/weapon/circuitboard/microwave( src )
		new /obj/item/weapon/circuitboard/vending( src )
		new /obj/item/weapon/circuitboard/washing( src )
		new /obj/item/weapon/stock_parts/scanning_module( src )
		new /obj/item/weapon/stock_parts/motor( src )
		new /obj/item/weapon/stock_parts/micro_laser( src )
		new /obj/item/weapon/stock_parts/matter_bin( src )
		new /obj/item/weapon/stock_parts/gear( src )
		new /obj/item/weapon/stock_parts/console_screen( src )
		new /obj/item/weapon/stock_parts/capacitor( src )
		new /obj/item/weapon/stock_parts/spring( src )
		new /obj/item/weapon/stock_parts/scanning_module( src )
		new /obj/item/weapon/stock_parts/motor( src )
		new /obj/item/weapon/stock_parts/micro_laser( src )
		new /obj/item/weapon/stock_parts/matter_bin( src )
		new /obj/item/weapon/stock_parts/gear( src )
		new /obj/item/weapon/stock_parts/console_screen( src )
		new /obj/item/weapon/stock_parts/capacitor( src )
		new /obj/item/weapon/stock_parts/spring( src )
		new /obj/item/weapon/stock_parts/scanning_module( src )
		new /obj/item/weapon/stock_parts/motor( src )
		new /obj/item/weapon/stock_parts/micro_laser( src )
		new /obj/item/weapon/stock_parts/matter_bin( src )
		new /obj/item/weapon/stock_parts/gear( src )
		new /obj/item/weapon/stock_parts/console_screen( src )
		new /obj/item/weapon/stock_parts/capacitor( src )
		new /obj/item/weapon/stock_parts/spring( src )
		new /obj/item/weapon/stock_parts/scanning_module( src )
		new /obj/item/weapon/stock_parts/motor( src )
		new /obj/item/weapon/stock_parts/micro_laser( src )
		new /obj/item/weapon/stock_parts/matter_bin( src )
		new /obj/item/weapon/stock_parts/gear( src )
		new /obj/item/weapon/stock_parts/console_screen( src )
		new /obj/item/weapon/stock_parts/capacitor( src )
		new /obj/item/weapon/stock_parts/spring( src )
		new /obj/item/weapon/stock_parts/scanning_module( src )
		new /obj/item/weapon/stock_parts/motor( src )
		new /obj/item/weapon/stock_parts/micro_laser( src )
		new /obj/item/weapon/stock_parts/matter_bin( src )
		new /obj/item/weapon/stock_parts/gear( src )
		new /obj/item/weapon/stock_parts/console_screen( src )
		new /obj/item/weapon/stock_parts/capacitor( src )
		new /obj/item/weapon/stock_parts/spring( src )
		new /obj/item/weapon/stock_parts/scanning_module( src )
		new /obj/item/weapon/stock_parts/motor( src )
		new /obj/item/weapon/stock_parts/micro_laser( src )
		new /obj/item/weapon/stock_parts/matter_bin( src )
		new /obj/item/weapon/stock_parts/gear( src )
		new /obj/item/weapon/stock_parts/console_screen( src )
		new /obj/item/weapon/stock_parts/capacitor( src )
		new /obj/item/weapon/stock_parts/spring( src )
		new /obj/item/weapon/stock_parts/scanning_module( src )
		new /obj/item/weapon/stock_parts/motor( src )
		new /obj/item/weapon/stock_parts/micro_laser( src )
		new /obj/item/weapon/stock_parts/matter_bin( src )
		new /obj/item/weapon/stock_parts/gear( src )
		new /obj/item/weapon/stock_parts/console_screen( src )
		new /obj/item/weapon/stock_parts/capacitor( src )
		new /obj/item/weapon/stock_parts/spring( src )
		new /obj/item/weapon/stock_parts/scanning_module( src )
		new /obj/item/weapon/stock_parts/motor( src )
		new /obj/item/weapon/stock_parts/micro_laser( src )
		new /obj/item/weapon/stock_parts/matter_bin( src )
		new /obj/item/weapon/stock_parts/gear( src )
		new /obj/item/weapon/stock_parts/console_screen( src )
		new /obj/item/weapon/stock_parts/capacitor( src )
		new /obj/item/weapon/stock_parts/spring( src )
		new /obj/item/weapon/stock_parts/scanning_module( src )
		new /obj/item/weapon/stock_parts/motor( src )
		new /obj/item/weapon/stock_parts/micro_laser( src )
		new /obj/item/weapon/stock_parts/matter_bin( src )
		new /obj/item/weapon/stock_parts/gear( src )
		new /obj/item/weapon/stock_parts/console_screen( src )
		new /obj/item/weapon/stock_parts/capacitor( src )
		new /obj/item/weapon/stock_parts/spring( src )
		new /obj/item/stack/cable_coil( src , 5 )
		new /obj/item/stack/material/glass/reinforced( src , 2 )