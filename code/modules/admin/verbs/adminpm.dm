#define IRCREPLYCOUNT 2


//allows right clicking mobs to send an admin PM to their client, forwards the selected mob's client to cmd_admin_pm
/client/proc/cmd_admin_pm_context(mob/M in mob_list)
	set category = null
	set name = "Admin PM Mob"
	if(!check_rights(R_ADMIN))
		to_chat(src, "<span class='pm warning'>Error: Admin-PM-Context: Only administrators may use this command.</span>")
		return
	if( !ismob(M) || !M.client )
		return
	cmd_admin_pm(M.client,null)
	feedback_add_details("admin_verb","Admin PM Mob") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

//shows a list of clients we could send PMs to, then forwards our choice to cmd_admin_pm
/client/proc/cmd_admin_pm_panel()
	set category = "Admin"
	set name = "Admin PM"
	if(!check_rights(R_ADMIN))
		to_chat(src, "<span class='pm warning'>Error: Admin-PM-Panel: Only administrators may use this command.</span>")
		return
	var/list/client/targets[0]
	for(var/client/T)
		if(T.mob)
			if(isnewplayer(T.mob))
				targets["(New Player) - [T]"] = T
			else if(isobserver(T.mob))
				targets["[T.mob.name](Ghost) - [T]"] = T
			else
				targets["[T.mob.real_name](as [T.mob.name]) - [T]"] = T
		else
			targets["(No Mob) - [T]"] = T
	var/target = tgui_input_list(src,"To whom shall we send a message?","Admin PM", sortList(targets))
	if(!target) //Admin canceled
		return
	cmd_admin_pm(targets[target],null)
	feedback_add_details("admin_verb","Admin PM") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_ahelp_reply(whom)
	if(prefs.muted & MUTE_ADMINHELP)
		to_chat(src, "<span class='pm warning'>Error: Admin-PM: You are unable to use admin PM-s (muted).</span>")
		return
	var/client/C
	if(istext(whom))
		if(cmptext(copytext(whom,1,2),"@"))
			whom = findStealthKey(whom)
		C = GLOB.directory[whom]
	else if(istype(whom,/client))
		C = whom
	if(!C)
		if(holder)
			to_chat(src, "<span class='pm warning'>Error: Admin-PM: Client not found.</span>")
		return

	var/datum/admin_help/AH = C.current_ticket

	if(AH)
		message_admins("<span class='pm'>[key_name_admin(src)] has started replying to [key_name(C, 0, 0)]'s admin help.</span>")
	var/msg = tgui_input_text(src,"Message:", "Private message to [key_name(C, 0, 0)]", multiline = TRUE)
	if (!msg)
		message_admins("<span class='pm'>[key_name_admin(src)] has cancelled their reply to [key_name(C, 0, 0)]'s admin help.</span>")
		return
	cmd_admin_pm(whom, msg, AH)

