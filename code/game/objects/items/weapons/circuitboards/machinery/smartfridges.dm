#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/circuitboard/smartfridge
	name = T_BOARD("smartfridge")
	build_path = /obj/machinery/smartfridge
	board_type = new /datum/frame/frame_types/machine
	hidden = TRUE
	req_components = list(
							/obj/item/stock_parts/motor = 1,
							/obj/item/stock_parts/gear = 2)

/obj/item/circuitboard/smartfridge/drying
	name = T_BOARD("smartfridge - drying rack")
	build_path = /obj/machinery/smartfridge/drying_rack
	hidden = FALSE

/obj/item/circuitboard/smartfridge/sheets
	name = T_BOARD("smartfridge - industrial sheet storage")
	build_path = /obj/machinery/smartfridge/sheets
	hidden = FALSE

/obj/item/circuitboard/smartfridge/sheets/mining
	name = T_BOARD("smartfridge - mining sheet storage")
	build_path = /obj/machinery/smartfridge/sheets/mining
	hidden = FALSE

/obj/item/circuitboard/smartfridge/medbay
	name = T_BOARD("smartfridge - refrigerated medicine storage")
	build_path = /obj/machinery/smartfridge/medbay
	hidden = FALSE

/obj/item/circuitboard/smartfridge/medbay/secure
	name = T_BOARD("smartfridge - secure refrigerated medicine storage")
	build_path = /obj/machinery/smartfridge/secure/medbay
	hidden = FALSE

/obj/item/circuitboard/smartfridge/science
	name = T_BOARD("smartfridge - biological sample storage")
	build_path = /obj/machinery/smartfridge/secure/extract
	hidden = FALSE

/obj/item/circuitboard/smartfridge/kitchen
	name = T_BOARD("smartfridge - food storage")
	build_path = /obj/machinery/smartfridge/chef
	hidden = FALSE

/obj/item/circuitboard/smartfridge/drinks
	name = T_BOARD("smartfridge - drink storage")
	build_path = /obj/machinery/smartfridge/drinks
	hidden = FALSE

/obj/item/circuitboard/smartfridge/drinks/showcase
	name = T_BOARD("smartfridge - drink showcase")
	build_path = /obj/machinery/smartfridge/drinks/showcase
	hidden = FALSE

/obj/item/circuitboard/smartfridge/produce
	name = T_BOARD("smartfridge - smart produce storage")
	build_path = /obj/machinery/smartfridge/produce
	hidden = FALSE

/obj/item/circuitboard/smartfridge/seeds
	name = T_BOARD("smartfridge - megaSeed servitor")
	build_path = /obj/machinery/smartfridge/seeds
	hidden = FALSE

//these 2 are weird af
/obj/item/circuitboard/smartfridge/chemvator
	name = T_BOARD("smartfridge - smart chemavator - upper")
	build_path = /obj/machinery/smartfridge/chemistry/chemvator
	hidden = FALSE

/obj/item/circuitboard/smartfridge/chemvator/down
	name = T_BOARD("smartfridge - smart chemavator - lower")
	build_path = /obj/machinery/smartfridge/chemistry/chemvator/down
	hidden = FALSE
