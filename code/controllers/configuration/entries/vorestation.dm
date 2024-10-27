/// For configuring if the important_items survive digestion
/datum/config_entry/flag/items_survive_digestion
	default = TRUE

/datum/config_entry/string/vgs_access_identifier // VGS
	default = null
	protection = CONFIG_ENTRY_LOCKED | CONFIG_ENTRY_HIDDEN

/datum/config_entry/number/vgs_server_port // VGS
	default = null
	min_val = 0
	max_val = 65535
	protection = CONFIG_ENTRY_LOCKED | CONFIG_ENTRY_HIDDEN

/datum/config_entry/flag/time_off
	default = FALSE
	protection = CONFIG_ENTRY_LOCKED

/datum/config_entry/flag/pto_job_change
	default = FALSE
	protection = CONFIG_ENTRY_LOCKED

/// Unlimited by default
/datum/config_entry/number/limit_interns
	default = -1
	min_val = -1
	protection = CONFIG_ENTRY_LOCKED

/// Unlimited by default
/datum/config_entry/number/limit_visitors
	default = -1
	min_val = -1
	protection = CONFIG_ENTRY_LOCKED

/// Hours
/datum/config_entry/number/pto_cap
	default = 100
	protection = CONFIG_ENTRY_LOCKED

/datum/config_entry/flag/require_flavor
	default = FALSE
	protection = CONFIG_ENTRY_LOCKED

/// API key for ipqualityscore.com
/datum/config_entry/string/ipqualityscore_apikey
	protection = CONFIG_ENTRY_LOCKED | CONFIG_ENTRY_HIDDEN

/datum/config_entry/flag/use_playtime_restriction_for_jobs
	default = FALSE
	protection = CONFIG_ENTRY_LOCKED

/// URL of the webhook for sending announcements/faxes to discord chat.
/datum/config_entry/string/chat_webhook_url
	protection = CONFIG_ENTRY_LOCKED | CONFIG_ENTRY_HIDDEN

/// Shared secret for authenticating to the chat webhook
/datum/config_entry/string/chat_webhook_key
	protection = CONFIG_ENTRY_LOCKED | CONFIG_ENTRY_HIDDEN

/// Directory in which to write exported fax HTML files.
/datum/config_entry/string/fax_export_dir
	default = "data/faxes"
	protection = CONFIG_ENTRY_LOCKED
