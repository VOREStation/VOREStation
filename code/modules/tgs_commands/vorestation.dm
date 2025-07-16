/datum/tgs_chat_command/status
	name = "status"
	help_text = "Shows the current production server status"
	admin_only = FALSE

/datum/tgs_chat_command/status/Run(datum/tgs_chat_user/sender, params)
	var/counts = 0
	var/afks = 0
	var/active = 0
	var/bellied = 0
	var/map_name = "n/a"
	if(using_map && using_map.full_name)
		map_name = using_map.full_name

	for(var/client/C in GLOB.clients)
		counts++
		if(!(isnewplayer(C.mob) || istype(C.mob, /mob/observer)))
			if(C.mob && isbelly(C.mob.loc))
				bellied++
		if(C.is_afk())
			afks++
		else
			active++

	return "Current server status:\n**Web Manifest:** <https://vore-station.net/manifest.php>\n**Players:** [counts]\n**Active:** [active]\n**AFK:** [afks]\n**Bellied:** [bellied]\n\n**Round Duration:** [roundduration2text()]\n**Current Map:** [map_name]"

/datum/tgs_chat_command/parsetest
	name = "parsetest"
	help_text = "Shows the current production server status"
	admin_only = FALSE

/datum/tgs_chat_command/parsetest/Run(datum/tgs_chat_user/sender, params)
	return "```You passed:[params]```"

/datum/tgs_chat_command/staffwho
	name = "staffwho"
	help_text = "Shows the current online staff count"
	admin_only = TRUE

/datum/tgs_chat_command/staffwho/Run(datum/tgs_chat_user/sender, params)
	var/message = "Current online staff:\n"

	var/list/admin_keys = list()
	var/list/mod_keys = list()
	var/list/dev_keys = list()
	var/list/other_keys = list()

	var/count = 0

	for(var/client/C in GLOB.admins)
		count++
		var/keymsg = "[C.key]"
		if(C.is_afk())
			keymsg += " (AFK)"
		else if(C.holder.fakekey)
			keymsg += " (Stealth)"
		else if(isobserver(C.mob))
			keymsg += " (Ghost)"
		else if(isnewplayer(C.mob))
			keymsg += " (Lobby)"
		else
			keymsg += " (Ingame)"

		if(check_rights_for(C, R_ADMIN) && check_rights_for(C, R_BAN)) // R_ADMIN and R_BAN apparently an admin makes
			admin_keys += keymsg

		else if(check_rights_for(C, R_ADMIN) && !(check_rights_for(C, R_SERVER))) // R_ADMIN but not R_SERVER makes a moderator
			mod_keys += keymsg

		else if(check_rights_for(C, R_SERVER)) // R_SERVER makes a dev
			dev_keys += keymsg

		else // No R_ADMIN&&R_BAN, R_ADMIN!R_BAN, R_SERVER, must be a GM or something
			other_keys += keymsg

	var/admin_msg = english_list(admin_keys, "-None-")
	var/mod_msg = english_list(mod_keys, "-None-")
	var/dev_msg = english_list(dev_keys, "-None-")
	var/other_msg = english_list(other_keys, "-None-")

	message += "**Admins:** [admin_msg]\n**Mods/GMs:** [mod_msg]\n**Devs:** [dev_msg]\n**Other:** [other_msg]\n**Total:** [count] online"
	return message

GLOBAL_LIST_EMPTY(pending_discord_registrations)
/datum/tgs_chat_command/register
	name = "register"
	help_text = "Registers your chat username with your Byond username"
	admin_only = FALSE

