GLOBAL_LIST_EMPTY(gas_sensors)

#define SENSOR_PRESSURE		(1<<0)
#define SENSOR_TEMPERATURE	(1<<1)
#define SENSOR_O2			(1<<2)
#define SENSOR_PLASMA		(1<<3)
#define SENSOR_N2			(1<<4)
#define SENSOR_CO2			(1<<5)
#define SENSOR_N2O			(1<<6)

/obj/machinery/air_sensor
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "gsensor1"
	name = "Gas Sensor"
	desc = "Senses atmospheric conditions."

	anchored = TRUE
	var/state = 0

	var/id_tag
	var/frequency = 1439

	var/on = 1
	var/output = 3
	//Flags:
	// 1 for pressure
	// 2 for temperature
	// Output >= 4 includes gas composition
	// 4 for oxygen concentration
	// 8 for phoron concentration
	// 16 for nitrogen concentration
	// 32 for carbon dioxide concentration

	var/datum/radio_frequency/radio_connection

/obj/machinery/air_sensor/update_icon()
	icon_state = "gsensor[on]"

/obj/machinery/air_sensor/process()
	if(on)
		var/datum/signal/signal = new
		signal.transmission_method = TRANSMISSION_RADIO //radio signal
		signal.data["tag"] = id_tag
		signal.data["timestamp"] = world.time

		var/datum/gas_mixture/air_sample = return_air()

		if(output&1)
			signal.data["pressure"] = num2text(round(air_sample.return_pressure(),0.1),)
		if(output&2)
			signal.data["temperature"] = round(air_sample.temperature,0.1)

		if(output>4)
			var/total_moles = air_sample.total_moles
			if(total_moles > 0)
				if(output&4)
					signal.data[GAS_O2] = round(100*air_sample.gas[GAS_O2]/total_moles,0.1)
				if(output&8)
					signal.data[GAS_PHORON] = round(100*air_sample.gas[GAS_PHORON]/total_moles,0.1)
				if(output&16)
					signal.data[GAS_N2] = round(100*air_sample.gas[GAS_N2]/total_moles,0.1)
				if(output&32)
					signal.data[GAS_CO2] = round(100*air_sample.gas[GAS_CO2]/total_moles,0.1)
			else
				signal.data[GAS_O2] = 0
				signal.data[GAS_PHORON] = 0
				signal.data[GAS_N2] = 0
				signal.data[GAS_CO2] = 0
		signal.data["sigtype"]="status"
		radio_connection.post_signal(src, signal, radio_filter = RADIO_ATMOSIA)

/obj/machinery/air_sensor/proc/set_frequency(new_frequency)
	SSradio.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = SSradio.add_object(src, frequency, RADIO_ATMOSIA)

/obj/machinery/air_sensor/Initialize(mapload)
	. = ..()
	if(frequency)
		set_frequency(frequency)

/obj/machinery/air_sensor/Destroy()
	if(SSradio)
		SSradio.remove_object(src,frequency)
	. = ..()

/obj/machinery/air_sensor/attackby(var/obj/item/W as obj, var/mob/user as mob)
	if(W.has_tool_quality(TOOL_WRENCH))
		return wrench_act(user, W)

	if(W.has_tool_quality(TOOL_MULTITOOL))
		return multitool_act(user, W)

	return ..()

/obj/machinery/air_sensor/proc/wrench_act(var/mob/living/user, var/obj/item/tool/wrench/W)
	playsound(src, W.usesound, 50, 1)
	user.visible_message("[user] unfastens \the [src].", "<span class='notice'>You have unfastened \the [src].</span>", "You hear ratchet.")
	var/obj/item/pipe_gsensor/gsensor = new /obj/item/pipe_gsensor(loc)
	gsensor.id_tag = id_tag
	gsensor.output = output
	qdel(src)
	playsound(src, 'sound/items/deconstruct.ogg', 50, 1)

