/decl/webhook/fax_sent
	id = WEBHOOK_FAX_SENT

/decl/webhook/fax_sent/get_message(var/list/data)
	.= ..()
	.["embeds"] = list(list(
		"title" = "[data["name"]]",
		"description" = data["body"],
		"color" = COLOR_WEBHOOK_DEFAULT
	))