/datum/tgs_chat_command/register/Run(datum/tgs_chat_user/sender, params)
	// Try to find if that ID is registered to someone already
	var/sql_discord = sql_sanitize_text(sender.id)
	var/datum/db_query/query = SSdbcore.NewQuery("SELECT discord_id FROM erro_player WHERE discord_id = '[sql_discord]'")
	query.Execute()
	if(query.NextRow())
		qdel(query)
		return "[sender.friendly_name], your Discord ID is already registered to a Byond username. Please contact an administrator if you changed your Byond username or Discord ID."
	qdel(query)
	var/key_to_find = "[ckey(params)]"

	// They didn't provide anything worth looking up.
	if(!length(key_to_find))
		return "[sender.friendly_name], you need to provide your Byond username at the end of the command. It can be in 'key' format (with spaces and characters) or 'ckey' format (without spaces or special characters)."

	// Try to find their client.
	var/client/user
	for(var/client/C in GLOB.clients)
		if(C.ckey == key_to_find)
			user = C
			break

	// Couldn't find them logged in.
	if(!user)
		return "[sender.friendly_name], I couldn't find a logged-in user with the username of '[key_to_find]', which is what you provided after conversion to Byond's ckey format. Please connect to the game server and try again."

	var/sql_ckey = sql_sanitize_text(key_to_find)
	query = SSdbcore.NewQuery("SELECT discord_id FROM erro_player WHERE ckey = '[sql_ckey]'")
	query.Execute()

	// We somehow found their client, BUT they don't exist in the database
	if(!query.NextRow())
		qdel(query)
		return "[sender.friendly_name], the server's database is either not responding or there's no evidence you've ever logged in. Please contact an administrator."

	// We found them in the database, AND they already have a discord ID assigned
	if(query.item[1])
		qdel(query)
		return "[sender.friendly_name], it appears you've already registered your chat and game IDs. If you've changed game or chat usernames, please contact an administrator for help."
	qdel(query)
	// Okay. We found them, they're in the DB, and they have no discord ID set.
	var/message = span_notice("A request has been sent from Discord to validate your Byond username, by '[sender.friendly_name]' in '[sender.channel.friendly_name]'") + "\
	<br>" + span_warning("If you did not send this request, do not click the link below, and do notify an administrator in-game or on Discord ASAP.") + "\
	<br><a href='byond://?src=\ref[user];discord_reg=[html_encode(sender.id)]'>Click Here</a> if you authorized this registration attempt. This link is valid for 10 minutes."
	to_chat(user, message)

	// To stifle href hacking
	GLOB.pending_discord_registrations.len++
	GLOB.pending_discord_registrations[GLOB.pending_discord_registrations.len] = list("ckey" = key_to_find, "id" = sender.id, "time" = world.realtime)

	return "[sender.friendly_name], I've sent you a message in-game. Please verify your username there to complete your registration within 10 minutes."

// Coin flip
/datum/tgs_chat_command/coinflip
	name = "flip"
	help_text = "babies first TGS command"
	admin_only = FALSE

/datum/tgs_chat_command/coinflip/Run(datum/tgs_chat_user/sender, params)
	var/x
	if(params != "tails" && params != "heads")
		return "```You need to guess!\n either heads or tails!```"
	if(prob(50))
		if(params == "tails")
			x = "correct"
		else
			x = "wrong"
		return "```Tails. [x]!```"

	if(params == "tails")
		x = "wrong"
	else
		x = "correct"
	return "```Heads. [x]!```"

/datum/tgs_chat_command/coinflip/alias
	name = "coin"

// Manifest
/datum/tgs_chat_command/manifest
	name = "manifest"
	help_text = "Shows the current crew manifest"
	admin_only = FALSE

/proc/ManifestToHtml()
	var/html = ""
	if(GLOB.data_core)
		html = GLOB.data_core.get_manifest(FALSE,TRUE,snowflake = TRUE)
	else
		html = span_bold("ERROR: NO DATACORE") //Could make the error more fancy later
	rustg_file_write(html,"[CONFIG_GET(string/nodebot_location)]\\html.html")

/datum/tgs_chat_command/manifest/Run(datum/tgs_chat_user/sender, params)
	if(CONFIG_GET(flag/nodebot_enabled))
		ManifestToHtml()
		return "http://manifest.chompstation13.net/"
	else
		var/outp = "Crew Manifest:"
		var/list/total = list()
		if(GLOB.data_core)
			GLOB.data_core.get_manifest_list()
		for(var/list/item in GLOB.PDA_Manifest)
			outp += "\n__**[item["cat"]]:**__"
			for(var/list/person in item["elems"])
				total |= person
				outp += "\n[person["name"]] -:- [person["rank"]]"

		return "**Total crew members:** [total.len]\n" + outp

