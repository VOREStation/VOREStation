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

	if(alert(usr, "Are you sure you want to request the admins spice things up for you? You accept the consequences if you do.",,"Yes","No") != "No")
		message_admins("[ADMIN_FULLMONTY(usr)] has requested the round be spiced up a little.")
		to_chat(usr, "<span class='notice'>You have requested some more spice in your round.</span>")
	else
		to_chat(usr, "<span class='notice'>Spice request cancelled.</span>")
		return

	//if they requested spice, then remove spice verb temporarily to prevent spamming
	usr.verbs -= /client/verb/adminspice
	spawn(6000)
		usr.verbs += /client/verb/adminspice	// 10 minute cool-down for spice request
