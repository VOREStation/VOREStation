/datum/data/pda/app/messenger
	name = "Messenger"
	icon = "comments-o"
	notify_icon = "comments"
	title = "SpaceMessenger V4.1.0"
	template = "pda_messenger"

	var/toff = 0 //If 1, messenger disabled
	var/list/tnote[0]  //Current Texts
	var/last_text //No text spamming

	var/m_hidden = 0 // Is the PDA hidden from the PDA list?
	var/active_conversation = null // New variable that allows us to only view a single conversation.
	var/list/conversations = list()    // For keeping up with who we have PDA messsages from.
	var/list/fakepdas = list() //So that fake PDAs show up in conversations for props. Namedlist of "fakeName" = fakeRef

/datum/data/pda/app/messenger/start()
	. = ..()
	unnotify()

/datum/data/pda/app/messenger/update_ui(mob/user as mob, list/data)
	data["silent"] = notify_silent						// does the pda make noise when it receives a message?
	data["toff"] = toff									// is the messenger function turned off?
	data["active_conversation"] = active_conversation	// Which conversation are we following right now?
	data["enable_message_embeds"] = user?.client?.prefs?.read_preference(/datum/preference/toggle/messenger_embeds)

	has_back = active_conversation
	if(active_conversation)
		data["messages"] = tnote
		for(var/c in tnote)
			if(c["target"] == active_conversation)
				data["convo_name"] = sanitize(c["owner"])
				data["convo_job"] = sanitize(c["job"])
				break
	else
		var/convopdas[0]
		var/pdas[0]
		for(var/obj/item/device/pda/P as anything in PDAs)
			var/datum/data/pda/app/messenger/PM = P.find_program(/datum/data/pda/app/messenger)

			if(!P.owner || PM.toff || P == pda || PM.m_hidden)
				continue
			if(conversations.Find("\ref[P]"))
				convopdas.Add(list(list("Name" = "[P]", "Reference" = "\ref[P]", "Detonate" = "[P.detonate]", "inconvo" = "1")))
			else
				pdas.Add(list(list("Name" = "[P]", "Reference" = "\ref[P]", "Detonate" = "[P.detonate]", "inconvo" = "0")))
		for(var/fakeRef in fakepdas)
			convopdas.Add(list(list("Name" = "[fakepdas[fakeRef]]", "Reference" = "[fakeRef]", "Detonate" = "0", "inconvo" = "1")))

		data["convopdas"] = convopdas
		data["pdas"] = pdas

		var/list/plugins = list()
		if(pda.cartridge)
			for(var/datum/data/pda/messenger_plugin/P as anything in pda.cartridge.messenger_plugins)
				plugins += list(list(name = P.name, icon = P.icon, ref = "\ref[P]"))
		data["plugins"] = plugins

		if(pda.cartridge)
			data["charges"] = pda.cartridge.charges ? pda.cartridge.charges : 0

/datum/data/pda/app/messenger/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	unnotify()

	. = TRUE
	switch(action)
		if("Toggle Messenger")
			toff = !toff
		if("Toggle Ringer")//If viewing texts then erase them, if not then toggle silent status
			notify_silent = !notify_silent
		if("Clear")//Clears messages
			if(params["option"] == "All")
				tnote.Cut()
				conversations.Cut()
			if(params["option"] == "Convo")
				var/new_tnote[0]
				for(var/i in tnote)
					if(i["target"] != active_conversation)
						new_tnote[++new_tnote.len] = i
				tnote = new_tnote
				conversations.Remove(active_conversation)

			active_conversation = null
		if("Message")
			var/obj/item/device/pda/P = locate(params["target"])
			create_message(usr, P)
			if(params["target"] in conversations)            // Need to make sure the message went through, if not welp.
				active_conversation = params["target"]
		if("Select Conversation")
			var/P = params["target"]
			for(var/n in conversations)
				if(P == n)
					active_conversation = P
		if("Messenger Plugin")
			if(!params["target"] || !params["plugin"])
				return

			var/obj/item/device/pda/P = locate(params["target"])
			if(!P)
				to_chat(usr, "PDA not found.")

			var/datum/data/pda/messenger_plugin/plugin = locate(params["plugin"])
			if(plugin && (plugin in pda.cartridge.messenger_plugins))
				plugin.messenger = src
				plugin.user_act(usr, P)
		if("Back")
			active_conversation = null

// Specifically here for the chat message.
/datum/data/pda/app/messenger/Topic(href, href_list)
	if(!pda.can_use(usr))
		return
	unnotify()

	switch(href_list["choice"])
		if("Message")
			var/obj/item/device/pda/P = locate(href_list["target"])
			create_message(usr, P)
			if(href_list["target"] in conversations)            // Need to make sure the message went through, if not welp.
				active_conversation = href_list["target"]


