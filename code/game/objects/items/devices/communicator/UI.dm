// Proc: ui_interact()
// Parameters: 4 (standard NanoUI arguments)
// Description: Uses a bunch of for loops to turn lists into lists of lists, so they can be displayed in nanoUI, then displays various buttons to the user.
/obj/item/communicator/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/key_state = null)
	// this is the data which will be sent to the ui
	var/data[0]						//General nanoUI information
	var/communicators[0]			//List of communicators
	var/invites[0]					//Communicators and ghosts we've invited to our communicator.
	var/requests[0]					//Communicators and ghosts wanting to go in our communicator.
	var/voices[0]					//Current /mob/living/voice s inside the device.
	var/connected_communicators[0]	//Current communicators connected to the device.

	var/im_contacts_ui[0]			//List of communicators that have been messaged.
	var/im_list_ui[0]				//List of messages.

	var/weather[0]
	var/modules_ui[0]				//Home screen info.

	//First we add other 'local' communicators.
	for(var/obj/item/communicator/comm in known_devices)
		if(comm.network_visibility && comm.exonet)
			communicators[++communicators.len] = list("name" = sanitize(comm.name), "address" = comm.exonet.address)

	//Now for ghosts who we pretend have communicators.
	for(var/mob/observer/dead/O in known_devices)
		if(O.client && O.client.prefs.communicator_visibility == 1 && O.exonet)
			communicators[++communicators.len] = list("name" = sanitize("[O.client.prefs.real_name]'s communicator"), "address" = O.exonet.address, "ref" = "\ref[O]")

	//Lists all the other communicators that we invited.
	for(var/obj/item/communicator/comm in voice_invites)
		if(comm.exonet)
			invites[++invites.len] = list("name" = sanitize(comm.name), "address" = comm.exonet.address, "ref" = "\ref[comm]")

	//Ghosts we invited.
	for(var/mob/observer/dead/O in voice_invites)
		if(O.exonet && O.client)
			invites[++invites.len] = list("name" = sanitize("[O.client.prefs.real_name]'s communicator"), "address" = O.exonet.address, "ref" = "\ref[O]")

	//Communicators that want to talk to us.
	for(var/obj/item/communicator/comm in voice_requests)
		if(comm.exonet)
			requests[++requests.len] = list("name" = sanitize(comm.name), "address" = comm.exonet.address, "ref" = "\ref[comm]")

	//Ghosts that want to talk to us.
	for(var/mob/observer/dead/O in voice_requests)
		if(O.exonet && O.client)
			requests[++requests.len] = list("name" = sanitize("[O.client.prefs.real_name]'s communicator"), "address" = O.exonet.address, "ref" = "\ref[O]")

	//Now for all the voice mobs inside the communicator.
	for(var/mob/living/voice/voice in contents)
		voices[++voices.len] = list("name" = sanitize("[voice.name]'s communicator"), "true_name" = sanitize(voice.name))

	//Finally, all the communicators linked to this one.
	for(var/obj/item/communicator/comm in communicating)
		connected_communicators[++connected_communicators.len] = list("name" = sanitize(comm.name), "true_name" = sanitize(comm.name), "ref" = "\ref[comm]")

	//Devices that have been messaged or recieved messages from.
	for(var/obj/item/communicator/comm in im_contacts)
		if(comm.exonet)
			im_contacts_ui[++im_contacts_ui.len] = list("name" = sanitize(comm.name), "address" = comm.exonet.address, "ref" = "\ref[comm]")

	for(var/mob/observer/dead/ghost in im_contacts)
		if(ghost.exonet)
			im_contacts_ui[++im_contacts_ui.len] = list("name" = sanitize(ghost.name), "address" = ghost.exonet.address, "ref" = "\ref[ghost]")

	for(var/obj/item/integrated_circuit/input/EPv2/CIRC in im_contacts)
		if(CIRC.exonet && CIRC.assembly)
			im_contacts_ui[++im_contacts_ui.len] = list("name" = sanitize(CIRC.assembly.name), "address" = CIRC.exonet.address, "ref" = "\ref[CIRC]")


	//Actual messages.
	for(var/I in im_list)
		im_list_ui[++im_list_ui.len] = list("address" = I["address"], "to_address" = I["to_address"], "im" = I["im"])

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
			weather[++weather.len] = W

	// Update manifest
	data_core.get_manifest_list()

	//Modules for homescreen.
	for(var/list/R in modules)
		modules_ui[++modules_ui.len] = R

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
	data["manifest"] = PDA_Manifest
	data["feeds"] = compile_news()
	data["latest_news"] = get_recent_news()
	if(newsfeed_channel)
		data["target_feed"] = data["feeds"][newsfeed_channel]

	// update the ui if it exists, returns null if no ui is passed/found
	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		// the ui does not exist, so we'll create a new() one
        // for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		data["currentTab"] = 1 // Reset the current tab, because we're going to home page
		ui = new(user, src, ui_key, "communicator_header.tmpl", "Communicator", 475, 700, state = key_state)
		// add templates for screens in common with communicator.
		ui.add_template("atmosphericScan", "atmospheric_scan.tmpl")
		ui.add_template("crewManifest", "crew_manifest.tmpl")
		ui.add_template("Body", "communicator.tmpl") // Main body
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()
		// auto update every five Master Controller tick
		ui.set_auto_update(5)

