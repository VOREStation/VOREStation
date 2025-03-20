// This code allows for airlocks to be controlled externally by setting an id_tag and comm frequency (disables ID access)
/obj/machinery/door/airlock
	var/id_tag
	var/frequency
	var/shockedby = list()
	var/datum/radio_frequency/radio_connection
	var/cur_command = null	//the command the door is currently attempting to complete

/obj/machinery/door/airlock/process()
	if (..() == PROCESS_KILL && !cur_command)
		. = PROCESS_KILL
	if (arePowerSystemsOn())
		execute_current_command()

/obj/machinery/door/airlock/receive_signal(datum/signal/signal)
	if (!arePowerSystemsOn()) return //no power

	if(!signal || signal.encryption) return

	if(id_tag != signal.data["tag"] || !signal.data["command"]) return

	cur_command = signal.data["command"]
	execute_current_command()
	if(cur_command)
		START_MACHINE_PROCESSING(src)


/obj/machinery/door/airlock/proc/execute_current_command()
	if(operating)
		return //emagged or busy doing something else

	if (!cur_command)
		return

	do_command(cur_command)

/obj/machinery/door/airlock/proc/check_completion(var/do_lock, var/delayed_status)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(do_lock)
		lock()
	if(delayed_status)
		addtimer(CALLBACK(src, PROC_REF(check_completion)), 0.2 SECONDS)
		return
	if(command_completed(cur_command))
		cur_command = null
	send_status()

/obj/machinery/door/airlock/proc/do_command(var/command)
	switch(command)
		if("open")
			open()
			addtimer(CALLBACK(src, PROC_REF(check_completion)), anim_length_before_density + anim_length_before_finalize)

		if("close")
			close()
			addtimer(CALLBACK(src, PROC_REF(check_completion)), anim_length_before_density + anim_length_before_finalize)

		if("unlock")
			unlock()
			check_completion()

		if("lock")
			check_completion(TRUE)

		if("secure_open")
			unlock()

			addtimer(CALLBACK(src, PROC_REF(do_secure_open)), 0.2 SECONDS)

		if("secure_close")
			unlock()
			close()
			addtimer(CALLBACK(src, PROC_REF(check_completion), TRUE, 0.2 SECONDS), anim_length_before_density + anim_length_before_finalize)

/obj/machinery/door/airlock/proc/do_secure_open()
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)
	open()
	addtimer(CALLBACK(src, PROC_REF(check_completion), TRUE), anim_length_before_density + anim_length_before_finalize)

/obj/machinery/door/airlock/proc/command_completed(var/command)
	switch(command)
		if("open")
			return (!density)

		if("close")
			return density

		if("unlock")
			return !locked

		if("lock")
			return locked

		if("secure_open")
			return (locked && !density)

		if("secure_close")
			return (locked && density)

	return 1	//Unknown command. Just assume it's completed.

/obj/machinery/door/airlock/proc/send_status(var/bumped = 0)
	if(radio_connection)
		var/datum/signal/signal = new
		signal.transmission_method = TRANSMISSION_RADIO //radio signal
		signal.data["tag"] = id_tag
		signal.data["timestamp"] = world.time

		signal.data["door_status"] = density?("closed"):("open")
		signal.data["lock_status"] = locked?("locked"):("unlocked")

		if (bumped)
			signal.data["bumped_with_access"] = 1

		radio_connection.post_signal(src, signal, range = AIRLOCK_CONTROL_RANGE, radio_filter = RADIO_AIRLOCK)


/obj/machinery/door/airlock/open(surpress_send)
	. = ..()
	if(!surpress_send) send_status()


/obj/machinery/door/airlock/close(surpress_send)
	. = ..()
	if(!surpress_send) send_status()


/obj/machinery/door/airlock/Bumped(atom/AM)
	..(AM)
	if(istype(AM, /obj/mecha))
		var/obj/mecha/mecha = AM
		if(density && radio_connection && mecha.occupant && (src.allowed(mecha.occupant) || src.check_access_list(mecha.operation_req_access)))
			send_status(1)
	return

/obj/machinery/door/airlock/proc/set_frequency(new_frequency)
	radio_connection = null
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency

	if(new_frequency)
		radio_connection = radio_controller.add_object(src, new_frequency, RADIO_AIRLOCK)

