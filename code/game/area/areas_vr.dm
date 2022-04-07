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
	var/added_roofs = 0
	for(var/turf/T in contents)
		log_and_message_admins("I am checking [T]")
		if(T.outdoors >= 0)
			log_and_message_admins("It's outdoors, I'll skip it.")
			continue
		if(HasAbove(T.z))
			log_and_message_admins("It has a z level above it, I will investigate what's above.")
			var/turf/TA = GetAbove(T)
			log_and_message_admins("I found [TA] up there.")
			if(isopenspace(TA))
				log_and_message_admins("[TA] is open space, I'll try to replace it.")
				TA.ChangeTurf(ceiling_type, TRUE, TRUE, TRUE)
				added_roofs ++
	log_and_message_admins("<span class='danger'>Made [added_roofs] roof tiles!</span>", R_DEBUG)
