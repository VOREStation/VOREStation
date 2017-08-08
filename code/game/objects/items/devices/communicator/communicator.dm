// Communicators
//
// Allows ghosts to roleplay with crewmembers without having to commit to joining the round, and also allows communications between two communicators.

var/global/list/obj/item/device/communicator/all_communicators = list()

/obj/item/device/communicator
	name = "communicator"
	desc = "A personal device used to enable long range dialog between two people, utilizing existing telecommunications infrastructure to allow \
	communications across different stations, planets, or even star systems."
	icon = 'icons/obj/device.dmi'
	icon_state = "communicator"
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_ID | SLOT_BELT
	show_messages = 1

	origin_tech = list(TECH_ENGINEERING = 2, TECH_MAGNET = 2, TECH_BLUESPACE = 2, TECH_DATA = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 30,"glass" = 10)

	var/video_range = 4
	var/obj/machinery/camera/communicator/video_source	// Their camera
	var/obj/machinery/camera/communicator/camera		// Our camera

	var/list/voice_mobs = list()
	var/list/voice_requests = list()
	var/list/voice_invites = list()

	var/list/im_contacts = list()
	var/list/im_list = list()

	var/note = "Thank you for choosing the T-14.2 Communicator, this is your notepad!" //Current note in the notepad function
	var/notehtml = ""

	var/obj/item/weapon/cartridge/cartridge = null //current cartridge
	var/list/modules = list(
							list("module" = "Phone", "icon" = "phone64", "number" = 2),
							list("module" = "Contacts", "icon" = "person64", "number" = 3),
							list("module" = "Messaging", "icon" = "comment64", "number" = 4),
							list("module" = "Note", "icon" = "note64", "number" = 5),
							list("module" = "Settings", "icon" = "gear64", "number" = 6)
							)	//list("module" = "Name of Module", "icon" = "icon name64", "number" = "what tab is the module")

	var/selected_tab = 1
	var/owner = ""
	var/occupation = ""
	var/alert_called = 0
	var/obj/machinery/exonet_node/node = null //Reference to the Exonet node, to avoid having to look it up so often.

	var/target_address = ""
	var/target_address_name = ""
	var/network_visibility = 1
	var/ringer = 1
	var/list/known_devices = list()
	var/datum/exonet_protocol/exonet = null
	var/list/communicating = list()
	var/update_ticks = 0

// Proc: New()
// Parameters: None
// Description: Adds the new communicator to the global list of all communicators, sorts the list, obtains a reference to the Exonet node, then tries to
//				assign the device to the holder's name automatically in a spectacularly shitty way.
/obj/item/device/communicator/New()
	..()
	all_communicators += src
	all_communicators = sortAtom(all_communicators)
	node = get_exonet_node()
	processing_objects |= src
	camera = new(src)
	camera.name = "[src] #[rand(100,999)]"
	camera.c_tag = camera.name
	//This is a pretty terrible way of doing this.
	spawn(5 SECONDS) //Wait for our mob to finish spawning.
		if(ismob(loc))
			register_device(loc)
			initialize_exonet(loc)
		else if(istype(loc, /obj/item/weapon/storage))
			var/obj/item/weapon/storage/S = loc
			if(ismob(S.loc))
				register_device(S.loc)
				initialize_exonet(S.loc)

// Proc: examine()
// Parameters: user - the user doing the examining
// Description: Allows the user to click a link when examining to look at video if one is going.
/obj/item/device/communicator/examine(mob/user)
	. = ..(user, 1)
	if(. && video_source)
		user << "<span class='notice'>It looks like it's on a video call: <a href='?src=\ref[src];watchvideo=1'>\[view\]</a></span>"

// Proc: initialize_exonet()
// Parameters: 1 (user - the person the communicator belongs to)
// Description: Sets up the exonet datum, gives the device an address, and then gets a node reference.  Afterwards, populates the device
//				list.
/obj/item/device/communicator/proc/initialize_exonet(mob/user)
	if(!user || !istype(user, /mob/living))
		return
	if(!exonet)
		exonet = new(src)
	if(!exonet.address)
		exonet.make_address("communicator-[user.client]-[user.name]")
	if(!node)
		node = get_exonet_node()
	populate_known_devices()

// Proc: examine()
// Parameters: 1 (user - the person examining the device)
// Description: Shows all the voice mobs inside the device, and their status.
/obj/item/device/communicator/examine(mob/user)
	if(!..(user))
		return

	var/msg = ""
	for(var/mob/living/voice/voice in contents)
		msg += "<span class='notice'>On the screen, you can see a image feed of [voice].</span>\n"
		msg += "<span class='warning'>"

		if(voice && voice.key)
			switch(voice.stat)
				if(CONSCIOUS)
					if(!voice.client)
						msg += "[voice] appears to be asleep.\n" //afk
				if(UNCONSCIOUS)
					msg += "[voice] doesn't appear to be conscious.\n"
				if(DEAD)
					msg += "<span class='deadsay'>[voice] appears to have died...</span>\n" //Hopefully this never has to be used.
		else
			msg += "<span class='notice'>The device doesn't appear to be transmitting any data.</span>\n"
		msg += "</span>"
	user << msg
	return

