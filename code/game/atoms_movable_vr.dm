/atom/movable/proc/Bump_vr(var/atom/A, yes)
	return

/atom/movable/set_dir(newdir)
	. = ..(newdir)
	if(riding_datum)
		riding_datum.handle_vehicle_offsets()

/atom/movable/relaymove(mob/user, direction)
	. = ..()
	if(riding_datum)
		riding_datum.handle_ride(user, direction)
