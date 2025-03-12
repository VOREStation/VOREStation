/turf/space/transit
	can_build_into_floor = FALSE
	var/pushdirection // push things that get caught in the transit tile this direction

//Overwrite because we dont want people building rods in space.
/turf/space/transit/attackby(obj/O as obj, mob/user as mob)
	return

/turf/space/transit/Initialize(mapload)
	. = ..()
	toggle_transit(reverse_dir[pushdirection])

//------------------------

/turf/space/transit/north // moving to the north
	icon_state = "arrow-north"
	pushdirection = SOUTH  // south because the space tile is scrolling south

/turf/space/transit/south // moving to the south
	icon_state = "arrow-south"
	pushdirection = SOUTH  // south because the space tile is scrolling south

/turf/space/transit/east // moving to the east
	icon_state = "arrow-east"
	pushdirection = WEST

/turf/space/transit/west // moving to the west
	icon_state = "arrow-west"
	pushdirection = WEST

//------------------------