// Proc: emp_act()
// Parameters: None
// Description: Drops all calls when EMPed, so the holder can then get murdered by the antagonist.
/obj/item/device/communicator/emp_act()
	close_connection(reason = "Hardware error de%#_^@%-BZZZZZZZT")

// Proc: add_to_EPv2()
// Parameters: 1 (hex - a single hexadecimal character)
// Description: Called when someone is manually dialing with nanoUI.  Adds colons when appropiate.
/obj/item/device/communicator/proc/add_to_EPv2(var/hex)
	var/length = length(target_address)
	if(length >= 24)
		return
	if(length == 4 || length == 9 || length == 14 || length == 19 || length == 24 || length == 29)
		target_address += ":[hex]"
		return
	target_address += hex

// Proc: populate_known_devices()
// Parameters: 1 (user - the person using the device)
// Description: Searches all communicators and ghosts in the world, and adds them to the known_devices list if they are 'visible'.
/obj/item/device/communicator/proc/populate_known_devices(mob/user)
	if(!exonet)
		exonet = new(src)
	src.known_devices.Cut()
	if(!get_connection_to_tcomms()) //If the network's down, we can't see anything.
		return
	for(var/obj/item/device/communicator/comm in all_communicators)
		if(!comm || !comm.exonet || !comm.exonet.address || comm.exonet.address == src.exonet.address) //Don't add addressless devices, and don't add ourselves.
			continue
		src.known_devices |= comm
	for(var/mob/observer/dead/O in dead_mob_list)
		if(!O.client || O.client.prefs.communicator_visibility == 0)
			continue
		src.known_devices |= O

// Proc: get_connection_to_tcomms()
// Parameters: None
// Description: Simple check to see if the exonet node is active.
/obj/item/device/communicator/proc/get_connection_to_tcomms()
	if(node && node.on && node.allow_external_communicators && !is_jammed(src))
		return 1
	return 0

// Proc: process()
// Parameters: None
// Description: Ticks the update_ticks variable, and checks to see if it needs to disconnect communicators every five ticks..
/obj/item/device/communicator/process()
	update_ticks++
	if(update_ticks % 5)
		if(!node)
			node = get_exonet_node()
		if(!get_connection_to_tcomms())
			close_connection(reason = "Connection timed out")

// Proc: attackby()
// Parameters: 2 (C - what is used on the communicator. user - the mob that has the communicator)
// Description: When an ID is swiped on the communicator, the communicator reads the job and checks it against the Owner name, if success, the occupation is added.
/obj/item/device/communicator/attackby(obj/item/C as obj, mob/user as mob)
	if(istype(C, /obj/item/weapon/card/id))
		var/obj/item/weapon/card/id/idcard = C
		if(!idcard.registered_name || !idcard.assignment)
			user << "<span class='notice'>\The [src] rejects the ID.</span>"
			return
		if(!owner)
			user << "<span class='notice'>\The [src] rejects the ID.</span>"
			return
		if(owner == idcard.registered_name)
			occupation = idcard.assignment
			user << "<span class='notice'>Occupation updated.</span>"
			return
	else return

// Proc: attack_self()
// Parameters: 1 (user - the mob that clicked the device in their hand)
// Description: Makes an exonet datum if one does not exist, allocates an address for it, maintains the lists of all devies, clears the alert icon, and
//				finally makes NanoUI appear.
/obj/item/device/communicator/attack_self(mob/user)
	initialize_exonet(user)
	alert_called = 0
	update_icon()
	ui_interact(user)
	if(video_source)
		watch_video(user)

// Proc: MouseDrop()
//Same thing PDAs do
/obj/item/device/communicator/MouseDrop(obj/over_object as obj)
	var/mob/M = usr
	if (!(src.loc == usr) || (src.loc && src.loc.loc == usr))
		return
	if(!istype(over_object, /obj/screen))
		return attack_self(M)
	return


// Proc: attack_ghost()
// Parameters: 1 (user - the ghost clicking on the device)
// Description: Recreates the known_devices list, so that the ghost looking at the device can see themselves, then calls ..() so that NanoUI appears.
/obj/item/device/communicator/attack_ghost(mob/user)
	populate_known_devices() //Update the devices so ghosts can see the list on NanoUI.
	..()

/mob/observer/dead
	var/datum/exonet_protocol/exonet = null
	var/list/exonet_messages = list()

// Proc: New()
// Parameters: None
// Description: Gives ghosts an exonet address based on their key and ghost name.
/mob/observer/dead/New()
	. = ..()
	spawn(20)
		exonet = new(src)
		if(client)
			exonet.make_address("communicator-[src.client]-[src.client.prefs.real_name]")
		else
			exonet.make_address("communicator-[key]-[src.real_name]")

// Proc: Destroy()
// Parameters: None
// Description: Removes the ghost's address and nulls the exonet datum, to allow qdel()ing.
/mob/observer/dead/Destroy()
	. = ..()
	if(exonet)
		exonet.remove_address()
		exonet = null
	return ..()

