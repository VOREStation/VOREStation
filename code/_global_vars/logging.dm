GLOBAL_VAR(round_id)
GLOBAL_PROTECT(round_id)

/// The directory in which ALL log files should be stored
GLOBAL_VAR_INIT(log_directory, "data/logs/") //See world.dm for the full calculated path
GLOBAL_PROTECT(log_directory)

#define DECLARE_LOG_NAMED(log_var_name, log_file_name, start)\
GLOBAL_VAR(##log_var_name);\
GLOBAL_PROTECT(##log_var_name);\
/world/_initialize_log_files(temp_log_override = null){\
	..();\
	GLOB.##log_var_name = temp_log_override || "[GLOB.log_directory]/[##log_file_name].log";\
	if(!temp_log_override && ##start){\
		start_log(GLOB.##log_var_name);\
	}\
}

#define DECLARE_LOG(log_name, start) DECLARE_LOG_NAMED(##log_name, "[copytext(#log_name, 1, length(#log_name) - 3)]", start)
#define START_LOG TRUE
#define DONT_START_LOG FALSE

/// Populated by log declaration macros to set log file names and start messages
/world/proc/_initialize_log_files(temp_log_override = null)
	// Needs to be here to avoid compiler warnings
	SHOULD_CALL_PARENT(TRUE)
	return

// All individual log files.
// These should be used where the log category cannot easily be a json log file.
DECLARE_LOG(config_error_log, DONT_START_LOG)
DECLARE_LOG(perf_log, DONT_START_LOG) // Declared here but name is set in time_track subsystem

#ifdef REFERENCE_TRACKING_LOG_APART
DECLARE_LOG_NAMED(harddel_log, "harddels", START_LOG)
#endif

#if defined(UNIT_TEST) || defined(SPACEMAN_DMM)
DECLARE_LOG_NAMED(test_log, "tests", START_LOG)
#endif

/// All admin related log lines minus their categories
GLOBAL_LIST_EMPTY(admin_activities)
GLOBAL_PROTECT(admin_activities)

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

#undef DECLARE_LOG
#undef DECLARE_LOG_NAMED
#undef START_LOG
#undef DONT_START_LOG
