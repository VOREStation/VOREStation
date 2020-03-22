//
// Objects for making phoron airlocks work
// Instructions: Choose a base tag, and include equipment with tags as follows:
// Phoron Lock Controller (/obj/machinery/embedded_controller/radio/airlock/phoron), id_tag = "[base]"
// 		Don't set any other tag vars, they will be auto-populated
// Internal Sensor (obj/machinery/airlock_sensor/phoron), id_tag = "[base]_sensor"
//		Make sure it is actually located inside the airlock, not on a wall turf.  use pixel_x/y
// Exterior doors: (obj/machinery/door/airlock), id_tag = "[base]_outer"
// Interior doors: (obj/machinery/door/airlock), id_tag = "[base]_inner"
// Exterior access button: (obj/machinery/access_button/airlock_exterior),  master_tag = "[base]"
// Interior access button: (obj/machinery/access_button/airlock_interior),  master_tag = "[base]"
// Srubbers: (obj/machinery/portable_atmospherics/powered/scrubber/huge/stationary), frequency = "1379", scrub_id = "[base]_scrubber"
// Pumps: (obj/machinery/atmospherics/unary/vent_pump/high_volume), frequency = 1379 id_tag = "[base]_pump"
//

obj/machinery/airlock_sensor/phoron
	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "airlock_sensor_off"
	name = "phoronlock sensor"
	var/previousPhoron

obj/machinery/airlock_sensor/phoron/process()
	if(on)
		var/datum/gas_mixture/air_sample = return_air()
		var/pressure = round(air_sample.return_pressure(), 0.1)
		var/phoron = ("phoron" in air_sample.gas) ? round(air_sample.gas["phoron"], 0.1) : 0

		if(abs(pressure - previousPressure) > 0.1 || previousPressure == null || abs(phoron - previousPhoron) > 0.1 || previousPhoron == null)
			var/datum/signal/signal = new
			signal.transmission_method = 1 //radio signal
			signal.data["tag"] = id_tag
			signal.data["timestamp"] = world.time
			signal.data["pressure"] = num2text(pressure)
			signal.data["phoron"] = num2text(phoron)
			radio_connection.post_signal(src, signal, range = AIRLOCK_CONTROL_RANGE, radio_filter = RADIO_AIRLOCK)
			previousPressure = pressure
			previousPhoron = phoron
			alert = (pressure < ONE_ATMOSPHERE*0.8) || (phoron > 0.5)
			update_icon()

obj/machinery/airlock_sensor/phoron/airlock_interior
	command = "cycle_interior"

obj/machinery/airlock_sensor/phoron/airlock_exterior
	command = "cycle_exterior"


// Radio remote control
/obj/machinery/portable_atmospherics/powered/scrubber/huge/stationary
	var/frequency = 0
	var/datum/radio_frequency/radio_connection

/obj/machinery/portable_atmospherics/powered/scrubber/huge/stationary/Initialize()
	. = ..()
	if(frequency)
		set_frequency(frequency)

/obj/machinery/portable_atmospherics/powered/scrubber/huge/stationary/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	if(frequency)
		radio_connection = radio_controller.add_object(src, frequency, radio_filter = RADIO_ATMOSIA)

/obj/machinery/portable_atmospherics/powered/scrubber/huge/stationary/receive_signal(datum/signal/signal)
	if(!signal.data["tag"] || (signal.data["tag"] != scrub_id) || (signal.data["sigtype"] != "command"))
		return 0
	if(signal.data["power"])
		on = text2num(signal.data["power"]) ? TRUE : FALSE
	if("power_toggle" in signal.data)
		on = !on
	if(signal.data["status"])
		spawn(2)
			broadcast_status()
		return //do not update_icon
	spawn(2)
		broadcast_status()
	update_icon()
	return

/obj/machinery/portable_atmospherics/powered/scrubber/huge/stationary/proc/broadcast_status()
	if(!radio_connection)
		return 0
	var/datum/signal/signal = new
	signal.transmission_method = 1 //radio signal
	signal.source = src
	signal.data = list(
		"tag" = scrub_id,
		"power" = on,
		"sigtype" = "status"
	)
	radio_connection.post_signal(src, signal, radio_filter = RADIO_AIRLOCK)
	return 1

