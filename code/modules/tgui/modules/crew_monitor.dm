/datum/tgui_module/crew_monitor
	name = "Crew monitor"
	tgui_id = "CrewMonitor"

/datum/tgui_module/crew_monitor/tgui_act(action, params, datum/tgui/ui)
	if(..())
		return TRUE

	var/turf/T = get_turf(usr)
	if(!T || !(T.z in using_map.player_levels))
		to_chat(usr, "<span class='warning'><b>Unable to establish a connection</b>: You're too far away from the station!</span>")
		return FALSE

	switch(action)
		if("track")
			if(isAI(usr))
				var/mob/living/silicon/ai/AI = usr
				var/mob/living/carbon/human/H = locate(params["track"]) in mob_list
				if(hassensorlevel(H, SUIT_SENSOR_TRACKING))
					AI.ai_actual_track(H)
			return TRUE
		if("setZLevel")
			ui.set_map_z_level(params["mapZLevel"])
			SStgui.update_uis(src)

/datum/tgui_module/crew_monitor/tgui_interact(mob/user, datum/tgui/ui = null)
	var/z = get_z(user)
	var/list/map_levels = using_map.get_map_levels(z, TRUE, om_range = DEFAULT_OVERMAP_RANGE)
	
	if(!map_levels.len)
		to_chat(user, "<span class='warning'>The crew monitor doesn't seem like it'll work here.</span>")
		if(ui)
			ui.close()
		return null

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, tgui_id, name)
		ui.autoupdate = TRUE
		ui.open()


/datum/tgui_module/crew_monitor/tgui_data(mob/user, ui_key = "main", datum/tgui_state/state = GLOB.tgui_default_state)
	var/data[0]

	data["isAI"] = isAI(user)

	var/z = get_z(user)
	var/list/map_levels = uniquelist(using_map.get_map_levels(z, TRUE, om_range = DEFAULT_OVERMAP_RANGE))
	data["map_levels"] = map_levels

	data["crewmembers"] = list()
	for(var/zlevel in map_levels)
		data["crewmembers"] += crew_repository.health_data(zlevel)

	return data

/datum/tgui_module/crew_monitor/ntos
	tgui_id = "NtosCrewMonitor"

/datum/tgui_module/crew_monitor/ntos/tgui_state(mob/user)
	return GLOB.tgui_ntos_state

/datum/tgui_module/crew_monitor/ntos/tgui_static_data()
	. = ..()
	
	var/datum/computer_file/program/host = tgui_host()
	if(istype(host) && host.computer)
		. += host.computer.get_header_data()

/datum/tgui_module/crew_monitor/ntos/tgui_act(action, params)
	if(..())
		return

	var/datum/computer_file/program/host = tgui_host()
	if(istype(host) && host.computer)
		if(action == "PC_exit")
			host.computer.kill_program()
			return TRUE
		if(action == "PC_shutdown")
			host.computer.shutdown_computer()
			return TRUE
		if(action == "PC_minimize")
			host.computer.minimize_program(usr)
			return TRUE

// Subtype for glasses_state
/datum/tgui_module/crew_monitor/glasses
/datum/tgui_module/crew_monitor/glasses/tgui_state(mob/user)
	return GLOB.tgui_glasses_state

// Subtype for self_state
/datum/tgui_module/crew_monitor/robot
/datum/tgui_module/crew_monitor/robot/tgui_state(mob/user)
	return GLOB.tgui_self_state

// Subtype for nif_state
/datum/tgui_module/crew_monitor/nif
/datum/tgui_module/crew_monitor/nif/tgui_state(mob/user)
	return GLOB.tgui_nif_state
