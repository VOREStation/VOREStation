/obj/item/circuitboard/airlock_cycling
	name = T_BOARD("cycling airlock button")
	build_path = /obj/machinery/access_button
	board_type = new /datum/frame/frame_types/button
	matter = list(MAT_STEEL = 50, MAT_GLASS = 50)

/datum/design/circuit/airlock_cycling
	name = "Machine Design (Cycling Airlock Board)"
	desc = "The circuit board for cycling airlock parts."
	id = "airlock_cycling"
	build_path = /obj/item/circuitboard/airlock_cycling
	req_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 2)
	sort_string = "MAAAD"

/obj/item/circuitboard/airlock_cycling/attackby(obj/item/I as obj, mob/user as mob)
	if(I.has_tool_quality(TOOL_MULTITOOL))
		var/result = tgui_input_list(
			user,
			"What do you want to reconfigure the board to?",
			"Multitool-Circuitboard interface",
			list(
				"Button",
				"Sensor",
				"Controller - Standard",
				"Controller - Advanced",
				"Controller - Access",
			))
		switch(result)
			if("Button")
				name = T_BOARD("cycling airlock button")
				build_path = /obj/machinery/access_button
			if("Sensor")
				name = T_BOARD("cycling airlock sensor")
				build_path = /obj/machinery/airlock_sensor
			if("Controller - Standard")
				name = T_BOARD("cycling airlock controller (simple)")
				build_path = /obj/machinery/embedded_controller/radio/airlock/airlock_controller
			if("Controller - Advanced")
				name = T_BOARD("cycling airlock controller (advanced)")
				build_path = /obj/machinery/embedded_controller/radio/airlock/advanced_airlock_controller
			if("Controller - Access")
				name = T_BOARD("cycling airlock controller (access)")
				build_path = /obj/machinery/embedded_controller/radio/airlock/access_controller
	return