// Proc: ui_interact()
// Parameters: 4 (standard NanoUI arguments)
// Description: Uses a bunch of for loops to turn lists into lists of lists, so they can be displayed in nanoUI, then displays various buttons to the user.
/obj/item/device/communicator/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/key_state = null)
	// this is the data which will be sent to the ui
	var/data[0]						//General nanoUI information
	var/communicators[0]			//List of communicators
	var/invites[0]					//Communicators and ghosts we've invited to our communicator.
	var/requests[0]					//Communicators and ghosts wanting to go in our communicator.
	var/voices[0]					//Current /mob/living/voice s inside the device.
	var/connected_communicators[0]	//Current communicators connected to the device.

	var/im_contacts_ui[0]			//List of communicators that have been messaged.
	var/im_list_ui[0]				//List of messages.

	var/modules_ui[0]				//Home screen info.

	//First we add other 'local' communicators.
	for(var/obj/item/device/communicator/comm in known_devices)
		if(comm.network_visibility && comm.exonet)
			communicators[++communicators.len] = list("name" = sanitize(comm.name), "address" = comm.exonet.address)

	//Now for ghosts who we pretend have communicators.
	for(var/mob/observer/dead/O in known_devices)
		if(O.client && O.client.prefs.communicator_visibility == 1 && O.exonet)
			communicators[++communicators.len] = list("name" = sanitize("[O.client.prefs.real_name]'s communicator"), "address" = O.exonet.address, "ref" = "\ref[O]")

	//Lists all the other communicators that we invited.
	for(var/obj/item/device/communicator/comm in voice_invites)
		if(comm.exonet)
			invites[++invites.len] = list("name" = sanitize(comm.name), "address" = comm.exonet.address, "ref" = "\ref[comm]")

	//Ghosts we invited.
	for(var/mob/observer/dead/O in voice_invites)
		if(O.exonet && O.client)
			invites[++invites.len] = list("name" = sanitize("[O.client.prefs.real_name]'s communicator"), "address" = O.exonet.address, "ref" = "\ref[O]")

	//Communicators that want to talk to us.
	for(var/obj/item/device/communicator/comm in voice_requests)
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
	for(var/obj/item/device/communicator/comm in communicating)
		connected_communicators[++connected_communicators.len] = list("name" = sanitize(comm.name), "true_name" = sanitize(comm.name), "ref" = "\ref[comm]")

	//Devices that have been messaged or recieved messages from.
	for(var/obj/item/device/communicator/comm in im_contacts)
		if(comm.exonet)
			im_contacts_ui[++im_contacts_ui.len] = list("name" = sanitize(comm.name), "address" = comm.exonet.address, "ref" = "\ref[comm]")

	for(var/mob/observer/dead/ghost in im_contacts)
		if(ghost.exonet)
			im_contacts_ui[++im_contacts_ui.len] = list("name" = sanitize(ghost.name), "address" = ghost.exonet.address, "ref" = "\ref[ghost]")

	//Actual messages.
	for(var/I in im_list)
		im_list_ui[++im_list_ui.len] = list("address" = I["address"], "to_address" = I["to_address"], "im" = I["im"])

	//Modules for homescreen.
	for(var/list/R in modules)
		modules_ui[++modules_ui.len] = R

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

	// update the ui if it exists, returns null if no ui is passed/found
	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		// the ui does not exist, so we'll create a new() one
        // for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "communicator.tmpl", "Communicator", 475, 700, state = key_state)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()
		// auto update every five Master Controller tick
		ui.set_auto_update(5)

// Proc: Topic()
// Parameters: 2 (standard Topic arguments)
// Description: Responds to NanoUI button presses.
/obj/item/device/communicator/Topic(href, href_list)
	if(..())
		return 1
	if(href_list["rename"])
		var/new_name = sanitizeSafe(input(usr,"Please enter your name.","Communicator",usr.name) )
		if(new_name)
			owner = new_name
			name = "[owner]'s [initial(name)]"
			if(camera)
				camera.name = name
				camera.c_tag = name

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
			usr << "<span class='danger'>Error: Cannot connect to Exonet node.</span>"
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
			usr << "<span class='danger'>Error: Cannot connect to Exonet node.</span>"
			return
		var/their_address = href_list["message"]
		var/text = sanitizeSafe(input(usr,"Enter your message.","Text Message"))
		if(text)
			exonet.send_message(their_address, "text", text)
			im_list += list(list("address" = exonet.address, "to_address" = their_address, "im" = text))
			log_pda("[usr] (COMM: [src]) sent \"[text]\" to [exonet.get_atom_from_address(their_address)]")

	if(href_list["disconnect"])
		var/name_to_disconnect = href_list["disconnect"]
		for(var/mob/living/voice/V in contents)
			if(name_to_disconnect == V.name)
				close_connection(usr, V, "[usr] hung up")
		for(var/obj/item/device/communicator/comm in communicating)
			if(name_to_disconnect == comm.name)
				close_connection(usr, comm, "[usr] hung up")

	if(href_list["startvideo"])
		var/ref_to_video = href_list["startvideo"]
		var/obj/item/device/communicator/comm = locate(ref_to_video)
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
		for(var/obj/item/device/communicator/comm in communicating)
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

	nanomanager.update_uis(src)
	add_fingerprint(usr)

