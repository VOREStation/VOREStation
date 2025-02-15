/var/global/running_demand_events = list()

/hook/sell_shuttle/proc/supply_demand_sell_shuttle(var/area/area_shuttle)
	for(var/datum/event/supply_demand/E in running_demand_events)
		E.handle_sold_shuttle(area_shuttle)
	return 1 // All hooks must return one to show success.

//
// The Supply Demand Event - CentCom asks for us to put some stuff on the shuttle
//
/datum/event/supply_demand
	var/my_department = "Supply Division"
	var/list/required_items = list()
	var/end_time
	announceWhen = 1
	startWhen = 2
	endWhen = 1800 // Aproximately 1 hour in master controller ticks, refined by end_time

/datum/event/supply_demand/setup()
	my_department = "[using_map.company_name] Supply Division" // Can't have company name in initial value (not const)
	end_time = world.time + 1 HOUR + (severity * 30 MINUTES)
	running_demand_events += src
	// Decide what items are requried!
	// We base this on what departmets are most active, excluding departments we don't have
	var/list/notHaveDeptList = metric.departments.Copy()
	notHaveDeptList.Remove(list(DEPARTMENT_ENGINEERING, DEPARTMENT_MEDICAL, DEPARTMENT_RESEARCH, DEPARTMENT_CARGO, DEPARTMENT_CIVILIAN))
	var/deptActivity = metric.assess_all_departments(severity * 2, notHaveDeptList)
	for(var/dept in deptActivity)
		switch(dept)
			if(DEPARTMENT_ENGINEERING)
				choose_atmos_items(severity + 1)
			if(DEPARTMENT_MEDICAL)
				choose_chemistry_items(roll(severity, 2))
			if(DEPARTMENT_RESEARCH) // Would be nice to differentiate between research diciplines
				choose_research_items(roll(severity, 2))
				choose_robotics_items(roll(1, severity))
			if(DEPARTMENT_CARGO)
				choose_alloy_items(rand(1, severity))
			if(DEPARTMENT_CIVILIAN) // Would be nice to separate out chef/gardener/bartender
				choose_food_items(roll(severity, 2))
				choose_bar_items(roll(severity, 2))
	if(required_items.len == 0)
		choose_bar_items(rand(5, 10)) // Really? Well add drinks. If a crew can't even get the bar open they suck.

/datum/event/supply_demand/announce()
	var/message = "[using_map.company_short] is comparing accounts and the bean counters found our division "
	if(severity <= EVENT_LEVEL_MUNDANE)
		message += "is a few items short. "
	else if(severity == EVENT_LEVEL_MODERATE)
		message += "is well... missing some inventory. "
	else
		message += "has a warehouse full of empty crates! "
	message += "We have to fill that gap quick before anyone starts asking questions. "
	message += "You'd better have this stuff here by [worldtime2stationtime(end_time)]<br>"
	message += "The requested items are as follows"
	message += "<hr>"
	for (var/datum/supply_demand_order/req in required_items)
		message += req.describe() + "<br>"
	message += "<hr>"
	message += "Deliver these items to [command_name()] via the supply shuttle.  Please put the ones you can into crates!<br>"

	for(var/dpt in GLOB.req_console_supplies)
		send_console_message(message, dpt);

	// Also announce over main comms so people know to look
	command_announcement.Announce("An order for the [using_map.facility_type] to deliver supplies to [command_name()] has been delivered to all supply Request Consoles", my_department)

/datum/event/supply_demand/tick()
	if(required_items.len == 0)
		endWhen = activeFor  // End early becuase we're done already!

/datum/event/supply_demand/end()
	running_demand_events -= src
	// Check if the crew succeeded or failed!
	if(required_items.len == 0)
		// Success!
		SSsupply.points += 100 * severity
		var/msg = "Great work! With those items you delivered our inventory levels all match up. "
		msg += "[capitalize(pick(first_names_female))] from accounting will have nothing to complain about. "
		msg += "I think you'll find a little something in your supply account."
		command_announcement.Announce(msg, my_department)
	else
		// Fail!
		var/datum/supply_demand_order/random = pick(required_items)
		command_announcement.Announce("What happened? Accounting is here right now and they're already asking where that [random.name] is. Damn, I gotta go", my_department)
		var/message = "The delivery deadline was reached with the following needs outstanding:<hr>"
		for(var/datum/supply_demand_order/req in required_items)
			message += req.describe() + "<br>"
		post_comm_message("'[my_department] Mission Summary'", message)
/**
 * Event Handler for responding to the supply shuttle arriving at centcom.
 */
