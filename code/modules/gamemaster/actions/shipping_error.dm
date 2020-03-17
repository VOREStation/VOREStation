/datum/gm_action/shipping_error
	name = "shipping error"
	departments = list(DEPARTMENT_CARGO)
	reusable = TRUE

/datum/gm_action/shipping_error/get_weight()
	var/cargo = metric.count_people_in_department(DEPARTMENT_CARGO)
	var/weight = (cargo * 40)
	return weight

/datum/gm_action/shipping_error/start()
	..()
	var/datum/supply_order/O = new /datum/supply_order()
	O.ordernum = supply_controller.ordernum
	O.object = supply_controller.supply_pack[pick(supply_controller.supply_pack)]
	O.ordered_by = random_name(pick(MALE,FEMALE), species = "Human")
	supply_controller.shoppinglist += O