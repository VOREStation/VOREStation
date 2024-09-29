#define MODE_SINGLE 1
#define MODE_DOUBLE 2
#define MODE_CANISTER 3

/obj/machinery/bomb_tester
	name = "explosive effect simulator"
	desc = "A device that can calculate the potential explosive yield of provided gases."
	icon = 'icons/obj/machines/bomb_tester_vr.dmi'
	icon_state = "generic"
	anchored = TRUE
	density = TRUE
	idle_power_usage = 50
	active_power_usage = 1.5 KILOWATTS

	circuit = /obj/item/circuitboard/bomb_tester

	var/icon_name = "generic"

	var/obj/item/tank/tank1
	var/obj/item/tank/tank2
	var/obj/machinery/portable_atmospherics/canister/test_canister

	var/sim_mode = MODE_SINGLE
	var/sim_canister_output = 10*ONE_ATMOSPHERE

	var/simulating = 0
	var/simulation_started = 0
	var/simulation_delay = 20 SECONDS

	var/simulation_results

	var/datum/gas_mixture/faketank
	var/faketank_integrity

/obj/machinery/bomb_tester/New()
	..()
	default_apply_parts()
	RefreshParts()
	faketank = new

/obj/machinery/bomb_tester/Destroy()
	tank1 = null //Base machine Destroy()
	tank2 = null //handles deleting contents
	test_canister = null
	..()

/obj/machinery/bomb_tester/dismantle()
	if(tank1)
		tank1.forceMove(get_turf(src))
		tank1 = null
	if(tank2)
		tank2.forceMove(get_turf(src))
		tank2 = null
	simulation_finish(1)
	return ..()

/obj/machinery/bomb_tester/process()
	..()
	if(test_canister && !Adjacent(test_canister))
		test_canister = null
	if(simulating && world.time >= simulation_started + simulation_delay)
		simulation_finish()

/obj/machinery/bomb_tester/update_icon()
	cut_overlays()
	if(tank1)
		add_overlay("[icon_name]-tank1")
	if(tank2)
		add_overlay("[icon_name]-tank2")
	if(stat & NOPOWER)
		icon_state = "[icon_name]-p"
	else
		icon_state = "[icon_name][simulating]"

/obj/machinery/bomb_tester/power_change()
	..()
	update_icon()
	if(simulating && stat & NOPOWER)
		simulation_finish(1)

/obj/machinery/bomb_tester/RefreshParts()
	..()
	var/scan_rating = 0
	for(var/obj/item/stock_parts/scanning_module/S in component_parts)
		scan_rating += S.rating
	simulation_delay = 25 SECONDS - scan_rating SECONDS

/obj/machinery/bomb_tester/attackby(var/obj/item/I, var/mob/user)
	if(default_deconstruction_screwdriver(user, I))
		return
	if(default_deconstruction_crowbar(user, I))
		return
	if(default_part_replacement(user, I))
		return
	if(istype(I, /obj/item/tank))
		if(!tank1 || !tank2)
			user.drop_item(I)
			I.forceMove(src)
			if(!tank1)
				tank1 = I
			else
				tank2 = I
			update_icon()
			SStgui.update_uis(src)
			to_chat(user, "<span class='notice'>You connect \the [I] to \the [src]'s [I==tank1 ? "primary" : "secondary"] slot.</span>")
			return
	..()

/obj/machinery/bomb_tester/attack_hand(var/mob/user)
	add_fingerprint(user)
	tgui_interact(user)

/obj/machinery/bomb_tester/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BombTester", name)
		ui.open()

/obj/machinery/bomb_tester/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	data["simulating"] = simulating
	if(!simulating)
		data["mode"] = sim_mode
		data["tank1"] = tank1
		data["tank1ref"] = REF(tank1)
		data["tank2"] = tank2
		data["tank2ref"] = REF(tank2)
		data["canister"] = test_canister
		data["sim_canister_output"] = sim_canister_output
	
	return data

