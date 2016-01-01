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
	w_class = 2.0
	slot_flags = SLOT_ID | SLOT_BELT
	show_messages = 1

	origin_tech = list(TECH_ENGINEERING = 2, TECH_MAGNET = 2, TECH_BLUESPACE = 2, TECH_DATA = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 30,"glass" = 10)

	var/list/voice_mobs = list()
	var/list/voice_requests = list()
	var/list/voice_invites = list()
	var/selected_tab = 1	//1 equals dialing, 2 equals reviewing requests/invites.
	var/owner = ""
	var/alert_called = 0
	var/obj/machinery/exonet_node/node = null //Reference to the Exonet node, to avoid having to look it up so often.

	var/target_address = ""
	var/network_visibility = 1
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
	//This is a pretty terrible way of doing this.
	spawn(50) //Wait for our mob to finish spawning.
		if(ismob(loc))
			register_device(loc)
		else if(istype(loc, /obj/item/weapon/storage))
			var/obj/item/weapon/storage/S = loc
			if(ismob(S.loc))
				register_device(S.loc)

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
	for(var/mob/dead/observer/O in dead_mob_list)
		if(!O.client || O.client.prefs.communicator_visibility == 0)
			continue
		src.known_devices |= O

// Proc: get_connection_to_tcomms()
// Parameters: None
// Description: Simple check to see if the exonet node is active.
/obj/item/device/communicator/proc/get_connection_to_tcomms()
	if(node)
		if(node.on && node.allow_external_communicators)
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
		if(!node || !node.on || !node.allow_external_communicators)
			close_connection(reason = "Connection timed out")

// Proc: attack_self()
// Parameters: 1 (user - the mob that clicked the device in their hand)
// Description: Makes an exonet datum if one does not exist, allocates an address for it, maintains the lists of all devies, clears the alert icon, and
//				finally makes NanoUI appear.
/obj/item/device/communicator/attack_self(mob/user)
	if(!exonet)
		exonet = new(src)
	if(!exonet.address)
		exonet.make_address("communicator-[user.client]-[user.name]")
	if(!node)
		node = get_exonet_node()
	populate_known_devices()
	alert_called = 0
	update_icon()
	ui_interact(user)

// Proc: attack_ghost()
// Parameters: 1 (user - the ghost clicking on the device)
// Description: Recreates the known_devices list, so that the ghost looking at the device can see themselves, then calls ..() so that NanoUI appears.
/obj/item/device/communicator/attack_ghost(mob/user)
	populate_known_devices() //Update the devices so ghosts can see the list on NanoUI.
	..()

/mob/dead/observer
	var/datum/exonet_protocol/exonet = null

// Proc: New()
// Parameters: None
// Description: Gives ghosts an exonet address based on their key and ghost name.
/mob/dead/observer/New()
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
/mob/dead/observer/Destroy()
	. = ..()
	if(exonet)
		exonet.remove_address()
		exonet = null
	..()

// Proc: ui_interact()
// Parameters: 4 (standard NanoUI arguments)
// Description: Uses a bunch of for loops to turn lists into lists of lists, so they can be displayed in nanoUI, then displays various buttons to the user.
/obj/item/device/communicator/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	// this is the data which will be sent to the ui
	var/data[0]						//General nanoUI information
	var/communicators[0]			//List of communicators
	var/invites[0]					//Communicators and ghosts we've invited to our communicator.
	var/requests[0]					//Communicators and ghosts wanting to go in our communicator.
	var/voices[0]					//Current /mob/living/voice s inside the device.
	var/connected_communicators[0]	//Current communicators connected to the device.

	//First we add other 'local' communicators.
	for(var/obj/item/device/communicator/comm in known_devices)
		if(comm.network_visibility && comm.exonet)
			communicators[++communicators.len] = list("name" = sanitize(comm.name), "address" = comm.exonet.address)

	//Now for ghosts who we pretend have communicators.
	for(var/mob/dead/observer/O in known_devices)
		if(O.client && O.client.prefs.communicator_visibility == 1 && O.exonet)
			communicators[++communicators.len] = list("name" = sanitize("[O.client.prefs.real_name]'s communicator"), "address" = O.exonet.address)

	//Lists all the other communicators that we invited.
	for(var/obj/item/device/communicator/comm in voice_invites)
		if(comm.exonet)
			invites[++invites.len] = list("name" = sanitize(comm.name), "address" = comm.exonet.address)

	//Ghosts we invited.
	for(var/mob/dead/observer/O in voice_invites)
		if(O.exonet && O.client)
			invites[++invites.len] = list("name" = sanitize("[O.client.prefs.real_name]'s communicator"), "address" = O.exonet.address)

	//Communicators that want to talk to us.
	for(var/obj/item/device/communicator/comm in voice_requests)
		if(comm.exonet)
			requests[++requests.len] = list("name" = sanitize(comm.name), "address" = comm.exonet.address)

	//Ghosts that want to talk to us.
	for(var/mob/dead/observer/O in voice_requests)
		if(O.exonet && O.client)
			requests[++requests.len] = list("name" = sanitize("[O.client.prefs.real_name]'s communicator"), "address" = O.exonet.address)

	//Now for all the voice mobs inside the communicator.
	for(var/mob/living/voice/voice in contents)
		voices[++voices.len] = list("name" = sanitize("[voice.name]'s communicator"), "true_name" = sanitize(voice.name))

	//Finally, all the communicators linked to this one.
	for(var/obj/item/device/communicator/comm in communicating)
		connected_communicators[++connected_communicators.len] = list("name" = sanitize(comm.name), "true_name" = sanitize(comm.name))


	data["owner"] = owner ? owner : "Unset"
	data["connectionStatus"] = get_connection_to_tcomms()
	data["visible"] = network_visibility
	data["address"] = exonet.address ? exonet.address : "Unallocated"
	data["targetAddress"] = target_address
	data["currentTab"] = selected_tab
	data["knownDevices"] = communicators
	data["invitesSent"] = invites
	data["requestsReceived"] = requests
	data["voice_mobs"] = voices
	data["communicating"] = connected_communicators

	// update the ui if it exists, returns null if no ui is passed/found
	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		// the ui does not exist, so we'll create a new() one
        // for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "communicator.tmpl", "Communicator", 450, 700)
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

	if(href_list["toggle_visibility"])
		network_visibility = !network_visibility

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
	if(href_list["disconnect"])
		var/name_to_disconnect = href_list["disconnect"]
		for(var/mob/living/voice/V in contents)
			if(name_to_disconnect == V.name)
				close_connection(usr, V, "[usr] hung up")
		for(var/obj/item/device/communicator/comm in communicating)
			if(name_to_disconnect == comm.name)
				close_connection(usr, comm, "[usr] hung up")

	if(href_list["copy"])
		target_address = href_list["copy"]

	if(href_list["switch_tab"])
		selected_tab = href_list["switch_tab"]

	nanomanager.update_uis(src)
	add_fingerprint(usr)

