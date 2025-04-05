#define REGULATE_NONE	0
#define REGULATE_INPUT	1	//shuts off when input side is below the target pressure
#define REGULATE_OUTPUT	2	//shuts off when output side is above the target pressure

/obj/machinery/atmospherics/binary/passive_gate
	icon = 'icons/atmos/passive_gate.dmi'
	icon_state = "map"
	construction_type = /obj/item/pipe/directional
	pipe_state = "passivegate"
	level = 1

	name = "pressure regulator"
	desc = "A one-way air valve that can be used to regulate input or output pressure, and flow rate. Does not require power."

	use_power = USE_POWER_OFF
	interact_offline = TRUE

	var/unlocked = 0	//If 0, then the valve is locked closed, otherwise it is open(-able, it's a one-way valve so it closes if gas would flow backwards).
	var/target_pressure = ONE_ATMOSPHERE
	var/max_pressure_setting = 15000	//kPa
	var/set_flow_rate = ATMOS_DEFAULT_VOLUME_PUMP * 2.5
	var/regulate_mode = REGULATE_OUTPUT

	var/flowing = 0	//for icons - becomes zero if the valve closes itself due to regulation mode

	var/frequency = 0
	var/id = null
	var/datum/radio_frequency/radio_connection

/obj/machinery/atmospherics/binary/passive_gate/Initialize(mapload)
	. = ..()
	air1.volume = ATMOS_DEFAULT_VOLUME_PUMP * 2.5
	air2.volume = ATMOS_DEFAULT_VOLUME_PUMP * 2.5
	if(frequency)
		set_frequency(frequency)

/obj/machinery/atmospherics/binary/passive_gate/Destroy()
	unregister_radio(src, frequency)
	. = ..()

/obj/machinery/atmospherics/binary/passive_gate/update_icon()
	icon_state = (unlocked && flowing)? "on" : "off"

/obj/machinery/atmospherics/binary/passive_gate/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T))
			return
		add_underlay(T, node1, turn(dir, 180))
		add_underlay(T, node2, dir)

/obj/machinery/atmospherics/binary/passive_gate/hide(var/i)
	update_underlays()

/obj/machinery/atmospherics/binary/passive_gate/process()
	..()

	last_flow_rate = 0

	if(!unlocked)
		return 0

	var/output_starting_pressure = air2.return_pressure()
	var/input_starting_pressure = air1.return_pressure()

	var/pressure_delta
	switch (regulate_mode)
		if (REGULATE_INPUT)
			pressure_delta = input_starting_pressure - target_pressure
		if (REGULATE_OUTPUT)
			pressure_delta = target_pressure - output_starting_pressure
		if (REGULATE_NONE)
			pressure_delta = input_starting_pressure - output_starting_pressure

	//-1 if pump_gas() did not move any gas, >= 0 otherwise
	var/returnval = -1
	if((regulate_mode == REGULATE_NONE || pressure_delta > 0.01) && (air1.temperature > 0 || air2.temperature > 0))	//since it's basically a valve, it makes sense to check both temperatures
		flowing = 1

		//flow rate limit
		var/transfer_moles = (set_flow_rate/air1.volume)*air1.total_moles

		//Figure out how much gas to transfer to meet the target pressure.
		switch (regulate_mode)
			if (REGULATE_INPUT)
				transfer_moles = min(transfer_moles, calculate_transfer_moles(air2, air1, pressure_delta, (network1)? network1.volume : 0))
			if (REGULATE_OUTPUT)
				transfer_moles = min(transfer_moles, calculate_transfer_moles(air1, air2, pressure_delta, (network2)? network2.volume : 0))
			if (REGULATE_NONE)
				var/source = air1
				var/sink = air2
				// If node1 is a network of more than 1 pipe, we want to transfer from that whole network, otw use just node1, as current
				if(istype(node1, /obj/machinery/atmospherics/pipe))
					var/obj/machinery/atmospherics/pipe/p = node1
					if(istype(p.parent, /datum/pipeline)) // Nested if-blocks to avoid the mystical :
						var/datum/pipeline/l = p.parent
						if(istype(l.air, /datum/gas_mixture))
							source = l.air
				// If node2 is a network of more than 1 pipe, we want to transfer to that whole network, otw use just node2, as current
				if(istype(node2, /obj/machinery/atmospherics/pipe))
					var/obj/machinery/atmospherics/pipe/p = node2
					if(istype(p.parent, /datum/pipeline))
						var/datum/pipeline/l = p.parent
						if(istype(l.air, /datum/gas_mixture))
							sink = l.air
				transfer_moles = max(0, calculate_equalize_moles(source, sink)) // Not regulated, don't care about flow rate

		//pump_gas() will return a negative number if no flow occurred
		if(regulate_mode == REGULATE_NONE) // ACTUALLY move gases from the whole network, not just the immediate pipes
			var/source = air1
			var/sink = air2
			// If node1 is a network of more than 1 pipe, we want to transfer from that whole network, otw use just node1, as current
			if(istype(node1, /obj/machinery/atmospherics/pipe))
				var/obj/machinery/atmospherics/pipe/p = node1
				if(istype(p.parent, /datum/pipeline)) // Nested if-blocks to avoid the mystical :
					var/datum/pipeline/l = p.parent
					if(istype(l.air, /datum/gas_mixture))
						source = l.air
			// If node2 is a network of more than 1 pipe, we want to transfer to that whole network, otw use just node2, as current
			if(istype(node2, /obj/machinery/atmospherics/pipe))
				var/obj/machinery/atmospherics/pipe/p = node2
				if(istype(p.parent, /datum/pipeline))
					var/datum/pipeline/l = p.parent
					if(istype(l.air, /datum/gas_mixture))
						sink = l.air
			returnval = pump_gas_passive(src, source, sink, transfer_moles)
		else
			returnval = pump_gas_passive(src, air1, air2, transfer_moles)

	if (returnval >= 0)
		if(network1)
			network1.update = 1

		if(network2)
			network2.update = 1

	if (last_flow_rate)
		flowing = 1

	update_icon()


