/obj/machinery/embedded_controller
	name = "Embedded Controller"
	layer = ABOVE_WINDOW_LAYER
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 10
	var/datum/embedded_program/program	//the currently executing program
	var/list/valid_actions = list()
	var/on = 1

/obj/machinery/embedded_controller/Initialize()
	if(ispath(program))
		program = new program(src)
	return ..()

/obj/machinery/embedded_controller/Destroy()
	if(istype(program))
		qdel(program) // the program will clear the ref in its Destroy
	return ..()

/obj/machinery/embedded_controller/examine(mob/user, infix, suffix)
	. = ..()
	if(in_range(src, user))
		. += "It has an ID tag of \"[program?.id_tag]\""

/obj/machinery/embedded_controller/proc/post_signal(datum/signal/signal, comm_line)
	return 0

/obj/machinery/embedded_controller/receive_signal(datum/signal/signal, receive_method, receive_param)
	if(!signal || signal.encryption) return

	if(program)
		program.receive_signal(signal, receive_method, receive_param)

/obj/machinery/embedded_controller/Topic()
	. = ..()
	// stack_trace("WARNING: Embedded controller [src] ([type]) had Topic() called unexpectedly. Please report this.") // statpanel means that topic can always be called for clicking

/obj/machinery/embedded_controller/tgui_act(action, params, datum/tgui/ui)
	if(..())
		return TRUE
	if(LAZYLEN(valid_actions))
		if(action in valid_actions)
			program.receive_user_command(action)
			return TRUE
	if(ui.user)
		add_fingerprint(ui.user)

/obj/machinery/embedded_controller/process()
	if(program)
		program.process()

	update_icon()

/obj/machinery/embedded_controller/attack_ai(mob/user as mob)
	tgui_interact(user)

/obj/machinery/embedded_controller/attack_hand(mob/user as mob)
	if(!user.IsAdvancedToolUser())
		return 0

	tgui_interact(user)

/obj/machinery/embedded_controller/tgui_interact(mob/user, datum/tgui/ui = null)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "EmbeddedController", src)
		ui.open()

//
// Embedded controller with a radio! (Most things (All things?) use this)
//
/obj/machinery/embedded_controller/radio
	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "airlock_control_standby"
	power_channel = ENVIRON
	density = FALSE
	unacidable = TRUE

	var/id_tag
	//var/radio_power_use = 50 //power used to xmit signals

	var/frequency = 1379
	var/radio_filter = null
	var/datum/radio_frequency/radio_connection

/obj/machinery/embedded_controller/radio/Initialize()
	set_frequency(frequency) // Set it before parent instantiates program
	. = ..()

/obj/machinery/embedded_controller/radio/Destroy()
	if(radio_controller)
		radio_controller.remove_object(src,frequency)
	..()

/obj/machinery/embedded_controller/radio/update_icon()
	if(on && program)
		if(program.memory["processing"])
			icon_state = "airlock_control_process"
		else
			icon_state = "airlock_control_standby"
	else
		icon_state = "airlock_control_off"

/obj/machinery/embedded_controller/radio/post_signal(datum/signal/signal, var/radio_filter = null)
	signal.transmission_method = TRANSMISSION_RADIO
	if(radio_connection)
		//use_power(radio_power_use)	//neat idea, but causes way too much lag.
		return radio_connection.post_signal(src, signal, radio_filter)
	else
		qdel(signal)

/obj/machinery/embedded_controller/radio/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = radio_controller.add_object(src, frequency, radio_filter)