/obj/machinery/portable_atmospherics/powered/scrubber/huge/stationary/phoronlock		//Special scrubber with bonus inbuilt heater
	volume_rate = 40000
	active_power_usage = 2000
	var/target_temp = T20C
	var/heating_power = 150000

/obj/machinery/portable_atmospherics/powered/scrubber/huge/stationary/phoronlock/process()
	..()

	if(on)
		var/datum/gas_mixture/env = loc.return_air()
		if(env && abs(env.temperature - target_temp) > 0.1)
			var/datum/gas_mixture/removed = env.remove_ratio(0.99)
			if(removed)
				var/heat_transfer = removed.get_thermal_energy_change(target_temp)
				removed.add_thermal_energy(min(heating_power,heat_transfer))
				env.merge(removed)

		var/transfer_moles = min(1, volume_rate/env.volume)*env.total_moles
		for(var/i=1 to 3)	//Scrubs 4 times as fast
			scrub_gas(src, scrubbing_gas, env, air_contents, transfer_moles, active_power_usage)

//
// PHORON LOCK CONTROLLER
//
/obj/machinery/embedded_controller/radio/airlock/phoron
	var/tag_scrubber

/obj/machinery/embedded_controller/radio/airlock/phoron/Initialize()
	. = ..()
	program = new/datum/computer/file/embedded_program/airlock/phoron(src)

//Advanced airlock controller for when you want a more versatile airlock controller - useful for turning simple access control rooms into airlocks
/obj/machinery/embedded_controller/radio/airlock/phoron
	name = "Phoron Lock Controller"

/obj/machinery/embedded_controller/radio/airlock/phoron/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]

	data = list(
		"chamber_pressure" = program.memory["chamber_sensor_pressure"],
		"chamber_phoron" = program.memory["chamber_sensor_phoron"],
		"exterior_status" = program.memory["exterior_status"],
		"interior_status" = program.memory["interior_status"],
		"processing" = program.memory["processing"]
	)

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "phoron_airlock_console.tmpl", name, 470, 290)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/embedded_controller/radio/airlock/phoron/Topic(href, href_list)
	if((. = ..()))
		return

	var/clean = 0
	switch(href_list["command"])	//anti-HTML-hacking checks
		if("cycle_ext")
			clean = 1
		if("cycle_int")
			clean = 1
		if("force_ext")
			clean = 1
		if("force_int")
			clean = 1
		if("abort")
			clean = 1
		if("secure")
			clean = 1

	if(clean)
		program.receive_user_command(href_list["command"])

	return 1

//
// PHORON LOCK CONTROLLER PROGRAM
//

//Handles the control of airlocks

#define STATE_IDLE			0
#define STATE_PREPARE		1
#define STATE_CLEAN			16
#define STATE_PRESSURIZE	17

#define TARGET_NONE			0
#define TARGET_INOPEN		-1
#define TARGET_OUTOPEN		-2

/datum/computer/file/embedded_program/airlock/phoron
	var/tag_scrubber

/datum/computer/file/embedded_program/airlock/phoron/New(var/obj/machinery/embedded_controller/M)
	..(M)
	memory["chamber_sensor_phoron"] = 0
	memory["external_sensor_pressure"] = VIRGO3B_ONE_ATMOSPHERE
	memory["external_sensor_phoron"] = VIRGO3B_MOL_PHORON
	memory["internal_sensor_phoron"] = 0
	memory["scrubber_status"] = "unknown"
	memory["target_phoron"] = 0.1
	memory["secure"] = 1

	if (istype(M, /obj/machinery/embedded_controller/radio/airlock/phoron))	//if our controller is an airlock controller than we can auto-init our tags
		var/obj/machinery/embedded_controller/radio/airlock/phoron/controller = M
		tag_scrubber = controller.tag_scrubber ? controller.tag_scrubber : "[id_tag]_scrubber"