// Proc: receive_exonet_message()
// Parameters: 4 (origin atom - the source of the message's holder, origin_address - where the message came from, message - the message received,
//				  text - message text to send if message is of type "text")
// Description: Handles voice requests and invite messages originating from both real communicators and ghosts.  Also includes a ping response and IM function.
/obj/item/device/communicator/receive_exonet_message(var/atom/origin_atom, origin_address, message, text)
	if(message == "voice")
		if(isobserver(origin_atom) || istype(origin_atom, /obj/item/device/communicator))
			if(origin_atom in voice_invites)
				var/user = null
				if(ismob(origin_atom.loc))
					user = origin_atom.loc
				open_connection(user, origin_atom)
				return
			else if(origin_atom in voice_requests)
				return //Spam prevention
			else
				request(origin_atom)
	if(message == "ping")
		if(network_visibility)
			var/random = rand(200,350)
			random = random / 10
			exonet.send_message(origin_address, "64 bytes received from [exonet.address] ecmp_seq=1 ttl=51 time=[random] ms")
	if(message == "text")
		request_im(origin_atom, origin_address, text)
		return

// Proc: receive_exonet_message()
// Parameters: 3 (origin atom - the source of the message's holder, origin_address - where the message came from, message - the message received)
// Description: Handles voice requests and invite messages originating from both real communicators and ghosts.  Also includes a ping response.
/mob/observer/dead/receive_exonet_message(origin_atom, origin_address, message, text)
	if(message == "voice")
		if(istype(origin_atom, /obj/item/device/communicator))
			var/obj/item/device/communicator/comm = origin_atom
			if(src in comm.voice_invites)
				comm.open_connection(src)
				return
			src << "<span class='notice'>\icon[origin_atom] Receiving communicator request from [origin_atom].  To answer, use the <b>Call Communicator</b> \
			verb, and select that name to answer the call.</span>"
			src << 'sound/machines/defib_SafetyOn.ogg'
			comm.voice_invites |= src
	if(message == "ping")
		if(client && client.prefs.communicator_visibility)
			var/random = rand(450,700)
			random = random / 10
			exonet.send_message(origin_address, "64 bytes received from [exonet.address] ecmp_seq=1 ttl=51 time=[random] ms")
	if(message == "text")
		src << "<span class='notice'>\icon[origin_atom] Received text message from [origin_atom]: <b>\"[text]\"</b></span>"
		src << 'sound/machines/defib_safetyOff.ogg'
		exonet_messages.Add("<b>From [origin_atom]:</b><br>[text]")
		return

// Proc: register_device()
// Parameters: 1 (user - the person to use their name for)
// Description: Updates the owner's name and the device's name.
/obj/item/device/communicator/proc/register_device(mob/user)
	if(!user)
		return
	owner = user.name

	name = "[owner]'s [initial(name)]"
	if(camera)
		camera.name = name
		camera.c_tag = name

// Proc: add_communicating()
// Parameters: 1 (comm - the communicator to add to communicating)
// Description: Used when this communicator gets a new communicator to relay say/me messages to
/obj/item/device/communicator/proc/add_communicating(obj/item/device/communicator/comm)
	if(!comm || !istype(comm)) return

	communicating |= comm
	listening_objects |= src
	update_icon()

// Proc: del_communicating()
// Parameters: 1 (comm - the communicator to remove from communicating)
// Description: Used when this communicator is being asked to stop relaying say/me messages to another
/obj/item/device/communicator/proc/del_communicating(obj/item/device/communicator/comm)
	if(!comm || !istype(comm)) return

	communicating.Remove(comm)
	update_icon()

// Proc: open_connection()
// Parameters: 2 (user - the person who initiated the connecting being opened, candidate - the communicator or observer that will connect to the device)
// Description: Typechecks the candidate, then calls the correct proc for further connecting.
/obj/item/device/communicator/proc/open_connection(mob/user, var/atom/candidate)
	if(isobserver(candidate))
		voice_invites.Remove(candidate)
		open_connection_to_ghost(user, candidate)
	else
		if(istype(candidate, /obj/item/device/communicator))
			open_connection_to_communicator(user, candidate)

// Proc: open_connection_to_communicator()
// Parameters: 2 (user - the person who initiated this and will be receiving feedback information, candidate - someone else's communicator)
// Description: Adds the candidate and src to each other's communicating lists, allowing messages seen by the devices to be relayed.
/obj/item/device/communicator/proc/open_connection_to_communicator(mob/user, var/atom/candidate)
	if(!istype(candidate, /obj/item/device/communicator))
		return
	var/obj/item/device/communicator/comm = candidate
	voice_invites.Remove(candidate)
	comm.voice_requests.Remove(src)

	if(user)
		comm.visible_message("<span class='notice'>\icon[src] Connecting to [src].</span>")
		user << "<span class='notice'>\icon[src] Attempting to call [comm].</span>"
		sleep(10)
		user << "<span class='notice'>\icon[src] Dialing internally from [station_name()], [system_name()].</span>" // Vorestation edit
		sleep(20) //If they don't have an exonet something is very wrong and we want a runtime.
		user << "<span class='notice'>\icon[src] Connection re-routed to [comm] at [comm.exonet.address].</span>"
		sleep(40)
		user << "<span class='notice'>\icon[src] Connection to [comm] at [comm.exonet.address] established.</span>"
		comm.visible_message("<span class='notice'>\icon[src] Connection to [src] at [exonet.address] established.</span>")
		sleep(20)

	src.add_communicating(comm)
	comm.add_communicating(src)