#define ONOFF_TOGGLE(flag) "\[[(output & flag) ? "YES" : "NO"]]"
/obj/machinery/air_sensor/proc/multitool_act(mob/living/user, obj/item/multitool/tool)
	var/list/options = list(
		"Pressure: [ONOFF_TOGGLE(SENSOR_PRESSURE)]" = SENSOR_PRESSURE,
		"Temperature: [ONOFF_TOGGLE(SENSOR_TEMPERATURE)]" = SENSOR_TEMPERATURE,
		"Oxygen: [ONOFF_TOGGLE(SENSOR_O2)]" = SENSOR_O2,
		"Toxins: [ONOFF_TOGGLE(SENSOR_PLASMA)]" = SENSOR_PLASMA,
		"Nitrogen: [ONOFF_TOGGLE(SENSOR_N2)]" = SENSOR_N2,
		"Carbon Dioxide: [ONOFF_TOGGLE(SENSOR_CO2)]" = SENSOR_CO2,
		"Nitrous Oxide: [ONOFF_TOGGLE(SENSOR_N2O)]" = SENSOR_N2O,
		"-SAVE TO BUFFER-" = "multitool"
	)

	var/answer = tgui_input_list(user, "[src] has an ID of \"[id_tag]\" and a frequency of [frequency]. What would you like to change?", "Options!", options)

	if(!(src in view(5, user)))
		return TRUE

	if(answer in options) // Null will break us out
		switch(options[answer])
			if(SENSOR_PRESSURE)
				output ^= SENSOR_PRESSURE
			if(SENSOR_TEMPERATURE)
				output ^= SENSOR_TEMPERATURE
			if(SENSOR_O2)
				output ^= SENSOR_O2
			if(SENSOR_PLASMA)
				output ^= SENSOR_PLASMA
			if(SENSOR_N2)
				output ^= SENSOR_N2
			if(SENSOR_CO2)
				output ^= SENSOR_CO2
			if(SENSOR_N2O)
				output ^= SENSOR_N2O
			if("frequency")
				var/new_frequency = tgui_input_number(user, "[src] has a frequency of [frequency]. What would you like it to be?", "[src] frequency", frequency, RADIO_HIGH_FREQ, RADIO_LOW_FREQ)
				if(new_frequency)
					new_frequency = sanitize_frequency(new_frequency, RADIO_LOW_FREQ, RADIO_HIGH_FREQ)
					set_frequency(new_frequency)
			if("multitool")
				id_tag = tgui_input_text(user, "Please insert an ID tag for [src], example 'burn_chamber'.", "Set ID Tag", id_tag, MAX_NAME_LEN, FALSE)
				if(!id_tag || !Adjacent(user))
					return

				var/obj/item/multitool/M = tool
				M.connectable = src
				to_chat(user, "<span class='notice'>You save [src] into [M]'s buffer</span>")

	return TRUE
#undef ONOFF_TOGGLE

/obj/machinery/computer/general_air_control
	icon_keyboard = "atmos_key"
	icon_screen = "tank"
	name = "Computer"
	desc = "Control atmospheric systems, remotely."
	var/frequency = 1439
	var/list/sensors = list()
	var/list/sensor_information = list()
	var/datum/radio_frequency/radio_connection
	circuit = /obj/item/circuitboard/air_management

/obj/machinery/computer/general_air_control/Destroy()
	if(SSradio)
		SSradio.remove_object(src, frequency)
	. = ..()

/obj/machinery/computer/general_air_control/attack_hand(mob/user)
	if(..(user))
		return

	tgui_interact(user)

/obj/machinery/computer/general_air_control/attackby(var/obj/item/W as obj, var/mob/user as mob)
	if(W.has_tool_quality(TOOL_MULTITOOL))
		return multitool_act(W, user)

	. = ..(W, user)

/obj/machinery/computer/general_air_control/receive_signal(datum/signal/signal)
	if(!signal || signal.encryption) return

	var/id_tag = signal.data["tag"]
	if(!id_tag || !sensors.Find(id_tag)) return

	sensor_information[id_tag] = signal.data

/obj/machinery/computer/general_air_control/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "GeneralAtmoControl", name)
		ui.open()

