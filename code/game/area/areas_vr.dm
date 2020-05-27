/area
	var/enter_message
	var/exit_message

/area/Entered(var/atom/movable/AM, oldLoc)
	. = ..()
	if(enter_message && isliving(AM))
		to_chat(AM, enter_message)

/area/Exited(var/atom/movable/AM, newLoc)
	. = ..()
	if(exit_message && isliving(AM))
		to_chat(AM, exit_message)
