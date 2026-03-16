/*
Every cycle, the pump uses the air in air_in to try and move a specific volume of gas into air_out.

node1, air1, network1 correspond to input
node2, air2, network2 correspond to output

Thus, the two variables affect pump operation are set in New():
	air1.volume
		This is the volume of gas available to the pump that may be transfered to the output
	air2.volume
		Higher quantities of this cause more air to be perfected later
		but overall network volume is also increased as this increases...
*/
#define VOLUME_PUMP_MAX_OUTPUT_PRESSURE 9000 // kpa
#define VOLUME_PUMP_LEAK_AMOUNT 0.04 // About 4% of the volume moved will leak.

/obj/machinery/atmospherics/binary/volume_pump
	icon = 'icons/atmos/volume_pump.dmi'
	icon_state = "map_off"
	construction_type = /obj/item/pipe/directional
	pipe_state = "volumepump"
	level = 1
	var/base_icon = "pump"

	name = "volumetric gas pump"
	desc = "A pump that moves gas by volume"

	use_power = USE_POWER_OFF
	idle_power_usage = 150		//internal circuitry, friction losses and stuff
	power_rating = 15000	//15000 W ~ 20.4 HP

	var/max_transfer_rate = ATMOS_DEFAULT_VOLUME_PUMP	// Ls
	var/transfer_rate = 20 // L

	var/frequency = ZERO_FREQ
	var/id = null
	var/datum/radio_frequency/radio_connection

	var/overclocked = FALSE
	var/mutable_appearance/overclock_overlay

/obj/machinery/atmospherics/binary/volume_pump/Initialize(mapload)
	. = ..()

	air1.volume = ATMOS_DEFAULT_VOLUME_PUMP
	air2.volume = ATMOS_DEFAULT_VOLUME_PUMP
	if(frequency)
		set_frequency(frequency)

/obj/machinery/atmospherics/binary/volume_pump/Destroy()
	unregister_radio(src, frequency)
	. = ..()

/obj/machinery/atmospherics/binary/pump/on
	icon_state = "map_on"
	use_power = USE_POWER_IDLE

/obj/machinery/atmospherics/binary/volume_pump/fuel
	icon_state = "map_off-fuel"
	base_icon = "pump-fuel"
	icon_connect_type = "-fuel"
	connect_types = CONNECT_TYPE_FUEL

/obj/machinery/atmospherics/binary/volume_pump/fuel/on
	icon_state = "map_on-fuel"
	use_power = USE_POWER_IDLE

/obj/machinery/atmospherics/binary/volume_pump/aux
	icon_state = "map_off-aux"
	base_icon = "pump-aux"
	icon_connect_type = "-aux"
	connect_types = CONNECT_TYPE_AUX

/obj/machinery/atmospherics/binary/volume_pump/aux/on
	icon_state = "map_on-aux"
	use_power = USE_POWER_IDLE

/obj/machinery/atmospherics/binary/volume_pump/update_icon()
	if(!powered())
		icon_state = "off"
	else
		icon_state = "[use_power ? "on" : "off"]"

	overclock_overlay = mutable_appearance('icons/atmos/volume_pump_overclock.dmi', "vpumpoverclock")
	if(powered() && use_power && overclocked)
		add_overlay(overclock_overlay)
	else
		cut_overlay(overclock_overlay)

/obj/machinery/atmospherics/binary/volume_pump/update_underlays()
	..()
	underlays.Cut()
	var/turf/T = get_turf(src)
	if(!istype(T))
		return
	add_underlay(T, node1, turn(dir, -180), node1?.icon_connect_type)
	add_underlay(T, node2, dir, node2?.icon_connect_type)

/obj/machinery/atmospherics/binary/volume_pump/hide(var/i)
	update_underlays()

/obj/machinery/atmospherics/binary/volume_pump/process()
	last_power_draw = 0
	last_flow_rate = 0
	var/power_draw = 0

	if((stat & (NOPOWER|BROKEN)) || !use_power)
		return

	var/input_starting_moles = air1.total_moles
	var/output_starting_pressure = air2.return_pressure()

	// The pump will refuse to do anything if the pressure is too high or low, unless it is overclocked.
	if((input_starting_moles < MINIMUM_MOLES_TO_PUMP  || output_starting_pressure > VOLUME_PUMP_MAX_OUTPUT_PRESSURE) && !overclocked)
		return

	var/transfer_ratio = transfer_rate / air1.volume
	if(!transfer_ratio)
		return

	var/datum/gas_mixture/removed = air1.remove_ratio(transfer_ratio)
	var/transfer_moles = removed.total_moles
	last_flow_rate = (transfer_moles/input_starting_moles)*air1.volume

	// Some gases will leak if overclocked. Trade off for no pump limits.
	if(overclocked)
		var/datum/gas_mixture/environment = loc.return_air()
		var/datum/gas_mixture/leaked = removed.remove_ratio(VOLUME_PUMP_LEAK_AMOUNT)
		environment.merge(leaked)

	air2.merge(removed)

	// This part is necessary, as the function pump_gas has limits that reduces the volume pump to just a glorified pressure pump.
	// The gas pump does not care about trying to meet a specific pressure. It will keep moving gas till a pressure limit is reached.
	power_draw = (transfer_moles/input_starting_moles)*power_rating

	if (power_draw >= 0)
		last_power_draw = power_draw
		use_power(power_draw)

		if(network1)
			network1.update = TRUE

		if(network2)
			network2.update = TRUE

	return TRUE

//Radio remote control

/obj/machinery/atmospherics/binary/volume_pump/proc/set_frequency(new_frequency)
	SSradio.remove_object(src, frequency)
	frequency = new_frequency
	if(frequency)
		radio_connection = SSradio.add_object(src, frequency, radio_filter = RADIO_ATMOSIA)

