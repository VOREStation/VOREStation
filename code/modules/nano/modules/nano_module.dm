/datum/nano_module
	var/name
	var/datum/host
	var/list/using_access

/datum/nano_module/New(var/datum/host)
	..()
	src.host = host.nano_host()

/datum/nano_module/nano_host()
	return host ? host : src

/datum/nano_module/proc/can_still_topic(var/datum/topic_state/state = default_state)
	return CanUseTopic(usr, state) == STATUS_INTERACTIVE

/datum/nano_module/proc/check_eye(var/mob/user)
	return -1

/datum/nano_module/proc/check_access(var/mob/user, var/access)
	if(!access)
		return 1

	if(using_access)
		if(access in using_access)
			return 1
		else
			return 0

	if(!istype(user))
		return 0

	var/obj/item/card/id/I = user.GetIdCard()
	if(!I)
		return 0

	if(access in I.access)
		return 1

	return 0

/datum/nano_module/proc/print_text(var/text, var/mob/user)
	var/obj/item/modular_computer/MC = nano_host()
	if(istype(MC))
		if(!MC.nano_printer)
			to_chat(user, "Error: No printer detected. Unable to print document.")
			return

		if(!MC.nano_printer.print_text(text))
			to_chat(user, "Error: Printer was unable to print the document. It may be out of paper.")
	else
		to_chat(user, "Error: Unable to detect compatible printer interface. Are you running NTOSv2 compatible system?")

/datum/proc/initial_data()
	return list()

/datum/proc/update_layout()
	return FALSE

/datum/nano_module/proc/relaymove(var/mob/user, direction)
	return FALSE
