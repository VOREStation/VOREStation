//////////////////////////
// Circuits and Research
//////////////////////////

// Tesla coils are built as machines using a circuit researchable in RnD
/obj/item/circuitboard/tesla_coil
	name = T_BOARD("tesla coil")
	build_path = /obj/machinery/power/tesla_coil
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_MAGNET = 2, TECH_POWER = 4)
	req_components = list(/obj/item/stock_parts/capacitor = 1)

/datum/design/circuit/tesla_coil
	name = "Machine Design (Tesla Coil Board)"
	desc = "The circuit board for a tesla coil."
	id = "tesla_coil"
	build_path = /obj/item/circuitboard/tesla_coil
	req_tech = list(TECH_MAGNET = 2, TECH_POWER = 4)
	sort_string = "MAAAC"

// Grounding rods can be built as machines using a circuit made in an autolathe.
/obj/item/circuitboard/grounding_rod
	name = T_BOARD("grounding rod")
	build_path = /obj/machinery/power/grounding_rod
	board_type = new /datum/frame/frame_types/machine
	matter = list(MAT_STEEL = 50, MAT_GLASS = 50)
	origin_tech = list(TECH_MAGNET = 1, TECH_POWER = 2)
	req_components = list()

/datum/category_item/autolathe/engineering/grounding_rod
	name = "grounding rod electronics"
	path = /obj/item/circuitboard/grounding_rod

// SPECIAL BOARDS BELOW

/obj/item/circuitboard/tesla_coil/attackby(obj/item/I as obj, mob/user as mob)
	if(I.has_tool_quality(TOOL_MULTITOOL))
		var/result = tgui_input_list(user, "What do you want to reconfigure the board to?", "Multitool-Circuitboard interface", list("Standard", "Relay", "Prism", "Amplifier", "Recaster", "Collector"))
		switch(result)
			if("Standard")
				name = T_BOARD("tesla coil")
				build_path = /obj/machinery/power/tesla_coil
			if("Relay")
				name = T_BOARD("tesla relay coil")
				build_path = /obj/machinery/power/tesla_coil/relay
			if("Prism")
				name = T_BOARD("tesla prism coil")
				build_path = /obj/machinery/power/tesla_coil/splitter
			if("Amplifier")
				name = T_BOARD("tesla amplifier coil")
				build_path = /obj/machinery/power/tesla_coil/amplifier
			if("Recaster")
				name = T_BOARD("tesla recaster coil")
				build_path = /obj/machinery/power/tesla_coil/recaster
			if("Collector")
				name = T_BOARD("tesla collector coil")
				build_path = /obj/machinery/power/tesla_coil/collector
	return