/datum/computer/file/embedded_program/airlock/phoron/receive_signal(datum/signal/signal, receive_method, receive_param)
	var/receive_tag = signal.data["tag"]
	if(!receive_tag) return
	if(..()) return 1

	if(receive_tag==tag_chamber_sensor)
		memory["chamber_sensor_phoron"] = text2num(signal.data["phoron"])
		memory["chamber_sensor_pressure"] = text2num(signal.data["pressure"])

	else if(receive_tag==tag_exterior_sensor)
		memory["external_sensor_phoron"] = text2num(signal.data["phoron"])

	else if(receive_tag==tag_interior_sensor)
		memory["internal_sensor_phoron"] = text2num(signal.data["phoron"])

	else if(receive_tag==tag_scrubber)
		if(signal.data["power"])
			memory["scrubber_status"] = "on"
		else
			memory["scrubber_status"] = "off"

// Note: This code doesn't wait for pumps and scrubbers to be offline like other code does
// The idea is to make the doors open and close faster, since there isn't much harm really.
// But lets evaluate how it actually works in the game.
/datum/computer/file/embedded_program/airlock/phoron/process()
	switch(state)
		if(STATE_IDLE)
			if(target_state == TARGET_INOPEN)
				// TODO - Check if okay to just open immediately
				close_doors()
				state = STATE_PREPARE
			else if(target_state == TARGET_OUTOPEN)
				close_doors()
				state = STATE_PREPARE
			// else if(memory["scrubber_status"] != "off")
			// 	signalScrubber(tag_scrubber, 0) // Keep scrubbers off while idle
			// else if(memory["pump_status"] != "off")
			// 	signalPump(tag_airpump, 0) // Keep vent pump off while idle

		if(STATE_PREPARE)
			if (check_doors_secured())
				if(target_state == TARGET_INOPEN)
					if(memory["chamber_sensor_phoron"] > memory["target_phoron"])
						state = STATE_CLEAN
						signalScrubber(tag_scrubber, 1) // Start cleaning
						signalPump(tag_airpump, 1, 1, memory["target_pressure"]) // And pressurizng to offset losses
					else // We can go directly to pressurize
						state = STATE_PRESSURIZE
						signalPump(tag_airpump, 1, 1, memory["target_pressure"]) // Send a signal to start pressurizing
				// We must be cycling outwards! Shut down the pumps and such!
				else if(memory["scrubber_status"] != "off")
					signalScrubber(tag_scrubber, 0)
				else if(memory["pump_status"] != "off")
					signalPump(tag_airpump, 0)
				else
					cycleDoors(target_state)
					state = STATE_IDLE
					target_state = TARGET_NONE

		if(STATE_CLEAN)
			if(!check_doors_secured())
				//the airlock will not allow itself to continue to cycle when any of the doors are forced open.
				stop_cycling()
			else if(memory["chamber_sensor_phoron"] <= memory["target_phoron"])
				// Okay, we reached target phoron! Turn off the scrubber
				signalScrubber(tag_scrubber, 0)
				// And proceed to finishing pressurization
				state = STATE_PRESSURIZE

		if(STATE_PRESSURIZE)
			if(!check_doors_secured())
				//the airlock will not allow itself to continue to cycle when any of the doors are forced open.
				stop_cycling()
			else if(memory["chamber_sensor_pressure"] >= memory["target_pressure"] * 0.95)
				signalPump(tag_airpump, 0)	// send a signal to stop pumping. No need to wait for it tho.
				cycleDoors(target_state)
				state = STATE_IDLE
				target_state = TARGET_NONE

	memory["processing"] = (state != target_state)
	return 1

/datum/computer/file/embedded_program/airlock/phoron/stop_cycling()
	state = STATE_IDLE
	target_state = TARGET_NONE
	signalPump(tag_airpump, 0)
	signalScrubber(tag_scrubber, 0)

/datum/computer/file/embedded_program/airlock/phoron/proc/signalScrubber(var/tag, var/power)
	var/datum/signal/signal = new
	signal.data = list(
		"tag" = tag,
		"sigtype" = "command",
		"power" = "[power]",
	)
	post_signal(signal)


#undef STATE_IDLE
#undef STATE_PREPARE
#undef STATE_CLEAN
#undef STATE_PRESSURIZE

#undef TARGET_NONE
#undef TARGET_INOPEN
#undef TARGET_OUTOPEN
