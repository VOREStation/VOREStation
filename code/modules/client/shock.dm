/client/var/datum/tgui_shock/tgui_shocker

/client/verb/configure_shocker()
	set name = "Configure MultiShock Integration"
	set category = "OOC.Game Settings"

	if(tgui_shocker)
		tgui_shocker.tgui_interact(mob)

/mob/proc/attempt_multishock(flag)
	client?.attempt_multishock(flag)

/client/proc/attempt_multishock(flag)
	tgui_shocker?.shock(flag)

// NOTE: This datum controls TWO UIs, `window` is hidden and provides all of the WebSocket shit, `tgui_interact` is a
// normal configuration UI!
/datum/tgui_shock
	/// The user who opened the window
	var/client/client
	/// The modal window
	var/datum/tgui_window/window

	var/port = 8765
	var/enabled_flags = 0
	var/intensity = 15
	var/duration = 1

	var/connected = FALSE
	var/selected_device = -1
	var/list/available_devices

//////////////////////////////////////////
// SHOCK.JS UI                          //
//////////////////////////////////////////
/datum/tgui_shock/New(client/client, id)
	src.client = client
	window = new(client, id)
	window.subscribe(src, PROC_REF(on_message))
	window.is_browser = TRUE

/datum/tgui_shock/proc/initialize()
	set waitfor = FALSE
	window.initialize(
		inline_js = file2text('html/shock.js')
	)

/datum/tgui_shock/proc/connect()
	window.send_message("connect", list(
		"port" = port,
	))

/datum/tgui_shock/proc/request_devices()
	if(!connected)
		return
	window.send_message("enumerateShockers")

/datum/tgui_shock/proc/shock(flag)
	if(!connected || !selected_device)
		return

	if(flag != SHOCKFLAG_TEST)
		if(!(enabled_flags & flag))
			return

	window.send_message("shock", list(
		"intensity" = intensity,
		"duration" = duration,
		"shocker_ids" = list(
			selected_device
		),
		"warning" = FALSE,
	))

/datum/tgui_shock/proc/estop()
	window.send_message("estop")

/datum/tgui_shock/proc/on_message(type, payload, href_list)
	if(type == "connected")
		connected = TRUE
	else if(type == "disconnected")
		connected = FALSE
	else if(type == "error")
		connected = FALSE
		log_debug("WebSocket Error [json_encode(payload)]")
	else if(type == "incomingMessage")
		if(payload["lastCall"] == "get_devices")
			available_devices = json_decode(payload["data"])

//////////////////////////////////////////
// TGUI                                 //
//////////////////////////////////////////
/datum/tgui_shock/tgui_state(mob/user)
	return GLOB.tgui_always_state

/datum/tgui_shock/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui, custom_state)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ShockConfigurator", "Shock Configurator")
		ui.open()

/datum/tgui_shock/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	data["port"] = port
	data["connected"] = connected
	data["intensity"] = intensity
	data["duration"] = duration
	data["selectedDevice"] = selected_device
	data["availableDevices"] = available_devices
	data["enabledFlags"] = enabled_flags

	return data

/datum/tgui_shock/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	. = ..()

	switch(action)
		if("connect")
			if(connected)
				estop()
			else
				// TODO: preferences
				connect()
			. = TRUE
		if("request_devices")
			request_devices()
			. = TRUE
		if("estop")
			estop()
			. = TRUE
		if("setSelectedDevice")
			selected_device = text2num(params["device"])
			. = TRUE
		if("test")
			shock(SHOCKFLAG_TEST)
			. = TRUE
		if("set_flag")
			enabled_flags ^= text2num(params["flag"])
			. = TRUE
		if("port")
			port = text2num(params["port"])
			. = TRUE
		if("intensity")
			intensity = text2num(params["intensity"])
			. = TRUE
		if("duration")
			duration = text2num(params["duration"])
			. = TRUE
