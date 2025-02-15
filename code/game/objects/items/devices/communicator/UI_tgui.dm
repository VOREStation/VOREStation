// Etc UI-only vars
/obj/item/communicator
	// Stuff for moving cameras
	var/turf/last_camera_turf
	// Stuff needed to render the map
	var/map_name
	var/obj/screen/map_view/cam_screen
	var/list/cam_plane_masters
	var/obj/screen/background/cam_background
	var/obj/screen/skybox/local_skybox

// Proc: setup_tgui_camera()
// Parameters: None
// Description: This sets up all of the variables above to handle in-UI map windows.
/obj/item/communicator/proc/setup_tgui_camera()
	map_name = "communicator_[REF(src)]_map"

	// Initialize map objects
	cam_screen = new
	cam_screen.name = "screen"
	cam_screen.assigned_map = map_name
	cam_screen.del_on_map_removal = FALSE
	cam_screen.screen_loc = "[map_name]:1,1"

	cam_plane_masters = get_tgui_plane_masters()

	for(var/obj/screen/instance as anything in cam_plane_masters)
		instance.assigned_map = map_name
		instance.del_on_map_removal = FALSE
		instance.screen_loc = "[map_name]:CENTER"

	local_skybox = new()
	local_skybox.assigned_map = map_name
	local_skybox.del_on_map_removal = FALSE
	local_skybox.screen_loc = "[map_name]:CENTER,CENTER"
	cam_plane_masters += local_skybox

	cam_background = new
	cam_background.assigned_map = map_name
	cam_background.del_on_map_removal = FALSE

// Proc: update_active_camera_screen()
// Parameters: None
// Description: This refreshes the camera location
/obj/item/communicator/proc/update_active_camera_screen()
	if(!video_source?.can_use())
		show_static()
		return

	var/newturf = get_turf(video_source)
	if(!is_on_same_plane_or_station(get_z(newturf), get_z(src)))
		show_static()
		return

	var/obj/item/communicator/communicator = video_source.loc
	if(istype(communicator))
		if(communicator.selfie_mode)
			var/mob/target = get(communicator, /mob)
			if(istype(target))
				cam_screen.vis_contents = list(target)
			else
				cam_screen.vis_contents = list(communicator)
			cam_background.fill_rect(1, 1, 1, 1)
			cam_background.icon_state = "clear"
			local_skybox.cut_overlays()
			return

	// If we're not forcing an update for some reason and the cameras are in the same location,
	// we don't need to update anything.
	if(last_camera_turf == newturf)
		return

	// We get a new turf in case they've moved in the last half decisecond (it's BYOND, it might happen)
	last_camera_turf = get_turf(video_source)

	if(!is_on_same_plane_or_station(get_z(last_camera_turf), get_z(src)))
		show_static()
		return

	var/list/visible_turfs = list()
	var/list/visible_things = view(video_range, last_camera_turf)
	for(var/turf/visible_turf in visible_things)
		visible_turfs += visible_turf

	cam_screen.vis_contents = visible_turfs
	cam_background.icon_state = "clear"
	cam_background.fill_rect(1, 1, (video_range * 2), (video_range * 2))

	local_skybox.cut_overlays()
	local_skybox.add_overlay(SSskybox.get_skybox(get_z(last_camera_turf)))
	local_skybox.scale_to_view(video_range * 2)
	local_skybox.set_position("CENTER", "CENTER", (world.maxx>>1) - last_camera_turf.x, (world.maxy>>1) - last_camera_turf.y)

/obj/item/communicator/proc/show_static()
	cam_screen.vis_contents.Cut()
	cam_background.icon_state = "scanline2"
	cam_background.fill_rect(1, 1, (video_range * 2), (video_range * 2))
	local_skybox.cut_overlays()

// Proc: tgui_state()
// Parameters: User
// Description: This tells TGUI to only allow us to be interacted with while in a mob inventory.
/obj/item/communicator/tgui_state(mob/user)
	return GLOB.tgui_inventory_state

// Proc: tgui_interact()
// Parameters: User, UI, Parent UI
// Description: This proc handles opening the UI. It's basically just a standard stub.
/obj/item/communicator/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui, datum/tgui_state/custom_state)
	ui = SStgui.try_update_ui(user, src, ui)
	// Update the camera every SStgui tick in case it moves
	update_active_camera_screen()
	if(!ui)
		// Register map objects
		user.client.register_map_obj(cam_screen)
		for(var/plane in cam_plane_masters)
			user.client.register_map_obj(plane)
		user.client.register_map_obj(cam_background)
		// Setup UI
		ui = new(user, src, "Communicator", name)
		if(custom_state)
			ui.set_state(custom_state)
		ui.open()
	if(custom_state) // Just in case
		ui.set_state(custom_state)

