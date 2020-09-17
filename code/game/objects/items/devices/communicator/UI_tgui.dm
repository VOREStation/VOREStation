// Proc: tgui_state()
// Parameters: User
// Description: This tells TGUI to only allow us to be interacted with while in a mob inventory.
/obj/item/device/communicator/tgui_state(mob/user)
	return GLOB.tgui_inventory_state

// Proc: tgui_interact()
// Parameters: User, UI, Parent UI
// Description: This proc handles opening the UI. It's basically just a standard stub.
/obj/item/device/communicator/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui, datum/tgui_state/custom_state)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Communicator", name)
		if(custom_state)
			ui.set_state(custom_state)
		ui.open()
	if(custom_state) // Just in case
		ui.set_state(custom_state)

// Proc: tgui_data()
// Parameters: User, UI, State
// Description: Uses a bunch of for loops to turn lists into lists of lists, so they can be displayed in nanoUI, then displays various buttons to the user.
/obj/item/device/communicator/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	// this is the data which will be sent to the ui
	var/list/data = list()						//General nanoUI information
	var/list/communicators = list()			    //List of communicators
	var/list/invites = list()					//Communicators and ghosts we've invited to our communicator.
	var/list/requests = list()					//Communicators and ghosts wanting to go in our communicator.
	var/list/voices = list()					//Current /mob/living/voice s inside the device.
	var/list/connected_communicators = list()	//Current communicators connected to the device.

	var/list/im_contacts_ui = list()			//List of communicators that have been messaged.
	var/list/im_list_ui = list()				//List of messages.

	var/list/weather = list()
	var/list/modules_ui = list()				//Home screen info.

	//First we add other 'local' communicators.
	for(var/obj/item/device/communicator/comm in known_devices)
		if(comm.network_visibility && comm.exonet)
			communicators.Add(list(list(
				"name" = sanitize(comm.name),
				"address" = comm.exonet.address
			)))

	//Now for ghosts who we pretend have communicators.
	for(var/mob/observer/dead/O in known_devices)
		if(O.client && O.client.prefs.communicator_visibility == 1 && O.exonet)
			communicators.Add(list(list(
				"name" = sanitize("[O.client.prefs.real_name]'s communicator"),
				"address" = O.exonet.address,
				"ref" = "\ref[O]"
			)))

	//Lists all the other communicators that we invited.
	for(var/obj/item/device/communicator/comm in voice_invites)
		if(comm.exonet)
			invites.Add(list(list(
				"name" = sanitize(comm.name),
				"address" = comm.exonet.address,
				"ref" = "\ref[comm]"
			)))

	//Ghosts we invited.
	for(var/mob/observer/dead/O in voice_invites)
		if(O.exonet && O.client)
			invites.Add(list(list(
				"name" = sanitize("[O.client.prefs.real_name]'s communicator"),
				"address" = O.exonet.address,
				"ref" = "\ref[O]"
			)))

	//Communicators that want to talk to us.
	for(var/obj/item/device/communicator/comm in voice_requests)
		if(comm.exonet)
			requests.Add(list(list(
				"name" = sanitize(comm.name),
				"address" = comm.exonet.address,
				"ref" = "\ref[comm]"
			)))

	//Ghosts that want to talk to us.
	for(var/mob/observer/dead/O in voice_requests)
		if(O.exonet && O.client)
			requests.Add(list(list(
				"name" = sanitize("[O.client.prefs.real_name]'s communicator"),
				"address" = O.exonet.address,
				"ref" = "\ref[O]"
			)))

	//Now for all the voice mobs inside the communicator.
	for(var/mob/living/voice/voice in contents)
		voices.Add(list(list(
			"name" = sanitize("[voice.name]'s communicator"),
			"true_name" = sanitize(voice.name),
		)))

	//Finally, all the communicators linked to this one.
	for(var/obj/item/device/communicator/comm in communicating)
		connected_communicators.Add(list(list(
			"name" = sanitize(comm.name),
			"true_name" = sanitize(comm.name),
			"ref" = "\ref[comm]",
		)))

	//Devices that have been messaged or recieved messages from.
	for(var/obj/item/device/communicator/comm in im_contacts)
		if(comm.exonet)
			im_contacts_ui.Add(list(list(
				"name" = sanitize(comm.name),
				"address" = comm.exonet.address,
				"ref" = "\ref[comm]"
			)))

	for(var/mob/observer/dead/ghost in im_contacts)
		if(ghost.exonet)
			im_contacts_ui.Add(list(list(
				"name" = sanitize(ghost.name),
				"address" = ghost.exonet.address,
				"ref" = "\ref[ghost]"
			)))

	for(var/obj/item/integrated_circuit/input/EPv2/CIRC in im_contacts)
		if(CIRC.exonet && CIRC.assembly)
			im_contacts_ui.Add(list(list(
				"name" = sanitize(CIRC.assembly.name),
				"address" = CIRC.exonet.address,
				"ref" = "\ref[CIRC]"
			)))


	//Actual messages.
	for(var/I in im_list)
		im_list_ui.Add(list(list(
			"address" = I["address"],
			"to_address" = I["to_address"],
			"im" = I["im"]
		)))

	//Weather reports.
	for(var/datum/planet/planet in SSplanets.planets)
		if(planet.weather_holder && planet.weather_holder.current_weather)
			var/list/W = list(
				"Planet" = planet.name,
				"Time" = planet.current_time.show_time("hh:mm"),
				"Weather" = planet.weather_holder.current_weather.name,
				"Temperature" = planet.weather_holder.temperature - T0C,
				"High" = planet.weather_holder.current_weather.temp_high - T0C,
				"Low" = planet.weather_holder.current_weather.temp_low - T0C,
				"WindDir" = planet.weather_holder.wind_dir ? dir2text(planet.weather_holder.wind_dir) : "None",
				"WindSpeed" = planet.weather_holder.wind_speed ? "[planet.weather_holder.wind_speed > 2 ? "Severe" : "Normal"]" : "None",
				"Forecast" = english_list(planet.weather_holder.forecast, and_text = "&#8594;", comma_text = "&#8594;", final_comma_text = "&#8594;") // Unicode RIGHTWARDS ARROW.
				)
			weather.Add(list(W))


	//Modules for homescreen.
	for(var/list/R in modules)
		modules_ui.Add(list(R))

	data["user"] = "\ref[user]"	// For receiving input() via topic, because input(usr,...) wasn't working on cartridges
	data["owner"] = owner ? owner : "Unset"
	data["occupation"] = occupation ? occupation : "Swipe ID to set."
	data["connectionStatus"] = get_connection_to_tcomms()
	data["visible"] = network_visibility
	data["address"] = exonet.address ? exonet.address : "Unallocated"
	data["targetAddress"] = target_address
	data["targetAddressName"] = target_address_name
	data["currentTab"] = selected_tab
	data["knownDevices"] = communicators
	data["invitesSent"] = invites
	data["requestsReceived"] = requests
	data["voice_mobs"] = voices
	data["communicating"] = connected_communicators
	data["video_comm"] = video_source ? "\ref[video_source.loc]" : null
	data["imContacts"] = im_contacts_ui
	data["imList"] = im_list_ui
	data["time"] = stationtime2text()
	data["ring"] = ringer
	data["homeScreen"] = modules_ui
	data["note"] = note					// current notes
	data["weather"] = weather
	data["aircontents"] = src.analyze_air()
	data["flashlight"] = fon
	data["feeds"] = compile_news()
	data["latest_news"] = get_recent_news()
	if(newsfeed_channel)
		data["target_feed"] = data["feeds"][newsfeed_channel]
	else
		data["target_feed"] = null

	return data

