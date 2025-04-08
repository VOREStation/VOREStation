/*!
 * Copyright (c) 2020 Aleksej Komarov
 * SPDX-License-Identifier: MIT
 */

/**
 * tgui datum (represents a UI).
 */
/datum/tgui
	/// The mob who opened/is using the UI.
	var/mob/user
	/// The object which owns the UI.
	var/datum/src_object
	/// The title of the UI.
	var/title
	/// The window_id for browse() and onclose().
	var/datum/tgui_window/window
	/// Key that is used for remembering the window geometry.
	var/window_key
	/// Deprecated: Window size.
	var/window_size
	/// The interface (template) to be used for this UI.
	var/interface
	/// Update the UI every MC tick.
	var/autoupdate = TRUE
	/// If the UI has been initialized yet.
	var/initialized = FALSE
	/// Time of opening the window.
	var/opened_at
	/// Stops further updates when close() was called.
	var/closing = FALSE
	/// The status/visibility of the UI.
	var/status = STATUS_INTERACTIVE
	/// Timed refreshing state
	var/refreshing = FALSE
	/// Topic state used to determine status/interactability.
	var/datum/tgui_state/state = null
	/// Rate limit client refreshes to prevent DoS.
	COOLDOWN_DECLARE(refresh_cooldown)
	/// Are byond mouse events beyond the window passed in to the ui
	var/mouse_hooked = FALSE
	/// The map z-level to display.
	var/map_z_level = 1
	/// The Parent UI
	var/datum/tgui/parent_ui
	/// Children of this UI
	var/list/children = list()
	/// Any partial packets that we have received from TGUI, waiting to be sent
	var/partial_packets

/**
 * public
 *
 * Create a new UI.
 *
 * required user mob The mob who opened/is using the UI.
 * required src_object datum The object or datum which owns the UI.
 * required interface string The interface used to render the UI.
 * optional title string The title of the UI.
 * optional parent_ui datum/tgui The parent of this UI.
 * optional ui_x int Deprecated: Window width.
 * optional ui_y int Deprecated: Window height.
 *
 * return datum/tgui The requested UI.
 */
/datum/tgui/New(mob/user, datum/src_object, interface, title, datum/tgui/parent_ui, ui_x, ui_y)
	src.user = user
	src.src_object = src_object
	src.window_key = "[REF(src_object)]-main"
	src.interface = interface
	if(title)
		src.title = title
	src.state = src_object.tgui_state()
	src.parent_ui = parent_ui
	if(parent_ui)
		parent_ui.children += src
	// Deprecated
	if(ui_x && ui_y)
		src.window_size = list(ui_x, ui_y)

/datum/tgui/Destroy()
	user = null
	src_object = null
	return ..()

/**
 * public
 *
 * Open this UI (and initialize it with data).
 *
 * return bool - TRUE if a new pooled window is opened, FALSE in all other situations including if a new pooled window didn't open because one already exists.
 */
/datum/tgui/proc/open()
	if(!user?.client)
		return FALSE
	if(window)
		return FALSE
	process_status()
	if(status < STATUS_UPDATE)
		return FALSE
	window = SStgui.request_pooled_window(user)
	if(!window)
		return FALSE
	opened_at = world.time
	window.acquire_lock(src)
	if(!window.is_ready())
		window.initialize(
			strict_mode = TRUE,
			fancy = user.read_preference(/datum/preference/toggle/tgui_fancy),
			assets = list(
				get_asset_datum(/datum/asset/simple/tgui),
				))
	else
		window.send_message("ping")
	send_assets()
	window.send_message("update", get_payload(
		with_data = TRUE,
		with_static_data = TRUE))
	if(mouse_hooked)
		window.set_mouse_macro()
	SStgui.on_open(src)

	return TRUE


/datum/tgui/proc/send_assets()
	var/flush_queue = window.send_asset(get_asset_datum(
		/datum/asset/simple/namespaced/fontawesome))
	flush_queue |= window.send_asset(get_asset_datum(
		/datum/asset/simple/namespaced/tgfont))
	flush_queue |= window.send_asset(get_asset_datum(
		/datum/asset/json/icon_ref_map))
	for(var/datum/asset/asset in src_object.ui_assets(user))
		flush_queue |= window.send_asset(asset)
	if (flush_queue)
		user.client.browse_queue_flush()

