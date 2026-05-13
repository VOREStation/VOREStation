#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/circuitboard/comm_monitor
	name = T_BOARD("telecommunications monitor console")
	build_path = /obj/machinery/computer/telecomms/monitor

/obj/item/circuitboard/comm_server
	name = T_BOARD("telecommunications server monitor console")
	build_path = /obj/machinery/computer/telecomms/server

/obj/item/circuitboard/comm_traffic
	name = T_BOARD("telecommunications traffic control console")
	build_path = /obj/machinery/computer/telecomms/traffic

/obj/item/circuitboard/message_server
	name = T_BOARD("message server")
	build_path = /obj/machinery/message_server
	board_type = new /datum/frame/frame_types/machine
