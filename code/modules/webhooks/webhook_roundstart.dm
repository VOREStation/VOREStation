/decl/webhook/roundstart
	id = WEBHOOK_ROUNDSTART

// Data expects a "url" field pointing to the current hosted server and port to connect on.
/decl/webhook/roundstart/get_message(var/list/data)
	. = ..()
	var/desc = "Gamemode: **[global.master_mode]**\n"
	desc += "Players: **[global.player_list.len]**"
	if(data && data["url"])
		desc += "\nAddress: <[data["url"]]>"

	.["embeds"] = list(list(
		"title" = "Round has started.",
		"description" = desc,
		"color" = COLOR_WEBHOOK_DEFAULT
	))
