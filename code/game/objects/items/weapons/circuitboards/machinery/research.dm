#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/weapon/circuitboard/rdserver
	name = T_BOARD("R&D server")
	build_path = /obj/machinery/r_n_d/server/core
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_DATA = 3)
	req_components = list(
							/obj/item/stack/cable_coil = 2,
							/obj/item/weapon/stock_parts/scanning_module = 1)

/obj/item/weapon/circuitboard/rdserver/attackby(obj/item/I as obj, mob/user as mob)
	if(I.has_tool_quality(TOOL_SCREWDRIVER))
		playsound(src, I.usesound, 50, 1)
		user.visible_message("<b>\The [user]</b> adjusts the jumper on \the [src]'s access protocol pins.", "<span class='notice'>You adjust the jumper on the access protocol pins.</span>")
		if(build_path == /obj/machinery/r_n_d/server/core)
			name = T_BOARD("RD Console - Robotics")
			build_path = /obj/machinery/r_n_d/server/robotics
			to_chat(user, "<span class='notice'>Access protocols set to robotics.</span>")
		else
			name = T_BOARD("RD Console")
			build_path = /obj/machinery/r_n_d/server/core
			to_chat(user, "<span class='notice'>Access protocols set to default.</span>")
	return

/obj/item/weapon/circuitboard/destructive_analyzer
	name = T_BOARD("destructive analyzer")
	build_path = /obj/machinery/r_n_d/destructive_analyzer
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2, TECH_DATA = 2)
	req_components = list(
							/obj/item/weapon/stock_parts/scanning_module = 1,
							/obj/item/weapon/stock_parts/manipulator = 1,
							/obj/item/weapon/stock_parts/micro_laser = 1)

/obj/item/weapon/circuitboard/autolathe
	name = T_BOARD("autolathe")
	build_path = /obj/machinery/autolathe
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 2)
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin = 3,
							/obj/item/weapon/stock_parts/manipulator = 1,
							/obj/item/weapon/stock_parts/console_screen = 1)

/obj/item/weapon/circuitboard/protolathe
	name = T_BOARD("protolathe")
	build_path = /obj/machinery/r_n_d/protolathe
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 2)
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin = 2,
							/obj/item/weapon/stock_parts/manipulator = 2,
							/obj/item/weapon/reagent_containers/glass/beaker = 2)

/obj/item/weapon/circuitboard/circuit_imprinter
	name = T_BOARD("circuit imprinter")
	build_path = /obj/machinery/r_n_d/circuit_imprinter
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 2)
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin = 1,
							/obj/item/weapon/stock_parts/manipulator = 1,
							/obj/item/weapon/reagent_containers/glass/beaker = 2)

/obj/item/weapon/circuitboard/mechfab
	name = "Circuit board (Exosuit Fabricator)"
	build_path = /obj/machinery/mecha_part_fabricator
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin = 2,
							/obj/item/weapon/stock_parts/manipulator = 1,
							/obj/item/weapon/stock_parts/micro_laser = 1,
							/obj/item/weapon/stock_parts/console_screen = 1)

/obj/item/weapon/circuitboard/prosthetics
	name = "Circuit board (Prosthetics Fabricator)"
	build_path = /obj/machinery/mecha_part_fabricator/pros
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin = 2,
							/obj/item/weapon/stock_parts/manipulator = 1,
							/obj/item/weapon/stock_parts/micro_laser = 1,
							/obj/item/weapon/stock_parts/console_screen = 1)

/obj/item/weapon/circuitboard/ntnet_relay
	name = "Circuit board (NTNet Quantum Relay)"
	build_path = /obj/machinery/ntnet_relay
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_DATA = 4)
	req_components = list(
							/obj/item/stack/cable_coil = 15)
