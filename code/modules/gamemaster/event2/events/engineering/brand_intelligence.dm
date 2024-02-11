/datum/event2/meta/brand_intelligence
	name = "vending machine malware"
	departments = list(DEPARTMENT_ENGINEERING, DEPARTMENT_EVERYONE)
	chaos = 10
	chaotic_threshold = EVENT_CHAOS_THRESHOLD_LOW_IMPACT
	event_type = /datum/event2/event/brand_intelligence

/datum/event2/meta/brand_intelligence/get_weight()
	return 10 + (metric.count_people_in_department(DEPARTMENT_ENGINEERING) * 20)



/datum/event2/event/brand_intelligence
	var/malware_spread_cooldown = 30 SECONDS

	var/list/vending_machines = list() // List of venders that can potentially be infected.
	var/list/infected_vending_machines = list() // List of venders that have been infected.
	var/obj/machinery/vending/vender_zero = null // The first vending machine infected. If that one gets fixed, all other infected machines will be cured.
	var/last_malware_spread_time = null

/datum/event2/event/brand_intelligence/set_up()
	for(var/obj/machinery/vending/V in machines)
		if(!(V.z in using_map.station_levels))
			continue
		vending_machines += V

	if(!vending_machines.len)
		log_debug("Could not find any vending machines on station Z levels. Aborting.")
		abort()
		return

	vender_zero = pick(vending_machines)

/datum/event2/event/brand_intelligence/announce()
	if(prob(90))
		command_announcement.Announce("An ongoing mass upload of malware for vendors has been detected onboard \the [location_name()], \
		which appears to transmit to nearby vendors. The original infected machine is believed to be \a [vender_zero].", "Vendor Service Alert")

/datum/event2/event/brand_intelligence/start()
	infect_vender(vender_zero)

/datum/event2/event/brand_intelligence/event_tick()
	if(last_malware_spread_time + malware_spread_cooldown > world.time)
		return // Still on cooldown.
	last_malware_spread_time = world.time

	if(vending_machines.len)
		var/next_victim = pick(vending_machines)
		infect_vender(next_victim)

		// Every time Vender Zero infects, it says something.
		vender_zero.speak(pick("Try our aggressive new marketing strategies!", \
								 "You should buy products to feed your lifestyle obsession!", \
								 "Consume!", \
								 "Your money can buy happiness!", \
								 "Engage direct marketing!", \
								 "Advertising is legalized lying! But don't let that put you off our great deals!", \
								 "You don't want to buy anything? Yeah, well I didn't want to buy your mom either."))


/datum/event2/event/brand_intelligence/should_end()
	if(!vending_machines.len)
		return TRUE
	if(!can_propagate(vender_zero))
		return TRUE
	return FALSE

/datum/event2/event/brand_intelligence/end()
	if(can_propagate(vender_zero)) // The crew failed and all the machines are infected!
		return
	// Otherwise Vender Zero was taken out in some form.
	if(vender_zero)
		vender_zero.visible_message(span("notice", "\The [vender_zero]'s network activity light flickers wildly \
		for a few seconds as a small screen reads: 'Rolling out firmware reset to networked machines'."))
	for(var/obj/machinery/vending/vender in infected_vending_machines)
		cure_vender(vender)

/datum/event2/event/brand_intelligence/proc/infect_vender(obj/machinery/vending/V)
	vending_machines -= V
	infected_vending_machines += V
	V.shut_up = FALSE
	V.shoot_inventory = TRUE

/datum/event2/event/brand_intelligence/proc/cure_vender(obj/machinery/vending/V)
	infected_vending_machines -= V
	V.shut_up = TRUE
	V.shoot_inventory = FALSE

/datum/event2/event/brand_intelligence/proc/can_propagate(obj/machinery/vending/V)
	return V && V.shut_up == FALSE