/datum/data/pda/app/messenger/proc/create_message(var/mob/living/U, var/obj/item/device/pda/P)
	var/t = tgui_input_text(U, "Please enter message", name, null)
	if(!t)
		return
	t = sanitize(copytext(t, 1, MAX_MESSAGE_LEN))
	t = readd_quotes(t)
	if(!t || !istype(P))
		return
	if(!in_range(pda, U) && pda.loc != U)
		return

	var/datum/data/pda/app/messenger/PM = P.find_program(/datum/data/pda/app/messenger)

	if(!PM || PM.toff || toff)
		return

	if(last_text && world.time < last_text + 5)
		return

	if(!pda.can_use(usr))
		return

	last_text = world.time
	// check if telecomms I/O route 1459 is stable
	//var/telecomms_intact = telecomms_process(P.owner, owner, t)
	var/obj/machinery/message_server/useMS = null
	if(message_servers)
		for(var/obj/machinery/message_server/MS as anything in message_servers)
		//PDAs are now dependent on the Message Server.
			if(MS.active)
				useMS = MS
				break

	var/datum/signal/signal = pda.telecomms_process()

	var/useTC = 0
	if(signal)
		if(signal.data["done"])
			useTC = 1
			var/turf/pos = get_turf(P)
			// TODO: Make the radio system cooperate with the space manager
			if(pos.z in signal.data["level"])
				useTC = 2
				//Let's make this barely readable
				if(signal.data["compression"] > 0)
					t = Gibberish(t, signal.data["compression"] + 50)

	if(useMS && useTC) // only send the message if it's stable
		if(useTC != 2) // Does our recipient have a broadcaster on their level?
			to_chat(U, "ERROR: Cannot reach recipient.")
			return
		useMS.send_pda_message("[P.owner]","[pda.owner]","[t]")
		pda.investigate_log("<span class='game say'>PDA Message - <span class='name'>[U.key] - [pda.owner]</span> -> <span class='name'>[P.owner]</span>: <span class='message'>[t]</span></span>", "pda")

		receive_message(list("sent" = 1, "owner" = "[P.owner]", "job" = "[P.ownjob]", "message" = "[t]", "target" = "\ref[P]"), "\ref[P]")
		PM.receive_message(list("sent" = 0, "owner" = "[pda.owner]", "job" = "[pda.ownjob]", "message" = "[t]", "target" = "\ref[pda]"), "\ref[pda]")

		SStgui.update_user_uis(U, P) // Update the sending user's PDA UI so that they can see the new message
		log_pda("(PDA: [src.name]) sent \"[t]\" to [P.name]", usr)
		to_chat(U, "[icon2html(pda,U.client)] <b>Sent message to [P.owner] ([P.ownjob]), </b>\"[t]\"")
	else
		to_chat(U, "<span class='notice'>ERROR: Messaging server is not responding.</span>")

/datum/data/pda/app/messenger/proc/available_pdas()
	var/list/names = list()
	var/list/plist = list()
	var/list/namecounts = list()

	if(toff)
		to_chat(usr, "Turn on your receiver in order to send messages.")
		return

	for(var/obj/item/device/pda/P as anything in PDAs)
		var/datum/data/pda/app/messenger/PM = P.find_program(/datum/data/pda/app/messenger)

		if(!P.owner || !PM || PM.hidden || P == pda || PM.toff)
			continue

		var/name = P.owner
		if(name in names)
			namecounts[name]++
			name = text("[name] ([namecounts[name]])")
		else
			names.Add(name)
			namecounts[name] = 1

		plist[text("[name]")] = P
	return plist

/datum/data/pda/app/messenger/proc/can_receive()
	return pda.owner && !toff && !hidden

/datum/data/pda/app/messenger/proc/receive_message(list/data, ref)
	tnote.Add(list(data))
	if(!conversations.Find(ref))
		conversations.Add(ref)
	if(!data["sent"])
		var/owner = data["owner"]
		var/job = data["job"]
		var/message = data["message"]
		notify("<b>Message from [owner] ([job]), </b>\"[message]\" (<a href='?src=\ref[src];choice=Message;target=[ref]'>Reply</a>)")

/datum/data/pda/app/messenger/multicast
/datum/data/pda/app/messenger/multicast/receive_message(list/data, ref)
	. = ..()

	var/obj/item/device/pda/multicaster/M = pda
	if(!istype(M))
		return

	var/list/modified_message = data.Copy()
	modified_message["owner"] = modified_message["owner"] + " \[Relayed]"
	modified_message["target"] = "\ref[M]"

	var/list/targets = list()
	for(var/obj/item/device/pda/pda in PDAs)
		if(pda.cartridge && pda.owner && is_type_in_list(pda.cartridge, M.cartridges_to_send_to))
			targets |= pda
	if(targets.len)
		for(var/obj/item/device/pda/target in targets)
			var/datum/data/pda/app/messenger/P = target.find_program(/datum/data/pda/app/messenger)
			if(P)
				P.receive_message(modified_message, "\ref[M]")

/*
Generalized proc to handle GM fake prop messages, or future fake prop messages from mapping landmarks.
We need a separate proc for this due to the "target" component and creation of a fake conversation entry.
Invoked by /obj/item/device/pda/proc/createPropFakeConversation_admin(var/mob/M)
*/
/datum/data/pda/app/messenger/proc/createFakeMessage(fakeName, fakeRef, fakeJob, sent, message)
	receive_message(list("sent" = sent, "owner" = "[fakeName]", "job" = "[fakeJob]", "message" = "[message]", "target" = "[fakeRef]"), fakeRef)
	if(!fakepdas[fakeRef])
		fakepdas[fakeRef] = fakeName