/obj/machinery/computer/general_air_control/tgui_data(mob/user)
	var/list/data = list()
	var/sensors_ui[0]
	if(sensors.len)
		for(var/id_tag in sensors)
			var/long_name = sensors[id_tag]
			var/list/sensor_data = sensor_information[id_tag]
			sensors_ui[++sensors_ui.len] = list("long_name" = long_name, "sensor_data" = sensor_data)
	else
		sensors_ui = null

	data["sensors"] = sensors_ui

	return data

/obj/machinery/computer/general_air_control/proc/set_frequency(new_frequency)
	SSradio.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = SSradio.add_object(src, frequency, RADIO_ATMOSIA)

/obj/machinery/computer/general_air_control/proc/multitool_act(var/obj/item/W as obj, var/mob/user as mob)
	var/list/options = list("Sensors", "Frequency", "Cancel")
	var/answer = tgui_input_list(user, "[src] has a frequency of [frequency]. What would you like to change?", "Options!", options)
	. = TRUE
	if(!answer || answer == "Cancel" || !Adjacent(user))
		return

	switch(answer)
		if("Sensors")
			configure_sensors(user, W)

		if("Frequency")
			var/new_frequency = tgui_input_number(user, "[src] has a frequency of [frequency]. What would you like it to be?", "[src] frequency", frequency, RADIO_HIGH_FREQ, RADIO_LOW_FREQ)
			if(new_frequency)
				new_frequency = sanitize_frequency(new_frequency, RADIO_LOW_FREQ, RADIO_HIGH_FREQ)
				set_frequency(new_frequency)

	return

/obj/machinery/computer/general_air_control/proc/configure_sensors(mob/living/user, obj/item/multitool/tool)
	to_chat(user, "CONFIGURE SENSOR FUNC")
	var/choice = tgui_input_list(user, "Would you like to add or remove a sensor/meter?", "Configuration", list("Add", "Remove","Cancel"))
	if( !choice || choice == "Cancel" || !Adjacent(user))
		return

	switch(choice)
		if("Add")
			// Device must be a meter or gas sensor.
			var/obj/machinery/device = tool.connectable
			if(!device || !(istype(device, /obj/machinery/meter)) && !(istype(device, /obj/machinery/air_sensor)))
				to_chat(user, "<span class='warning'>Error: No device in multitool buffer, or incompatible device is not a sensor or meter.</span>")
				return

			var/device_name = tgui_input_text(user, "Enter a name for the Sensor/Meter.", "Name")
			if (!device_name || !Adjacent(user))
				to_chat(user, "<span class='warning'>Error: No name was given for [tool.connectable].</span>")
				return

			if(istype(device, /obj/machinery/air_sensor))
				var/obj/machinery/air_sensor/AS = device
				sensors[AS.id_tag] = device_name
			else
				var/obj/machinery/meter/M = device
				sensors[M.id] = device_name

			to_chat(user, "You have added the [tool.connectable] to the [src] under the name [device_name]!")

		if("Remove")
			// Creates an associative mapping of Names to Tags, from Tags to Names.
			var/list/sensor_names = list()
			for(tag in sensors)
				sensor_names[sensors[tag]] = sensors[tag]

			var/to_remove = tgui_input_list(user, "Select a sensor/meter to remove", "Sensor/Meter Removal", sensor_names)
			if(!to_remove)
				return

			var/confirm = tgui_alert(user, "Are you sure you want to remove the sensor/meter '[to_remove]'?", "Warning", list("Yes", "No"))
			if(confirm == "No" || !Adjacent(user))
				return

			sensors -= sensor_names[to_remove]
			to_chat(user, "<span class='notice'>Successfully removed sensor/meter with name <code>[to_remove]</code></span>")

/obj/machinery/computer/general_air_control/Initialize(mapload)
	. = ..()
	if(frequency)
		set_frequency(frequency)

