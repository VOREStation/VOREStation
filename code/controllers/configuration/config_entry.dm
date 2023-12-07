/datum/config_entry
	/// Read-only, this is determined by the last portion of the derived entry type
	var/name
	/// The configured value for this entry. This shouldn't be initialized in code, instead set default
	var/config_entry_value
	/// Read-only default value for this config entry, used for resetting value to defaults when necessary. This is what config_entry_value is initially set to
	var/default
	/// The file which this was loaded from, if any
	var/resident_file
	/// Set to TRUE if the default has been overridden by a config entry
	var/modified = FALSE
	/// The config name of a configuration type that depricates this, if it exists
	var/deprecated_by
	/// The /datum/config_entry type that supercedes this one
	var/protection = NONE
	/// Do not instantiate if type matches this
	var/abstract_type = /datum/config_entry
	/// Force validate and set on VV. VAS proccall guard will run regardless.
	var/vv_VAS = TRUE
	/// Controls if error is thrown when duplicate configuration values for this entry type are encountered
	var/dupes_allowed = FALSE
	/// Stores the original protection configuration, used for set_default()
	var/default_protection
