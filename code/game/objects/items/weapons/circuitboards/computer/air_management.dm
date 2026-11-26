#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/circuitboard/air_management
	name = T_BOARD("atmosphere monitoring console")
	build_path = /obj/machinery/computer/general_air_control
	var/frequency = PUMPS_FREQ
	var/list/sensors = list()

/obj/item/circuitboard/air_management/tank_control
	name = T_BOARD("tank control")
	build_path = /obj/machinery/computer/general_air_control/large_tank_control
	frequency = PUBLIC_LOW_FREQ

/obj/item/circuitboard/air_management/supermatter_core
	name = T_BOARD("core control")
	build_path = /obj/machinery/computer/general_air_control/supermatter_core
	frequency = ENGINE_FREQ

/obj/item/circuitboard/air_management/injector_control
	name = T_BOARD("injector control")
	build_path = /obj/machinery/computer/general_air_control/fuel_injection

/obj/item/circuitboard/air_management/storage_monitor
	name = T_BOARD("ship gas storage monitoring")
	build_path = /obj/machinery/computer/general_air_control/storage_monitor
	frequency = ATMOMETER_FREQ
	sensors = list(
		"dist_main_meter"="Distribution Loop",
		"scrub_main_meter"="Scrubbers Loop",
		"mair_main_meter"="Standard Air Mix Tank Meter",
		"aux_mix_meter"="Gas Mixing Buffer",
		"n2_tank"="Nitrogen Reserves",
		"o2_tank"="Oxygen Reserves",
		"no2_tank"="Nitrous Oxide Reserves",
		"phoron_tank"="Phoron Reserves",
		"co2_tank"="Carbon Dioxide Reserves",
		"engine_fuel"="Engine Fuel"
		)

/obj/item/circuitboard/air_management/storage_monitor/station
	name = T_BOARD("station gas storage monitoring")
	build_path = /obj/machinery/computer/general_air_control/storage_monitor/station
	frequency = ATMOMETER_FREQ
	sensors = list(
		"dist_main_meter"="Distribution Loop",
		"scrub_main_meter"="Scrubbers Loop",
		"mair_main_meter"="Standard Air Mix Meter",
		"aux_mix_meter"="Gas Mixing Buffer",
		"n2_tank"="Nitrogen Reserves",
		"o2_tank"="Oxygen Reserves",
		"no2_tank"="Nitrous Oxide Reserves",
		"phoron_tank"="Phoron Reserves",
		"co2_tank"="Carbon Dioxide Reserves",
		"mining_air"="Outpost Air Reserves"
		)

/obj/item/circuitboard/air_management/construct(obj/machinery/computer/general_air_control/C)
	if (..(C))
		C.frequency = frequency
		C.sensors = sensors

/obj/item/circuitboard/air_management/atom_deconstruct(disassembled = TRUE, obj/machinery/computer/general_air_control/C)
	if (..(C))
		frequency = C.frequency
		sensors = C.sensors