// Proc: tgui_static_data()
// Parameters: User, UI, State
// Description: Just like tgui_data, except it only gets called once when the user opens the UI, not every tick.
/obj/item/device/communicator/tgui_static_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()
	// Update manifest'
	if(data_core)
		data_core.get_manifest_list()
	data["manifest"] = PDA_Manifest
	return data

// Proc: tgui-act()
// Parameters: 4 (standard tgui_act arguments)
// Description: Responds to UI button presses.
/obj/item/device/communicator/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	add_fingerprint(usr)
	. = TRUE
	switch(action)
		if("rename")
			var/new_name = sanitizeSafe(input(usr,"Please enter your name.","Communicator",usr.name) )
			if(new_name)
				register_device(new_name)

		if("toggle_visibility")
			switch(network_visibility)
				if(1) //Visible, becoming invisbile
					network_visibility = 0
					if(camera)
						camera.remove_network(NETWORK_COMMUNICATORS)
				if(0) //Invisible, becoming visible
					network_visibility = 1
					if(camera)
						camera.add_network(NETWORK_COMMUNICATORS)

		if("toggle_ringer")
			ringer = !ringer

		if("add_hex")
			var/hex = params["add_hex"]
			add_to_EPv2(hex)

		if("write_target_address")
			target_address = sanitizeSafe(params["val"])

		if("clear_target_address")
			target_address = ""

		if("dial")
			if(!get_connection_to_tcomms())
				to_chat(usr, "<span class='danger'>Error: Cannot connect to Exonet node.</span>")
				return FALSE
			var/their_address = params["dial"]
			exonet.send_message(their_address, "voice")

		if("decline")
			var/ref_to_remove = params["decline"]
			var/atom/decline = locate(ref_to_remove)
			if(decline)
				del_request(decline)

		if("message")
			if(!get_connection_to_tcomms())
				to_chat(usr, "<span class='danger'>Error: Cannot connect to Exonet node.</span>")
				return FALSE
			var/their_address = params["message"]
			var/text = sanitizeSafe(input(usr,"Enter your message.","Text Message"))
			if(text)
				exonet.send_message(their_address, "text", text)
				im_list += list(list("address" = exonet.address, "to_address" = their_address, "im" = text))
				log_pda("(COMM: [src]) sent \"[text]\" to [exonet.get_atom_from_address(their_address)]", usr)
				for(var/mob/M in player_list)
					if(M.stat == DEAD && M.is_preference_enabled(/datum/client_preference/ghost_ears))
						if(istype(M, /mob/new_player) || M.forbid_seeing_deadchat)
							continue
						if(exonet.get_atom_from_address(their_address) == M)
							continue
						M.show_message("Comm IM - [src] -> [exonet.get_atom_from_address(their_address)]: [text]")

		if("disconnect")
			var/name_to_disconnect = params["disconnect"]
			for(var/mob/living/voice/V in contents)
				if(name_to_disconnect == sanitize(V.name))
					close_connection(usr, V, "[usr] hung up")
			for(var/obj/item/device/communicator/comm in communicating)
				if(name_to_disconnect == sanitize(comm.name))
					close_connection(usr, comm, "[usr] hung up")

		if("startvideo")
			var/ref_to_video = params["startvideo"]
			var/obj/item/device/communicator/comm = locate(ref_to_video)
			if(comm)
				connect_video(usr, comm)

		if("endvideo")
			if(video_source)
				end_video()

		if("copy")
			target_address = params["copy"]

		if("copy_name")
			target_address_name = params["copy_name"]

		if("hang_up")
			for(var/mob/living/voice/V in contents)
				close_connection(usr, V, "[usr] hung up")
			for(var/obj/item/device/communicator/comm in communicating)
				close_connection(usr, comm, "[usr] hung up")

		if("switch_tab")
			selected_tab = params["switch_tab"]

		if("edit")
			var/n = input(usr, "Please enter message", name, notehtml) as message|null
			n = sanitizeSafe(n, extra = 0)
			if(n)
				note = html_decode(n)
				notehtml = note
				note = replacetext(note, "\n", "<br>")
			else
				note = ""
				notehtml = note

		if("Light")
			fon = !fon
			set_light(fon * flum)

		if("newsfeed")
			newsfeed_channel = text2num(params["newsfeed"])

