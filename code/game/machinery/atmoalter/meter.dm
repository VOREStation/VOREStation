/obj/machinery/meter
	name = "meter"
	desc = "It measures something."
	icon = 'icons/obj/meter_vr.dmi'
	icon_state = "meterX"
	var/obj/machinery/atmospherics/pipe/target = null
	var/list/pipes_on_turf = list()
	anchored = TRUE
	power_channel = ENVIRON
	var/frequency = 0
	var/id
	use_power = USE_POWER_IDLE
	idle_power_usage = 15

/obj/machinery/meter/Initialize(mapload)
	. = ..()
	if (!target)
		target = select_target()

/obj/machinery/meter/Destroy()
	pipes_on_turf.Cut()
	target = null
	return ..()

/obj/machinery/meter/proc/select_target()
	var/obj/machinery/atmospherics/pipe/P
	for(P in loc)
		if(!P.hides_under_flooring())
			break
	if(!P)
		P = locate(/obj/machinery/atmospherics/pipe) in loc
	return P

/obj/machinery/meter/process()
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
		var/datum/radio_frequency/radio_connection = radio_controller.return_frequency(frequency)

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

	if(get_dist(user, src) > 3 && !(isAI(user) || isobserver(user)))
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

/obj/machinery/meter/attackby(var/obj/item/W, var/mob/user)
	if(W.has_tool_quality(TOOL_WRENCH))
		playsound(src, W.usesound, 50, 1)
		to_chat(user, span_notice("You begin to unfasten \the [src]..."))
		if(do_after(user, 40 * W.toolspeed))
			user.visible_message( \
				span_infoplain(span_bold("\The [user]") + " unfastens \the [src]."), \
				span_notice("You have unfastened \the [src]."), \
				"You hear ratchet.")
			new /obj/item/pipe_meter(get_turf(src))
			qdel(src)
			return

	if(istype(W, /obj/item/multitool))
		for(var/obj/machinery/atmospherics/pipe/P in loc)
			pipes_on_turf |= P
		if(!pipes_on_turf.len)
			return
		target = pipes_on_turf[1]
		pipes_on_turf.Remove(target)
		pipes_on_turf.Add(target)
		to_chat(user, span_notice("Pipe meter set to moniter \the [target]."))
		return

	return ..()

// TURF METER - REPORTS A TILE'S AIR CONTENTS

/obj/machinery/meter/turf/select_target()
	return loc

/obj/machinery/meter/turf/attackby(var/obj/item/W as obj, var/mob/user as mob)
	return