// Proc: tgui_data()
// Parameters: User, UI, State
// Description: Uses a bunch of for loops to turn lists into lists of lists, so they can be displayed in nanoUI, then displays various buttons to the user.
/obj/item/communicator/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
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
	for(var/obj/item/communicator/comm in known_devices)
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
	for(var/obj/item/communicator/comm in voice_invites)
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
	for(var/obj/item/communicator/comm in voice_requests)
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
	for(var/obj/item/communicator/comm in communicating)
		connected_communicators.Add(list(list(
			"name" = sanitize(comm.name),
			"true_name" = sanitize(comm.name),
			"ref" = "\ref[comm]",
		)))

	//Devices that have been messaged or recieved messages from.
	for(var/obj/item/communicator/comm in im_contacts)
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
	data["selfie_mode"] = selfie_mode

	return data

// Proc: tgui_static_data()
// Parameters: User, UI, State
// Description: Just like tgui_data, except it only gets called once when the user opens the UI, not every tick.
/obj/item/communicator/tgui_static_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()
	// Update manifest'
	if(data_core)
		data_core.get_manifest_list()
	data["manifest"] = GLOB.PDA_Manifest
	data["mapRef"] = map_name
	return data

// Proc: tgui-act()
// Parameters: 4 (standard tgui_act arguments)
// Description: Responds to UI button presses.
/obj/item/communicator/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	add_fingerprint(ui.user)
	. = TRUE
	switch(action)
		if("rename")
			var/new_name = sanitizeSafe(tgui_input_text(ui.user,"Please enter your name.","Communicator",ui.user.name) )
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

		if("set_ringer_tone")
			var/ringtone = tgui_input_text(ui.user, "Set Ringer Tone", "Ringer")
			if(ringtone)
				ttone = ringtone

		if("selfie_mode")
			selfie_mode = !selfie_mode

		if("add_hex")
			var/hex = params["add_hex"]
			add_to_EPv2(hex)

		if("write_target_address")
			target_address = sanitizeSafe(params["val"])

		if("clear_target_address")
			target_address = ""

		if("dial")
			if(!get_connection_to_tcomms())
				to_chat(ui.user, span_danger("Error: Cannot connect to Exonet node."))
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
				to_chat(ui.user, span_danger("Error: Cannot connect to Exonet node."))
				return FALSE
			var/their_address = params["message"]
			var/text = sanitizeSafe(tgui_input_text(ui.user,"Enter your message.","Text Message"))
			if(text)
				exonet.send_message(their_address, "text", text)
				im_list += list(list("address" = exonet.address, "to_address" = their_address, "im" = text))
				log_pda("(COMM: [src]) sent \"[text]\" to [exonet.get_atom_from_address(their_address)]", ui.user)
				var/obj/item/communicator/comm = exonet.get_atom_from_address(their_address)
				to_chat(ui.user, span_notice("[icon2html(src, ui.user.client)] Sent message to [istype(comm, /obj/item/communicator) ? comm.owner : comm.name], <b>\"[text]\"</b> (<a href='byond://?src=\ref[src];action=Reply;target=\ref[exonet.get_atom_from_address(comm.exonet.address)]'>Reply</a>)"))
				for(var/mob/M in player_list)
					if(M.stat == DEAD && M.client?.prefs?.read_preference(/datum/preference/toggle/ghost_ears))
						if(isnewplayer(M) || M.forbid_seeing_deadchat)
							continue
						if(exonet.get_atom_from_address(their_address) == M)
							continue
						M.show_message("Comm IM - [src] -> [exonet.get_atom_from_address(their_address)]: [text]")

		if("disconnect")
			var/name_to_disconnect = params["disconnect"]
			for(var/mob/living/voice/V in contents)
				if(name_to_disconnect == sanitize(V.name))
					close_connection(ui.user, V, "[ui.user] hung up")
			for(var/obj/item/communicator/comm in communicating)
				if(name_to_disconnect == sanitize(comm.name))
					close_connection(ui.user, comm, "[ui.user] hung up")

		if("startvideo")
			var/ref_to_video = params["startvideo"]
			var/obj/item/communicator/comm = locate(ref_to_video)
			if(comm)
				connect_video(ui.user, comm)

		if("endvideo")
			if(video_source)
				end_video()

		if("copy")
			target_address = params["copy"]

		if("copy_name")
			target_address_name = params["copy_name"]

		if("hang_up")
			for(var/mob/living/voice/V in contents)
				close_connection(ui.user, V, "[ui.user] hung up")
			for(var/obj/item/communicator/comm in communicating)
				close_connection(ui.user, comm, "[ui.user] hung up")

		if("switch_tab")
			selected_tab = params["switch_tab"]

		if("edit")
			var/n = tgui_input_text(ui.user, "Please enter message", name, notehtml, multiline = TRUE, prevent_enter = TRUE)
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
