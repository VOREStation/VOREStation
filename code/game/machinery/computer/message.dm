// Allows you to monitor messages that passes the server.

/obj/machinery/computer/message_monitor
	name = "messaging monitor console"
	desc = "Used to access and maintain data on messaging servers. Allows you to view PDA and request console messages."
	icon_screen = "comm_logs"
	light_color = "#00b000"
	var/hack_icon = "error"
	circuit = /obj/item/circuitboard/message_monitor
	//Server linked to.
	var/obj/machinery/message_server/linkedServer = null
	//Sparks effect - For emag
	var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread
	//Messages - Saves me time if I want to change something.
	var/noserver = list("text" = "ALERT: No server detected.", "style" = "alert")
	var/incorrectkey = list("text" = "ALERT: Incorrect decryption key!", "style" = "warning")
	var/defaultmsg = list("text" = "Welcome. Please select an option.", "style" = "notice")
	var/rebootmsg = list("text" = "%$&(£: Critical %$$@ Error // !RestArting! <lOadiNg backUp iNput ouTput> - ?pLeaSe wAit!", "style" = "warning")
	//Computer properties
	var/hacking = 0		// Is it being hacked into by the AI/Cyborg
	var/emag = 0		// When it is emagged.
	var/auth = 0 // Are they authenticated?
	var/optioncount = 8
	// Custom temp Properties
	var/customsender = "System Administrator"
	var/obj/item/pda/customrecepient = null
	var/customjob		= "Admin"
	var/custommessage 	= "This is a test, please ignore."
	var/list/temp = null

/obj/machinery/computer/message_monitor/attackby(obj/item/O as obj, mob/living/user as mob)
	if(stat & (NOPOWER|BROKEN))
		..()
		return
	if(!istype(user))
		return
	if(O.has_tool_quality(TOOL_SCREWDRIVER) && emag)
		//Stops people from just unscrewing the monitor and putting it back to get the console working again.
		to_chat(user, span_warning("It is too hot to mess with!"))
		return

	..()
	return

/obj/machinery/computer/message_monitor/emag_act(var/remaining_charges, var/mob/user)
	// Will create sparks and print out the console's password. You will then have to wait a while for the console to be back online.
	// It'll take more time if there's more characters in the password..
	if(!emag && operable())
		if(!isnull(linkedServer))
			emag = 1
			spark_system.set_up(5, 0, src)
			spark_system.start()
			var/obj/item/paper/monitorkey/MK = new/obj/item/paper/monitorkey
			MK.loc = loc
			// Will help make emagging the console not so easy to get away with.
			MK.info += "<br><br><font color='red'>£%@%(*$%&(£&?*(%&£/{}</font>"
			spawn(100*length(linkedServer.decryptkey)) UnmagConsole()
			temp = rebootmsg
			update_icon()
			return 1
		else
			to_chat(user, span_notice("A no server error appears on the screen."))

/obj/machinery/computer/message_monitor/update_icon()
	if(emag || hacking)
		icon_screen = hack_icon
	else
		icon_screen = initial(icon_screen)
	..()

/obj/machinery/computer/message_monitor/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/computer/message_monitor/LateInitialize()
	. = ..()
	//Is the server isn't linked to a server, and there's a server available, default it to the first one in the list.
	if(!linkedServer)
		if(message_servers && message_servers.len > 0)
			linkedServer = message_servers[1]

/obj/machinery/computer/message_monitor/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MessageMonitor", name)
		ui.open()