/**
 * public
 *
 * Close the UI.
 *
 * optional can_be_suspended bool
 */
/datum/tgui/proc/close(can_be_suspended = TRUE, logout = FALSE)
	if(closing)
		return
	closing = TRUE
	for(var/datum/tgui/child in children)
		child.close(can_be_suspended, logout)
	// If we don't have window_id, open proc did not have the opportunity
	// to finish, therefore it's safe to skip this whole block.
	if(window)
		// Windows you want to keep are usually blue screens of death
		// and we want to keep them around, to allow user to read
		// the error message properly.
		window.release_lock()
		window.close(can_be_suspended, logout)
		src_object.tgui_close(user)
		SStgui.on_close(src)
	state = null
	if(parent_ui)
		parent_ui.children -= src
	parent_ui = null
	qdel(src)

/**
 * public
 *
 * Enable/disable auto-updating of the UI.
 *
 * required value bool Enable/disable auto-updating.
 */
/datum/tgui/proc/set_autoupdate(autoupdate)
	src.autoupdate = autoupdate

/**
 * public
 *
 * Enable/disable passing through byond mouse events to the window
 *
 * required value bool Enable/disable hooking.
 */
/datum/tgui/proc/set_mouse_hook(value)
	src.mouse_hooked = value
	//Handle unhooking/hooking on already open windows ?

/**
 * public
 *
 * Replace current ui.state with a new one.
 *
 * required state datum/ui_state/state Next state
 */
/datum/tgui/proc/set_state(datum/tgui_state/state)
	src.state = state

/**
 * public
 *
 * Makes an asset available to use in tgui.
 *
 * required asset datum/asset
 *
 * return bool - true if an asset was actually sent
 */
/datum/tgui/proc/send_asset(datum/asset/asset)
	if(!window)
		CRASH("send_asset() was called either without calling open() first or when open() did not return TRUE.")
	return window.send_asset(asset)

/**
 * public
 *
 * Send a full update to the client (includes static data).
 *
 * optional custom_data list Custom data to send instead of ui_data.
 * optional force bool Send an update even if UI is not interactive.
 */
/datum/tgui/proc/send_full_update(custom_data, force)
	if(!user?.client || !initialized || closing)
		return
	//if(!COOLDOWN_FINISHED(src, refresh_cooldown))
		//refreshing = TRUE
		//addtimer(CALLBACK(src, PROC_REF(send_full_update)), TGUI_REFRESH_FULL_UPDATE_COOLDOWN, TIMER_UNIQUE)
		//return
	//refreshing = FALSE
	var/should_update_data = force || status >= STATUS_UPDATE
	window.send_message("update", get_payload(
		custom_data,
		with_data = should_update_data,
		with_static_data = TRUE))
	//COOLDOWN_START(src, refresh_cooldown, TGUI_REFRESH_FULL_UPDATE_COOLDOWN)

/**
 * public
 *
 * Send a partial update to the client (excludes static data).
 *
 * optional custom_data list Custom data to send instead of ui_data.
 * optional force bool Send an update even if UI is not interactive.
 */
/datum/tgui/proc/send_update(custom_data, force)
	if(!user?.client || !initialized || closing)
		return
	var/should_update_data = force || status >= STATUS_UPDATE
	window.send_message("update", get_payload(
		custom_data,
		with_data = should_update_data))

/**
 * private
 *
 * Package the data to send to the UI, as JSON.
 *
 * return list
 */
/datum/tgui/proc/get_payload(custom_data, with_data, with_static_data)
	var/list/json_data = list()
	json_data["config"] = list(
		"title" = title,
		"status" = status,
		"interface" = interface,
		//"refreshing" = refreshing,
		"refreshing" = FALSE,
		"map" = (using_map && using_map.path) ? using_map.path : "Unknown",
		"mapZLevel" = map_z_level,
		"window" = list(
			"key" = window_key,
			"size" = window_size,
			"fancy" = user.read_preference(/datum/preference/toggle/tgui_fancy),
			"locked" = user.read_preference(/datum/preference/toggle/tgui_lock),
		),
		"client" = list(
			"ckey" = user.client.ckey,
			"address" = user.client.address,
			"computer_id" = user.client.computer_id,
		),
		"user" = list(
			"name" = "[user]",
			"observer" = isobserver(user),
		),
	)
	var/data = custom_data || with_data && src_object.tgui_data(user, src, state)
	if(data)
		json_data["data"] = data
	var/static_data = with_static_data && src_object.tgui_static_data(user)
	if(static_data)
		json_data["static_data"] = static_data
	if(src_object.tgui_shared_states)
		json_data["shared"] = src_object.tgui_shared_states
	return json_data