/obj/machinery/bomb_tester/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	if(simulating)
		return

	switch(action)
		if("set_mode")
			sim_mode = clamp(text2num(params["mode"]), MODE_SINGLE, MODE_CANISTER)
			var/text_mode
			switch(sim_mode)
				if(MODE_SINGLE)
					text_mode = "single gas tank detonation"
				if(MODE_DOUBLE)
					text_mode = "tank transfer valve detonation"
				if(MODE_CANISTER)
					text_mode = "canister-assisted single gas tank detonation"
			to_chat(usr, "<span class='notice'>[src] set to simulate a [text_mode].</span>")
			return TRUE
		
		if("add_tank")
			if(istype(usr.get_active_hand(), /obj/item/tank))
				var/obj/item/tank/T = usr.get_active_hand()
				var/slot = params["slot"]
				if(slot == 1 && !tank1)
					tank1 = T
				else if(slot == 2 && !tank2)
					tank2 = T
				else
					to_chat(usr, "<span class='warning'>Slot [slot] is full.</span>")
					return
				
				usr.drop_item(T)
				T.forceMove(src)
				return TRUE
			else
				to_chat(usr, "<span class='warning'>You must be wielding a tank to insert it!</span>")

		if("remove_tank")
			var/obj/item/tank/T = locate(params["ref"]) in list(tank1, tank2)
			if(istype(T))
				if(T == tank1)
					tank1 = null
				if(T == tank2)
					tank2 = null
				T.forceMove(get_turf(src))
				update_icon()
			return TRUE

		if("canister_scan")
			for(var/obj/machinery/portable_atmospherics/canister/C in orange(1,src))
				if(C && C == test_canister)
					continue
				else if(C)
					test_canister = C
					break
				else
					test_canister = null
			return TRUE

		if("set_can_pressure")
			sim_canister_output = CLAMP(text2num(params["pressure"]), ONE_ATMOSPHERE/10, ONE_ATMOSPHERE*10)
			return TRUE

		if("start_sim")
			start_simulating()
			return TRUE

/obj/machinery/bomb_tester/proc/start_simulating()
	if(!tank1 || (sim_mode == MODE_DOUBLE && !tank2) || (sim_mode == MODE_CANISTER && !test_canister))
		simulation_results = "Error"
		simulation_finish()
		return
	if((tank1?.air_contents.return_pressure() > TANK_RUPTURE_PRESSURE) || (tank2?.air_contents.return_pressure() > TANK_RUPTURE_PRESSURE))
		simulation_results = "Unstable"
		simulation_finish()
		return
	simulating = 1
	update_use_power(USE_POWER_ACTIVE)
	simulation_started = world.time
	update_icon()
	switch(sim_mode)
		if(MODE_SINGLE)
			spawn()
				single_tank_sim()

		if(MODE_DOUBLE)
			spawn()
				ttv_sim()

		if(MODE_CANISTER)
			spawn()
				canister_sim()

/obj/machinery/bomb_tester/proc/simulate_tank() //This is a heavily cut down version of check_status() from tanks.dm
	faketank.react()
	var/pressure = faketank.return_pressure()
	if(pressure > TANK_FRAGMENT_PRESSURE)
		if(faketank_integrity <= 7)
			faketank.react()
			faketank.react()
			faketank.react()
			pressure = faketank.return_pressure()

			var/strength = (pressure-TANK_FRAGMENT_PRESSURE)/TANK_FRAGMENT_SCALE
			var/mult = ((faketank.volume/140)**(1/2)) * (faketank.total_moles**(2/3))/((29*0.64) **(2/3)) //Don't ask me what this is, see tanks.dm

			var/dev = round((mult*strength)*0.15)
			var/heavy = round((mult*strength)*0.35)
			var/light = round((mult*strength)*0.80)
			simulation_results += "<hr>Final Result: Explosive tank rupture. [dev?"Extreme damage within [2*dev] meters. ":""][heavy?"Heavy damage within [2*heavy] meters. ":""][light?"Light damage within [2*light] meters. ":""]Hazardous shrapnel produced."
			return 1
		else
			faketank_integrity -= 7

	else if(pressure > TANK_RUPTURE_PRESSURE)
		faketank.react()
		if(faketank_integrity <= 0)
			simulation_results += "<hr>Final Result: Tank rupture, minimal concussive force. Hazardous shrapnel produced."
			return 1
		else
			faketank_integrity -= 5

	else if(pressure > TANK_LEAK_PRESSURE || faketank.temperature - T0C > 173)
		faketank_integrity -= 1
	return 0

/obj/machinery/bomb_tester/proc/single_tank_sim()
	faketank.volume = tank1.volume
	faketank.copy_from(tank1.air_contents)
	faketank_integrity = tank1.integrity

	simulation_results = "<center><h1><b>Single Tank Ignition Test</b></h1></center>"
	simulation_results += "<hr>"

	simulation_results += "<br>Initial gas tank status:<br>[format_gas_for_results(faketank)]"

	faketank.add_thermal_energy(15000)

	var/intervals = 0
	while(intervals < 10)
		intervals++
		simulation_results += "<hr>[intervals*2] seconds after ignition."
		if(simulate_tank())
			break
		simulation_results += "<br>Gas tank status:<br>[format_gas_for_results(faketank)]"
		sleep(2)

	if(intervals == 10)
		simulation_results += "<hr>Final Result: No detonation."