//takes input from cmd_admin_pm_context, cmd_admin_pm_panel or /client/Topic and sends them a PM.
//Fetching a message if needed. src is the sender and C is the target client
/client/proc/cmd_admin_pm(whom, msg, datum/admin_help/AH)
	if(prefs.muted & MUTE_ADMINHELP)
		to_chat(src, "<span class='pm warning'>Error: Admin-PM: You are unable to use admin PM-s (muted).</span>")
		return

	if(!holder && !current_ticket)	//no ticket? https://www.youtube.com/watch?v=iHSPf6x1Fdo
		to_chat(src, "<span class='pm warning'>You can no longer reply to this ticket, please open another one by using the Adminhelp verb if need be.</span>")
		to_chat(src, "<span class='pm notice'>Message: [msg]</span>")
		return

	var/client/recipient
	var/irc = 0
	if(istext(whom))
		if(cmptext(copytext(whom,1,2),"@"))
			whom = findStealthKey(whom)
		if(whom == "IRCKEY")
			irc = 1
		else
			recipient = GLOB.directory[whom]
	else if(istype(whom,/client))
		recipient = whom


	if(irc)
		if(!ircreplyamount)	//to prevent people from spamming irc
			return
		if(!msg)
			msg = tgui_input_text(src,"Message:", "Private message to Administrator", multiline = TRUE)

		if(!msg)
			return
		if(holder)
			to_chat(src, "<span class='pm warning'>Error: Use the admin IRC channel, nerd.</span>")
			return


	else
		if(!recipient)
			if(holder)
				to_chat(src, "<span class='pm warning'>Error: Admin-PM: Client not found.</span>")
				to_chat(src, msg)
			else
				current_ticket.MessageNoRecipient(msg)
			return

		//get message text, limit it's length.and clean/escape html
		if(!msg)
			msg = tgui_input_text(src,"Message:", "Private message to [key_name(recipient, 0, 0)]", multiline = TRUE)

			if(!msg)
				return

			if(prefs.muted & MUTE_ADMINHELP)
				to_chat(src, "<span class='pm warning'>Error: Admin-PM: You are unable to use admin PM-s (muted).</span>")
				return

			if(!recipient)
				if(holder)
					to_chat(src, "<span class='pm warning'>Error: Admin-PM: Client not found.</span>")
				else
					current_ticket.MessageNoRecipient(msg)
				return

	if (src.handle_spam_prevention(msg,MUTE_ADMINHELP))
		return

	//clean the message if it's not sent by a high-rank admin
	if(!check_rights(R_SERVER|R_DEBUG,0)||irc)//no sending html to the poor bots
		msg = trim(sanitize(copytext(msg,1,MAX_MESSAGE_LEN)))
		if(!msg)
			return

	var/rawmsg = msg

	var/keywordparsedmsg = keywords_lookup(msg)

	if(irc)
		to_chat(src, "<span class='pm notice'>PM to-<b>Admins</b>: [rawmsg]</span>")
		admin_ticket_log(src, "<span class='pm warning'>Reply PM from-<b>[key_name(src, TRUE, TRUE)]</b> to <i>IRC</i>: [keywordparsedmsg]</span>")
		ircreplyamount--
		send2irc("Reply: [ckey]",rawmsg)
	else
		if(recipient.holder)
			if(holder)	//both are admins
				to_chat(recipient, "<span class='pm warning'>Admin PM from-<b>[key_name(src, recipient, 1)]</b>: [keywordparsedmsg]</span>")
				to_chat(src, "<span class='pm notice'>Admin PM to-<b>[key_name(recipient, src, 1)]</b>: [keywordparsedmsg]</span>")

				//omg this is dumb, just fill in both their tickets
				var/interaction_message = "<span class='pm notice'>PM from-<b>[key_name(src, recipient, 1)]</b> to-<b>[key_name(recipient, src, 1)]</b>: [keywordparsedmsg]</span>"
				admin_ticket_log(src, interaction_message)
				if(recipient != src)	//reeee
					admin_ticket_log(recipient, interaction_message)

			else		//recipient is an admin but sender is not
				var/replymsg = "<span class='pm warning'>Reply PM from-<b>[key_name(src, recipient, 1)]</b>: [keywordparsedmsg]</span>"
				admin_ticket_log(src, replymsg)
				to_chat(recipient, replymsg)
				to_chat(src, "<span class='pm notice'>PM to-<b>Admins</b>: [msg]</span>")

			//play the recieving admin the adminhelp sound (if they have them enabled)
			if(recipient.is_preference_enabled(/datum/client_preference/holder/play_adminhelp_ping))
				recipient << 'sound/effects/adminhelp.ogg'

		else
			if(holder)	//sender is an admin but recipient is not. Do BIG RED TEXT
				if(!recipient.current_ticket)
					new /datum/admin_help(msg, recipient, TRUE)

				to_chat(recipient, "<span class='pm warning' size='4'><b>-- Administrator private message --</b></span>")
				to_chat(recipient, "<span class='pm warning'>Admin PM from-<b>[key_name(src, recipient, 0)]</b>: [msg]</span>")
				to_chat(recipient, "<span class='pm warning'><i>Click on the administrator's name to reply.</i></span>")
				to_chat(src, "<span class='pm notice'>Admin PM to-<b>[key_name(recipient, src, 1)]</b>: [msg]</span>")

				admin_ticket_log(recipient, "<span class='pm notice'>PM From [key_name_admin(src)]: [keywordparsedmsg]</span>")

				//always play non-admin recipients the adminhelp sound
				recipient << 'sound/effects/adminhelp.ogg'

				//AdminPM popup for ApocStation and anybody else who wants to use it. Set it with POPUP_ADMIN_PM in config.txt ~Carn
				if(config.popup_admin_pm)
					spawn()	//so we don't hold the caller proc up
						var/sender = src
						var/sendername = key
						var/reply = tgui_input_text(recipient, msg,"Admin PM from-[sendername]", "", multiline = TRUE)	//show message and await a reply
						if(recipient && reply)
							if(sender)
								recipient.cmd_admin_pm(sender,reply)										//sender is still about, let's reply to them
							else
								adminhelp(reply)													//sender has left, adminhelp instead
						return

			else		//neither are admins
				to_chat(src, "<span class='pm warning'>Error: Admin-PM: Non-admin to non-admin PM communication is forbidden.</span>")
				return

	if(irc)
		log_admin("PM: [key_name(src)]->IRC: [rawmsg]")
		for(var/client/X in GLOB.admins)
			to_chat(X, "<span class='pm notice'><B>PM: [key_name(src, X, 0)]-&gt;IRC:</B> [keywordparsedmsg]</span>")
	else
		log_admin("PM: [key_name(src)]->[key_name(recipient)]: [rawmsg]")
		//we don't use message_admins here because the sender/receiver might get it too
		for(var/client/X in GLOB.admins)
			if(X.key!=key && X.key!=recipient.key)	//check client/X is an admin and isn't the sender or recipient
				to_chat(X, "<span class='pm notice'><B>PM: [key_name(src, X, 0)]-&gt;[key_name(recipient, X, 0)]:</B> [keywordparsedmsg]</span>" )

