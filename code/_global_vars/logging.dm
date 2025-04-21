GLOBAL_VAR(round_id)
GLOBAL_PROTECT(round_id)

/// The directory in which ALL log files should be stored
GLOBAL_VAR_INIT(log_directory, "data/logs/") //See world.dm for the full calculated path
GLOBAL_PROTECT(log_directory)

GLOBAL_VAR(diary)
GLOBAL_PROTECT(diary)

GLOBAL_VAR(error_log)
GLOBAL_PROTECT(error_log)

GLOBAL_VAR(sql_error_log)
GLOBAL_PROTECT(sql_error_log)

GLOBAL_VAR(query_debug_log)
GLOBAL_PROTECT(query_debug_log)

GLOBAL_VAR(debug_log)
GLOBAL_PROTECT(debug_log)

GLOBAL_VAR(href_logfile)
GLOBAL_PROTECT(href_logfile)

/// All bomb related messages
GLOBAL_LIST_EMPTY(bombers)
GLOBAL_PROTECT(bombers)

/// Stores who uploaded laws to which silicon-based lifeform, and what the law was
GLOBAL_LIST_EMPTY(lawchanges)
GLOBAL_PROTECT(lawchanges)
