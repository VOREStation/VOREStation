/// Logging for config errors
/// Rarely gets called; just here in case the config breaks.
/proc/log_config(text, list/data)
	var/entry = "CONFIG: "

	entry += text
	entry += " | DATA: "
	entry += data

	WRITE_LOG(GLOB.diary, entry)
	SEND_TEXT(world.log, text)
