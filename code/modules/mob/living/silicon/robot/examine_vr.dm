/mob/living/silicon/robot/proc/examine_bellies_borg()

	var/list/message_list = list()
	for(var/obj/belly/B as anything in vore_organs)
		var/bellymessage = B.get_examine_msg()
		if(bellymessage) message_list += bellymessage
		bellymessage = B.get_examine_msg_absorbed()
		if(bellymessage) message_list += bellymessage

	return message_list
