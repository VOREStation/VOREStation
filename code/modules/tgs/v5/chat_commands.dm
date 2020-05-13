/datum/tgs_chat_command/status
	name = "status"
	help_text = "Shows the current production server status"
	admin_only = FALSE

/datum/tgs_chat_command/status/Run(datum/tgs_chat_user/sender, params)
	return "Current server status:\n**Web Manifest:** <https://vore-station.net/manifest.php>\n**Players:** [TGS_CLIENT_COUNT]\n**Round Duration:** [roundduration2text()]"

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

		if(R_ADMIN & C.holder.rights && R_BAN & C.holder.rights) // R_ADMIN and R_BAN apparently an admin makes
			admin_keys += keymsg

		else if(R_ADMIN & C.holder.rights && !(R_SERVER & C.holder.rights)) // R_ADMIN but not R_SERVER makes a moderator
			mod_keys += keymsg

		else if(R_SERVER & C.holder.rights) // R_SERVER makes a dev
			dev_keys += keymsg

		else // No R_ADMIN&&R_BAN, R_ADMIN!R_BAN, R_SERVER, must be a GM or something
			other_keys += keymsg

	var/admin_msg = english_list(admin_keys, "-None-")
	var/mod_msg = english_list(mod_keys, "-None-")
	var/dev_msg = english_list(dev_keys, "-None-")
	var/other_msg = english_list(other_keys, "-None-")

	message += "**Admins:** [admin_msg]\n**Mods/GMs:** [mod_msg]\n **Devs:** [dev_msg]\n**Other:** [other_msg]\n**Total:** [count] online"
	return message