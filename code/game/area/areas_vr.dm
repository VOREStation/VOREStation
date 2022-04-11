/area
	var/enter_message
	var/exit_message
	var/limit_mob_size = TRUE //If mob size is limited in the area.
	var/block_suit_sensors = FALSE //If mob size is limited in the area.
	var/turf/ceiling_type

/area/Entered(var/atom/movable/AM, oldLoc)
	. = ..()
	if(enter_message && isliving(AM))
		to_chat(AM, enter_message)

/area/Exited(var/atom/movable/AM, newLoc)
	. = ..()
	if(exit_message && isliving(AM))
		to_chat(AM, exit_message)

/area/Initialize(mapload)
	apply_ceiling()
	. = ..()

/area/proc/apply_ceiling()
	if(!ceiling_type)
		return
	for(var/turf/T in contents)
		if(T.outdoors >= 0)
			continue
		if(HasAbove(T.z))
			var/turf/TA = GetAbove(T)
			if(isopenspace(TA))
				TA.ChangeTurf(ceiling_type, TRUE, TRUE, TRUE)
