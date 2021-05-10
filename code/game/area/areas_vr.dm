/area
	var/enter_message
	var/exit_message
	var/limit_mob_size = TRUE //If mob size is limited in the area.
	var/block_suit_sensors = FALSE //If mob size is limited in the area.

/area/Entered(var/atom/movable/AM, oldLoc)
	. = ..()
	if(enter_message && isliving(AM))
		to_chat(AM, enter_message)

/area/Exited(var/atom/movable/AM, newLoc)
	. = ..()
	if(exit_message && isliving(AM))
		to_chat(AM, exit_message)
