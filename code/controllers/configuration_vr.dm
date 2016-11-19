//
// Lets read our settings from the configuration file on startup too!
//

/hook/startup/proc/read_vs_config()
	var/list/Lines = file2list("config/config.txt")
	for(var/t in Lines)
		if(!t)	continue

		t = trim(t)
		if (length(t) == 0)
			continue
		else if (copytext(t, 1, 2) == "#")
			continue

		var/pos = findtext(t, " ")
		var/name = null
		var/value = null

		if (pos)
			name = lowertext(copytext(t, 1, pos))
			value = copytext(t, pos + 1)
		else
			name = lowertext(t)

		if (!name)
			continue

		switch (name)
			if ("chat_webhook_url")
				config.chat_webhook_url = value
			if ("chat_webhook_key")
				config.chat_webhook_key = value
			if ("fax_export_dir")
				config.fax_export_dir = value
			if ("items_survive_digestion")
				config.items_survive_digestion = 1
	return 1
