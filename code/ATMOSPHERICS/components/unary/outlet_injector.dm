//Basically a one way passive valve. If the pressure inside is greater than the environment then gas will flow passively,
//but it does not permit gas to flow back from the environment into the injector. Can be turned off to prevent any gas flow.
//When it receives the "inject" signal, it will try to pump it's entire contents into the environment regardless of pressure, using power.

/obj/machinery/atmospherics/unary/outlet_injector
	icon = 'icons/atmos/injector.dmi'
	icon_state = "map_injector"
	pipe_state = "injector"

	name = "air injector"
	desc = "Passively injects air into its surroundings. Has a valve attached to it that can control flow rate."

	use_power = USE_POWER_OFF
	idle_power_usage = 150		//internal circuitry, friction losses and stuff
	power_rating = 15000	//15000 W ~ 20 HP

	var/injecting = 0

	var/volume_rate = 50	//flow rate limit

	var/frequency = ZERO_FREQ
	var/id = null
	var/datum/radio_frequency/radio_connection

	level = 1

/obj/machinery/atmospherics/unary/outlet_injector/Initialize(mapload)
	. = ..()

	air_contents.volume = ATMOS_DEFAULT_VOLUME_PUMP + 500	//Give it a small reservoir for injecting. Also allows it to have a higher flow rate limit than vent pumps, to differentiate injectors a bit more.
	if(frequency)
		set_frequency(frequency)

/obj/machinery/atmospherics/unary/outlet_injector/Destroy()
	unregister_radio(src, frequency)
	. = ..()

/obj/machinery/atmospherics/unary/outlet_injector/update_icon()
	if(!powered())
		icon_state = "off"
	else
		icon_state = "[use_power ? "on" : "off"]"

/obj/machinery/atmospherics/unary/outlet_injector/update_underlays()
	..()
	underlays.Cut()
	var/turf/T = get_turf(src)
	if(!istype(T))
		return
	add_underlay(T, node, dir)

/obj/machinery/atmospherics/unary/outlet_injector/power_change()
	var/old_stat = stat
	..()
	if(old_stat != stat)
		update_icon()

/obj/machinery/atmospherics/unary/outlet_injector/process()
	..()

	last_power_draw = 0
	last_flow_rate = 0

	if((stat & (NOPOWER|BROKEN)) || !use_power)
		return

	var/power_draw = -1
	var/datum/gas_mixture/environment = loc.return_air()

	if(environment && air_contents.temperature > 0)
		var/transfer_moles = (volume_rate/air_contents.volume)*air_contents.total_moles //apply flow rate limit
		power_draw = pump_gas(src, air_contents, environment, transfer_moles, power_rating)

	if (power_draw >= 0)
		last_power_draw = power_draw
		use_power(power_draw)

		if(network)
			network.update = 1

	return 1

/obj/machinery/atmospherics/unary/outlet_injector/proc/inject()
	if(injecting || (stat & NOPOWER))
		return 0

	var/datum/gas_mixture/environment = loc.return_air()
	if (!environment)
		return 0

	injecting = 1

	if(air_contents.temperature > 0)
		var/power_used = pump_gas(src, air_contents, environment, air_contents.total_moles, power_rating)
		use_power(power_used)

		if(network)
			network.update = 1

	flick("inject", src)

/obj/machinery/atmospherics/unary/outlet_injector/proc/set_frequency(new_frequency)
	SSradio.remove_object(src, frequency)
	frequency = new_frequency
	if(frequency)
		radio_connection = SSradio.add_object(src, frequency)

/obj/machinery/atmospherics/unary/outlet_injector/proc/broadcast_status()
	if(!radio_connection)
		return 0

	var/datum/signal/signal = new
	signal.transmission_method = TRANSMISSION_RADIO //radio signal
	signal.source = src

	signal.data = list(
		"tag" = id,
		"device" = "AO",
		"power" = use_power,
		"volume_rate" = volume_rate,
		"sigtype" = "status"
	)

	radio_connection.post_signal(src, signal)

	return 1

/obj/machinery/atmospherics/unary/outlet_injector/receive_signal(datum/signal/signal)
	if(!signal.data["tag"] || (signal.data["tag"] != id) || (signal.data["sigtype"]!="command"))
		return 0

	if(signal.data["power"])
		update_use_power(text2num(signal.data["power"]))

	if(signal.data["power_toggle"])
		update_use_power(!use_power)

	if(signal.data["inject"])
		spawn inject()
		return

	if(signal.data["set_volume_rate"])
		var/number = text2num(signal.data["set_volume_rate"])
		volume_rate = between(0, number, air_contents.volume)

	if(signal.data["status"])
		spawn(2)
			broadcast_status()
		return //do not update_icon

	spawn(2)
		broadcast_status()
	update_icon()

/obj/machinery/atmospherics/unary/outlet_injector/hide(var/i)
	update_underlays()

/obj/machinery/atmospherics/unary/outlet_injector/attack_hand(mob/user as mob)
	to_chat(user, span_notice("You toggle \the [src]."))
	injecting = !injecting
	update_use_power(injecting ? USE_POWER_IDLE : USE_POWER_OFF)
	update_icon()

/obj/machinery/atmospherics/unary/outlet_injector/attackby(var/obj/item/W as obj, var/mob/user as mob)
	if (W.has_tool_quality(TOOL_MULTITOOL))
		var/list/options = list("Frequency", "ID Tag", "-SAVE TO BUFFER-", "Cancel")
		var/answer = tgui_alert(user, "[src] has an ID of \"[id]\" and a frequency of [frequency]. What would you like to change?", "Options!", options)
		if(!answer || answer == "Cancel" || !Adjacent(user))
			return

		switch(answer)
			if("Frequency")
				var/new_frequency = tgui_input_number(user, "[src] has a frequency of [frequency]. What would you like it to be?", "[src] frequency", frequency, RADIO_HIGH_FREQ, RADIO_LOW_FREQ)
				if(new_frequency)
					new_frequency = sanitize_frequency(new_frequency, RADIO_LOW_FREQ, RADIO_HIGH_FREQ)
					set_frequency(new_frequency)
					to_chat(user, span_notice("You set the [src]'s frequency to [frequency]."))

			if("ID Tag")
				id = tgui_input_text(user, "Please insert an ID tag for [src], example 'exhaust_port'.", "Set ID Tag", id, MAX_NAME_LEN)
				if(id)
					to_chat(user, span_notice("You set the [src]'s ID Tag to \"[id]\"."))

			if("-SAVE TO BUFFER-")
				var/obj/item/multitool/tool = W
				tool.connectable = src
				to_chat(user, span_notice("You copied the [src] into the [tool]'s buffer!"))

		return ..()

	if (!W.has_tool_quality(TOOL_WRENCH))
		return ..()

	playsound(src, W.usesound, 50, 1)
	to_chat(user, span_notice("You begin to unfasten \the [src]..."))
	if (do_after(user, 40 * W.toolspeed, target = src))
		user.visible_message( \
			span_infoplain(span_bold("\The [user]") + " unfastens \the [src]."), \
			span_notice("You have unfastened \the [src]."), \
			"You hear a ratchet.")
		deconstruct()

/obj/machinery/atmospherics/unary/outlet_injector/click_ctrl(mob/user)
	if (volume_rate == ATMOS_DEFAULT_VOLUME_PUMP + 500 || use_power == USE_POWER_OFF)
		return ..()

	volume_rate = ATMOS_DEFAULT_VOLUME_PUMP + 500
	to_chat(user, span_notice("You have set \the [src] to [volume_rate]"))
	update_icon()