// Proc: open_connection_to_ghost()
// Parameters: 2 (user - the person who initiated this, candidate - the ghost that will be turned into a voice mob)
// Description: Pulls the candidate ghost from deadchat, makes a new voice mob, transfers their identity, then their client.
/obj/item/device/communicator/proc/open_connection_to_ghost(mob/user, var/mob/candidate)
	if(!isobserver(candidate))
		return
	//Handle moving the ghost into the new shell.
	announce_ghost_joinleave(candidate, 0, "They are occupying a personal communications device now.")
	voice_requests.Remove(candidate)
	voice_invites.Remove(candidate)
	var/mob/living/voice/new_voice = new /mob/living/voice(src) 	//Make the voice mob the ghost is going to be.
	new_voice.transfer_identity(candidate) 	//Now make the voice mob load from the ghost's active character in preferences.
	//Do some simple logging since this is a tad risky as a concept.
	var/msg = "[candidate && candidate.client ? "[candidate.client.key]" : "*no key*"] ([candidate]) has entered [src], triggered by \
	[user && user.client ? "[user.client.key]" : "*no key*"] ([user ? "[user]" : "*null*"]) at [x],[y],[z].  They have joined as [new_voice.name]."
	message_admins(msg)
	log_game(msg)
	new_voice.mind = candidate.mind			//Transfer the mind, if any.
	new_voice.ckey = candidate.ckey			//Finally, bring the client over.
	voice_mobs.Add(new_voice)
	listening_objects |= src

	var/obj/screen/blackness = new() 	//Makes a black screen, so the candidate can't see what's going on before actually 'connecting' to the communicator.
	blackness.screen_loc = ui_entire_screen
	blackness.icon = 'icons/effects/effects.dmi'
	blackness.icon_state = "1"
	blackness.mouse_opacity = 2			//Can't see anything!
	new_voice.client.screen.Add(blackness)

	update_icon()

	//Now for some connection fluff.
	if(user)
		user << "<span class='notice'>\icon[src] Connecting to [candidate].</span>"
	new_voice << "<span class='notice'>\icon[src] Attempting to call [src].</span>"
	sleep(10)
	new_voice << "<span class='notice'>\icon[src] Dialing to [station_name()], Kara Subsystem, [system_name()].</span>"
	sleep(20)
	new_voice << "<span class='notice'>\icon[src] Connecting to [station_name()] telecommunications array.</span>"
	sleep(40)
	new_voice << "<span class='notice'>\icon[src] Connection to [station_name()] telecommunications array established.  Redirecting signal to [src].</span>"
	sleep(20)

	//We're connected, no need to hide everything.
	new_voice.client.screen.Remove(blackness)
	qdel(blackness)

	new_voice << "<span class='notice'>\icon[src] Connection to [src] established.</span>"
	new_voice << "<b>To talk to the person on the other end of the call, just talk normally.</b>"
	new_voice << "<b>If you want to end the call, use the 'Hang Up' verb.  The other person can also hang up at any time.</b>"
	new_voice << "<b>Remember, your character does not know anything you've learned from observing!</b>"
	if(new_voice.mind)
		new_voice.mind.assigned_role = "Disembodied Voice"
	if(user)
		user << "<span class='notice'>\icon[src] Your communicator is now connected to [candidate]'s communicator.</span>"

// Proc: close_connection()
// Parameters: 3 (user - the user who initiated the disconnect, target - the mob or device being disconnected, reason - string shown when disconnected)
// Description: Deletes specific voice_mobs or disconnects communicators, and shows a message to everyone when doing so.  If target is null, all communicators
//				and voice mobs are removed.
/obj/item/device/communicator/proc/close_connection(mob/user, var/atom/target, var/reason)
	if(voice_mobs.len == 0 && communicating.len == 0)
		return

	for(var/mob/living/voice/voice in voice_mobs) //Handle ghost-callers
		if(target && voice != target) //If no target is inputted, it deletes all of them.
			continue
		voice << "<span class='danger'>\icon[src] [reason].</span>"
		visible_message("<span class='danger'>\icon[src] [reason].</span>")
		voice_mobs.Remove(voice)
		qdel(voice)
		update_icon()

	for(var/obj/item/device/communicator/comm in communicating) //Now we handle real communicators.
		if(target && comm != target)
			continue
		src.del_communicating(comm)
		comm.del_communicating(src)
		comm.visible_message("<span class='danger'>\icon[src] [reason].</span>")
		visible_message("<span class='danger'>\icon[src] [reason].</span>")
		if(comm.camera && video_source == comm.camera) //We hung up on the person on video
			end_video()
		if(camera && comm.video_source == camera) //We hung up on them while they were watching us
			comm.end_video()

	if(voice_mobs.len == 0 && communicating.len == 0)
		listening_objects.Remove(src)

// Proc: request()
// Parameters: 1 (candidate - the ghost or communicator wanting to call the device)
// Description: Response to a communicator or observer trying to call the device.  Adds them to the list of requesters
/obj/item/device/communicator/proc/request(var/atom/candidate)
	if(candidate in voice_requests)
		return
	var/who = null
	if(isobserver(candidate))
		who = candidate.name
	else if(istype(candidate, /obj/item/device/communicator))
		var/obj/item/device/communicator/comm = candidate
		who = comm.owner
		comm.voice_invites |= src

	if(!who)
		return

	voice_requests |= candidate

	if(ringer)
		playsound(loc, 'sound/machines/twobeep.ogg', 50, 1)
		for (var/mob/O in hearers(2, loc))
			O.show_message(text("\icon[src] *beep*"))

	alert_called = 1
	update_icon()

	//Search for holder of the device.
	var/mob/living/L = null
	if(loc && isliving(loc))
		L = loc

	if(L)
		L << "<span class='notice'>\icon[src] Communications request from [who].</span>"

