/**
 * Helper for logging chat messages or other logs with arbitrary inputs (e.g. announcements)
 *
 * This proc compiles a log string by prefixing the tag to the message
 * and suffixing what it was forced_by if anything
 * if the message lacks a tag and suffix then it is logged on its own
 * Arguments:
 * * message - The message being logged
 * * message_type - the type of log the message is(ATTACK, SAY, etc)
 * * tag - tag that indicates the type of text(announcement, telepathy, etc)
 * * log_globally - boolean checking whether or not we write this log to the log file
 * * forced_by - source that forced the dialogue if any
 */
/atom/proc/log_talk(message, message_type, tag = null, log_globally = TRUE, forced_by = null, custom_say_emote = null)
	var/prefix = tag ? "([tag]) " : ""
	var/suffix = forced_by ? " FORCED by [forced_by]" : ""
	log_message("[prefix][custom_say_emote ? "*[custom_say_emote]*, " : ""]\"[message]\"[suffix]", message_type, log_globally = log_globally)

/// Logging for generic spoken messages
/proc/log_say(text, list/data)
	logger.Log(LOG_CATEGORY_GAME_SAY, text, data)

/// Logging for whispered messages
/proc/log_whisper(text, list/data)
	logger.Log(LOG_CATEGORY_GAME_WHISPER, text, data)
