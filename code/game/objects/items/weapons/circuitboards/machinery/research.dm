#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/circuitboard/autolathe
	name = T_BOARD("autolathe")
	build_path = /obj/machinery/autolathe
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 2)
	req_components = list(
							/obj/item/stock_parts/matter_bin = 3,
							/obj/item/stock_parts/manipulator = 1,
							/obj/item/stock_parts/console_screen = 1)

/obj/item/circuitboard/machine/protolathe
	name = T_BOARD("protolathe")
	build_path = /obj/machinery/rnd/production/protolathe
	board_type = new /datum/frame/frame_types/machine
	req_components = list(
							/obj/item/stock_parts/matter_bin = 2,
							/obj/item/stock_parts/manipulator = 2,
							/obj/item/reagent_containers/glass/beaker = 2)
	hidden = TRUE // Base types aren't cared for, a fully unlocked lathe shouldn't be easy to make

/obj/item/circuitboard/machine/protolathe/department
	name = T_BOARD("departmental protolathe")
	build_path = /obj/machinery/rnd/production/protolathe/department
/obj/item/circuitboard/machine/protolathe/department/engineering
	name = T_BOARD("departmental protolathe (engineering)")
	build_path = /obj/machinery/rnd/production/protolathe/department/engineering
	hidden = FALSE
/obj/item/circuitboard/machine/protolathe/department/service
	name = T_BOARD("departmental protolathe (service)")
	build_path = /obj/machinery/rnd/production/protolathe/department/service
	hidden = FALSE
/obj/item/circuitboard/machine/protolathe/department/medical
	name = T_BOARD("departmental protolathe (medical)")
	build_path = /obj/machinery/rnd/production/protolathe/department/medical
	hidden = FALSE
/obj/item/circuitboard/machine/protolathe/department/cargo
	name = T_BOARD("departmental protolathe (cargo)")
	build_path = /obj/machinery/rnd/production/protolathe/department/cargo
	hidden = FALSE
/obj/item/circuitboard/machine/protolathe/department/science
	name = T_BOARD("departmental protolathe (science)")
	build_path = /obj/machinery/rnd/production/protolathe/department/science
	hidden = FALSE
/obj/item/circuitboard/machine/protolathe/department/security
	name = T_BOARD("departmental protolathe (security)")
	build_path = /obj/machinery/rnd/production/protolathe/department/security
	hidden = FALSE

/obj/item/circuitboard/circuit_imprinter
	name = T_BOARD("circuit imprinter")
	build_path = /obj/machinery/rnd/production/circuit_imprinter
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 2)
	req_components = list(
							/obj/item/stock_parts/matter_bin = 1,
							/obj/item/stock_parts/manipulator = 1,
							/obj/item/reagent_containers/glass/beaker = 2)

/obj/item/circuitboard/mechfab
	name = T_BOARD("Exosuit Fabricator")
	build_path = /obj/machinery/mecha_part_fabricator_tg
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	req_components = list(
							/obj/item/stock_parts/matter_bin = 2,
							/obj/item/stock_parts/manipulator = 1,
							/obj/item/stock_parts/micro_laser = 1,
							/obj/item/stock_parts/console_screen = 1)

/obj/item/circuitboard/prosthetics
	name = T_BOARD("Prosthetics Fabricator")
	build_path = /obj/machinery/mecha_part_fabricator_tg/prosthetics
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	req_components = list(
							/obj/item/stock_parts/matter_bin = 2,
							/obj/item/stock_parts/manipulator = 1,
							/obj/item/stock_parts/micro_laser = 1,
							/obj/item/stock_parts/console_screen = 1)

/obj/item/circuitboard/ntnet_relay
	name = T_BOARD("NTNet Quantum Relay")
	build_path = /obj/machinery/ntnet_relay
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_DATA = 4)
	req_components = list(
							/obj/item/stack/cable_coil = 15)

/obj/item/circuitboard/protean_reconstitutor
	name = T_BOARD("protean reconstitutor")
	board_type = new /datum/frame/frame_types/machine
	build_path = /obj/machinery/protean_reconstitutor
	origin_tech = list(TECH_MAGNET = 5, TECH_BLUESPACE = 5, TECH_MATERIAL = 5, TECH_ENGINEERING = 5, TECH_DATA = 5)
	req_components = list(
							/obj/item/stock_parts/matter_bin = 1,
							/obj/item/stock_parts/manipulator = 1,
							/obj/item/stock_parts/console_screen = 1,
							/obj/item/stack/cable_coil = 5)

/obj/item/circuitboard/artifact_harvester
	name = T_BOARD("artifact harvester")
	build_path = /obj/machinery/artifact_harvester
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_MATERIAL = 2, TECH_POWER = 4, TECH_ENGINEERING = 2)
	req_components = list(
							/obj/item/stock_parts/capacitor = 5, //Yes, it's ALL capacitors. It's only purpose is to store power!
							/obj/item/stock_parts/console_screen = 1)

/obj/item/circuitboard/artifact_scanpad
	name = T_BOARD("artifact scanpad")
	build_path = /obj/machinery/artifact_scanpad
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_MATERIAL = 2, TECH_POWER = 4, TECH_ENGINEERING = 2)
	req_components = list(
							/obj/item/stock_parts/manipulator = 1,
							/obj/item/stock_parts/console_screen = 1)

/obj/item/circuitboard/destructive_analyzer
	name = T_BOARD("destructive analyzer")
	build_path = /obj/machinery/rnd/destructive_analyzer
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2, TECH_DATA = 2)
	req_components = list(
							/obj/item/stock_parts/scanning_module = 1,
							/obj/item/stock_parts/manipulator = 1,
							/obj/item/stock_parts/micro_laser = 1)

/obj/item/circuitboard/doppler_array
	name = T_BOARD("doppler array")
	build_path = /obj/machinery/doppler_array
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 1, TECH_DATA = 3)
	req_components = list(
							/obj/item/stock_parts/scanning_module = 4)
