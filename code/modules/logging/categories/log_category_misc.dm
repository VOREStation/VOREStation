/datum/log_category/attack
	category = LOG_CATEGORY_ATTACK
	config_flag = /datum/config_entry/flag/log_attack

/datum/log_category/supicious_login
	category = LOG_CATEGORY_SUSPICIOUS_LOGIN
	config_flag = /datum/config_entry/flag/log_suspicious_login

/datum/log_category/config
	category = LOG_CATEGORY_CONFIG

// Logs seperately, printed into on server shutdown to store hard deletes and such
/datum/log_category/qdel
	category = LOG_CATEGORY_QDEL
	// We want this human readable so it's easy to see at a glance
	entry_flags = ENTRY_USE_DATA_W_READABLE

/datum/log_category/vore
	category = LOG_CATEGORY_VORE
	config_flag = /datum/config_entry/flag/log_vore
