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
	var/list/counts = get_staffwho_numbers()
	var/list/keys = counts["keys"]
	counts -= "keys" // Remove the 'keys' list as we don't want to iterate onto it here. We can hold the list.
	for(var/key in counts)
		message += "**[key]:** [counts[key]]\n"
	message += "**Online:** [english_list(keys, "***!!Nobody!!***")]"
	return message