/datum/event/supply_demand/proc/handle_sold_shuttle(var/area/area_shuttle)
	var/match_found = 0;

	for(var/atom/movable/MA in area_shuttle)
		// Special case to allow us to count mechs!
		if(MA.anchored && !istype(MA, /obj/mecha))	continue // Ignore anchored stuff

		// If its a crate, search inside of it for matching items.
		if(istype(MA, /obj/structure/closet/crate))
			for(var/atom/item_in_crate in MA)
				match_found |= match_item(item_in_crate)
		else
			// Otherwise check it against our list
			match_found |= match_item(MA)

	if(match_found && required_items.len >= 1)
		// Okay we delivered SOME.  Lets give an update, but only if not finished.
		var/message = "Shipment Received.  As a reminder, the following items are still requried:"
		message += "<hr>"
		for (var/datum/supply_demand_order/req in required_items)
			message += req.describe() + "<br>"
		message += "<hr>"
		message += "Deliver these items to [command_name()] via the supply shuttle.  Please put the ones you can into crates!<br>"
		send_console_message(message, "Cargo Bay")

/**
 * Helper method to check an item against the list of required_items.
 */
/datum/event/supply_demand/proc/match_item(var/atom/I)
	for(var/datum/supply_demand_order/meta in required_items)
		if(meta.match_item(I))
			if(meta.qty_need <= 0)
				required_items -= meta
			return 1
	return 0 // Nothing found if we get here

/**
 * Utility method to send message to request consoles.
 * @param message - Message to send
 * @param to_department - Name of department to deliver to, or null to send to all departments.
 * @return 1 if successful, 0 if couldn't send.
 */
/datum/event/supply_demand/proc/send_console_message(var/message, var/to_department)
	for(var/obj/machinery/message_server/MS in world)
		if(!MS.active) continue
		MS.send_rc_message(to_department ? to_department : "All Departments", my_department, message, "", "", 2)

//
//  Supply Demand Datum - Keeps track of what centcomm has demanded
//

/datum/supply_demand_order
	var/name		// Name of the item
	var/qty_orig // How much was requested
	var/qty_need // How much we still need

/datum/supply_demand_order/New(var/qty)
	if(qty) qty_orig = qty
	qty_need = qty_orig

/datum/supply_demand_order/proc/describe()
	return "[name] - (Qty: [qty_need])"

/datum/supply_demand_order/proc/match_item(var/atom/I)
	return 0

//
// Request is for a physical thing
//
/datum/supply_demand_order/thing
	var/atom/type_path // Type path of the item required

/datum/supply_demand_order/thing/New(var/qty, var/atom/type_path)
	..()
	src.type_path = type_path
	src.name = initial(type_path.name)
	if(!name)
		log_debug("supply_demand event: Order for thing [type_path] has no name.")

/datum/supply_demand_order/thing/match_item(var/atom/I)
	if(istype(I, type_path))
		// Hey, we found it!  How we handle it depends on some details tho.
		if(istype(I, /obj/item/stack))
			var/obj/item/stack/S = I
			var amount_to_take = min(S.get_amount(), qty_need)
			S.use(amount_to_take)
			qty_need -= amount_to_take
		else
			qty_need -= 1
			qdel(I)
		return 1

//
// Request is for an amount of some reagent
//
/datum/supply_demand_order/reagent
	var/reagent_id

/datum/supply_demand_order/reagent/New(var/qty, var/datum/reagent/R)
	..()
	name = R.name
	reagent_id = R.id

/datum/supply_demand_order/reagent/describe()
	return "[qty_need] units of [name] in its own container(s)"

// Any reagent container will do now. Whole number units only.
/datum/supply_demand_order/reagent/match_item(var/atom/I)
	if(!I.reagents)
		return
	if(!istype(I, /obj/item/reagent_containers))
		return
	var/amount_to_take = min(I.reagents.get_reagent_amount(reagent_id), qty_need)
	if(amount_to_take >= 1)
		I.reagents.remove_reagent(reagent_id, amount_to_take, safety = 1)
		qty_need = CEILING((qty_need - amount_to_take), 1)
		return 1
	else
		log_debug("supply_demand event: not taking reagent '[reagent_id]': [amount_to_take]")
	return

//
// Request is for a gas mixture.
//	In this case the target is moles!
//
/datum/supply_demand_order/gas
	name = "gas mixture"
	var/datum/gas_mixture/mixture

/datum/supply_demand_order/gas/describe()
	var/pressure = mixture.return_pressure()
	var/total_moles = mixture.total_moles
	var desc = "Canister filled to [round(pressure,0.1)] kPa with gas mixture:\n"
	for(var/gas in mixture.gas)
		desc += "<br>- [gas_data.name[gas]]: [round((mixture.gas[gas] / total_moles) * 100)]%\n"
	return desc

