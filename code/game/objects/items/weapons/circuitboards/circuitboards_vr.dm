#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/weapon/circuitboard/get_examine_desc()
	. = ..()
	if(LAZYLEN(req_components))
		var/list/nice_list = list()
		for(var/B in req_components)
			var/atom/A = B
			if(!ispath(A))
				continue
			nice_list += list("[req_components[A]] [initial(A.name)]")
		. += "Required components: [english_list(nice_list)]."

// VOREStation specific circuit boards!

// Board for the parts lathe in partslathe.dm
/obj/item/weapon/circuitboard/partslathe
	name = T_BOARD("parts lathe")
	build_path = /obj/machinery/partslathe
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 2)
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin = 2,
							/obj/item/weapon/stock_parts/manipulator = 2,
							/obj/item/weapon/stock_parts/console_screen = 1)

// Board for the algae oxygen generator in algae_generator.dm
/obj/item/weapon/circuitboard/algae_farm
	name = T_BOARD("algae oxygen generator")
	build_path = /obj/machinery/atmospherics/binary/algae_farm
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_ENGINEERING = 3, TECH_BIO = 2)
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin = 2,
							/obj/item/weapon/stock_parts/manipulator = 1,
							/obj/item/weapon/stock_parts/capacitor = 1,
							/obj/item/weapon/stock_parts/console_screen = 1)

// Board for the thermal regulator in airconditioner_vr.dm
/obj/item/weapon/circuitboard/thermoregulator
	name = T_BOARD("thermal regulator")
	build_path = /obj/machinery/power/thermoregulator
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_ENGINEERING = 4, TECH_POWER = 3)
	req_components = list(
							/obj/item/stack/cable_coil = 20,
							/obj/item/weapon/stock_parts/capacitor/super = 3)

// Board for the bomb tester in bomb_tester_vr.dm
/obj/item/weapon/circuitboard/bomb_tester
	name = T_BOARD("explosive effect simulator")
	build_path = /obj/machinery/bomb_tester
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_PHORON = 3, TECH_DATA = 2, TECH_MAGNET = 2)
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin/adv = 1,
							/obj/item/weapon/stock_parts/scanning_module = 5)

// Board for the timeclock terminal in timeclock_vr.dm
/obj/item/weapon/circuitboard/timeclock
	name = T_BOARD("timeclock")
	build_path = /obj/machinery/computer/timeclock
	board_type = new /datum/frame/frame_types/timeclock_terminal
	matter = list(MAT_STEEL = 50, MAT_GLASS = 50)

// Board for the ID restorer in id_restorer_vr.dm
/obj/item/weapon/circuitboard/id_restorer
	name = T_BOARD("ID restoration console")
	build_path = /obj/machinery/computer/id_restorer
	board_type = new /datum/frame/frame_types/id_restorer
	matter = list(MAT_STEEL = 50, MAT_GLASS = 50)

/obj/item/weapon/circuitboard/security/xenobio
	name = T_BOARD("xenobiology camera monitor")
	build_path = /obj/machinery/computer/security/xenobio
	network = list(NETWORK_XENOBIO)
	req_access = list()
	matter = list(MAT_STEEL = 50, MAT_GLASS = 50)
