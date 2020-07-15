/datum/tgui_module/crew_monitor
	name = "Crew monitor"

/datum/tgui_module/crew_monitor/tgui_act(action, params)
	if(..())
		return TRUE

	var/turf/T = get_turf(tgui_host())
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

/datum/tgui_module/crew_monitor/tgui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = 0, datum/tgui/master_ui = null, datum/tgui_state/state = GLOB.tgui_default_state)
	var/z = get_z(tgui_host())
	var/list/map_levels = using_map.get_map_levels(z, TRUE, om_range = DEFAULT_OVERMAP_RANGE)
	
	if(!map_levels.len)
		to_chat(user, "<span class='warning'>The crew monitor doesn't seem like it'll work here.</span>")
		if(ui)
			ui.close()
		return null

	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "CrewMonitor", name, 800, 600, master_ui, state)
		ui.autoupdate = TRUE
		ui.open()


/datum/tgui_module/crew_monitor/tgui_data(mob/user, ui_key = "main", datum/tgui_state/state = GLOB.tgui_default_state)
	var/data[0]

	data["isAI"] = isAI(user)

	var/z = get_z(tgui_host())
	var/list/map_levels = uniquelist(using_map.get_map_levels(z, TRUE, om_range = DEFAULT_OVERMAP_RANGE))
	data["map_levels"] = map_levels

	data["crewmembers"] = list()
	for(var/zlevel in map_levels)
		data["crewmembers"] += crew_repository.health_data(zlevel)

	return data
