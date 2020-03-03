/datum/gm_action/brand_intelligence
	name = "rampant vending machines"
	length = 30 MINUTES
	departments = list(DEPARTMENT_ENGINEERING, DEPARTMENT_EVERYONE)

	var/list/obj/machinery/vending/vendingMachines = list()
	var/list/obj/machinery/vending/infectedVendingMachines = list()
	var/obj/machinery/vending/originMachine
	var/start_time = 0

	var/active = FALSE	// Are we currently infecting?

/datum/gm_action/brand_intelligence/announce()
	if(prob(90))
		command_announcement.Announce("An ongoing mass upload of malware for vendors has been detected onboard  [station_name()], which appears to transmit \
	to other nearby vendors.  The original infected machine is believed to be \a [originMachine.name].", "Vendor Service Alert")

/datum/gm_action/brand_intelligence/set_up()
	vendingMachines.Cut()
	infectedVendingMachines.Cut()

	for(var/obj/machinery/vending/V in machines)
		if(isNotStationLevel(V.z))	continue
		vendingMachines.Add(V)

	if(!vendingMachines.len)
		length = 0
		return

	originMachine = pick(vendingMachines)
	vendingMachines.Remove(originMachine)
	originMachine.shut_up = 0
	originMachine.shoot_inventory = 1

	start_time = world.time
	active = TRUE

/datum/gm_action/brand_intelligence/start()
	..()
	while(originMachine || active)
		if(!vendingMachines.len || !originMachine || originMachine.shut_up)	//if every machine is infected, or if the original vending machine is missing or has it's voice switch flipped
			end()
			return

		if(ISMULTIPLE(world.time - start_time, 5))
			if(prob(15))
				var/obj/machinery/vending/infectedMachine = pick(vendingMachines)
				vendingMachines.Remove(infectedMachine)
				infectedVendingMachines.Add(infectedMachine)
				infectedMachine.shut_up = 0
				infectedMachine.shoot_inventory = 1

				if(ISMULTIPLE(world.time - start_time, 12))
					originMachine.speak(pick("Try our aggressive new marketing strategies!", \
											 "You should buy products to feed your lifestyle obsession!", \
											 "Consume!", \
											 "Your money can buy happiness!", \
											 "Engage direct marketing!", \
											 "Advertising is legalized lying! But don't let that put you off our great deals!", \
											 "You don't want to buy anything? Yeah, well I didn't want to buy your mom either."))

/datum/gm_action/brand_intelligence/end()
	active = FALSE
	for(var/obj/machinery/vending/infectedMachine in infectedVendingMachines)
		infectedMachine.shut_up = 1
		infectedMachine.shoot_inventory = 0

/datum/gm_action/brand_intelligence/get_weight()
	return 60 + (metric.count_people_in_department(DEPARTMENT_ENGINEERING) * 20)
