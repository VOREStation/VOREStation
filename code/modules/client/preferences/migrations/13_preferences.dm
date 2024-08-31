/// Transforms the bay style `"preferences": ["SOUND_MIDI", ...]` to `"SOUND_MIDI": 1` and `"preferences_disabled": [...]` to `0`.
/datum/preferences/proc/migration_13_preferences(datum/json_savefile/S)
	var/list/preferences_enabled = S.get_entry("preferences")
	for(var/key in preferences_enabled)
		S.set_entry("[key]", TRUE)

	var/list/preferences_disabled = S.get_entry("preferences_disabled")
	for(var/key in preferences_disabled)
		S.set_entry("[key]", FALSE)