// Proc: del_request()
// Parameters: 1 (candidate - the ghost or communicator to be declined)
// Description: Declines a request and cleans up both ends
/obj/item/device/communicator/proc/del_request(var/atom/candidate)
	if(!(candidate in voice_requests))
		return

	if(isobserver(candidate))
		candidate << "<span class='warning'>Your communicator call request was declined.</span>"
	else if(istype(candidate, /obj/item/device/communicator))
		var/obj/item/device/communicator/comm = candidate
		comm.voice_invites -= src

	voice_requests -= candidate

	//Search for holder of our device.
	var/mob/living/us = null
	if(loc && isliving(loc))
		us = loc

	if(us)
		us << "<span class='notice'>\icon[src] Declined request.</span>"

// Proc: request_im()
// Parameters: 3 (candidate - the communicator wanting to message the device, origin_address - the address of the sender, text - the message)
// Description: Response to a communicator trying to message the device.
//				Adds them to the list of people that have messaged this device and adds the message to the message list.
/obj/item/device/communicator/proc/request_im(var/atom/candidate, var/origin_address, var/text)
	var/who = null
	if(isobserver(candidate))
		var/mob/observer/dead/ghost = candidate
		who = ghost
		im_list += list(list("address" = origin_address, "to_address" = exonet.address, "im" = text))
	else if(istype(candidate, /obj/item/device/communicator))
		var/obj/item/device/communicator/comm = candidate
		who = comm.owner
		comm.im_contacts |= src
		im_list += list(list("address" = origin_address, "to_address" = exonet.address, "im" = text))
	else return

	im_contacts |= candidate

	if(!who)
		return

	if(ringer)
		playsound(loc, 'sound/machines/twobeep.ogg', 50, 1)
		for (var/mob/O in hearers(2, loc))
			O.show_message(text("\icon[src] *beep*"))

	alert_called = 1
	update_icon()

	//Search for holder of the device.
	var/mob/living/L = null
	if(loc && isliving(loc))
		L = loc

	if(L)
		L << "<span class='notice'>\icon[src] Message from [who].</span>"

// Proc: Destroy()
// Parameters: None
// Description: Deletes all the voice mobs, disconnects all linked communicators, and cuts lists to allow successful qdel()
/obj/item/device/communicator/Destroy()
	for(var/mob/living/voice/voice in contents)
		voice_mobs.Remove(voice)
		voice << "<span class='danger'>\icon[src] Connection timed out with remote host.</span>"
		qdel(voice)
	close_connection(reason = "Connection timed out")
	communicating.Cut()
	voice_requests.Cut()
	voice_invites.Cut()
	all_communicators -= src
	processing_objects -= src
	listening_objects.Remove(src)
	qdel(camera)
	camera = null
	if(exonet)
		exonet.remove_address()
		exonet = null
	return ..()

// Proc: update_icon()
// Parameters: None
// Description: Self explanatory
/obj/item/device/communicator/update_icon()
	if(video_source)
		icon_state = "communicator-video"
		return

	if(voice_mobs.len || communicating.len)
		icon_state = "communicator-active"
		return

	if(alert_called)
		icon_state = "communicator-called"
		return

	icon_state = initial(icon_state)

// Proc: see_emote()
// Parameters: 2 (M - the mob the emote originated from, text - the emote's contents)
// Description: Relays the emote to all linked communicators.
/obj/item/device/communicator/see_emote(mob/living/M, text)
	var/rendered = "\icon[src] <span class='message'>[text]</span>"
	for(var/obj/item/device/communicator/comm in communicating)
		var/turf/T = get_turf(comm)
		if(!T) return
		var/list/in_range = get_mobs_and_objs_in_view_fast(T,world.view,0) //Range of 3 since it's a tiny video display
		var/list/mobs_to_relay = in_range["mobs"]

		for(var/mob/mob in mobs_to_relay) //We can't use visible_message(), or else we will get an infinite loop if two communicators hear each other.
			var/dst = get_dist(get_turf(mob),get_turf(comm))
			if(dst <= video_range)
				mob.show_message(rendered)
			else
				mob << "You can barely see some movement on \the [src]'s display."

	..()

// Proc: hear_talk()
// Parameters: 4 (M - the mob the speech originated from, text - what is being said, verb - the word used to describe how text is being said, speaking - language
//				being used)
// Description: Relays the speech to all linked communicators.
/obj/item/device/communicator/hear_talk(mob/living/M, text, verb, datum/language/speaking)
	for(var/obj/item/device/communicator/comm in communicating)

		var/turf/T = get_turf(comm)
		if(!T) return
		var/list/in_range = get_mobs_and_objs_in_view_fast(T,world.view,0)
		var/list/mobs_to_relay = in_range["mobs"]

		for(var/mob/mob in mobs_to_relay)
			//Can whoever is hearing us understand?
			if(!mob.say_understands(M, speaking))
				if(speaking)
					text = speaking.scramble(text)
				else
					text = stars(text)
			var/name_used = M.GetVoice()
			var/rendered = null
			if(speaking) //Language being used
				rendered = "<span class='game say'>\icon[src] <span class='name'>[name_used]</span> [speaking.format_message(text, verb)]</span>"
			else
				rendered = "<span class='game say'>\icon[src] <span class='name'>[name_used]</span> [verb], <span class='message'>\"[text]\"</span></span>"
			mob.show_message(rendered, 2)

