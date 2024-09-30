/datum/tgui_module/computer_configurator
	name = "NTOS Computer Configuration Tool"
	ntos = TRUE
	tgui_id = "Configuration"
	var/obj/item/modular_computer/movable = null

/datum/tgui_module/computer_configurator/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	movable = tgui_host()
	// No computer connection, we can't get data from that.
	if(!istype(movable))
		return 0

	var/list/data = ..()

	data["disk_size"] = movable.hard_drive.max_capacity
	data["disk_used"] = movable.hard_drive.used_capacity
	data["power_usage"] = movable.last_power_usage
	data["battery_exists"] = movable.battery_module ? 1 : 0
	if(movable.battery_module)
		data["battery_rating"] = movable.battery_module.battery.maxcharge
		data["battery_percent"] = round(movable.battery_module.battery.percent())

	if(movable.battery_module && movable.battery_module.battery)
		data["battery"] = list("max" = movable.battery_module.battery.maxcharge, "charge" = round(movable.battery_module.battery.charge))

	var/list/hardware = movable.get_all_components()
	var/list/all_entries[0]
	for(var/obj/item/computer_hardware/H in hardware)
		all_entries.Add(list(list(
		"name" = H.name,
		"desc" = H.desc,
		"enabled" = H.enabled,
		"critical" = H.critical,
		"powerusage" = H.power_usage
		)))

	data["hardware"] = all_entries
	return data

/datum/tgui_module/computer_configurator/tgui_act(action, params)
	if(..())
		return
	switch(action)
		if("PC_toggle_component")
			var/obj/item/computer_hardware/H = movable.find_hardware_by_name(params["name"])
			if(H && istype(H))
				H.enabled = !H.enabled
			. = TRUE