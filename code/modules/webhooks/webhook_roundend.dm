/decl/webhook/roundend
	id = WEBHOOK_ROUNDEND

// Data expects three numerical fields: "survivors", "escaped", "ghosts", "clients"
/decl/webhook/roundend/get_message(var/list/data)
	. = ..()
	var/desc = "A round of **[SSticker.mode ? SSticker.mode.name : "Unknown"]** ([game_id]) has ended.\n\n"
	if(data)
		var/s_escaped =  "Escaped"
		if(!emergency_shuttle.evac)
			s_escaped = "Transferred"
		if(data["survivors"] > 0)
			desc += "Survivors: **[data["survivors"]]**\n"
			desc += "[s_escaped]: **[data["escaped"]]**\n"
		else
			desc += "There were **no survivors**.\n\n"
		desc += "Ghosts: **[data["ghosts"]]**\n"
		desc += "Players: **[data["clients"]]**\n"
		desc += "Round duration: **[roundduration2text()]**"

	.["embeds"] = list(list(
	//	"title" = global.end_credits_title,
		"title" = "Round Has Ended",
		"description" = desc,
		"color" = COLOR_WEBHOOK_DEFAULT
	))