// Proc: show_message()
// Parameters: 4 (msg - the message, type - number to determine if message is visible or audible, alt - unknown, alt_type - unknown)
// Description: Relays the message to all linked communicators.
/obj/item/device/communicator/show_message(msg, type, alt, alt_type)
	var/rendered = "\icon[src] <span class='message'>[msg]</span>"
	for(var/obj/item/device/communicator/comm in communicating)
		var/turf/T = get_turf(comm)
		if(!T) return
		var/list/in_range = get_mobs_and_objs_in_view_fast(T,world.view,0)
		var/list/mobs_to_relay = in_range["mobs"]

		for(var/mob/mob in mobs_to_relay)
			mob.show_message(rendered)
	..()

// Verb: join_as_voice()
// Parameters: None
// Description: Allows ghosts to call communicators, if they meet all the requirements.
/mob/observer/dead/verb/join_as_voice()
	set category = "Ghost"
	set name = "Call Communicator"
	set desc = "If there is a communicator available, send a request to speak through it.  This will reset your respawn timer, if someone picks up."

	if(ticker.current_state < GAME_STATE_PLAYING)
		src << "<span class='danger'>The game hasn't started yet!</span>"
		return

	if (!src.stat)
		return

	if (usr != src)
		return //something is terribly wrong

	var/confirm = alert(src, "Would you like to talk as [src.client.prefs.real_name], over a communicator?  \
						This will reset your respawn timer, if someone answers.", "Join as Voice?", "Yes","No")
	if(confirm == "No")
		return

	for(var/mob/living/L in mob_list) //Simple check so you don't have dead people calling.
		if(src.client.prefs.real_name == L.real_name)
			src << "<span class='danger'>Your identity is already present in the game world.  Please load in a different character first.</span>"
			return

	var/obj/machinery/exonet_node/E = get_exonet_node()
	if(!E || !E.on || !E.allow_external_communicators)
		src << "<span class='danger'>The Exonet node at telecommunications is down at the moment, or is actively blocking you, so your call can't go through.</span>"
		return

	var/list/choices = list()
	for(var/obj/item/device/communicator/comm in all_communicators)
		if(!comm.network_visibility || !comm.exonet || !comm.exonet.address)
			continue
		choices.Add(comm)

	if(!choices.len)
		src << "<span class='danger'>There are no available communicators, sorry.</span>"
		return

	var/choice = input(src,"Send a voice request to whom?") as null|anything in choices
	if(choice)
		var/obj/item/device/communicator/chosen_communicator = choice
		var/mob/observer/dead/O = src
		if(O.exonet)
			O.exonet.send_message(chosen_communicator.exonet.address, "voice")

			src << "A communications request has been sent to [chosen_communicator].  Now you need to wait until someone answers."

// Verb: text_communicator()
// Parameters: None
// Description: Allows a ghost to send a text message to a communicator.
/mob/observer/dead/verb/text_communicator()
	set category = "Ghost"
	set name = "Text Communicator"
	set desc = "If there is a communicator available, send a text message to it."

	if(ticker.current_state < GAME_STATE_PLAYING)
		src << "<span class='danger'>The game hasn't started yet!</span>"
		return

	if (!src.stat)
		return

	if (usr != src)
		return //something is terribly wrong

	for(var/mob/living/L in mob_list) //Simple check so you don't have dead people calling.
		if(src.client.prefs.real_name == L.real_name)
			src << "<span class='danger'>Your identity is already present in the game world.  Please load in a different character first.</span>"
			return

	var/obj/machinery/exonet_node/E = get_exonet_node()
	if(!E || !E.on || !E.allow_external_communicators)
		src << "<span class='danger'>The Exonet node at telecommunications is down at the moment, or is actively blocking you, so your call can't go through.</span>"
		return

	var/list/choices = list()
	for(var/obj/item/device/communicator/comm in all_communicators)
		if(!comm.network_visibility || !comm.exonet || !comm.exonet.address)
			continue
		choices.Add(comm)

	if(!choices.len)
		src << "<span class='danger'>There are no available communicators, sorry.</span>"
		return

	var/choice = input(src,"Send a text message to whom?") as null|anything in choices
	if(choice)
		var/obj/item/device/communicator/chosen_communicator = choice
		var/mob/observer/dead/O = src
		var/text_message = sanitize(input(src, "What do you want the message to say?")) as message
		if(text_message && O.exonet)
			O.exonet.send_message(chosen_communicator.exonet.address, "text", text_message)

			src << "<span class='notice'>You have sent '[text_message]' to [chosen_communicator].</span>."
			exonet_messages.Add("<b>To [chosen_communicator]:</b><br>[text_message]")
			log_pda("[usr] (COMM: [src]) sent \"[text_message]\" to [chosen_communicator]")


