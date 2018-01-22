//
// Lets read our settings from the configuration file on startup too!
//

/datum/configuration
	var/list/engine_map	// Comma separated list of engines to choose from.  Blank means fully random.
	var/assistants_ratio
	var/assistants_assured = 15 // Default 15, only used if the ratio is set though.

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
			if ("assistants_ratio")
				config.assistants_ratio = text2num(value)
			if ("assistants_assured")
				config.assistants_assured = text2num(value)
			if ("chat_webhook_url")
				config.chat_webhook_url = value
			if ("chat_webhook_key")
				config.chat_webhook_key = value
			if ("engine_map")
				config.engine_map = splittext(value, ",")
			if ("fax_export_dir")
				config.fax_export_dir = value
			if ("items_survive_digestion")
				config.items_survive_digestion = 1

	return 1
