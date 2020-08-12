/datum/tgui_module/shutoff_monitor
	name = "Shutoff Valve Monitoring"
	tgui_id = "ShutoffMonitor"

/datum/tgui_module/shutoff_monitor/tgui_act(action, params)
	if(..())
		return TRUE

	switch(action)
		if("toggle_enable")
			var/obj/machinery/atmospherics/valve/shutoff/S = locate(params["valve"])
			if(!istype(S))
				return 0
			S.close_on_leaks = !S.close_on_leaks
			return 1

		if("toggle_open")
			var/obj/machinery/atmospherics/valve/shutoff/S = locate(params["valve"])
			if(!istype(S))
				return 0
			if(S.open)
				S.close()
			else
				S.open()
			return 1

/datum/tgui_module/shutoff_monitor/tgui_data(mob/user)
	var/list/data = list()
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
	return data

/datum/tgui_module/shutoff_monitor/ntos
	ntos = TRUE