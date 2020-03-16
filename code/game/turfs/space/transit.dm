/turf/space/transit
	keep_sprite = TRUE
	can_build_into_floor = FALSE
	var/pushdirection // push things that get caught in the transit tile this direction

//Overwrite because we dont want people building rods in space.
/turf/space/transit/attackby(obj/O as obj, mob/user as mob)
	return

//------------------------

/turf/space/transit/north // moving to the north
	icon_state = "arrow-north"
	pushdirection = SOUTH  // south because the space tile is scrolling south

/turf/space/transit/north/New()
	..()
	if(!phase_shift_by_x)
		phase_shift_by_x = get_cross_shift_list(15)

	var/x_shift = phase_shift_by_x[src.x % (phase_shift_by_x.len - 1) + 1]
	var/transit_state = (world.maxy - src.y + x_shift)%15 + 1

	icon_state = "speedspace_ns_[transit_state]"
//------------------------

/turf/space/transit/south // moving to the south
	icon_state = "arrow-south"
	pushdirection = SOUTH  // south because the space tile is scrolling south

/turf/space/transit/south/New()
	..()
	if(!phase_shift_by_x)
		phase_shift_by_x = get_cross_shift_list(15)

	var/x_shift = phase_shift_by_x[src.x % (phase_shift_by_x.len - 1) + 1]
	var/transit_state = (world.maxy - src.y + x_shift)%15 + 1

	var/icon/I = new(icon, "speedspace_ns_[transit_state]")
	I.Flip(SOUTH)
	icon = I
//------------------------

/turf/space/transit/east // moving to the east
	icon_state = "arrow-east"
	pushdirection = WEST

/turf/space/transit/east/New()
	..()
	if(!phase_shift_by_y)
		phase_shift_by_y = get_cross_shift_list(15)

	var/y_shift = phase_shift_by_y[src.y % (phase_shift_by_y.len - 1) + 1]
	var/transit_state = (world.maxx - src.x + y_shift)%15 + 1

	icon_state = "speedspace_ew_[transit_state]"
//------------------------

/turf/space/transit/west // moving to the west
	icon_state = "arrow-west"
	pushdirection = WEST

/turf/space/transit/west/New()
	..()
	if(!phase_shift_by_y)
		phase_shift_by_y = get_cross_shift_list(15)

	var/y_shift = phase_shift_by_y[src.y % (phase_shift_by_y.len - 1) + 1]
	var/transit_state = (world.maxx - src.x + y_shift)%15 + 1

	var/icon/I = new(icon, "speedspace_ew_[transit_state]")
	I.Flip(WEST)
	icon = I

//------------------------