/datum/event2/meta/shipping_error
	name = "shipping error"
	departments = list(DEPARTMENT_CARGO)
	chaos = -10 // A helpful event.
	reusable = TRUE
	event_type = /datum/event2/event/shipping_error

/datum/event2/meta/shipping_error/get_weight()
	return (metric.count_people_with_job(/datum/job/cargo_tech) + metric.count_people_with_job(/datum/job/qm)) * 30

/datum/event2/event/shipping_error/start()
	var/datum/supply_order/O = new /datum/supply_order()
	O.ordernum = SSsupply.ordernum
	O.object = SSsupply.supply_pack[pick(SSsupply.supply_pack)]
	O.ordered_by = random_name(pick(MALE,FEMALE), species = "Human")
	SSsupply.shoppinglist += O
