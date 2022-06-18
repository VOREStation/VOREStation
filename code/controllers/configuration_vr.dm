//
// Lets read our settings from the configuration file on startup too!
//

/datum/configuration
	var/static/time_off = FALSE
	var/static/pto_job_change = FALSE
	var/static/limit_interns = -1 //Unlimited by default
	var/static/limit_visitors = -1 //Unlimited by default
	var/static/pto_cap = 100 //Hours
	var/static/require_flavor = FALSE
	var/static/ipqualityscore_apikey //API key for ipqualityscore.com
	var/static/use_playtime_restriction_for_jobs = FALSE

	var/static/allow_map_rotation = 0
	var/static/custom_rotation_handling = 0
	var/static/map_rotation_mode = 1
	var/static/rotation_schedule_mode = 1
	var/static/rotate_after_round = 10
	var/static/rotate_after_day = "Sunday"

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
			if ("limit_interns")
				config.limit_interns = text2num(value)
			if ("limit_visitors")
				config.limit_visitors = text2num(value)
			if ("pto_cap")
				config.pto_cap = text2num(value)
			if ("time_off")
				config.time_off = TRUE
			if ("pto_job_change")
				config.pto_job_change = TRUE
			if ("require_flavor")
				config.require_flavor = TRUE
			if ("ipqualityscore_apikey")
				config.ipqualityscore_apikey = value
			if ("use_playtime_restriction_for_jobs")
				config.use_playtime_restriction_for_jobs = TRUE
			if("allow_map_rotation")
				config.allow_map_rotation = text2num(value)
			if("custom_rotation_handling")
				config.custom_rotation_handling = text2num(value)
			if("map_rotation_mode")
				config.map_rotation_mode = text2num(value)
			if("rotation_schedule_mode")
				config.rotation_schedule_mode = text2num(value)
			if("rotate_after_round")
				config.rotate_after_round = text2num(value)
			if("rotate_after_day")
				config.rotate_after_day = value

	return 1
