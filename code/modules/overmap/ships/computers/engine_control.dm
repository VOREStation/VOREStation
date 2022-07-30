//Engine control and monitoring console

/obj/machinery/computer/ship/engines
	name = "engine control console"
	icon_keyboard = "tech_key"
	icon_screen = "engines"
	circuit = /obj/item/circuitboard/engine
	var/display_state = "status"

// fancy sprite
/obj/machinery/computer/ship/engines/adv
	icon_keyboard = null
	icon_state = "adv_engines"
	icon_screen = "adv_engines_screen"
	light_color = "#05A6A8"

/obj/machinery/computer/ship/engines/tgui_interact(mob/user, datum/tgui/ui)
	if(!linked)
		display_reconnect_dialog(user, "ship control systems")
		return

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "OvermapEngines", "[linked.name] Engines Control") // 390, 530
		ui.open()

/obj/machinery/computer/ship/engines/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = list()
	data["global_state"] = linked.engines_state
	data["global_limit"] = round(linked.thrust_limit*100)
	var/total_thrust = 0

	var/list/enginfo = list()
	for(var/datum/ship_engine/E in linked.engines)
		var/list/rdata = list()
		rdata["eng_type"] = E.name
		rdata["eng_on"] = E.is_on()
		rdata["eng_thrust"] = E.get_thrust()
		rdata["eng_thrust_limiter"] = round(E.get_thrust_limit()*100)
		var/list/status = E.get_status()
		if(!islist(status))
			log_runtime(EXCEPTION("Warning, ship [E.name] (\ref[E]) for [linked.name] returned a non-list status!"))
			status = list("Error")
		rdata["eng_status"] = status
		rdata["eng_reference"] = "\ref[E]"
		total_thrust += E.get_thrust()
		enginfo.Add(list(rdata))

	data["engines_info"] = enginfo
	data["total_thrust"] = total_thrust
	return data

/obj/machinery/computer/ship/engines/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	switch(action)
		if("global_toggle")
			linked.engines_state = !linked.engines_state
			for(var/datum/ship_engine/E in linked.engines)
				if(linked.engines_state == !E.is_on())
					E.toggle()
			. = TRUE

		if("set_global_limit")
			var/newlim = tgui_input_number(usr, "Input new thrust limit (0..100%)", "Thrust limit", linked.thrust_limit*100, 100, 0)
			if(tgui_status(usr, state) != STATUS_INTERACTIVE)
				return FALSE
			linked.thrust_limit = clamp(newlim/100, 0, 1)
			for(var/datum/ship_engine/E in linked.engines)
				E.set_thrust_limit(linked.thrust_limit)
			. = TRUE

		if("global_limit")
			linked.thrust_limit = clamp(linked.thrust_limit + text2num(params["global_limit"]), 0, 1)
			for(var/datum/ship_engine/E in linked.engines)
				E.set_thrust_limit(linked.thrust_limit)
			. = TRUE

		if("set_limit")
			var/datum/ship_engine/E = locate(params["engine"])
			var/newlim = tgui_input_number(usr, "Input new thrust limit (0..100)", "Thrust limit", E.get_thrust_limit(), 100, 0)
			if(tgui_status(usr, state) != STATUS_INTERACTIVE)
				return FALSE
			var/limit = clamp(newlim/100, 0, 1)
			if(istype(E))
				E.set_thrust_limit(limit)
			. = TRUE

		if("limit")
			var/datum/ship_engine/E = locate(params["engine"])
			var/limit = clamp(E.get_thrust_limit() + text2num(params["limit"]), 0, 1)
			if(istype(E))
				E.set_thrust_limit(limit)
			. = TRUE

		if("toggle_engine")
			var/datum/ship_engine/E = locate(params["engine"])
			if(istype(E))
				E.toggle()
			. = TRUE

	if(. && !issilicon(usr))
		playsound(src, "terminal_type", 50, 1)
