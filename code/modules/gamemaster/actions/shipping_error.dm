/datum/gm_action/shipping_error
	name = "shipping error"
	departments = list(ROLE_CARGO)
	reusable = TRUE

/datum/gm_action/shipping_error/get_weight()
	var/cargo = metric.count_people_in_department(ROLE_CARGO)
	var/weight = (cargo * 40)
	return weight

/datum/gm_action/shipping_error/start()
	..()
	var/datum/supply_order/O = new /datum/supply_order()
	O.ordernum = supply_controller.ordernum
	O.object = supply_controller.supply_packs[pick(supply_controller.supply_packs)]
	O.orderedby = random_name(pick(MALE,FEMALE), species = "Human")
	supply_controller.shoppinglist += O