/obj/machinery/door/airlock/Destroy()
	if(frequency && radio_controller)
		radio_controller.remove_object(src,frequency)
	return ..()

/obj/machinery/airlock_sensor
	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "airlock_sensor_off"
	layer = ABOVE_WINDOW_LAYER
	name = "airlock sensor"
	desc = "Sends atmospheric readings to a nearby controller."

	anchored = TRUE
	power_channel = ENVIRON
	circuit = /obj/item/circuitboard/airlock_cycling

	var/id_tag
	var/master_tag
	var/frequency = 1379
	var/command = "cycle"

	var/datum/radio_frequency/radio_connection

	var/on = 1
	var/alert = 0
	var/previousPressure

/obj/machinery/airlock_sensor/update_icon()
	if(panel_open)
		icon_state = "airlock_sensor_open"
		return
	if(on)
		if(alert)
			icon_state = "airlock_sensor_alert"
		else
			icon_state = "airlock_sensor_standby"
	else
		icon_state = "airlock_sensor_off"

/obj/machinery/airlock_sensor/attack_hand(mob/user)
	var/datum/signal/signal = new
	signal.transmission_method = TRANSMISSION_RADIO //radio signal
	signal.data["tag"] = master_tag
	signal.data["command"] = command

	radio_connection.post_signal(src, signal, range = AIRLOCK_CONTROL_RANGE, radio_filter = RADIO_AIRLOCK)
	flick("airlock_sensor_cycle", src)

/obj/machinery/airlock_sensor/process()
	if(on)
		var/datum/gas_mixture/air_sample = return_air()
		var/pressure = round(air_sample.return_pressure(),0.1)

		if(abs(pressure - previousPressure) > 0.001 || previousPressure == null)
			var/datum/signal/signal = new
			signal.transmission_method = TRANSMISSION_RADIO //radio signal
			signal.data["tag"] = id_tag
			signal.data["timestamp"] = world.time
			signal.data["pressure"] = num2text(pressure)

			radio_connection.post_signal(src, signal, range = AIRLOCK_CONTROL_RANGE, radio_filter = RADIO_AIRLOCK)

			previousPressure = pressure

			alert = (pressure < ONE_ATMOSPHERE*0.8)

			update_icon()

/obj/machinery/airlock_sensor/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = radio_controller.add_object(src, frequency, RADIO_AIRLOCK)

/obj/machinery/airlock_sensor/Initialize(mapload)
	. = ..()
	set_frequency(frequency)

/obj/machinery/airlock_sensor/Destroy()
	if(radio_controller)
		radio_controller.remove_object(src,frequency)
	return ..()

/obj/machinery/airlock_sensor/examine(mob/user, infix, suffix)
	. = ..()
	if(in_range(src, user))
		. += "It has a master tag of \"[master_tag]\"."
		. += "It has an ID tag of \"[id_tag]\"."
		. += "It has a frequency of [frequency]."
		. += "It has a command of \"[command]\"."
		if(panel_open)
			. += "It's panel is open."

/obj/machinery/airlock_sensor/attackby(obj/item/I, mob/user)
	if(default_deconstruction_screwdriver(user, I))
		return
	if(default_deconstruction_crowbar(user, I))
		return
	if(I.has_tool_quality(TOOL_MULTITOOL))
		var/choice = tgui_alert(user, "What would you like to configure?", "[src] Configuration", list("Master Tag", "ID Tag", "Frequency", "Command", "None"))
		switch(choice)
			if("Master Tag")
				var/new_value = tgui_input_text(user, "The current master tag is \"[master_tag]\", what would you like it to be?", "[src] Master Tag", master_tag, 30, encode = TRUE)
				if(new_value)
					master_tag = new_value
			if("ID Tag")
				var/new_value = tgui_input_text(user, "The current id tag is \"[id_tag]\", what would you like it to be?", "[src] ID Tag", id_tag, 30, encode = TRUE)
				if(new_value)
					id_tag = new_value
			if("Frequency")
				var/new_frequency = tgui_input_number(user, "[src] has a frequency of [frequency]. What would you like it to be?", "[src] frequency", frequency, RADIO_HIGH_FREQ, RADIO_LOW_FREQ)
				if(new_frequency)
					new_frequency = sanitize_frequency(new_frequency, RADIO_LOW_FREQ, RADIO_HIGH_FREQ)
					set_frequency(new_frequency)
			if("Command")
				var/new_value = tgui_input_text(user, "The current command is \"[command]\", what would you like it to be? Valid options include: cycle, cycle_interior, cycle_exterior.", "[src] command", command, encode = TRUE)
				if(new_value)
					command = new_value

		return TRUE
	return ..()

