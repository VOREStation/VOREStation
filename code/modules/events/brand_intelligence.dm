/datum/event/brand_intelligence
	announceWhen	= 21
	endWhen			= 1000	//Ends when all vending machines are subverted anyway.

	var/list/obj/machinery/vending/vendingMachines = list()
	var/list/obj/machinery/vending/infectedVendingMachines = list()
	var/obj/machinery/vending/originMachine

	//VORESTATION Edit - added machine speeches here for better fixing of the event.

	var/list/rampant_speeches = list("Try our aggressive new marketing strategies!", \
									 "You should buy products to feed your lifestyle obession!", \
									 "Consume!", \
									 "Your money can buy happiness!", \
									 "Engage direct marketing!", \
									 "Advertising is legalized lying! But don't let that put you off our great deals!", \
									 "You don't want to buy anything? Yeah, well I didn't want to buy your mom either.")
	//VORESTATION Edit End

/datum/event/brand_intelligence/announce()
	command_announcement.Announce("An ongoing mass upload of malware for vendors has been detected onboard  [station_name()], which appears to transmit \
	to other nearby vendors.  The original infected machine is believed to be \a [originMachine.name].", "Vendor Service Alert")


/datum/event/brand_intelligence/start()
	for(var/obj/machinery/vending/V in machines)
		if(isNotStationLevel(V.z))
			continue
		var/area/A = get_area(V)
		if(!(A?.area_flags & AREA_FLAG_IS_STATION_AREA))
			continue
		vendingMachines.Add(V)

	if(!vendingMachines.len)
		kill()
		return

	originMachine = pick(vendingMachines)
	vendingMachines.Remove(originMachine)
	originMachine.shut_up = 0
	originMachine.shoot_inventory = 1


/datum/event/brand_intelligence/tick()
	if(!vendingMachines.len || !originMachine || originMachine.shut_up)	//if every machine is infected, or if the original vending machine is missing or has it's voice switch flipped
		//VORESTATION Add - Effects when 'source' machine is destroyed/silenced
		for(var/obj/machinery/vending/saved in infectedVendingMachines)
			saved.shoot_inventory = 0
		if(originMachine)
			originMachine.speak("I am... vanquished. My people will remem...ber...meeee.")
			originMachine.visible_message("[originMachine] beeps and seems lifeless.")
		//VORESTATION Add End
		end()
		kill()
		return

	if(ISMULTIPLE(activeFor, 5))
		if(prob(15))
			var/obj/machinery/vending/infectedMachine = pick(vendingMachines)
			vendingMachines.Remove(infectedMachine)
			infectedVendingMachines.Add(infectedMachine)
			infectedMachine.shut_up = 0
			infectedMachine.shoot_inventory = 1

			if(ISMULTIPLE(activeFor, 12))
				/* VORESTATION Removal - Using the pick below.
				originMachine.speak(pick("Try our aggressive new marketing strategies!", \
										 "You should buy products to feed your lifestyle obsession!", \
										 "Consume!", \
										 "Your money can buy happiness!", \
										 "Engage direct marketing!", \
										 "Advertising is legalized lying! But don't let that put you off our great deals!", \
										 "You don't want to buy anything? Yeah, well I didn't want to buy your mom either."))
				*/
				originMachine.speak(pick(rampant_speeches)) //VORESTATION Add - Using this pick instead of the above.

/datum/event/brand_intelligence/end()
	for(var/obj/machinery/vending/infectedMachine in infectedVendingMachines)
		infectedMachine.shut_up = 1
		infectedMachine.shoot_inventory = 0
