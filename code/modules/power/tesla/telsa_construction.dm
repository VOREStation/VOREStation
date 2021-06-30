//////////////////////////
// Circuits and Research
//////////////////////////

// Tesla coils are built as machines using a circuit researchable in RnD
/obj/item/weapon/circuitboard/tesla_coil
	name = T_BOARD("tesla coil")
	build_path = /obj/machinery/power/tesla_coil
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_MAGNET = 2, TECH_POWER = 4)
	req_components = list(/obj/item/weapon/stock_parts/capacitor = 1)

/datum/design/circuit/tesla_coil
	name = "Machine Design (Tesla Coil Board)"
	desc = "The circuit board for a tesla coil."
	id = "tesla_coil"
	build_path = /obj/item/weapon/circuitboard/tesla_coil
	req_tech = list(TECH_MAGNET = 2, TECH_POWER = 4)
	sort_string = "MAAAC"

// Grounding rods can be built as machines using a circuit made in an autolathe.
/obj/item/weapon/circuitboard/grounding_rod
	name = T_BOARD("grounding rod")
	build_path = /obj/machinery/power/grounding_rod
	board_type = new /datum/frame/frame_types/machine
	matter = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)
	req_components = list()

/datum/category_item/autolathe/engineering/grounding_rod
	name = "grounding rod electronics"
	path = /obj/item/weapon/circuitboard/grounding_rod
