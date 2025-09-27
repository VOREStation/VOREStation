#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/circuitboard/air_management
	name = T_BOARD("atmosphere monitoring console")
	build_path = /obj/machinery/computer/general_air_control
	var/frequency = PUMPS_FREQ

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

/obj/item/circuitboard/air_management/construct(var/obj/machinery/computer/general_air_control/C)
	if (..(C))
		C.frequency = frequency

/obj/item/circuitboard/air_management/deconstruct(var/obj/machinery/computer/general_air_control/C)
	if (..(C))
		frequency = C.frequency
