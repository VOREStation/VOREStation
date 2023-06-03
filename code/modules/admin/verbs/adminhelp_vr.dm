/datum/admin_help/proc/send2adminchat()
	if(!config.chat_webhook_url)
		return

	var/list/adm = get_admin_counts()
	var/list/afkmins = adm["afk"]
	var/list/allmins = adm["total"]

	spawn(0) //Unreliable world.Exports()
		var/query_string = "type=adminhelp"
		query_string += "&key=[url_encode(config.chat_webhook_key)]"
		query_string += "&from=[url_encode(key_name(initiator))]"
		query_string += "&msg=[url_encode(html_decode(name))]"
		query_string += "&admin_number=[allmins.len]"
		query_string += "&admin_number_afk=[afkmins.len]"
		world.Export("[config.chat_webhook_url]?[query_string]")

/client/verb/adminspice()
	set category = "Admin"
	set name = "Request Spice"
	set desc = "Request admins to spice round up for you"

	//handle muting and automuting
	if(prefs.muted & MUTE_ADMINHELP)
		to_chat(usr, "<span class='danger'>Error: You cannot request spice (muted from adminhelps).</span>")
		return

	if(tgui_alert(usr, "Are you sure you want to request the admins spice things up for you? You accept the consequences if you do.","Spicy!",list("Yes","No")) != "No")
		message_admins("[ADMIN_FULLMONTY(usr)] has requested the round be spiced up a little.")
		to_chat(usr, "<span class='notice'>You have requested some more spice in your round.</span>")
	else
		to_chat(usr, "<span class='notice'>Spice request cancelled.</span>")
		return

	//if they requested spice, then remove spice verb temporarily to prevent spamming
	usr.verbs -= /client/verb/adminspice
	spawn(10 MINUTES)
		if(usr)		// In case we left in the 10 minute cooldown
			usr.verbs += /client/verb/adminspice	// 10 minute cool-down for spice request

//Works using the event_consent_list associative list. key is ckey, value is time they pressed the button.
//Checked by /client/proc/assess_player_readiness()
/client/verb/show_event_interest()
	set category = "Admin"
	set name = "Show Event Enthusiasm"
	set desc = "Let staff wanting to run events know you're eager for disruptive events."

	if(usr.key in event_consent_list)
		var/choice = tgui_alert(usr, "Would you rather focus on scenes or chilling out?",
		"Withdraw Enthusiasm", list("Choose to Relax", "Cancel"))
		if(choice == "Choose to Relax")
			event_consent_list -= usr.key
			to_chat(usr, SPAN_NOTICE("You have been removed from the list of people enthusiastic for events."))
	else if(istype(usr, /mob/living))
		var/choice = tgui_alert(usr, "Would you like to let staff know that you are actively available to respond to and engage with impromptu events \
		such as rescuing people, filling special orders and so forth? This will add you to a list that staff can request at any time \
		telling them where you are and whether you are AFK. This does not compel staff to entertain you. \
		Please note: Your OOC prefs WILL NOT be overriden by opting in.",
		"Consent to Disruption", list("Show Enthusiasm", "Cancel"))
		if(choice == "Show Enthusiasm")
			event_consent_list[usr.key] = world.time
			to_chat(usr, SPAN_NOTICE("You have been added to list of players who are eager to have the rounds shaken up. \
			You will be automatically removed if afk for over 30 minutes or leave the round through the verb or cryo/tram/portal"))
	else
		to_chat(usr, SPAN_NOTICE("Only players actively in the round can show interest!"))