/obj/machinery/computer/message_monitor/tgui_data(mob/user)
	var/list/data = list()

	data["customsender"] = customsender
	data["customrecepient"] = "[customrecepient]"
	data["customjob"] = customjob
	data["custommessage"] = custommessage

	data["temp"] = temp
	data["hacking"] = !!hacking
	data["emag"] = !!emag
	data["auth"] = !!auth
	data["linkedServer"] = list()
	if(linkedServer && auth)
		data["linkedServer"]["active"] = linkedServer.active
		data["linkedServer"]["broke"] = linkedServer.stat & (NOPOWER|BROKEN)

		var/list/pda_msgs = list()
		for(var/datum/data_pda_msg/pda in linkedServer.pda_msgs)
			pda_msgs.Add(list(list(
				"ref" = "\ref[pda]",
				"sender" = pda.sender,
				"recipient" = pda.recipient,
				"message" = pda.message,
			)))
		data["linkedServer"]["pda_msgs"] = pda_msgs

		var/list/rc_msgs = list()
		for(var/datum/data_rc_msg/rc in linkedServer.rc_msgs)
			rc_msgs.Add(list(list(
				"ref" = "\ref[rc]",
				"sender" = rc.send_dpt,
				"recipient" = rc.rec_dpt,
				"message" = rc.message,
				"stamp" = rc.stamp,
				"id_auth" = rc.id_auth,
				"priority" = rc.priority,
			)))
		data["linkedServer"]["rc_msgs"] = rc_msgs

		var/spamIndex = 0
		var/list/spamfilter = list()
		for(var/token in linkedServer.spamfilter)
			spamIndex++
			spamfilter.Add(list(list(
				"index" = spamIndex,
				"token" = token,
			)))
		data["linkedServer"]["spamFilter"] = spamfilter

		//Get out list of viable PDAs
		var/list/obj/item/pda/sendPDAs = list()
		for(var/obj/item/pda/P in PDAs)
			if(!P.owner || P.hidden)
				continue
			var/datum/data/pda/app/messenger/M = P.find_program(/datum/data/pda/app/messenger)
			if(!M || M.toff)
				continue
			sendPDAs["[P.name]"] = "\ref[P]"
		data["possibleRecipients"] = sendPDAs

	data["isMalfAI"] = ((istype(user, /mob/living/silicon/ai) || istype(user, /mob/living/silicon/robot)) && (user.mind.special_role && user.mind.original == user))

	return data

/obj/machinery/computer/message_monitor/attack_hand(var/mob/living/user as mob)
	if(stat & (NOPOWER|BROKEN))
		return
	if(!istype(user))
		return
	tgui_interact(user)

/obj/machinery/computer/message_monitor/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/message_monitor/proc/BruteForce(mob/user as mob)
	if(isnull(linkedServer))
		to_chat(user, span_warning("Could not complete brute-force: Linked Server Disconnected!"))
	else
		var/currentKey = linkedServer.decryptkey
		to_chat(user, span_warning("Brute-force completed! The key is '[currentKey]'."))
	hacking = 0
	update_icon()

/obj/machinery/computer/message_monitor/proc/UnmagConsole()
	emag = 0
	update_icon()

/obj/machinery/computer/message_monitor/proc/ResetMessage()
	customsender 	= "System Administrator"
	customrecepient = null
	custommessage 	= "This is a test, please ignore."
	customjob 		= "Admin"