/**
 * private
 *
 * Run an update cycle for this UI. Called internally by SStgui
 * every second or so.
 */
/datum/tgui/process(force = FALSE)
	if(closing)
		return
	var/datum/host = src_object.tgui_host(user)
	// If the object or user died (or something else), abort.
	if(!src_object || !host || !user || !window)
		close(can_be_suspended = FALSE)
		return
	// Validate ping
	if(!initialized && world.time - opened_at > TGUI_PING_TIMEOUT)
		log_tgui(user, \
			"Error: Zombie window detected, killing it with fire.\n" \
			+ "window_id: [window.id]\n" \
			+ "opened_at: [opened_at]\n" \
			+ "world.time: [world.time]")
		close(can_be_suspended = FALSE)
		return
	// Update through a normal call to ui_interact
	if(status != STATUS_DISABLED && (autoupdate || force))
		src_object.tgui_interact(user, src, parent_ui)
		return
	// Update status only
	var/needs_update = process_status()
	if(status <= STATUS_CLOSE)
		close()
		return
	if(needs_update)
		window.send_message("update", get_payload())

/**
 * private
 *
 * Updates the status, and returns TRUE if status has changed.
 */
/datum/tgui/proc/process_status()
	var/prev_status = status
	if(src_object)
		status = src_object.tgui_status(user, state)
	if(parent_ui)
		status = min(status, parent_ui.status)
	return prev_status != status

/datum/tgui/proc/set_map_z_level(nz)
	map_z_level = nz

/**
 * private
 *
 * Callback for handling incoming tgui messages.
 */
/datum/tgui/proc/on_message(type, list/payload, list/href_list)
	// Pass act type messages to tgui_act
	if(type && copytext(type, 1, 5) == "act/")
		var/act_type = copytext(type, 5)
		var/id = href_list["packetId"]
		if(!isnull(id))
			id = text2num(id)

			var/total = text2num(href_list["totalPackets"])
			if(id == 1)
				if(total > MAX_MESSAGE_CHUNKS)
					return

				partial_packets = new /list(total)

			partial_packets[id] = href_list["packet"]

			if(id != total)
				return

			var/assembled_payload = ""
			for(var/packet in partial_packets)
				assembled_payload += packet

			payload = json_decode(assembled_payload)
			partial_packets = null
		#ifdef TGUI_DEBUGGING
		log_tgui(user, "Action: [act_type] [href_list["payload"]], Window: [window.id], Source: [src_object]")
		#endif
		process_status()
		DEFAULT_QUEUE_OR_CALL_VERB(VERB_CALLBACK(src, PROC_REF(on_act_message), act_type, payload, state))
		return FALSE
	switch(type)
		if("ready")
			// Send a full update when the user manually refreshes the UI
			if(initialized)
				send_full_update()
			initialized = TRUE
		if("ping/reply")
			initialized = TRUE
		if("suspend")
			close(can_be_suspended = TRUE)
		if("close")
			close(can_be_suspended = FALSE)
		if("log")
			if(href_list["fatal"])
				close(can_be_suspended = FALSE)
		if("setSharedState")
			if(status != STATUS_INTERACTIVE)
				return
			LAZYINITLIST(src_object.tgui_shared_states)
			src_object.tgui_shared_states[href_list["key"]] = href_list["value"]
			SStgui.update_uis(src_object)
		if("fallback")
			#ifdef TGUI_DEBUGGING
			log_tgui(user, "Fallback Triggered: [href_list["payload"]], Window: [window.id], Source: [src_object]")
			#endif
			src_object.tgui_fallback(payload)

/// Wrapper for behavior to potentially wait until the next tick if the server is overloaded
/datum/tgui/proc/on_act_message(act_type, payload, state)
	if(QDELETED(src) || QDELETED(src_object))
		return
	if(src_object.tgui_act(act_type, payload, src, state))
		SStgui.update_uis(src_object)