/obj/machinery/airlock_sensor/airlock_interior
	command = "cycle_interior"

/obj/machinery/airlock_sensor/airlock_exterior
	command = "cycle_exterior"

// Return the air from the turf in "front" of us (Used in shuttles, so it can be in the shuttle area but sense outside it)
/obj/machinery/airlock_sensor/airlock_exterior/shuttle/return_air()
	var/turf/T = get_step(src, dir)
	if(isnull(T))
		return ..()
	return T.return_air()

/obj/machinery/access_button
	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "access_button_standby"
	layer = ABOVE_WINDOW_LAYER
	name = "access button"

	anchored = TRUE
	power_channel = ENVIRON
	circuit = /obj/item/circuitboard/airlock_cycling

	var/master_tag
	var/frequency = 1449
	var/command = "cycle"

	var/datum/radio_frequency/radio_connection

	var/on = 1

/obj/machinery/access_button/update_icon()
	if(panel_open)
		icon_state = "access_button_open"
	else if(on)
		icon_state = "access_button_standby"
	else
		icon_state = "access_button_off"

/obj/machinery/access_button/examine(mob/user, infix, suffix)
	. = ..()
	if(in_range(src, user))
		. += "It has a master tag of \"[master_tag]\"."
		. += "It has a frequency of \"[frequency]\"."
		. += "It is sending a command of \"[command]\"."
		if(panel_open)
			. += "It's panel is open."

/obj/machinery/access_button/attackby(obj/item/I as obj, mob/user as mob)
	//Swiping ID on the access button
	if (istype(I, /obj/item/card/id) || istype(I, /obj/item/pda))
		attack_hand(user)
		return
	if(default_deconstruction_screwdriver(user, I))
		return
	if(default_deconstruction_crowbar(user, I))
		return
	if(I.has_tool_quality(TOOL_MULTITOOL))
		var/choice = tgui_alert(user, "What would you like to change?", "[src] Settings", list("Tag", "Frequency", "Command", "None"))
		switch(choice)
			if("Tag")
				var/new_id = tgui_input_text(user, "[src] has an master tag of \"[master_tag]\". What would you like it to be?", "[src] ID", master_tag, 30, FALSE, TRUE)
				if(new_id)
					master_tag = new_id
			if("Frequency")
				var/new_frequency = tgui_input_number(user, "[src] has a frequency of [frequency]. What would you like it to be?", "[src] frequency", frequency, RADIO_HIGH_FREQ, RADIO_LOW_FREQ)
				if(new_frequency)
					new_frequency = sanitize_frequency(new_frequency, RADIO_LOW_FREQ, RADIO_HIGH_FREQ)
					set_frequency(new_frequency)
			if("Command")
				var/new_command = tgui_input_text(user, "[src] has a command of \"[command]\". Valid options include: cycle, cycle_interior, cycle_exterior", "[src] command", command, encode = TRUE)
				if(new_command)
					command = new_command

		return TRUE
	..()

/obj/machinery/access_button/attack_hand(mob/user)
	add_fingerprint(user)
	if(!allowed(user))
		to_chat(user, span_warning("Access Denied"))

	else if(radio_connection)
		var/datum/signal/signal = new
		signal.transmission_method = TRANSMISSION_RADIO //radio signal
		signal.data["tag"] = master_tag
		signal.data["command"] = command

		radio_connection.post_signal(src, signal, range = AIRLOCK_CONTROL_RANGE, radio_filter = RADIO_AIRLOCK)
	flick("access_button_cycle", src)


/obj/machinery/access_button/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = radio_controller.add_object(src, frequency, RADIO_AIRLOCK)


/obj/machinery/access_button/Initialize(mapload)
	. = ..()
	set_frequency(frequency)

/obj/machinery/access_button/Destroy()
	if(radio_controller)
		radio_controller.remove_object(src, frequency)
	return ..()

/obj/machinery/access_button/airlock_interior
	frequency = 1379
	command = "cycle_interior"

/obj/machinery/access_button/airlock_exterior
	frequency = 1379
	command = "cycle_exterior"