/proc/IrcPm(target,msg,sender)
	var/client/C = GLOB.directory[target]

	var/datum/admin_help/ticket = C ? C.current_ticket : GLOB.ahelp_tickets.CKey2ActiveTicket(target)
	var/compliant_msg = trim(lowertext(msg))
	var/irc_tagged = "[sender](IRC)"
	var/list/splits = splittext(compliant_msg, " ")
	if(splits.len && splits[1] == "ticket")
		if(splits.len < 2)
			return "Usage: ticket <close|resolve|icissue|reject>"
		switch(splits[2])
			if("close")
				if(ticket)
					ticket.Close(irc_tagged)
					return "Ticket #[ticket.id] successfully closed"
			if("resolve")
				if(ticket)
					ticket.Resolve(irc_tagged)
					return "Ticket #[ticket.id] successfully resolved"
			if("icissue")
				if(ticket)
					ticket.ICIssue(irc_tagged)
					return "Ticket #[ticket.id] successfully marked as IC issue"
			if("reject")
				if(ticket)
					ticket.Reject(irc_tagged)
					return "Ticket #[ticket.id] successfully rejected"
			else
				return "Usage: ticket <close|resolve|icissue|reject>"
		return "Error: Ticket could not be found"

	var/static/stealthkey
	var/adminname = "Administrator"

	if(!C)
		return "Error: No client"

	if(!stealthkey)
		stealthkey = GenIrcStealthKey()

	msg = sanitize(copytext(msg,1,MAX_MESSAGE_LEN))
	if(!msg)
		return "Error: No message"

	message_admins("IRC message from [sender] to [key_name_admin(C)] : [msg]")
	log_admin("IRC PM: [sender] -> [key_name(C)] : [msg]")

	to_chat(C, "<span class='pm warning'><font size='4'><b>-- Administrator private message --</b></font></span>")
	to_chat(C, "<span class='pm warning'>Admin PM from-<b><a href='?priv_msg=[stealthkey]'>[adminname]</A></b>: [msg]</span>")
	to_chat(C, "<span class='pm warning'><i>Click on the administrator's name to reply.</i></span>")

	admin_ticket_log(C, "<span class='pm notice'>PM From [irc_tagged]: [msg]</span>")

	window_flash(C)
	//always play non-admin recipients the adminhelp sound
	C << 'sound/effects/adminhelp.ogg'

	C.ircreplyamount = IRCREPLYCOUNT

	return "Message Successful"

/proc/GenIrcStealthKey()
	var/num = (rand(0,1000))
	var/i = 0
	while(i == 0)
		i = 1
		for(var/P in GLOB.stealthminID)
			if(num == GLOB.stealthminID[P])
				num++
				i = 0
	var/stealth = "@[num2text(num)]"
	GLOB.stealthminID["IRCKEY"] = stealth
	return	stealth

#undef IRCREPLYCOUNT
