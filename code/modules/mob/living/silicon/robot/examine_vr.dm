/mob/living/silicon/robot/proc/examine_bellies_borg()

	var/list/message_list = list()
	for(var/belly in vore_organs)
		var/obj/belly/B = belly
		message_list += B.get_examine_msg()
		message_list += B.get_examine_msg_absorbed()

	return message_list