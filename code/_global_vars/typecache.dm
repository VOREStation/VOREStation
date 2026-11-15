//please store common type caches here.
//type caches should only be stored here if used in mutiple places or likely to be used in mutiple places.

//Note: typecache can only replace istype if you know for sure the thing is at least a datum.

GLOBAL_LIST_INIT(typecache_stack, typecacheof(/obj/item/stack))

/// A typecache listing structures that are considered to have surfaces that you can place items on that are higher than the floor. This, of course, should be restricted to /atom/movables. This is primarily used for food decomposition code.
GLOBAL_LIST_INIT(typecache_elevated_structures, typecacheof(list(
	/obj/machinery,
	/obj/structure,
	/obj/structure/table,
	//Kitchen
	/obj/machinery/smartfridge,
	/obj/structure/bonfire,
	/obj/structure/fireplace,
	/obj/machinery/appliance/cooker/grill,
//	/obj/machinery/griddle,
	/obj/machinery/appliance/cooker/fryer,
	/obj/machinery/processor,
	/obj/machinery/microwave,
	/obj/machinery/appliance/cooker/oven,
	/obj/machinery/gibber,
	/obj/machinery/icecream_vat,
	//Botany
	/obj/machinery/biogenerator,
	/obj/machinery/portable_atmospherics/hydroponics, // So that harvest doesn't catch germs or decompose (includes dirt piles)
	//Medbay
	/obj/machinery/atmospherics/unary/cryo_cell,
	/obj/machinery/chem_master, // Pills may catch germs
)))
