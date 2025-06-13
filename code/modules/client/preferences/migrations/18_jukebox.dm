/// Remaps jukebox volume from 0-1 to 0-100.
/datum/preferences/proc/migration_18_jukebox(datum/json_savefile/S)
	S.set_entry("media_volume", S.get_entry("media_volume") * 100)
	S.save()
