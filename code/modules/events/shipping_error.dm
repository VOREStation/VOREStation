/datum/event/shipping_error/start()
	var/datum/supply_order/O = new /datum/supply_order()
	O.ordernum = supply_controller.ordernum
	O.object = supply_controller.supply_pack[pick(supply_controller.supply_pack)]
	O.ordered_by = random_name(pick(MALE,FEMALE), species = SPECIES_HUMAN)
	supply_controller.shoppinglist += O