// Discord ping
/datum/tgs_chat_command/discordping
	name = "discordping"
	help_text = "Pings the discord associated with the associated ckey"
	admin_only = TRUE

/datum/tgs_chat_command/discordping/Run(datum/tgs_chat_user/sender, params)
	var/key_to_find = "[ckey(params)]"

	// They didn't provide anything worth looking up.
	if(!length(key_to_find))
		return "[sender.friendly_name], you need to provide a Byond username at the end of the command. It can be in 'key' format (with spaces and characters) or 'ckey' format (without spaces or special characters)."

	var/datum/db_query/query = SSdbcore.NewQuery("SELECT discord_id FROM erro_player WHERE ckey = :t_ckey",list("t_ckey" = key_to_find))
	query.Execute()

	if(!query.NextRow())
		qdel(query)
		return "[sender.friendly_name], the server's database is either not responding or there's no such ckey in the database."

	if(!query.item[1])
		qdel(query)
		return "[sender.friendly_name], [key_to_find] is in the database, but has no discord ID associated with them."
	var/discord_id = query.item[1]
	qdel(query)
	return "[key_to_find]'s discord is <@[discord_id]>"

/datum/tgs_chat_command/getkey
	name = "getkey"
	help_text = "Finds the key associated with a discord id"
	admin_only = TRUE

/datum/tgs_chat_command/getkey/Run(datum/tgs_chat_user/sender, params)
	if(!params)
		return "[sender.friendly_name], you need to provide a Discord ID at the end of the command. To obtain someone's Discord ID, you need to enable developer mode on discord, and then right click on their name and click Copy ID."

	var/datum/db_query/query = SSdbcore.NewQuery("SELECT ckey FROM erro_player WHERE discord_id = :t_discord", list("t_discord"=params))
	query.Execute()

	if(!query.NextRow())
		qdel(query)
		return "[sender.friendly_name], the server's database is either not responding or there's no such Discord ID in the database."

	var/user_key = query.item[1]
	qdel(query)
	return "<@[params]>'s ckey is [user_key]"

/datum/tgs_chat_command/vore
	name = "vore"
	help_text = "vore"
	admin_only = FALSE

/datum/tgs_chat_command/vore/Run(datum/tgs_chat_user/sender, params)
	return "vore"

// - FAX
/datum/tgs_chat_command/readfax
	name = "readfax"
	help_text = "Reads a fax with specified faxid"
	admin_only = TRUE

/datum/tgs_chat_command/readfax/Run(sender, params)
	var/list/all_params = splittext(params, " ")
	if(!LAZYLEN(all_params))
		return "```Invalid command, missing fax id```"
	var/faxid = all_params[1]
	if(!all_params[1] || !fexists("[CONFIG_GET(string/fax_export_dir)]/fax_[faxid].html"))
		return "I’m sorry Dave, I’m afraid I can’t do that"
	var/faxmsg = return_file_text("[CONFIG_GET(string/fax_export_dir)]/fax_[faxid].html")
	return "FAX: ```[strip_html_properly(faxmsg)]```"

// Reply to admin tickets
/datum/tgs_chat_command/ticketreply
	name = "ticket"
	help_text = "allows admins to reply to open tickets. Usage: ticket id \[reply, reject, icissue, close, resolve, handle, reopen\] message"
	admin_only = TRUE

