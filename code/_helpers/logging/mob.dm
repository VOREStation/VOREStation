/**
 * Logs a message to the mob_tags log, including the mobs tag
 * Arguments:
 * * text - text to log.
 */
/mob/proc/log_mob_tag(text, list/data)
	logger.Log(LOG_CATEGORY_DEBUG_MOBTAG, text, data)

/// Logs a message in a mob's individual log, and in the global logs as well if log_globally is true
/mob/log_message(message, message_type, color = null, log_globally = TRUE, list/data)
	if(!LAZYLEN(message))
		stack_trace("Empty message")
		return

	// Cannot use the list as a map if the key is a number, so we stringify it (thank you BYOND)
	var/smessage_type = GLOB.logtype_to_string[message_type]

	//This makes readability a bit better for admins.
	var/list/timestamped_message = list(
		"time" = world.timeofday,
		"name" = name,
		"ckey" = ckey,
		"loc" = loc_name(src),
		"event_id" = LAZYLEN(logging[smessage_type]),
		"message" = message,
		"color" = color
	)

	if(!CONFIG_GET(flag/database_logging))
		if(!islist(logging[smessage_type]))
			logging[smessage_type] = list()
		UNTYPED_LIST_ADD(logging[smessage_type], timestamped_message)

	if(HAS_CONNECTED_PLAYER(src))
		if(CONFIG_GET(flag/database_logging))
			db_log_insert(src, message, smessage_type, color)
		else
			if(!islist(persistent_client.logging[smessage_type]))
				persistent_client.logging[smessage_type] = list()
			UNTYPED_LIST_ADD(persistent_client.logging[smessage_type], timestamped_message)

	..()
