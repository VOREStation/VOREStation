/decl/webhook/roundprep
	id = WEBHOOK_ROUNDPREP

// Data expects "url" and field pointing to the current hosted server and port to connect on.
/decl/webhook/roundprep/get_message(var/list/data)
	. = ..()
	var/desc = "The server has been started!\n"
	if(data && data["map"])
		desc += "Map: **[data["map"]]**\n"
	if(data && data["url"])
		desc += "Address: <[data["url"]]>"

	.["embeds"] = list(list(
		"title" = "New round is being set up.",
		"description" = desc,
		"color" = COLOR_WEBHOOK_DEFAULT
	))
