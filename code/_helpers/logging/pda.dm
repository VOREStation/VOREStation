/// Logging for PDA messages sent
/proc/log_pda(text, list/data)
	logger.Log(LOG_CATEGORY_PDA, text, data)
