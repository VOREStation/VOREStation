//a controller for a docking port with multiple independent airlocks
//this is the master controller, that things will try to dock with.
/obj/machinery/embedded_controller/radio/docking_port_multi
	name = "docking port controller"
	program = /datum/computer/file/embedded_program/docking/multi
	var/child_tags_txt
	var/child_names_txt
	var/list/child_names = list()

/obj/machinery/embedded_controller/radio/docking_port_multi/Initialize()
	. = ..()
	var/list/names = splittext(child_names_txt, ";")
	var/list/tags = splittext(child_tags_txt, ";")
	if (names.len == tags.len)
		for (var/i = 1; i <= tags.len; i++)
			child_names[tags[i]] = names[i]


/obj/machinery/embedded_controller/radio/docking_port_multi/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]
	var/datum/computer/file/embedded_program/docking/multi/docking_program = program // Cast to proper type

	var/list/airlocks[child_names.len]
	var/i = 1
	for (var/child_tag in child_names)
		airlocks[i++] = list("name"=child_names[child_tag], "override_enabled"=(docking_program.children_override[child_tag] == "enabled"))

	data = list(
		"docking_status" = docking_program.get_docking_status(),
		"airlocks" = airlocks,
	)

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)

	if (!ui)
		ui = new(user, src, ui_key, "multi_docking_console.tmpl", name, 470, 290)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/embedded_controller/radio/docking_port_multi/Topic(href, href_list)
	return 1 // Apparently we swallow all input (this is corrected legacy code)



//a docking port based on an airlock
// This is the actual controller that will be commanded by the master defined above
/obj/machinery/embedded_controller/radio/airlock/docking_port_multi
	name = "docking port controller"
	program = /datum/computer/file/embedded_program/airlock/multi_docking
	var/master_tag	//for mapping
	tag_secure = 1

/obj/machinery/embedded_controller/radio/airlock/docking_port_multi/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]
	var/datum/computer/file/embedded_program/airlock/multi_docking/airlock_program = program // Cast to proper type

	data = list(
		"chamber_pressure" = round(airlock_program.memory["chamber_sensor_pressure"]),
		"exterior_status" = airlock_program.memory["exterior_status"],
		"interior_status" = airlock_program.memory["interior_status"],
		"processing" = airlock_program.memory["processing"],
		"docking_status" = airlock_program.master_status,
		"airlock_disabled" = (airlock_program.docking_enabled && !airlock_program.override_enabled),
		"override_enabled" = airlock_program.override_enabled,
	)

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)

	if (!ui)
		ui = new(user, src, ui_key, "docking_airlock_console.tmpl", name, 470, 290)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/embedded_controller/radio/airlock/docking_port_multi/Topic(href, href_list)
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
		if("toggle_override")
			clean = 1

	if(clean)
		program.receive_user_command(href_list["command"])

	return 1



/*** DEBUG VERBS ***

/datum/computer/file/embedded_program/docking/multi/proc/print_state()
	to_world("id_tag: [id_tag]")
	to_world("dock_state: [dock_state]")
	to_world("control_mode: [control_mode]")
	to_world("tag_target: [tag_target]")
	to_world("response_sent: [response_sent]")

/datum/computer/file/embedded_program/docking/multi/post_signal(datum/signal/signal, comm_line)
	to_world("Program [id_tag] sent a message!")
	print_state()
	to_world("[id_tag] sent command \"[signal.data["command"]]\" to \"[signal.data["recipient"]]\"")
	..(signal)

/obj/machinery/embedded_controller/radio/docking_port_multi/verb/view_state()
	set category = "Debug"
	set src in view(1)
	src.program:print_state()

/obj/machinery/embedded_controller/radio/docking_port_multi/verb/spoof_signal(var/command as text, var/sender as text)
	set category = "Debug"
	set src in view(1)
	var/datum/signal/signal = new
	signal.data["tag"] = sender
	signal.data["command"] = command
	signal.data["recipient"] = id_tag

	src.program:receive_signal(signal)

/obj/machinery/embedded_controller/radio/docking_port_multi/verb/debug_init_dock(var/target as text)
	set category = "Debug"
	set src in view(1)
	src.program:initiate_docking(target)

/obj/machinery/embedded_controller/radio/docking_port_multi/verb/debug_init_undock()
	set category = "Debug"
	set src in view(1)
	src.program:initiate_undocking()

*/
