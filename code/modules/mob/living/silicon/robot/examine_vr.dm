/mob/living/silicon/robot/proc/examine_bellies_borg()

	var/list/message_list = list()
	for(var/belly in vore_organs)
		var/obj/belly/B = belly
		var/bellymessage = B.get_examine_msg()
		if(bellymessage) message_list += bellymessage
		bellymessage = B.get_examine_msg_absorbed()
		if(bellymessage) message_list += bellymessage

	return message_list