/datum/supply_demand_order/gas/match_item(var/obj/machinery/portable_atmospherics/canister)
	if(!istype(canister))
		return
	var/datum/gas_mixture/canmix = canister.air_contents
	if(!canmix || canmix.total_moles <= 0)
		return
	if(canmix.return_pressure() < mixture.return_pressure())
		log_debug("supply_demand event: canister fails to match [canmix.return_pressure()] kPa < [mixture.return_pressure()] kPa")
		return
	// Make sure ratios are equal
	for(var/gas in mixture.gas)
		var/targetPercent = round((mixture.gas[gas] / mixture.total_moles) * 100)
		var/canPercent = round((canmix.gas[gas] / canmix.total_moles) * 100)
		if(abs(targetPercent-canPercent) > 1)
			log_debug("supply_demand event: canister fails to match because '[gas]': [canPercent] != [targetPercent]")
			return // Fail!
	// Huh, it actually matches!
	qty_need -= 1
	return 1

//
// Item choosing procs - Decide what supplies will be demanded!
//

/datum/event/supply_demand/proc/choose_food_items(var/differentTypes)
	var/list/types = subtypesof(/datum/recipe)
	for(var/i in 1 to differentTypes)
		var/datum/recipe/R = pick(types)
		types -= R // Don't pick the same thing twice
		var/chosen_path = initial(R.result)
		var/chosen_qty = rand(1, 5)
		required_items += new /datum/supply_demand_order/thing(chosen_qty, chosen_path)
	return

/datum/event/supply_demand/proc/choose_research_items(var/differentTypes)
	var/list/types = subtypesof(/datum/design)
	for(var/i in 1 to differentTypes)
		var/datum/design/D = pick(types)
		types -= D // Don't pick the same thing twice
		var/chosen_path = initial(D.build_path)
		var/chosen_qty = rand(1, 3)
		required_items += new /datum/supply_demand_order/thing(chosen_qty, chosen_path)
	return

/datum/event/supply_demand/proc/choose_chemistry_items(var/differentTypes)
	// Checking if they show up in health analyzer is good huristic for it being a drug
	var/list/medicineReagents = list()
	for(var/decl/chemical_reaction/instant/CR in SSchemistry.chemical_reactions)
		var/datum/reagent/R = SSchemistry.chemical_reagents[initial(CR.result)]
		if(R && R.scannable)
			medicineReagents += R
	for(var/i in 1 to differentTypes)
		var/datum/reagent/R = pick(medicineReagents)
		medicineReagents -= R // Don't pick the same thing twice
		var/chosen_qty = rand(1, 20) * 5
		required_items += new /datum/supply_demand_order/reagent(chosen_qty, R)
	return

/datum/event/supply_demand/proc/choose_bar_items(var/differentTypes)
	var/list/drinkReagents = list()
	for(var/decl/chemical_reaction/instant/drinks/CR in SSchemistry.chemical_reactions)
		var/datum/reagent/R = SSchemistry.chemical_reagents[initial(CR.result)]
		if(istype(R, /datum/reagent/drink) || istype(R, /datum/reagent/ethanol))
			drinkReagents += R
	for(var/i in 1 to differentTypes)
		var/datum/reagent/R = pick(drinkReagents)
		drinkReagents -= R // Don't pick the same thing twice
		var/chosen_qty = rand(1, 20) * 5
		required_items += new /datum/supply_demand_order/reagent(chosen_qty, R)
	return

/datum/event/supply_demand/proc/choose_robotics_items(var/differentTypes)
	// Do not make mechs dynamic, its too silly
	var/list/types = list(
		/obj/mecha/combat/durand,
		/obj/mecha/combat/gygax,
		/obj/mecha/medical/odysseus,
		/obj/mecha/working/ripley)
	for(var/i in 1 to differentTypes)
		var/T = pick(types)
		types -= T // Don't pick the same thing twice
		required_items += new /datum/supply_demand_order/thing(rand(1, 2), T)
	return

/datum/event/supply_demand/proc/choose_atmos_items(var/differentTypes)
	var/datum/gas_mixture/mixture = new
	mixture.temperature = T20C
	var/unpickedTypes = gas_data.gases.Copy()
	unpickedTypes -= GAS_VOLATILE_FUEL // Don't do that one
	for(var/i in 1 to differentTypes)
		var/gasId = pick(unpickedTypes)
		unpickedTypes -= gasId
		mixture.gas[gasId] = (rand(1,1000) * mixture.volume) / (R_IDEAL_GAS_EQUATION * mixture.temperature)
	mixture.update_values()
	var/datum/supply_demand_order/gas/O = new(qty = 1)
	O.mixture = mixture
	required_items += O
	return

/datum/event/supply_demand/proc/choose_alloy_items(var/differentTypes)
	var/list/types = subtypesof(/datum/alloy)
	for(var/i in 1 to differentTypes)
		var/datum/alloy/A = pick(types)
		types -= A // Don't pick the same thing twice
		var/chosen_path = initial(A.product)
		var/chosen_qty = FLOOR(rand(5, 100) * initial(A.product_mod), 1)
		required_items += new /datum/supply_demand_order/thing(chosen_qty, chosen_path)
	return