/obj/machinery/computer/general_air_control/large_tank_control
	icon = 'icons/obj/computer.dmi'
	frequency = 1441
	var/input_tag
	var/output_tag
	var/list/input_info
	var/list/output_info
	var/input_flow_setting = 200
	var/pressure_setting = ONE_ATMOSPHERE * 45
	circuit = /obj/item/circuitboard/air_management/tank_control

/obj/machinery/computer/general_air_control/large_tank_control/tgui_data(mob/user)
	var/list/data = ..()

	data["tanks"] = 1

	if(input_info)
		data["input_info"] = list("power" = input_info["power"], "volume_rate" = round(input_info["volume_rate"], 0.1))
	else
		data["input_info"] = null

	if(output_info)
		data["output_info"] = list("power" = output_info["power"], "output_pressure" = output_info["internal"])
	else
		data["output_info"] = null

	data["input_flow_setting"] = round(input_flow_setting, 0.1)
	data["pressure_setting"] = pressure_setting
	data["max_pressure"] = 50*ONE_ATMOSPHERE
	data["max_flowrate"] = ATMOS_DEFAULT_VOLUME_PUMP + 500

	return data

/obj/machinery/computer/general_air_control/large_tank_control/receive_signal(datum/signal/signal)
	if(!signal || signal.encryption) return

	var/id_tag = signal.data["tag"]

	if(input_tag == id_tag)
		input_info = signal.data
	else if(output_tag == id_tag)
		output_info = signal.data
	else
		..(signal)

/obj/machinery/computer/general_air_control/large_tank_control/tgui_act(action, params)
	if(..())
		return TRUE

	switch(action)
		if("adj_pressure")
			var/new_pressure = text2num(params["adj_pressure"])
			pressure_setting = between(0, new_pressure, 50*ONE_ATMOSPHERE)
			return TRUE

		if("adj_input_flow_rate")
			var/new_flow = text2num(params["adj_input_flow_rate"])
			input_flow_setting = between(0, new_flow, ATMOS_DEFAULT_VOLUME_PUMP + 500) //default flow rate limit for air injectors
			return TRUE

	if(!radio_connection)
		return FALSE
	var/datum/signal/signal = new
	signal.transmission_method = TRANSMISSION_RADIO //radio signal
	signal.source = src
	switch(action)
		if("in_refresh_status")
			input_info = null
			signal.data = list ("tag" = input_tag, "status" = 1)
			. = TRUE

		if("in_toggle_injector")
			input_info = null
			signal.data = list ("tag" = input_tag, "power_toggle" = 1)
			. = TRUE

		if("in_set_flowrate")
			input_info = null
			signal.data = list ("tag" = input_tag, "set_volume_rate" = "[input_flow_setting]")
			. = TRUE

		if("out_refresh_status")
			output_info = null
			signal.data = list ("tag" = output_tag, "status" = 1)
			. = TRUE

		if("out_toggle_power")
			output_info = null
			signal.data = list ("tag" = output_tag, "power_toggle" = 1)
			. = TRUE

		if("out_set_pressure")
			output_info = null
			signal.data = list ("tag" = output_tag, "set_internal_pressure" = "[pressure_setting]")
			. = TRUE

	signal.data["sigtype"]="command"
	radio_connection.post_signal(src, signal, radio_filter = RADIO_ATMOSIA)

/obj/machinery/computer/general_air_control/large_tank_control/multitool_act(var/obj/item/W as obj, var/mob/user as mob)
	var/list/options =  list("Inlet", "Outlet", "Sensors", "Frequency", "Cancel")
	var/choice = tgui_input_list(user, "[src] has a frequency of [frequency]. What would you like to change?", "Configuration", options)
	if(!choice || choice == "Cancel" || !Adjacent(user))
		return

	switch(choice)
		if ("Inlet")
			configure_inlet(user, W)

		if ("Outlet")
			configure_outlet(user, W)

		if ("Sensors")
			configure_sensors(user, W)

		if ("Frequency")
			var/new_frequency = tgui_input_number(user, "[src] has a frequency of [frequency]. What would you like it to be?", "[src] frequency", frequency, RADIO_HIGH_FREQ, RADIO_LOW_FREQ)
			if(new_frequency)
				new_frequency = sanitize_frequency(new_frequency, RADIO_LOW_FREQ, RADIO_HIGH_FREQ)
				set_frequency(new_frequency)

	return TRUE

