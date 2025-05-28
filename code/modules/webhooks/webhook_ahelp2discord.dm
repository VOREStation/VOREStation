/decl/webhook/ahelp_sent
	id = WEBHOOK_AHELP_SENT

/decl/webhook/ahelp_sent/get_message(var/list/data)
	.= ..()
	.["embeds"] = list(list(
		"title" = "[data["name"]]",
		"description" = data["body"],
		"color" = data["color"] || COLOR_WEBHOOK_DEFAULT
	))

/decl/webhook/ahelp_sent/get_mentions()
	. = !length(GLOB.admins) && ..() // VOREStation Edit - GLOB admins
