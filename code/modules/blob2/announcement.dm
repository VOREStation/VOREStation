/proc/level_seven_blob_announcement(var/obj/structure/blob/core/B)
	if(!B || !B.overmind)
		return
	var/datum/blob_type/blob = B.overmind.blob_type // Shortcut so we don't need to delve into three variables every time.
	var/list/lines = list()

	lines += "Confirmed outbreak of level [7 + blob.difficulty] biohazard aboard [station_name()]. All personnel must contain the outbreak."

	if(blob.difficulty >= BLOB_DIFFICULTY_MEDIUM) // Tell them what kind of blob it is if it's tough.
		lines += "The biohazard has been identified as a '[blob.name]'."

	if(blob.difficulty >= BLOB_DIFFICULTY_HARD) // If it's really hard then tell them where it is so the response occurs faster.
		lines += "It is suspected to have originated from \the [get_area(B)]."

	if(blob.difficulty >= BLOB_DIFFICULTY_SUPERHARD)
		lines += "Extreme caution is advised."

	command_announcement.Announce(lines.Join("\n"), "Biohazard Alert", new_sound = 'sound/AI/outbreak7.ogg')