// Verb: show_text_messages()
// Parameters: None
// Description: Lets ghosts review messages they've sent or received.
/mob/observer/dead/verb/show_text_messages()
	set category = "Ghost"
	set name = "Show Text Messages"
	set desc = "Allows you to see exonet text messages you've sent and received."

	var/HTML = "<html><head><title>Exonet Message Log</title></head><body>"
	for(var/line in exonet_messages)
		HTML += line + "<br>"
	HTML +="</body></html>"
	usr << browse(HTML, "window=log;size=400x444;border=1;can_resize=1;can_close=1;can_minimize=0")

// Proc: connect_video()
// Parameters: user - the mob doing the viewing of video, comm - the communicator at the far end
// Description: Sets up a videocall and puts the first view into it using watch_video, and updates the icon
/obj/item/device/communicator/proc/connect_video(mob/user,obj/item/device/communicator/comm)
	if((!user) || (!comm) || user.stat) return //KO or dead, or already in a video

	if(video_source) //Already in a video
		user << "<span class='danger'>You are already connected to a video call!</span>"
		return

	if(user.blinded) //User is blinded
		user << "<span class='danger'>You cannot see well enough to do that!</span>"
		return

	if(!(src in comm.communicating) || !comm.camera) //You called someone with a broken communicator or one that's fake or yourself or something
		user << "<span class='danger'>\icon[src]ERROR: Video failed. Either bandwidth is too low, or the other communicator is malfunctioning.</span>"
		return

	var/turf/t1 = get_turf(src)
	var/turf/t2 = get_turf(comm)
	if(!is_on_same_plane_or_station(t1.z, t2.z) || !video_source.can_use())
		user << "<span class='danger'>Request to establish video timed out!</span>"
		return

	user << "<span class='notice'>\icon[src] Attempting to start video over existing call.</span>"
	sleep(30)
	user << "<span class='notice'>\icon[src] Please wait...</span>"

	video_source = comm.camera
	comm.visible_message("<span class='danger'>\icon[src] New video connection from [comm].</span>")
	watch_video(user)
	update_icon()

// Proc: watch_video()
// Parameters: user - the mob doing the viewing of video
// Description: Moves a mob's eye to the far end for the duration of viewing the far end
/obj/item/device/communicator/proc/watch_video(mob/user)
	if(!Adjacent(user) || !video_source) return
	user.set_machine(video_source)
	user.reset_view(video_source)
	to_chat(user,"<span class='notice'>Now viewing video session. To leave camera view, close the communicator window OR: OOC -> Cancel Camera View</span>")
	to_chat(user,"<span class='notice'>To return to an active video session, use the communicator in your hand.</span>")
	spawn(0)
		while(user.machine == video_source && (Adjacent(user) || loc == user))
			var/turf/T = get_turf(video_source)
			if(!T || !is_on_same_plane_or_station(T.z, user.z) || !video_source.can_use())
				user << "<span class='warning'>The screen bursts into static, then goes black.</span>"
				video_cleanup(user)
				return
			sleep(10)

		video_cleanup(user)

// Proc: video_cleanup()
// Parameters: user - the mob who doesn't want to see video anymore
// Description: Cleans up mob's client when they stop watching a video
/obj/item/device/communicator/proc/video_cleanup(mob/user)
	if(!user) return

	user.reset_view(null)
	user.unset_machine()

// Proc: end_video()
// Parameters: reason - the text reason to print for why it ended
// Description: Ends the video call by clearing video_source
/obj/item/device/communicator/proc/end_video(var/reason)
	video_source = null

	. = "<span class='danger'>\icon[src] [reason ? reason : "Video session ended"].</span>"

	visible_message(.)
	update_icon()

//For synths who have no hands.
/obj/item/device/communicator/integrated
	name = "integrated communicator"
	desc = "A circuit used for long-range communications, able to be integrated into a system."

//A stupid hack because synths don't use languages properly or something.
//I don't want to go digging in saycode for a week, so BS it as translation software or something.

// Proc: open_connection_to_ghost()
// Parameters: 2 (refer to base definition for arguments)
// Description: Synths don't use languages properly, so this is a bandaid fix until that can be resolved..
/obj/item/device/communicator/integrated/open_connection_to_ghost(user, candidate)
	..(user, candidate)
	spawn(1)
		for(var/mob/living/voice/V in contents)
			V.universal_speak = 1
			V.universal_understand = 1

// Verb: activate()
// Parameters: None
// Description: Lets synths use their communicators without hands.
/obj/item/device/communicator/integrated/verb/activate()
	set category = "AI IM"
	set name = "Use Communicator"
	set desc = "Utilizes your built-in communicator."
	set src in usr

	if(usr.stat == 2)
		usr << "You can't do that because you are dead!"
		return

	src.attack_self(usr)

// Verb: activate()
// Parameters: None
// Description: Lets synths use their communicators without hands.
/obj/item/device/communicator/integrated/verb/see_video()
	set category = "AI IM"
	set name = "View Comm. Video"
	set desc = "Utilizes your built-in communicator."
	set src in usr

	if(usr.stat == 2)
		usr << "You can't do that because you are dead!"
		return

	src.watch_video(usr)

// A camera preset for spawning in the communicator
/obj/machinery/camera/communicator
	network = list(NETWORK_COMMUNICATORS)

/obj/machinery/camera/communicator/New()
	..()
	client_huds |= global_hud.whitense
	client_huds |= global_hud.darkMask