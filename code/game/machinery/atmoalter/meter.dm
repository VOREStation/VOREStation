/obj/machinery/meter
	name = "meter"
	desc = "It measures something."
	icon = 'icons/obj/meter.dmi'
	icon_state = "meterX"
	var/list/pipes_on_turf = list()
	anchored = TRUE
	power_channel = ENVIRON
	var/frequency = 0
	var/id
	var/open = FALSE
	use_power = USE_POWER_IDLE
	idle_power_usage = 15
	var/piping_layer = PIPING_LAYER_DEFAULT
	var/datum/weakref/cached_pipe = null

/obj/machinery/meter/Initialize(mapload, pipe_layer_selected)
	. = ..()
	// Check if we should attach to a pipe OTHER than the regular.
	// Don't do this if we have a mapper set pipe layer, or if we are not maploaded.
	if(mapload && piping_layer == PIPING_LAYER_DEFAULT)
		for(var/obj/machinery/atmospherics/pipe/P in get_turf(src))
			pipe_layer_selected = P.piping_layer // First come first serve
			break
	// Offset the icon as needed
	if(pipe_layer_selected != PIPING_LAYER_DEFAULT)
		piping_layer = pipe_layer_selected
		update_icon()
	// Rename automagically based on the pipelayer it's being made at.
	if(!mapload || name == initial(name)) // Check if we have a map edited name first
		switch(piping_layer)
			if(PIPING_LAYER_SUPPLY)
				name = "supply-meter"
			if(PIPING_LAYER_SCRUBBER)
				name = "scrubber-meter"
			if(PIPING_LAYER_FUEL)
				name = "fuel-meter"
			if(PIPING_LAYER_AUX)
				name = "aux-meter"

/obj/machinery/meter/Destroy()
	pipes_on_turf.Cut()
	cached_pipe = null
	return ..()

/obj/machinery/meter/proc/select_target()
	var/obj/machinery/atmospherics/pipe/P = cached_pipe?.resolve()
	if(P)
		return P
	for(P in get_turf(src))
		if(P.piping_layer != piping_layer)
			continue
		if(!P.hides_under_flooring())
			cached_pipe = WEAKREF(P)
			return P
	return null

/obj/machinery/meter/process()
	var/obj/machinery/atmospherics/pipe/target = select_target()
	if(!target)
		icon_state = "meterX"
		return 0

	if(stat & (BROKEN|NOPOWER))
		icon_state = "meter0"
		return 0

	var/datum/gas_mixture/environment = target.return_air()
	if(!environment)
		icon_state = "meterX"
		return 0

	var/env_pressure = environment.return_pressure()
	if(env_pressure <= 0.15*ONE_ATMOSPHERE)
		icon_state = "meter0"
	else if(env_pressure <= 1.8*ONE_ATMOSPHERE)
		var/val = round(env_pressure/(ONE_ATMOSPHERE*0.3) + 0.5)
		icon_state = "meter1_[val]"
	else if(env_pressure <= 30*ONE_ATMOSPHERE)
		var/val = round(env_pressure/(ONE_ATMOSPHERE*5)-0.35) + 1
		icon_state = "meter2_[val]"
	else if(env_pressure <= 59*ONE_ATMOSPHERE)
		var/val = round(env_pressure/(ONE_ATMOSPHERE*5) - 6) + 1
		icon_state = "meter3_[val]"
	else
		icon_state = "meter4"

	if(frequency)
		var/datum/radio_frequency/radio_connection = SSradio.return_frequency(frequency)

		if(!radio_connection) return

		var/datum/signal/signal = new
		signal.source = src
		signal.transmission_method = TRANSMISSION_RADIO
		signal.data = list(
			"tag" = id,
			"device" = "AM",
			"pressure" = round(env_pressure),
			"sigtype" = "status"
		)
		radio_connection.post_signal(src, signal)

/obj/machinery/meter/examine(mob/user)
	. = ..()

	var/obj/machinery/atmospherics/pipe/target = select_target()
	if(get_dist(user, src) > 6 && !(isAI(user) || isobserver(user)))
		. += span_warning("You are too far away to read it.")

	else if(stat & (NOPOWER|BROKEN))
		. += span_warning("The display is off.")

	else if(target)
		var/datum/gas_mixture/environment = target.return_air()
		if(environment)
			. += "The pressure gauge reads [round(environment.return_pressure(), 0.01)] kPa; [round(environment.temperature,0.01)]K ([round(environment.temperature-T0C,0.01)]&deg;C)"
		else
			. += "The sensor error light is blinking."
	else
		. += "The connect error light is blinking."

/obj/machinery/meter/Click()

	if(ishuman(usr) || isAI(usr)) // ghosts can call ..() for examine
		var/mob/living/L = usr
		if(!L.get_active_hand() || !L.Adjacent(src))
			usr.examinate(src)
			return 1

	return ..()

/obj/machinery/meter/attackby(obj/item/W, mob/user)
	if(W.has_tool_quality(TOOL_WRENCH))
		playsound(src, W.usesound, 50, 1)
		to_chat(user, span_notice("You begin to unfasten \the [src]..."))
		if(do_after(user, 4 SECONDS * W.toolspeed, target = src))
			user.visible_message( \
				span_infoplain(span_bold("\The [user]") + " unfastens \the [src]."), \
				span_notice("You have unfastened \the [src]."), \
				"You hear ratchet.")
			new /obj/item/pipe_meter(get_turf(src))
			qdel(src)
			return

	if(W.has_tool_quality(TOOL_SCREWDRIVER))
		playsound(src, W.usesound, 50, 1)
		to_chat(user, span_notice("You have [open ? "closed" : "opened"] the maintenance panel for [src]."))
		open = !open
		return

	if(W.has_tool_quality(TOOL_MULTITOOL))
		if(open) // For setting up the meter to be used by other devices over radio.
			id = tgui_input_text(user, "Please insert an ID tag for [src], example 'exhaust_pipe'.", "Set ID Tag", id, MAX_NAME_LEN)
			var/obj/item/multitool/tool = W
			tool.connectable = src
			return

		for(var/obj/machinery/atmospherics/pipe/P in loc)
			pipes_on_turf |= P
		if(!pipes_on_turf.len)
			return
		var/obj/machinery/atmospherics/pipe/target = select_target()
		target = pipes_on_turf[1]
		pipes_on_turf.Remove(target)
		pipes_on_turf.Add(target)
		to_chat(user, span_notice("Pipe meter set to moniter \the [target]."))
		return

	return ..()

/obj/machinery/meter/update_icon()
	. = ..()
	// Use offsets instead of custom icons
	switch(piping_layer)
		if(PIPING_LAYER_SUPPLY)
			pixel_x = -4
			pixel_y = -4
			name = "supply-meter"
		if(PIPING_LAYER_SCRUBBER)
			pixel_x = 4
			pixel_y = 4
			name = "scrubber-meter"
		if(PIPING_LAYER_FUEL)
			pixel_x = 8
			pixel_y = 8
			name = "fuel-meter"
		if(PIPING_LAYER_AUX)
			pixel_x = -8
			pixel_y = -8
			name = "aux-meter"
		else
			pixel_x = 0
			pixel_y = 0
			name = initial(name)

// TURF METER - REPORTS A TILE'S AIR CONTENTS

/obj/machinery/meter/turf/select_target()
	return loc

/obj/machinery/meter/turf/attackby(obj/item/W as obj, mob/user as mob)
	return
