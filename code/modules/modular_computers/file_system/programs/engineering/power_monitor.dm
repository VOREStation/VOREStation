/datum/computer_file/program/power_monitor
	filename = "powermonitor"
	filedesc = "Power Monitoring"
	nanomodule_path = /datum/nano_module/power_monitor/
	program_icon_state = "power_monitor"
	program_key_state = "power_key"
	program_menu_icon = "battery-3"
	extended_desc = "This program connects to sensors to provide information about electrical systems"
	ui_header = "power_norm.gif"
	required_access = access_engine
	requires_ntnet = 1
	network_destination = "power monitoring system"
	size = 9
	var/has_alert = 0

/datum/computer_file/program/power_monitor/process_tick()
	..()
	var/datum/nano_module/power_monitor/NMA = NM
	if(istype(NMA) && NMA.has_alarm())
		if(!has_alert)
			program_icon_state = "power_monitor_warn"
			ui_header = "power_warn.gif"
			update_computer_icon()
			has_alert = 1
	else
		if(has_alert)
			program_icon_state = "power_monitor"
			ui_header = "power_norm.gif"
			update_computer_icon()
			has_alert = 0

/datum/nano_module/power_monitor
	name = "Power monitor"
	var/list/grid_sensors
	var/active_sensor = null	//name_tag of the currently selected sensor

/datum/nano_module/power_monitor/New()
	..()
	refresh_sensors()

// Checks whether there is an active alarm, if yes, returns 1, otherwise returns 0.
/datum/nano_module/power_monitor/proc/has_alarm()
	for(var/obj/machinery/power/sensor/S in grid_sensors)
		if(S.check_grid_warning())
			return 1
	return 0

// If PC is not null header template is loaded. Use PC.get_header_data() to get relevant nanoui data from it. All data entries begin with "PC_...."
// In future it may be expanded to other modular computer devices.
/datum/nano_module/power_monitor/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)
	var/list/data = host.initial_data()

	var/list/sensors = list()
	// Focus: If it remains null if no sensor is selected and UI will display sensor list, otherwise it will display sensor reading.
	var/obj/machinery/power/sensor/focus = null

	var/z = get_z(nano_host())
	var/list/map_levels = using_map.get_map_levels(z)
	data["map_levels"] = map_levels

	// Build list of data from sensor readings.
	for(var/obj/machinery/power/sensor/S in grid_sensors)
		if(!(S.z in map_levels))
			continue
		sensors.Add(list(list(
		"name" = S.name_tag,
		"alarm" = S.check_grid_warning()
		)))
		if(S.name_tag == active_sensor)
			focus = S

	data["all_sensors"] = sensors
	if(focus)
		data["focus"] = focus.return_reading_data()

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "power_monitor.tmpl", "Power Monitoring Console", 800, 500, state = state)
		if(host.update_layout()) // This is necessary to ensure the status bar remains updated along with rest of the UI.
			ui.auto_update_layout = 1
		// adding a template with the key "mapContent" enables the map ui functionality
		ui.add_template("mapContent", "power_monitor_map_content.tmpl")
		// adding a template with the key "mapHeader" replaces the map header content
		ui.add_template("mapHeader", "power_monitor_map_header.tmpl")
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

// Refreshes list of active sensors kept on this computer.
/datum/nano_module/power_monitor/proc/refresh_sensors()
	grid_sensors = list()
	var/turf/T = get_turf(nano_host())
	var/list/levels = list()
	if(!T) // Safety check
		return
	if(T)
		levels += using_map.get_map_levels(T.z, FALSE)
	for(var/obj/machinery/power/sensor/S in machines)
		if(T && (S.loc.z == T.z) || (S.loc.z in levels) || (S.long_range)) // Consoles have range on their Z-Level. Sensors with long_range var will work between Z levels.
			if(S.name_tag == "#UNKN#") // Default name. Shouldn't happen!
				warning("Powernet sensor with unset ID Tag! [S.x]X [S.y]Y [S.z]Z")
			else
				grid_sensors += S

// Allows us to process UI clicks, which are relayed in form of hrefs.
/datum/nano_module/power_monitor/Topic(href, href_list)
	if(..())
		return 1
	if( href_list["clear"] )
		active_sensor = null
		. = 1
	if( href_list["refresh"] )
		refresh_sensors()
		. = 1
	else if( href_list["setsensor"] )
		active_sensor = href_list["setsensor"]
		. = 1
