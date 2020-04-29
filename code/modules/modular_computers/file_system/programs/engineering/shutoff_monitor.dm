/datum/computer_file/program/shutoff_monitor
	filename = "shutoffmonitor"
	filedesc = "Shutoff Valve Monitoring"
	nanomodule_path = /datum/nano_module/shutoff_monitor
	program_icon_state = "atmos_control"
	program_key_state = "atmos_key"
	program_menu_icon = "wrench"
	extended_desc = "This program allows for remote monitoring and control of emergency shutoff valves."
	required_access = access_engine
	requires_ntnet = 1
	network_destination = "shutoff valve control computer"
	size = 5
	var/has_alert = 0

/datum/nano_module/shutoff_monitor
	name = "Shutoff Valve Monitoring"

/datum/nano_module/shutoff_monitor/Topic(ref, href_list)
	if(..())
		return 1

	if(href_list["toggle_enable"])
		var/obj/machinery/atmospherics/valve/shutoff/S = locate(href_list["toggle_enable"])
		if(!istype(S))
			return 0
		S.close_on_leaks = !S.close_on_leaks
		return 1

	if(href_list["toggle_open"])
		var/obj/machinery/atmospherics/valve/shutoff/S = locate(href_list["toggle_open"])
		if(!istype(S))
			return 0
		if(S.open)
			S.close()
		else
			S.open()
		return 1

/datum/nano_module/shutoff_monitor/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)
	var/list/data = host.initial_data()
	var/list/valves = list()

	for(var/obj/machinery/atmospherics/valve/shutoff/S in GLOB.shutoff_valves)
		valves.Add(list(list(
		"name" = S.name,
		"enabled" = S.close_on_leaks,
		"open" = S.open,
		"x" = S.x,
		"y" = S.y,
		"z" = S.z,
		"ref" = "\ref[S]"
		)))

	data["valves"] = valves

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "shutoff_monitor.tmpl", "Shutoff Valve Monitoring", 627, 700, state = state)
		if(host.update_layout()) // This is necessary to ensure the status bar remains updated along with rest of the UI.
			ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)