//Radio remote control

/obj/machinery/atmospherics/binary/passive_gate/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	if(frequency)
		radio_connection = radio_controller.add_object(src, frequency, radio_filter = RADIO_ATMOSIA)

/obj/machinery/atmospherics/binary/passive_gate/proc/broadcast_status()
	if(!radio_connection)
		return 0

	var/datum/signal/signal = new
	signal.transmission_method = TRANSMISSION_RADIO //radio signal
	signal.source = src

	signal.data = list(
		"tag" = id,
		"device" = "AGP",
		"power" = unlocked,
		"target_output" = target_pressure,
		"regulate_mode" = regulate_mode,
		"set_flow_rate" = set_flow_rate,
		"sigtype" = "status"
	)

	radio_connection.post_signal(src, signal, radio_filter = RADIO_ATMOSIA)

	return 1

/obj/machinery/atmospherics/binary/passive_gate/receive_signal(datum/signal/signal)
	if(!signal.data["tag"] || (signal.data["tag"] != id) || (signal.data["sigtype"]!="command"))
		return 0

	if("power" in signal.data)
		unlocked = text2num(signal.data["power"])

	if("power_toggle" in signal.data)
		unlocked = !unlocked

	if("set_target_pressure" in signal.data)
		target_pressure = between(0, text2num(signal.data["set_target_pressure"]), max_pressure_setting)

	if("set_regulate_mode" in signal.data)
		regulate_mode = text2num(signal.data["set_regulate_mode"])

	if("set_flow_rate" in signal.data)
		regulate_mode = text2num(signal.data["set_flow_rate"])

	if("status" in signal.data)
		spawn(2)
			broadcast_status()
		return //do not update_icon

	spawn(2)
		broadcast_status()
	update_icon()
	return

/obj/machinery/atmospherics/binary/passive_gate/attack_hand(user as mob)
	if(..())
		return
	add_fingerprint(user)
	if(!allowed(user))
		to_chat(user, span_warning("Access denied."))
		return
	tgui_interact(user)

/obj/machinery/atmospherics/binary/passive_gate/tgui_interact(mob/user, datum/tgui/ui)
	if(stat & BROKEN)
		return FALSE
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PressureRegulator", name)
		ui.open()

/obj/machinery/atmospherics/binary/passive_gate/tgui_data(mob/user)
	// this is the data which will be sent to the ui
	var/data[0]

	data = list(
		"on" = unlocked,
		"pressure_set" = round(target_pressure*100),	//Nano UI can't handle rounded non-integers, apparently.
		"max_pressure" = max_pressure_setting,
		"input_pressure" = round(air1.return_pressure()*100),
		"output_pressure" = round(air2.return_pressure()*100),
		"regulate_mode" = regulate_mode,
		"set_flow_rate" = round(set_flow_rate*10),
		"last_flow_rate" = round(last_flow_rate*10),
	)

	return data


/obj/machinery/atmospherics/binary/passive_gate/tgui_act(action, params, datum/tgui/ui)
	if(..())
		return TRUE

	switch(action)
		if("toggle_valve")
			. = TRUE
			unlocked = !unlocked
		if("regulate_mode")
			. = TRUE
			switch(params["mode"])
				if("off") regulate_mode = REGULATE_NONE
				if("input") regulate_mode = REGULATE_INPUT
				if("output") regulate_mode = REGULATE_OUTPUT

		if("set_press")
			. = TRUE
			switch(params["press"])
				if("min")
					target_pressure = 0
				if("max")
					target_pressure = max_pressure_setting
				if("set")
					var/new_pressure = tgui_input_number(ui.user,"Enter new output pressure (0-[max_pressure_setting]kPa)","Pressure Control",src.target_pressure,max_pressure_setting,0)
					src.target_pressure = between(0, new_pressure, max_pressure_setting)

		if("set_flow_rate")
			. = TRUE
			switch(params["press"])
				if("min")
					set_flow_rate = 0
				if("max")
					set_flow_rate = air1.volume
				if("set")
					var/new_flow_rate = tgui_input_number(ui.user,"Enter new flow rate limit (0-[air1.volume]L/s)","Flow Rate Control",src.set_flow_rate,air1.volume,0)
					src.set_flow_rate = between(0, new_flow_rate, air1.volume)

	update_icon()
	add_fingerprint(ui.user)

/obj/machinery/atmospherics/binary/passive_gate/attackby(var/obj/item/W as obj, var/mob/user as mob)
	if (!W.has_tool_quality(TOOL_WRENCH))
		return ..()
	if (unlocked)
		to_chat(user, span_warning("You cannot unwrench \the [src], turn it off first."))
		return 1
	if(!can_unwrench())
		to_chat(user, span_warning("You cannot unwrench \the [src], it too exerted due to internal pressure."))
		add_fingerprint(user)
		return 1
	playsound(src, W.usesound, 50, 1)
	to_chat(user, span_notice("You begin to unfasten \the [src]..."))
	if (do_after(user, 40 * W.toolspeed))
		user.visible_message( \
			span_infoplain(span_bold("\The [user]") + " unfastens \the [src]."), \
			span_notice("You have unfastened \the [src]."), \
			"You hear ratchet.")
		deconstruct()

#undef REGULATE_NONE
#undef REGULATE_INPUT
#undef REGULATE_OUTPUT
