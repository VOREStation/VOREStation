/datum/tgs_chat_command/status
	name = "status"
	help_text = "Shows the current production server status"
	admin_only = FALSE

/datum/tgs_chat_command/status/Run(datum/tgs_chat_user/sender, params)
	return "```Players logged in: [GLOB.clients.len] - Round Duration: [roundduration2text()]```"

/datum/tgs_chat_command/parsetest
	name = "parsetest"
	help_text = "Shows the current production server status"
	admin_only = FALSE

/datum/tgs_chat_command/parsetest/Run(datum/tgs_chat_user/sender, params)
	return "```You passed:[params]```"