/obj/machinery/computer/message_monitor/tgui_act(action, params, datum/tgui/ui)
	if(..())
		return TRUE

	switch(action)
		if("cleartemp")
			temp = null
			. = TRUE
		//Authenticate
		if("auth")
			var/dkey = params["key"]
			if(dkey && dkey != "")
				if(linkedServer.decryptkey == dkey)
					auth = TRUE
				else
					temp = incorrectkey
			. = TRUE
		if("deauth")
			auth = FALSE
			. = TRUE
		//Find a server
		if("find")
			if(message_servers && message_servers.len > 1)
				linkedServer = tgui_input_list(ui.user,"Please select a server.", "Select a server.", message_servers)
				set_temp("NOTICE: Server selected.", "alert")
			else if(message_servers && message_servers.len > 0)
				linkedServer = message_servers[1]
				set_temp("NOTICE: Only Single Server Detected - Server selected.", "average")
			else
				temp = noserver
		//Hack the Console to get the password
		if("hack")
			if((istype(ui.user, /mob/living/silicon/ai) || istype(ui.user, /mob/living/silicon/robot)) && (ui.user.mind.special_role && ui.user.mind.original == ui.user))
				hacking = 1
				update_icon()
				//Time it takes to bruteforce is dependant on the password length.
				spawn(100*length(linkedServer.decryptkey))
					if(src && linkedServer && ui.user)
						BruteForce(ui.user)

	if(!auth)
		return

	if(!linkedServer || linkedServer.stat & (NOPOWER|BROKEN))
		temp = noserver
		return TRUE

	switch(action)
		//Turn the server on/off.
		if("active")
			linkedServer.active = !linkedServer.active
			. = TRUE
		//Clears the logs - KEY REQUIRED
		if("del_pda")
			linkedServer.pda_msgs = list()
			set_temp("NOTICE: Logs cleared.", "average")
			. = TRUE
		//Clears the request console logs - KEY REQUIRED
		if("del_rc")
			linkedServer.rc_msgs = list()
			set_temp("NOTICE: Logs cleared.", "average")
			. = TRUE
		//Change the password - KEY REQUIRED
		if("pass")
			var/dkey = trim(tgui_input_text(ui.user, "Please enter the current decryption key."))
			if(dkey && dkey != "")
				if(linkedServer.decryptkey == dkey)
					var/newkey = trim(tgui_input_text(ui.user,"Please enter the new key (3 - 16 characters max):",null,null,16))
					if(length(newkey) <= 3)
						set_temp("NOTICE: Decryption key too short!", "average")
					else if(length(newkey) > 16)
						set_temp("NOTICE: Decryption key too long!", "average")
					else if(newkey && newkey != "")
						linkedServer.decryptkey = newkey
					set_temp("NOTICE: Decryption key set.", "average")
				else
					temp = incorrectkey
			. = TRUE
		//Delete the log.
		if("delete")
			if(params["type"] == "pda")
				linkedServer.pda_msgs -= locate(params["id"])
			else
				linkedServer.rc_msgs -= locate(params["id"])
			set_temp("NOTICE: Log Deleted!", "average")
			. = TRUE
		//Fake messaging selection - KEY REQUIRED
		if("set_sender")
			customsender = sanitize(params["val"])
			. = TRUE
		if("set_sender_job")
			customjob = sanitize(params["val"])
			. = TRUE
		if("set_recipient")
			var/ref = params["val"]
			var/obj/item/pda/P = locate(ref)
			if(!istype(P) || !P.owner || P.hidden)
				return FALSE

			var/datum/data/pda/app/messenger/M = P.find_program(/datum/data/pda/app/messenger)
			if(!M || M.toff)
				return FALSE
			customrecepient = P
			. = TRUE
		if("set_message")
			custommessage = sanitize(params["val"])
			. = TRUE
		if("send_message")
			if(isnull(customsender) || customsender == "")
				customsender = "UNKNOWN"

			if(isnull(customrecepient))
				set_temp("NOTICE: No recepient selected!", "average")
				return TRUE

			if(isnull(custommessage) || custommessage == "")
				set_temp("NOTICE: No message entered!", "average")
				return TRUE

			var/obj/item/pda/PDARec = null
			for(var/obj/item/pda/P in PDAs)
				if(!P.owner || P.hidden)
					continue
				var/datum/data/pda/app/messenger/M = P.find_program(/datum/data/pda/app/messenger)
				if(!M || M.toff)
					continue
				if(P.owner == customsender)
					PDARec = P
			//Sender isn't faking as someone who exists
			if(isnull(PDARec))
				linkedServer.send_pda_message("[customrecepient.owner]", "[customsender]","[custommessage]")
				var/datum/data/pda/app/messenger/M = customrecepient.find_program(/datum/data/pda/app/messenger)
				if(M)
					M.receive_message(list("sent" = 0, "owner" = customsender, "job" = customjob, "message" = custommessage), null)
			//Sender is faking as someone who exists
			else
				linkedServer.send_pda_message("[customrecepient.owner]", "[PDARec.owner]","[custommessage]")

				var/datum/data/pda/app/messenger/M = customrecepient.find_program(/datum/data/pda/app/messenger)
				if(M)
					M.receive_message(list("sent" = 0, "owner" = "[PDARec.owner]", "job" = "[customjob]", "message" = "[custommessage]", "target" = "\ref[PDARec]"), "\ref[PDARec]")
			//Finally..
			ResetMessage()
			. = TRUE

		if("addtoken")
			linkedServer.spamfilter += tgui_input_text(ui.user,"Enter text you want to be filtered out","Token creation")
			. = TRUE

		if("deltoken")
			var/tokennum = text2num(params["deltoken"])
			linkedServer.spamfilter.Cut(tokennum, tokennum + 1)
			. = TRUE

/obj/machinery/computer/message_monitor/proc/set_temp(text = "", style = "info", update_now = FALSE)
	temp = list(text = text, style = style)
	if(update_now)
		SStgui.update_uis(src)

/obj/item/paper/monitorkey
	name = "Monitor Decryption Key"

/obj/item/paper/monitorkey/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/item/paper/monitorkey/LateInitialize()
	if(message_servers)
		for(var/obj/machinery/message_server/server in message_servers)
			if(!isnull(server.decryptkey))
				info = "<center><h2>Daily Key Reset</h2></center><br>The new message monitor key is '[server.decryptkey]'.<br>Please keep this a secret and away from the clown.<br>If necessary, change the password to a more secure one."
				info_links = info
				icon_state = "paper_words"
				break
