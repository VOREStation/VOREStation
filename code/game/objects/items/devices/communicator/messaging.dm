// Proc: receive_exonet_message()
// Parameters: 4 (origin atom - the source of the message's holder, origin_address - where the message came from, message - the message received,
//				  text - message text to send if message is of type "text")
// Description: Handles voice requests and invite messages originating from both real communicators and ghosts.  Also includes a ping response and IM function.
/obj/item/communicator/receive_exonet_message(var/atom/origin_atom, origin_address, message, text)
	if(message == "voice")
		if(isobserver(origin_atom) || istype(origin_atom, /obj/item/communicator))
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
		if(istype(origin_atom, /obj/item/communicator))
			var/obj/item/communicator/comm = origin_atom
			if(src in comm.voice_invites)
				comm.open_connection(src)
				return
			to_chat(src, span_notice("[icon2html(origin_atom,src.client)] Receiving communicator request from [origin_atom].  To answer, use the " + span_bold("Call Communicator") + "\
			verb, and select that name to answer the call."))
			src << 'sound/machines/defib_SafetyOn.ogg'
			comm.voice_invites |= src
	if(message == "ping")
		if(client && client.prefs.communicator_visibility)
			var/random = rand(450,700)
			random = random / 10
			exonet.send_message(origin_address, "64 bytes received from [exonet.address] ecmp_seq=1 ttl=51 time=[random] ms")
	if(message == "text")
		to_chat(src, span_notice("[icon2html(origin_atom,src.client)] Received text message from [origin_atom]: " + span_bold("\"[text]\"")))
		src << 'sound/machines/defib_safetyOff.ogg'
		exonet_messages.Add(span_bold("From [origin_atom]:") + "<br>[text]")
		return

// Proc: request_im()
// Parameters: 3 (candidate - the communicator wanting to message the device, origin_address - the address of the sender, text - the message)
// Description: Response to a communicator trying to message the device.
//				Adds them to the list of people that have messaged this device and adds the message to the message list.
/obj/item/communicator/proc/request_im(var/atom/candidate, var/origin_address, var/text)
	var/who = null
	if(isobserver(candidate))
		var/mob/observer/dead/ghost = candidate
		who = ghost.name
		im_list += list(list("address" = origin_address, "to_address" = exonet.address, "im" = text))
	else if(istype(candidate, /obj/item/communicator))
		var/obj/item/communicator/comm = candidate
		who = comm.owner
		comm.im_contacts |= src
		im_list += list(list("address" = origin_address, "to_address" = exonet.address, "im" = text))
	else if(istype(candidate, /obj/item/integrated_circuit))
		var/obj/item/integrated_circuit/CIRC = candidate
		who = CIRC
		im_list += list(list("address" = origin_address, "to_address" = exonet.address, "im" = text))
	else return

	im_contacts |= candidate

	if(!who)
		return

	if(ringer)
		var/S
		if(ttone in ttone_sound)
			S = ttone_sound[ttone]
		else
			S = 'sound/machines/twobeep.ogg'

		playsound(src, S, 50, 1)
		for (var/mob/O in hearers(2, loc))
			O.show_message(text("[icon2html(src,O.client)] *[ttone]*"))

	alert_called = 1
	update_icon()

	//Search for holder of the device.
	var/mob/living/L = null
	if(loc && isliving(loc))
		L = loc

	if(L)
		to_chat(L, span_notice("[icon2html(src,L.client)] Message from [who]: <b>\"[text]\"</b> (<a href='byond://?src=\ref[src];action=Reply;target=\ref[candidate]'>Reply</a>)"))

// This is the only Topic the communicators really uses
/obj/item/communicator/Topic(href, href_list)
	switch(href_list["action"])
		if("Reply")
			var/obj/item/communicator/comm = locate(href_list["target"])
			var/message = tgui_input_text(usr, "Enter your message below.", "Reply")

			if(message)
				exonet.send_message(comm.exonet.address, "text", message)
				im_list += list(list("address" = exonet.address, "to_address" = comm.exonet.address, "im" = message))
				log_pda("(COMM: [src]) sent \"[message]\" to [exonet.get_atom_from_address(comm.exonet.address)]", usr)
				to_chat(usr, span_notice("[icon2html(src,usr.client)] Sent message to [istype(comm, /obj/item/communicator) ? comm.owner : comm.name], <b>\"[message]\"</b> (<a href='byond://?src=\ref[src];action=Reply;target=\ref[exonet.get_atom_from_address(comm.exonet.address)]'>Reply</a>)"))

// Verb: text_communicator()
// Parameters: None
// Description: Allows a ghost to send a text message to a communicator.
/mob/observer/dead/verb/text_communicator()
	set category = "Ghost.Message"
	set name = "Text Communicator"
	set desc = "If there is a communicator available, send a text message to it."

	if(ticker.current_state < GAME_STATE_PLAYING)
		to_chat(src, span_danger("The game hasn't started yet!"))
		return

	if (!src.stat)
		return

	if (usr != src)
		return //something is terribly wrong

	for(var/mob/living/L in GLOB.mob_list) //Simple check so you don't have dead people calling.
		if(src.client.prefs.real_name == L.real_name)
			to_chat(src, span_danger("Your identity is already present in the game world.  Please load in a different character first."))
			return

	var/obj/machinery/exonet_node/E = get_exonet_node()
	if(!E || !E.on || !E.allow_external_communicators)
		to_chat(src, span_danger("The Exonet node at telecommunications is down at the moment, or is actively blocking you, \
		so your call can't go through."))
		return

	var/list/choices = list()
	for(var/obj/item/communicator/comm in all_communicators)
		if(!comm.network_visibility || !comm.exonet || !comm.exonet.address)
			continue
		choices.Add(comm)

	if(!choices.len)
		to_chat(src, span_danger("There are no available communicators, sorry."))
		return

	var/choice = tgui_input_list(src,"Send a text message to whom?", "Recipient Choice", choices)
	if(choice)
		var/obj/item/communicator/chosen_communicator = choice
		var/mob/observer/dead/O = src
		var/text_message = sanitize(tgui_input_text(src, "What do you want the message to say?", multiline = TRUE))
		if(text_message && O.exonet)
			O.exonet.send_message(chosen_communicator.exonet.address, "text", text_message)

			to_chat(src, span_notice("You have sent '[text_message]' to [chosen_communicator]."))
			exonet_messages.Add(span_bold("To [chosen_communicator]:") + "<br>[text_message]")
			log_pda("(DCOMM: [src]) sent \"[text_message]\" to [chosen_communicator]", src)
			for(var/mob/M in GLOB.player_list)
				if(M.stat == DEAD && M.client?.prefs?.read_preference(/datum/preference/toggle/ghost_ears))
					if(isnewplayer(M) || M.forbid_seeing_deadchat)
						continue
					if(M == src)
						continue
					M.show_message("Comm IM - [src] -> [chosen_communicator]: [text_message]")



// Verb: show_text_messages()
// Parameters: None
// Description: Lets ghosts review messages they've sent or received.
/mob/observer/dead/verb/show_text_messages()
	set category = "Ghost.Settings"
	set name = "Show Text Messages"
	set desc = "Allows you to see exonet text messages you've sent and received."

	var/HTML = "<html><head><title>Exonet Message Log</title></head><body>"
	for(var/line in exonet_messages)
		HTML += line + "<br>"
	HTML +="</body></html>"
	usr << browse(HTML, "window=log;size=400x444;border=1;can_resize=1;can_close=1;can_minimize=0")