/obj/machinery/computer/general_air_control/large_tank_control/proc/configure_outlet(mob/living/user, obj/item/multitool/tool)
	var/choice = tgui_alert(user, "Would you like to set an outlet or clear it?", "Configuration", list("Set", "Clear", "Cancel"))
	if(!choice || !Adjacent(user) || choice == "Cancel")
		return

	switch(choice)
		if ("Set")
			to_chat(user, "The buffer is [tool.connectable]")
			if (!istype(tool.connectable, /obj/machinery/atmospherics/unary/vent_pump))
				to_chat(user, "<span class='warning'>Error: Buffer is either empty, or object in buffer is invalid. Device should be a Unary Vent</span>")
				return

			var/obj/machinery/atmospherics/unary/vent_pump/pump = tool.connectable
			output_tag = pump.id_tag
			pump.external_pressure_bound = 0
			pump.external_pressure_bound_default = 0
			to_chat(user, "You have set the outlet!")
			return

		if ("Clear")
			output_tag = null
			to_chat(user, "You have cleared the outlet!")
			return

/obj/machinery/computer/general_air_control/large_tank_control/proc/configure_inlet(mob/living/user, obj/item/multitool/tool)
	var/choice = tgui_alert(user, "Would you like to set an inlet or clear it?", "Configuration", list("Set", "Clear", "Cancel"))
	if(!choice || !Adjacent(user) || choice == "Cancel")
		return

	switch(choice)
		if ("Set")
			if (!istype(tool.connectable, /obj/machinery/atmospherics/unary/outlet_injector))
				to_chat(user, "<span class='warning'>Error: Buffer is either empty, or object in buffer is invalid. Device should be Injector</span>")
				return

			var/obj/machinery/atmospherics/unary/outlet_injector/injector = tool.connectable
			input_tag = injector.id
			to_chat(user, "You have set the inlet")
			return

		if ("Clear")
			input_tag = null
			to_chat(user, "You have cleared the inlet!")
			return

/obj/machinery/computer/general_air_control/supermatter_core
	icon = 'icons/obj/computer.dmi'
	frequency = 1433
	var/input_tag
	var/output_tag
	var/list/input_info
	var/list/output_info
	var/input_flow_setting = 700
	var/pressure_setting = 100
	circuit = /obj/item/circuitboard/air_management/supermatter_core

/obj/machinery/computer/general_air_control/supermatter_core/tgui_data(mob/user)
	var/list/data = ..()
	data["core"] = 1

	if(input_info)
		data["input_info"] = list("power" = input_info["power"], "volume_rate" = round(input_info["volume_rate"], 0.1))
	else
		data["input_info"] = null

	if(output_info)
		// Yes, TECHNICALLY this is not output pressure, it's a pressure LIMIT. HOWEVER. The fact that the UI uses "output_pressure"
		// in EXACTLY THE SAME WAY as "pressure_limit" means this should just pass it as the other fucking data argument because holy shit what the
		// fuck
		data["output_info"] = list("power" = output_info["power"], "output_pressure" = output_info["external"])
	else
		data["output_info"] = null

	data["input_flow_setting"] = round(input_flow_setting, 0.1)
	data["pressure_setting"] = pressure_setting
	data["max_pressure"] = 10*ONE_ATMOSPHERE
	data["max_flowrate"] = ATMOS_DEFAULT_VOLUME_PUMP + 500

	return data

/obj/machinery/computer/general_air_control/supermatter_core/receive_signal(datum/signal/signal)
	if(!signal || signal.encryption) return

	var/id_tag = signal.data["tag"]

	if(input_tag == id_tag)
		input_info = signal.data
	else if(output_tag == id_tag)
		output_info = signal.data
	else
		..(signal)