// Proc: Topic()
// Parameters: 2 (standard Topic arguments)
// Description: Responds to NanoUI button presses.
/obj/item/communicator/Topic(href, href_list)
	if(..())
		return 1
	if(href_list["rename"])
		var/new_name = sanitizeSafe(input(usr,"Please enter your name.","Communicator",usr.name) )
		if(new_name)
			register_device(new_name)

	if(href_list["toggle_visibility"])
		switch(network_visibility)
			if(1) //Visible, becoming invisbile
				network_visibility = 0
				if(camera)
					camera.remove_network(NETWORK_COMMUNICATORS)
			if(0) //Invisible, becoming visible
				network_visibility = 1
				if(camera)
					camera.add_network(NETWORK_COMMUNICATORS)

	if(href_list["toggle_ringer"])
		ringer = !ringer

	if(href_list["add_hex"])
		var/hex = href_list["add_hex"]
		add_to_EPv2(hex)

	if(href_list["write_target_address"])
		var/new_address = sanitizeSafe(input(usr,"Please enter the desired target EPv2 address.  Note that you must write the colons \
			yourself.","Communicator",src.target_address) )
		if(new_address)
			target_address = new_address

	if(href_list["clear_target_address"])
		target_address = ""

	if(href_list["dial"])
		if(!get_connection_to_tcomms())
			to_chat(usr, "<span class='danger'>Error: Cannot connect to Exonet node.</span>")
			return
		var/their_address = href_list["dial"]
		exonet.send_message(their_address, "voice")

	if(href_list["decline"])
		var/ref_to_remove = href_list["decline"]
		var/atom/decline = locate(ref_to_remove)
		if(decline)
			del_request(decline)

	if(href_list["message"])
		if(!get_connection_to_tcomms())
			to_chat(usr, "<span class='danger'>Error: Cannot connect to Exonet node.</span>")
			return
		var/their_address = href_list["message"]
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

	if(href_list["disconnect"])
		var/name_to_disconnect = href_list["disconnect"]
		for(var/mob/living/voice/V in contents)
			if(name_to_disconnect == V.name)
				close_connection(usr, V, "[usr] hung up")
		for(var/obj/item/communicator/comm in communicating)
			if(name_to_disconnect == comm.name)
				close_connection(usr, comm, "[usr] hung up")

	if(href_list["startvideo"])
		var/ref_to_video = href_list["startvideo"]
		var/obj/item/communicator/comm = locate(ref_to_video)
		if(comm)
			connect_video(usr, comm)

	if(href_list["endvideo"])
		if(video_source)
			end_video()

	if(href_list["watchvideo"])
		if(video_source)
			watch_video(usr,video_source.loc)

	if(href_list["copy"])
		target_address = href_list["copy"]

	if(href_list["copy_name"])
		target_address_name = href_list["copy_name"]

	if(href_list["hang_up"])
		for(var/mob/living/voice/V in contents)
			close_connection(usr, V, "[usr] hung up")
		for(var/obj/item/communicator/comm in communicating)
			close_connection(usr, comm, "[usr] hung up")

	if(href_list["switch_tab"])
		selected_tab = href_list["switch_tab"]

	if(href_list["edit"])
		var/n = input(usr, "Please enter message", name, notehtml)
		n = sanitizeSafe(n, extra = 0)
		if(n)
			note = html_decode(n)
			notehtml = note
			note = replacetext(note, "\n", "<br>")
		else
			note = ""
			notehtml = note

	if(href_list["switch_template"])
		var/datum/nanoui/ui = SSnanoui.get_open_ui(usr, src, "main")
		if(ui)
			ui.add_template("Body", href_list["switch_template"])

	if(href_list["Light"])
		fon = !fon
		set_light(fon * flum)

	if(href_list["newsfeed"])
		newsfeed_channel = text2num(href_list["newsfeed"])

	SSnanoui.update_uis(src)
	add_fingerprint(usr)