/obj/machinery/bomb_tester/proc/ttv_sim()
	faketank.volume = tank1.air_contents.volume + tank2.air_contents.volume
	faketank.copy_from(tank1.air_contents)
	faketank_integrity = tank1.integrity
	faketank.merge(tank2.air_contents)

	simulation_results = "<center><h1><b>Tank Transfer Valve Mixture Test</b></h1></center>"
	simulation_results += "<hr>"

	simulation_results += "<br>Initial gas tank status (primary slot):<br>[format_gas_for_results(tank1.air_contents)]"
	simulation_results += "<br>Initial gas tank status (secondary slot):<br>[format_gas_for_results(tank2.air_contents)]"
	simulation_results += "<br>Initial gas mixture status:<br>[format_gas_for_results(faketank)]"

	var/intervals = 0
	while(intervals < 10)
		intervals++
		simulation_results += "<hr>[intervals*2] seconds after combining."
		if(simulate_tank())
			break
		simulation_results += "<br>Gas mixture status:<br>[format_gas_for_results(faketank)]"
		sleep(2)

	if(intervals == 10)
		simulation_results += "<hr>Final Result: No detonation."

/obj/machinery/bomb_tester/proc/canister_sim()
	test_canister.anchored = TRUE
	faketank.volume = tank1.air_contents.volume
	faketank.copy_from(tank1.air_contents)
	faketank_integrity = tank1.integrity

	var/datum/gas_mixture/fakecanister = new
	fakecanister.volume = test_canister.air_contents.volume
	fakecanister.copy_from(test_canister.air_contents)
	var/fakecanister_RFL = test_canister.release_flow_rate

	simulation_results = "<center><h1><b>Canister-Assisted Single Tank Ignition Test</b></h1></center>"
	simulation_results += "<hr>"

	simulation_results += "<br>Initial gas tank status:<br>[format_gas_for_results(faketank)]"

	var/intervals = 0
	while(intervals < 10)
		intervals++
		simulation_results += "<hr>[intervals*2] seconds after combining."
		var/pressure_delta = sim_canister_output - faketank.return_pressure()
		if(pressure_delta > 0)
			var/transfer_moles = calculate_transfer_moles(fakecanister, faketank, pressure_delta)
			transfer_moles = min(transfer_moles, (fakecanister_RFL/fakecanister.volume)*fakecanister.total_moles)
			pump_gas_passive(src, fakecanister, faketank, transfer_moles)
		if(simulate_tank())
			break
		simulation_results += "<br>Gas tank status:<br>[format_gas_for_results(faketank)]"
		sleep(2)

	if(intervals == 10)
		simulation_results += "<hr>Final Result: No detonation."

/obj/machinery/bomb_tester/proc/simulation_finish(cancelled = 0)
	simulating = 0
	update_use_power(USE_POWER_IDLE)
	update_icon()
	if(test_canister && test_canister.anchored && !test_canister.connected_port)
		test_canister.anchored = FALSE
	if(cancelled)
		return
	if(simulation_results == "Error")
		playsound(src, 'sound/machines/buzz-sigh.ogg', 50, 0)
		state("Invalid parameters.")
	else if(simulation_results == "Unstable")
		playsound(src, 'sound/machines/buzz-two.ogg', 50, 0)
		state("Tank instability detected. Please step away from the device.")
	else
		ping("Simulation complete!")
		playsound(src, "sound/machines/printer.ogg", 50, 1)
		var/obj/item/paper/P = new(get_turf(src))
		P.name = "Explosive Simulator printout"
		P.info = simulation_results

/obj/machinery/bomb_tester/proc/format_gas_for_results(var/datum/gas_mixture/G)
	G.update_values() //Just in case
	var/results = ""
	var/pressure = G.return_pressure()

	results += "Pressure: [round(pressure,0.1)] kPa"
	if(G.total_moles)
		results += "<br>Temperature: [round(G.temperature-T0C)]&deg;C"
		for(var/mix in G.gas)
			results += "<br>[gas_data.name[mix]]: [round((G.gas[mix] / G.total_moles) * 100)]%"

	return results

#undef MODE_SINGLE
#undef MODE_DOUBLE
#undef MODE_CANISTER