/obj/machinery/computer/general_air_control/supermatter_core/tgui_act(action, params)
	if(..())
		return TRUE

	switch(action)
		if("adj_pressure")
			var/new_pressure = text2num(params["adj_pressure"])
			pressure_setting = between(0, new_pressure, 10*ONE_ATMOSPHERE)
			return TRUE

		if("adj_input_flow_rate")
			var/new_flow = text2num(params["adj_input_flow_rate"])
			input_flow_setting = between(0, new_flow, ATMOS_DEFAULT_VOLUME_PUMP + 500) //default flow rate limit for air injectors
			return TRUE

	if(!radio_connection)
		return FALSE
	var/datum/signal/signal = new
	signal.transmission_method = TRANSMISSION_RADIO //radio signal
	signal.source = src
	switch(action)
		if("in_refresh_status")
			input_info = null
			signal.data = list ("tag" = input_tag, "status" = 1)
			. = TRUE

		if("in_toggle_injector")
			input_info = null
			signal.data = list ("tag" = input_tag, "power_toggle" = 1)
			. = TRUE

		if("in_set_flowrate")
			input_info = null
			signal.data = list ("tag" = input_tag, "set_volume_rate" = "[input_flow_setting]")
			. = TRUE

		if("out_refresh_status")
			output_info = null
			signal.data = list ("tag" = output_tag, "status" = 1)
			. = TRUE

		if("out_toggle_power")
			output_info = null
			signal.data = list ("tag" = output_tag, "power_toggle" = 1)
			. = TRUE

		if("out_set_pressure")
			output_info = null
			signal.data = list ("tag" = output_tag, "set_external_pressure" = "[pressure_setting]", "checks" = 1)
			. = TRUE

	signal.data["sigtype"]="command"
	radio_connection.post_signal(src, signal, radio_filter = RADIO_ATMOSIA)

/obj/machinery/computer/general_air_control/supermatter_core/multitool_act(var/obj/item/W as obj, var/mob/user as mob)
	var/list/options =  list("Inlet", "Outlet", "Sensors", "Frequency", "Cancel")
	var/choice = tgui_input_list(user, "[src] has a frequency of [frequency]. What would you like to change?", "Configuration", options)
	if(!choice || choice == "Cancel" || !Adjacent(user))
		return

	switch(choice)
		if ("Inlet")
			configure_inlet(user, W)

		if ("Outlet")
			configure_outlet(user, W)

		if ("Sensors")
			configure_sensors(user, W)

		if ("Frequency")
			var/new_frequency = tgui_input_number(user, "[src] has a frequency of [frequency]. What would you like it to be?", "[src] frequency", frequency, RADIO_HIGH_FREQ, RADIO_LOW_FREQ)
			if(new_frequency)
				new_frequency = sanitize_frequency(new_frequency, RADIO_LOW_FREQ, RADIO_HIGH_FREQ)
				set_frequency(new_frequency)

	return TRUE

/obj/machinery/computer/general_air_control/supermatter_core/proc/configure_outlet(mob/living/user, obj/item/multitool/tool)
	var/choice = tgui_alert(user, "Would you like to set an outlet or clear it?", "Configuration", list("Set", "Clear", "Cancel"))
	if(!choice || !Adjacent(user) || choice == "Cancel")
		return

	switch(choice)
		if ("Set")
			if (!istype(tool.connectable, /obj/machinery/atmospherics/unary/vent_pump))
				to_chat(user, "<span class='warning'>Error: Buffer is either empty, or object in buffer is invalid. Device should be Air Vent</span>")
				return

			var/obj/machinery/atmospherics/unary/vent_pump/pump = tool.connectable
			output_tag = pump.id_tag
			pump.external_pressure_bound = 0
			pump.external_pressure_bound_default = 0
			to_chat(user, "You have set the outlet!")
			return

		if ("Clear")
			output_tag = null
			to_chat(user, "You have cleared the outlet!")
			return