/datum/tgs_chat_command/ticketreply/Run(datum/tgs_chat_user/sender, params)
	var/list/message_as_list = splittext(params, " ")
	if(!LAZYLEN(message_as_list))
		return "```Invalid command usage: ticket id \[reply, reject, icissue, close, resolve, handle, reopen\] message```"

	var/id = text2num(message_as_list[1])
	if(!isnum(id))
		return "```First param must be the ticket ID.```"
	message_as_list.Cut(1, 2)
	if(!LAZYLEN(message_as_list))
		return "```Invalid command usage: ticket id \[reply, reject, icissue, close, resolve, handle, reopen\] message```"

	var/action = message_as_list[1]
	if(isnum(action))
		return "```Second param must be the action type.```"
	message_as_list.Cut(1, 2)

	if(!LAZYLEN(message_as_list) && action == "reply")
		return "```Invalid command usage: ticket id \[reply, reject, icissue, close, resolve, handle, reopen\] message```"

	if(!(action in list("reply", "reject", "icissue", "close", "resolve", "handle", "reopen")))
		return "```Invalid command usage: ticket id \[reply, reject, icissue, close, resolve, handle, reopen\] message```"

	var/text_message
	if(LAZYLEN(message_as_list))
		text_message = message_as_list.Join(" ")

	var/datum/ticket/found
	if(action == "reopen")
		for(var/datum/ticket/ticket in GLOB.tickets.closed_tickets)
			if(ticket.id == id)
				found = ticket
		if(!found)
			return "```Ticket with id #[id] was not found in closed tickets!```"
	else
		for(var/datum/ticket/ticket in GLOB.tickets.active_tickets)
			if(ticket.id == id)
				found = ticket
		if(!found)
			return "```Ticket with id #[id] was not found in active tickets!```"

	if(text_message)
		to_chat(found.initiator, span_admin_pm_warning("Admin PM from-" + span_bold("Discord Relay") + ": [text_message]"))
		found.AddInteraction("Discord Relay: [text_message]")
	switch(action)
		if("reject")
			found.Reject("Remote (Discord)")
		if("icissue")
			found.ICIssue("Remote (Discord)")
		if("close")
			found.Close("Remote (Discord)")
		if("resolve")
			found.Resolve("Remote (Discord)")
		if("handle")
			found.HandleIssue("Remote (Discord)")
		if("reopen")
			found.Reopen("Remote (Discord)")
	return "Ticket command ([action]) sent!"

// Remote smite
/datum/tgs_chat_command/remote_smite
	name = "smite"
	help_text = "allows admins to remotely smite players. Usage: smite \[bsa, lightning, pie, gib, dust\] name"
	admin_only = TRUE

/datum/tgs_chat_command/remote_smite/Run(datum/tgs_chat_user/sender, params)
	var/list/message_as_list = splittext(params, " ")
	if(!LAZYLEN(message_as_list))
		return "```Invalid command usage: smite \[bsa, lightning, pie, gib, dust\] name```"
	var/smite_name = message_as_list[1]
	if(!istext(smite_name))
		return "```First param must be the smite name.```"

	message_as_list.Cut(1, 2)
	if(!LAZYLEN(message_as_list))
		return "```Invalid command usage: smite \[bsa, lightning, pie, gib, dust\] name```"

	var/player_name = message_as_list.Join(" ")
	var/mob/living/real_target
	for(var/mob/living/target in GLOB.player_list)
		if(target.real_name == player_name)
			real_target = target
			break

	if(!real_target)
		return "Smite [smite_name] failed to find player ([player_name]), validate their name and try again."

	switch(smite_name)
		if("bsa")
			bluespace_artillery(real_target)
		if("lightning")
			var/turf/T = get_step(get_step(real_target, NORTH), NORTH)
			T.Beam(real_target, icon_state="lightning[rand(1,12)]", time = 5)
			real_target.electrocute_act(75,def_zone = BP_HEAD)
			real_target.visible_message(span_danger("[real_target] is struck by lightning!"))
		if("pie")
			new/obj/effect/decal/cleanable/pie_smudge(get_turf(real_target))
			playsound(real_target, 'sound/effects/slime_squish.ogg', 100, 1, get_rand_frequency(), falloff = 5)
			real_target.Weaken(1)
			real_target.visible_message(span_danger("[real_target] is struck by pie!"))
		if("gib")
			real_target.gib()
		if("dust")
			real_target.dust()
	return "Smite [smite_name] sent!"
