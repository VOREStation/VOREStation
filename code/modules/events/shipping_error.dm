/datum/event/shipping_error/start()
	var/datum/supply_order/O = new /datum/supply_order()
	O.ordernum = SSsupply.ordernum
	O.object = SSsupply.supply_pack[pick(SSsupply.supply_pack)]
	O.ordered_by = random_name(pick(MALE,FEMALE), species = SPECIES_HUMAN)
	SSsupply.shoppinglist += O
