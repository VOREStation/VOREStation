/datum/gm_action/nanotrasen_budget_allocation
	name = "supply point to cargo budget"
	enabled = TRUE
	departments = list(DEPARTMENT_CARGO)
	chaotic = 0
	reusable = TRUE

	var/datum/controller/supply/SC
	var/running = FALSE
	var/last_run

	var/thaler_earned

/datum/gm_action/nanotrasen_budget_allocation/New()
	..()
	SC = supply_controller

/datum/gm_action/nanotrasen_budget_allocation/set_up()
	running = TRUE
	return

/datum/gm_action/nanotrasen_budget_allocation/get_weight()
	. = round(SC.points / 15)

	var/cargo = metric.count_people_in_department(DEPARTMENT_CARGO)
	var/personnel = metric.count_people_in_department(DEPARTMENT_EVERYONE)
	if(cargo)
		. = round(SC.points / (10 + personnel)) + cargo * 10

	if(running || ( world.time < (last_run + 30 MINUTES)))
		. = 0

	return .

/datum/gm_action/nanotrasen_budget_allocation/start()
	. = ..()

	last_run = world.time

	var/point_difference = SC.points

	if(SC.points >= 1000)
		SC.points = round(SC.points / 3)
		point_difference -= SC.points

	else if(SC.points >= 500)
		SC.points -= 100 * (rand(5, 20) / 10)
		point_difference -= SC.points

	else
		SC.points = round(SC.points / 1.25)
		point_difference -= SC.points

	if(point_difference > 0)
		thaler_earned = round(point_difference / SC.points_per_money)

/datum/gm_action/nanotrasen_budget_allocation/end()
	spawn(5 MINUTES)
		running = FALSE
	return

/datum/gm_action/nanotrasen_budget_allocation/announce()
	spawn(rand(1 MINUTE, 5 MINUTES))
		command_announcement.Announce("[station_name()] Supply Department has earned a converted thaler budget of [thaler_earned] due to their backlogged daily requisition tokens.", "Supply Budget Conversion")
	return