// Proc: receive_exonet_message()
// Parameters: 3 (origin atom - the source of the message's holder, origin_address - where the message came from, message - the message received)
// Description: Handles voice requests and invite messages originating from both real communicators and ghosts.  Also includes a ping response.
/obj/item/device/communicator/receive_exonet_message(var/atom/origin_atom, origin_address, message)
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

// Proc: receive_exonet_message()
// Parameters: 3 (origin atom - the source of the message's holder, origin_address - where the message came from, message - the message received)
// Description: Handles voice requests and invite messages originating from both real communicators and ghosts.  Also includes a ping response.
/mob/dead/observer/receive_exonet_message(origin_atom, origin_address, message)
	if(message == "voice")
		if(istype(origin_atom, /obj/item/device/communicator))
			var/obj/item/device/communicator/comm = origin_atom
			if(src in comm.voice_invites)
				comm.open_connection(src)
				return
			src << "<span class='notice'>\icon[origin_atom] Receiving communicator request from [origin_atom].  To answer, use the <b>Call Communicator</b> \
			verb, and select that name to answer the call.</span>"
			comm.voice_invites |= src
	if(message == "ping")
		if(client && client.prefs.communicator_visibility)
			var/random = rand(450,700)
			random = random / 10
			exonet.send_message(origin_address, "64 bytes received from [exonet.address] ecmp_seq=1 ttl=51 time=[random] ms")

// Proc: register_device()
// Parameters: 1 (user - the person to use their name for)
// Description: Updates the owner's name and the device's name.
/obj/item/device/communicator/proc/register_device(mob/user)
	if(!user)
		return
	owner = user.name

	name = "[owner]'s [initial(name)]"

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
		user << "<span class='notice'>\icon[src] Dialing internally from [station_name()], Kara Subsystem, [system_name()].</span>"
		sleep(20) //If they don't have an exonet something is very wrong and we want a runtime.
		user << "<span class='notice'>\icon[src] Connection re-routed to [comm] at [comm.exonet.address].</span>"
		sleep(40)
		user << "<span class='notice'>\icon[src] Connection to [comm] at [comm.exonet.address] established.</span>"
		comm.visible_message("<span class='notice'>\icon[src] Connection to [src] at [exonet.address] established.</span>")
		sleep(20)

	communicating |= comm
	comm.communicating |= src

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

	for(var/obj/item/device/communicator/comm in communicating) //Now we handle real communicators.
		if(target && comm != target)
			continue
		comm.visible_message("<span class='danger'>\icon[src] [reason].</span>")
		visible_message("<span class='danger'>\icon[src] [reason].</span>")
		comm.communicating.Remove(src)
		communicating.Remove(comm)
	update_icon()

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
	if(exonet)
		exonet.remove_address()
		exonet = null
	..()

// Proc: update_icon()
// Parameters: None
// Description: Self explanatory
/obj/item/device/communicator/update_icon()
	if(voice_mobs.len > 0)
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
		for(var/mob/mob in viewers(get_turf(comm))) //We can't use visible_message(), or else we will get an infinite loop if two communicators hear each other.
			mob.show_message(rendered)
		for(var/mob/living/voice/V in comm.contents)
			V.show_message(rendered)
	..()

// Proc: hear_talk()
// Parameters: 4 (M - the mob the speech originated from, text - what is being said, verb - the word used to describe how text is being said, speaking - language
//				being used)
// Description: Relays the speech to all linked communicators.
/obj/item/device/communicator/hear_talk(mob/living/M, text, verb, datum/language/speaking)
	for(var/obj/item/device/communicator/comm in communicating)
		var/list/mobs_to_relay = list()
		mobs_to_relay |= viewers(get_turf(comm))
		mobs_to_relay |= comm.contents //Needed so ghost-callers can see speech.
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
		for(var/mob/mob in hearers(get_turf(comm))) //Ditto for audible messages.
			mob.show_message(rendered)
	..()

// Verb: join_as_voice()
// Parameters: None
// Description: Allows ghosts to call communicators, if they meet all the requirements.
/mob/dead/verb/join_as_voice()
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
		var/mob/dead/observer/O = src
		if(O.exonet)
			O.exonet.send_message(chosen_communicator.exonet.address, "voice")

			src << "A communications request has been sent to [chosen_communicator].  Now you need to wait until someone answers."

/obj/item/device/communicator/integrated //For synths who have no hands.
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