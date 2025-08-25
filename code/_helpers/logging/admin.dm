/* Items with ADMINPRIVATE prefixed are stripped from public logs. */

// For backwards compatibility these are currently also added to LOG_CATEGORY_GAME with their respective prefix
// This is to avoid breaking any existing tools that rely on the old format, but should be removed in the future

/// General logging for admin actions
/proc/log_admin(text, list/data)
	GLOB.admin_activities.Add(text)
	logger.Log(LOG_CATEGORY_ADMIN, text, data)
	logger.Log(LOG_CATEGORY_COMPAT_GAME, "ADMIN: [text]")

/// General logging for admin actions
/proc/log_admin_private(text, list/data)
	GLOB.admin_activities.Add(text)
	logger.Log(LOG_CATEGORY_ADMIN_PRIVATE, text, data)
	logger.Log(LOG_CATEGORY_COMPAT_GAME, "ADMINPRIVATE: [text]")

/// Logging for AdminSay (ASAY) messages
/proc/log_adminsay(text, list/data)
	GLOB.admin_activities.Add(text)
	logger.Log(LOG_CATEGORY_ADMIN_PRIVATE_ASAY, text, data)
	logger.Log(LOG_CATEGORY_COMPAT_GAME, "ADMINPRIVATE: ASAY: [text]")

/proc/log_modsay(text, mob/speaker)
	if (CONFIG_GET(flag/log_adminchat))
		WRITE_LOG(GLOB.diary, "MODSAY: [speaker.simple_info_line()]: [html_decode(text)]")

/proc/log_eventsay(text, mob/speaker)
	if (CONFIG_GET(flag/log_adminchat))
		WRITE_LOG(GLOB.diary, "EVENTSAY: [speaker.simple_info_line()]: [html_decode(text)]")

/**
 * Writes to a special log file if the log_suspicious_login config flag is set,
 * which is intended to contain all logins that failed under suspicious circumstances.
 *
 * Mirrors this log entry to log_access when access_log_mirror is TRUE, so this proc
 * doesn't need to be used alongside log_access and can replace it where appropriate.
 */
/proc/log_suspicious_login(text, list/data, access_log_mirror = TRUE)
	logger.Log(LOG_CATEGORY_SUSPICIOUS_LOGIN, text)
	if(access_log_mirror)
		log_access(text)
