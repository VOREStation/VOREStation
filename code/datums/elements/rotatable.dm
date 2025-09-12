/datum/element/rotatable
	VAR_PROTECTED/only_flip = FALSE

/datum/element/rotatable/onlyflip
	only_flip = TRUE

/datum/element/rotatable/Attach(datum/target)
	. = ..()
	if(!isatom(target))
		return ELEMENT_INCOMPATIBLE
	var/atom/set_atom = target
	if(!only_flip)
		set_atom.verbs |= /atom/movable/proc/rotate_clockwise
		set_atom.verbs |= /atom/movable/proc/rotate_counterclockwise
	set_atom.verbs |= /atom/movable/proc/turn_around

/datum/element/rotatable/Detach(datum/source)
	var/atom/set_atom = source
	if(!only_flip)
		set_atom.verbs -= /atom/movable/proc/rotate_clockwise
		set_atom.verbs -= /atom/movable/proc/rotate_counterclockwise
	set_atom.verbs -= /atom/movable/proc/turn_around
	return ..()

// Core rotation proc, override me to add conditions to object rotations or update_icons/state after!
/atom/movable/proc/handle_rotation_verbs(angle)
	if(isobserver(usr))
		if(!ghosts_can_use_rotate_verbs())
			return FALSE
	else
		if(usr.incapacitated())
			return FALSE
		if(ismouse(usr))
			to_chat(usr, span_notice("You are too tiny to do that!"))
			return FALSE

	if(anchored && !can_use_rotate_verbs_while_anchored())
		to_chat(usr, span_notice("It is fastened to the floor!"))
		return FALSE

	set_dir(turn(dir, angle))
	to_chat(usr, span_notice("You rotate \the [src] to face [dir2text(dir)]!"))
	return TRUE

// Overrides for customization
/atom/movable/proc/ghosts_can_use_rotate_verbs()
	return FALSE

/atom/movable/proc/can_use_rotate_verbs_while_anchored()
	return FALSE

// Helper VERBS
/atom/movable/proc/rotate_clockwise()
	SHOULD_NOT_OVERRIDE(TRUE)
	set name = "Rotate Clockwise"
	set category = "Object"
	set src in view(1)
	return handle_rotation_verbs(270)

/atom/movable/proc/rotate_counterclockwise()
	SHOULD_NOT_OVERRIDE(TRUE)
	set name = "Rotate Counter Clockwise"
	set category = "Object"
	set src in view(1)
	return handle_rotation_verbs(90)

/atom/movable/proc/turn_around()
	SHOULD_NOT_OVERRIDE(TRUE)
	set name = "Turn Around"
	set category = "Object"
	set src in view(1)
	return handle_rotation_verbs(180)
