/datum/element/rotatable/Attach(datum/target)
	. = ..()
	if(!isatom(target))
		return ELEMENT_INCOMPATIBLE
	var/atom/set_atom = target
	set_atom.verbs |= /atom/movable/proc/rotate_clockwise
	set_atom.verbs |= /atom/movable/proc/rotate_counterclockwise
	set_atom.verbs |= /atom/movable/proc/turn_around


/datum/element/rotatable/Detach(datum/source)
	var/atom/set_atom = source
	set_atom.verbs -= /atom/movable/proc/rotate_clockwise
	set_atom.verbs -= /atom/movable/proc/rotate_counterclockwise
	set_atom.verbs -= /atom/movable/proc/turn_around
	return ..()

// Helper procs
/atom/movable/proc/rotate_clockwise()
	set name = "Rotate Clockwise"
	set category = "Object"
	set src in oview(1)

	if(!isobserver(usr))
		if(usr.incapacitated())
			return FALSE
		if(ismouse(usr))
			to_chat(usr, span_notice("You are too tiny to do that!"))
			return FALSE
	if(anchored)
		to_chat(usr, "It is fastened to the floor!")
		return FALSE

	set_dir(turn(dir, 270))
	to_chat(usr, span_notice("You rotate the [src] to face [dir2text(dir)]!"))
	return TRUE

/atom/movable/proc/rotate_counterclockwise()
	set name = "Rotate Counter Clockwise"
	set category = "Object"
	set src in oview(1)

	if(!isobserver(usr))
		if(usr.incapacitated())
			return FALSE
		if(ismouse(usr))
			to_chat(usr, span_notice("You are too tiny to do that!"))
			return FALSE
	if(anchored)
		to_chat(usr, "It is fastened to the floor!")
		return FALSE

	set_dir(turn(dir, 90))
	to_chat(usr, span_notice("You rotate the [src] to face [dir2text(dir)]!"))
	return TRUE

/atom/movable/proc/turn_around()
	set name = "Rotate Around"
	set category = "Object"
	set src in oview(1)

	if(!isobserver(usr))
		if(usr.incapacitated())
			return FALSE
		if(ismouse(usr))
			to_chat(usr, span_notice("You are too tiny to do that!"))
			return FALSE
	if(anchored)
		to_chat(usr, "It is fastened to the floor!")
		return FALSE

	dir = GLOB.reverse_dir[dir]
	to_chat(usr, span_notice("You flip the [src] to face [dir2text(dir)]!"))