/obj/machinery/computer/general_air_control/supermatter_core/proc/configure_inlet(mob/living/user, obj/item/multitool/tool)
	var/choice = tgui_alert(user, "Would you like to set an inlet or clear it?", "Configuration", list("Set", "Clear", "Cancel"))
	if(!choice || !Adjacent(user) || choice == "Cancel")
		return

	switch(choice)
		if ("Set")
			to_chat(user, "The buffer is [tool.connectable]")
			if (!istype(tool.connectable, /obj/machinery/atmospherics/unary/outlet_injector))
				to_chat(user, "<span class='warning'>Error: Buffer is either empty, or object in buffer is invalid. Device should be Injector</span>")
				return

			var/obj/machinery/atmospherics/unary/outlet_injector/injector = tool.connectable
			input_tag = injector.id
			to_chat(user, "You have set the inlet!")
			return

		if ("Clear")
			input_tag = null
			to_chat(user, "You have cleared the inlet!")
			return

/obj/machinery/computer/general_air_control/fuel_injection
	icon = 'icons/obj/computer.dmi'
	icon_screen = "alert:0"
	var/device_tag
	var/list/device_info
	var/automation = 0
	var/cutoff_temperature = 2000
	var/on_temperature = 1200
	circuit = /obj/item/circuitboard/air_management/injector_control

/obj/machinery/computer/general_air_control/fuel_injection/process()
	if(automation)
		if(!radio_connection)
			return FALSE

		var/injecting = 0
		for(var/id_tag in sensor_information)
			var/list/data = sensor_information[id_tag]
			if(data["temperature"])
				if(data["temperature"] >= cutoff_temperature)
					injecting = 0
					break
				if(data["temperature"] <= on_temperature)
					injecting = 1

		var/datum/signal/signal = new
		signal.transmission_method = TRANSMISSION_RADIO //radio signal
		signal.source = src

		signal.data = list(
			"tag" = device_tag,
			"power" = injecting,
			"sigtype"="command"
		)

		radio_connection.post_signal(src, signal, radio_filter = RADIO_ATMOSIA)

	..()

/obj/machinery/computer/general_air_control/fuel_injection/tgui_data(mob/user)
	var/list/data = ..()
	data["fuel"] = 1
	data["automation"] = automation

	if(device_info)
		data["device_info"] = list("power" = device_info["power"], "volume_rate" = device_info["volume_rate"])
	else
		data["device_info"] = null

	return data

/obj/machinery/computer/general_air_control/fuel_injection/receive_signal(datum/signal/signal)
	if(!signal || signal.encryption) return

	var/id_tag = signal.data["tag"]

	if(device_tag == id_tag)
		device_info = signal.data
	else
		..(signal)

/obj/machinery/computer/general_air_control/fuel_injection/tgui_act(action, params)
	if(..())
		return TRUE

	switch(action)
		if("refresh_status")
			device_info = null
			if(!radio_connection)
				return FALSE

			var/datum/signal/signal = new
			signal.transmission_method = TRANSMISSION_RADIO //radio signal
			signal.source = src
			signal.data = list(
				"tag" = device_tag,
				"status" = 1,
				"sigtype"="command"
			)
			radio_connection.post_signal(src, signal, radio_filter = RADIO_ATMOSIA)
			. = TRUE

		if("toggle_automation")
			automation = !automation
			. = TRUE

		if("toggle_injector")
			device_info = null
			if(!radio_connection)
				return FALSE

			var/datum/signal/signal = new
			signal.transmission_method = TRANSMISSION_RADIO //radio signal
			signal.source = src
			signal.data = list(
				"tag" = device_tag,
				"power_toggle" = 1,
				"sigtype"="command"
			)

			radio_connection.post_signal(src, signal, radio_filter = RADIO_ATMOSIA)
			. = TRUE

		if("injection")
			if(!radio_connection)
				return FALSE

			var/datum/signal/signal = new
			signal.transmission_method = TRANSMISSION_RADIO //radio signal
			signal.source = src
			signal.data = list(
				"tag" = device_tag,
				"inject" = 1,
				"sigtype"="command"
			)

			radio_connection.post_signal(src, signal, radio_filter = RADIO_ATMOSIA)
			. = TRUE
