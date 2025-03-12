/datum/tgui_module/power_monitor
	name = "Power monitor"
	tgui_id = "PowerMonitor"
	var/list/grid_sensors
	var/active_sensor = null	//name_tag of the currently selected sensor

/datum/tgui_module/power_monitor/New()
	. = ..()
	refresh_sensors()

/datum/tgui_module/power_monitor/tgui_data(mob/user)
	var/list/data = list()

	var/list/sensors = list()
	// Focus: If it remains null if no sensor is selected and UI will display sensor list, otherwise it will display sensor reading.
	var/obj/machinery/power/sensor/focus = null

	var/z = get_z(user)
	var/list/map_levels = using_map.get_map_levels(z)

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
		data["focus"] = focus.tgui_data(user)
	else
		data["focus"] = null

	return data

/datum/tgui_module/power_monitor/tgui_act(action, params)
	if(..())
		return TRUE

	switch(action)
		if("clear")
			active_sensor = null
			. = TRUE
		if("refresh")
			refresh_sensors()
			. = TRUE
		if("setsensor")
			active_sensor = params["id"]
			. = TRUE

/datum/tgui_module/power_monitor/proc/has_alarm()
	for(var/obj/machinery/power/sensor/S in grid_sensors)
		if(S.check_grid_warning())
			return TRUE
	return FALSE

/datum/tgui_module/power_monitor/proc/refresh_sensors()
	grid_sensors = list()

	// Handle ultranested programs
	var/turf/T = get_turf(tgui_host())

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

/datum/tgui_module/power_monitor/ntos
	ntos = TRUE

// Subtype for self_state
/datum/tgui_module/power_monitor/robot
/datum/tgui_module/power_monitor/robot/tgui_state(mob/user)
	return GLOB.tgui_self_state
