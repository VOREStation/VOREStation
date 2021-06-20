//a docking port that uses a single door
/obj/machinery/embedded_controller/radio/simple_docking_controller
	name = "docking hatch controller"
	program = /datum/embedded_program/docking/simple
	var/tag_door
	valid_actions = list("force_door", "toggle_override")

/obj/machinery/embedded_controller/radio/simple_docking_controller/tgui_data(mob/user)
	var/datum/embedded_program/docking/simple/docking_program = program // Cast to proper type

	. = list(
		"docking_status" = docking_program.get_docking_status(),
		"override_enabled" = docking_program.override_enabled,
		"exterior_status" =	docking_program.memory["door_status"],
		"internalTemplateName" = "DockingConsoleSimple",
	)

//A docking controller program for a simple door based docking port
/datum/embedded_program/docking/simple
	var/tag_door

/datum/embedded_program/docking/simple/New(var/obj/machinery/embedded_controller/M)
	..(M)
	memory["door_status"] = list(state = "closed", lock = "locked")		//assume closed and locked in case the doors dont report in

	if (istype(M, /obj/machinery/embedded_controller/radio/simple_docking_controller))
		var/obj/machinery/embedded_controller/radio/simple_docking_controller/controller = M

		tag_door = controller.tag_door? controller.tag_door : "[id_tag]_hatch"

		spawn(10)
			signal_door("update")		//signals connected doors to update their status


/datum/embedded_program/docking/simple/receive_signal(datum/signal/signal, receive_method, receive_param)
	var/receive_tag = signal.data["tag"]

	if(!receive_tag) return

	if(receive_tag==tag_door)
		memory["door_status"]["state"] = signal.data["door_status"]
		memory["door_status"]["lock"] = signal.data["lock_status"]

	..(signal, receive_method, receive_param)

/datum/embedded_program/docking/simple/receive_user_command(command)
	. = TRUE
	switch(command)
		if("force_door")
			if (override_enabled)
				if(memory["door_status"]["state"] == "open")
					close_door()
				else
					open_door()
		if("toggle_override")
			if (override_enabled)
				disable_override()
			else
				enable_override()
		else
			. = FALSE

/datum/embedded_program/docking/simple/proc/signal_door(var/command)
	var/datum/signal/signal = new
	signal.data["tag"] = tag_door
	signal.data["command"] = command
	post_signal(signal)

///datum/embedded_program/docking/simple/proc/signal_mech_sensor(var/command)
//	signal_door(command)
//	return

/datum/embedded_program/docking/simple/proc/open_door()
	if(memory["door_status"]["state"] == "closed")
		//signal_mech_sensor("enable")
		signal_door("secure_open")
	else if(memory["door_status"]["lock"] == "unlocked")
		signal_door("lock")

/datum/embedded_program/docking/simple/proc/close_door()
	if(memory["door_status"]["state"] == "open")
		signal_door("secure_close")
		//signal_mech_sensor("disable")
	else if(memory["door_status"]["lock"] == "unlocked")
		signal_door("lock")

//tell the docking port to start getting ready for docking - e.g. pressurize
/datum/embedded_program/docking/simple/prepare_for_docking()
	return		//don't need to do anything

//are we ready for docking?
/datum/embedded_program/docking/simple/ready_for_docking()
	return 1	//don't need to do anything

//we are docked, open the doors or whatever.
/datum/embedded_program/docking/simple/finish_docking()
	open_door()

//tell the docking port to start getting ready for undocking - e.g. close those doors.
/datum/embedded_program/docking/simple/prepare_for_undocking()
	close_door()

//are we ready for undocking?
/datum/embedded_program/docking/simple/ready_for_undocking()
	return (memory["door_status"]["state"] == "closed" && memory["door_status"]["lock"] == "locked")

/*** DEBUG VERBS ***

/obj/machinery/embedded_controller/radio/simple_docking_controller/verb/view_state()
	set category = "Debug"
	set src in view(1)
	src.program:print_state()

/obj/machinery/embedded_controller/radio/simple_docking_controller/verb/spoof_signal(var/command as text, var/sender as text)
	set category = "Debug"
	set src in view(1)
	var/datum/signal/signal = new
	signal.data["tag"] = sender
	signal.data["command"] = command
	signal.data["recipient"] = id_tag

	src.program:receive_signal(signal)

/obj/machinery/embedded_controller/radio/simple_docking_controller/verb/debug_init_dock(var/target as text)
	set category = "Debug"
	set src in view(1)
	src.program:initiate_docking(target)

/obj/machinery/embedded_controller/radio/simple_docking_controller/verb/debug_init_undock()
	set category = "Debug"
	set src in view(1)
	src.program:initiate_undocking()

*/