/obj/machinery/atmospherics/binary/volume_pump/proc/broadcast_status()
	if(!radio_connection)
		return FALSE

	var/datum/signal/signal = new
	signal.transmission_method = TRANSMISSION_RADIO //radio signal
	signal.source = src

	signal.data = list(
		"tag" = id,
		"device" = "AGP",
		"power" = use_power,
		"transfer_rate" = transfer_rate,
		"sigtype" = "status"
	)

	radio_connection.post_signal(src, signal, radio_filter = RADIO_ATMOSIA)

	return TRUE

/obj/machinery/atmospherics/binary/volume_pump/tgui_interact(mob/user, datum/tgui/ui)
	if(stat & (BROKEN|NOPOWER))
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "GasPump", name)
		ui.open()

/obj/machinery/atmospherics/binary/volume_pump/tgui_data(mob/user)
	// this is the data which will be sent to the ui
	var/list/data = list(
		"on" = use_power,
		"rate" = transfer_rate*100,
		"max_rate" = max_transfer_rate,
		"last_flow_rate" = last_flow_rate*10,
		"last_power_draw" = last_power_draw,
		"max_power_draw" = power_rating,
	)

	return data

/obj/machinery/atmospherics/binary/volume_pump/receive_signal(datum/signal/signal)
	if(!signal.data["tag"] || (signal.data["tag"] != id) || (signal.data["sigtype"]!="command"))
		return FALSE

	if(signal.data["power"])
		if(text2num(signal.data["power"]))
			update_use_power(USE_POWER_IDLE)
		else
			update_use_power(USE_POWER_OFF)

	if("power_toggle" in signal.data)
		update_use_power(!use_power)

	if(signal.data["set_volume_rate"])
		transfer_rate = between(0, text2num(signal.data["set_volume_rate"]), air1.volume)

	if(signal.data["status"])
		broadcast_status()
		return //do not update_icon

	broadcast_status()
	update_icon()
	return

/obj/machinery/atmospherics/binary/volume_pump/attack_ghost(mob/user)
	tgui_interact(user)

/obj/machinery/atmospherics/binary/volume_pump/attack_hand(mob/user)
	if(..())
		return
	add_fingerprint(user)
	if(!allowed(user))
		to_chat(user, span_warning("Access denied."))
		return
	tgui_interact(user)

/obj/machinery/atmospherics/binary/volume_pump/tgui_act(action, params, datum/tgui/ui)
	if(..())
		return TRUE

	switch(action)
		if("power")
			update_use_power(!use_power)
			. = TRUE
		if("set_press")
			var/press = params["press"]
			switch(press)
				if("min")
					transfer_rate = 0
				if("max")
					transfer_rate = max_transfer_rate
				if("set")
					var/new_rate = tgui_input_number(ui.user,"Enter new transfer rate (0-[max_transfer_rate] L/s)","Flow Control",src.transfer_rate, max_transfer_rate, 0)
					src.transfer_rate = between(0, new_rate, max_transfer_rate)
			. = TRUE

	add_fingerprint(ui.user)
	update_icon()

/obj/machinery/atmospherics/binary/volume_pump/power_change()
	var/old_stat = stat
	..()
	if(old_stat != stat)
		update_icon()

/obj/machinery/atmospherics/binary/volume_pump/attackby(var/obj/item/W as obj, var/mob/user as mob)
	if (W.has_tool_quality(TOOL_WRENCH))
		wrench_act(W, user)

	if (W.has_tool_quality(TOOL_MULTITOOL))
		multitool_act(W, user)

/obj/machinery/atmospherics/binary/volume_pump/examine(mob/user)
	. = ..()
	. += "This device is designed to move large volumes of gasses quickly, but with no gurantee of exact pressures.\
	Meaning that this can naievely over-pressurize pipes and devices past the device's designed limit."
	. += span_bold("The [src]'s pressure limit is [VOLUME_PUMP_MAX_OUTPUT_PRESSURE].")
	. += span_notice("Its pressure limits could be [overclocked ? "en" : "dis"]abled with a" + span_bold("multitool") + ".")
	if(overclocked)
		. += "Its warning light is on[use_power ? " and it's spewing gas!" : "."]"


/obj/machinery/atmospherics/binary/volume_pump/proc/wrench_act(var/obj/item/W as obj, var/mob/user as mob)
	if (!(stat & NOPOWER) && use_power)
		to_chat(user, span_warning("You cannot unwrench this [src], turn it off first."))
		return TRUE
	if(!can_unwrench())
		to_chat(user, span_warning("You cannot unwrench this [src], it too exerted due to internal pressure."))
		add_fingerprint(user)
		return TRUE
	playsound(src, W.usesound, 50, 1)
	to_chat(user, span_notice("You begin to unfasten \the [src]..."))
	if(do_after(user, 40 * W.toolspeed, src))
		user.visible_message( \
			span_infoplain(span_bold("\The [user]") + " unfastens \the [src]."), \
			span_notice("You have unfastened \the [src]."), \
			"You hear ratchet.")
		deconstruct()

/obj/machinery/atmospherics/binary/volume_pump/proc/multitool_act(var/obj/item/W as obj, var/mob/user as mob)
	if(!overclocked)
		overclocked = TRUE
		to_chat(user, span_notice("The pump makes a grinding noise and air starts to hiss out as you disable its pressure limits."))
	else
		overclocked = FALSE
		to_chat(user, span_notice("The pump quiets down as you turn its limiters back on."))
	update_icon()

#undef VOLUME_PUMP_MAX_OUTPUT_PRESSURE
#undef VOLUME_PUMP_LEAK_AMOUNT
