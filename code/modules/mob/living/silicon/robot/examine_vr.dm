/mob/living/silicon/robot/proc/examine_bellies_borg()

	var/message = ""
	for (var/I in src.vore_organs)
		var/datum/belly/B = vore_organs[I]
		message += B.get_examine_msg()

	return message