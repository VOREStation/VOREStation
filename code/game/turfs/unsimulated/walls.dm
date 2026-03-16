/turf/unsimulated/wall
	name = "wall"
	icon = 'icons/turf/walls.dmi'
	icon_state = "riveted"
	opacity = 1
	density = TRUE
	blocks_air = TRUE

//For the tram
/turf/unsimulated/wall/moving
	icon = 'icons/turf/transit_vr.dmi'

//other set - for map building
/turf/unsimulated/wall/wall1
	icon_state = "riveted1"

/turf/unsimulated/wall/wall2
	icon_state = "riveted2"

/turf/unsimulated/wall/fakeglass
	name = "window"
	icon_state = "fakewindows"
	opacity = 0

//other set - for map building
/turf/unsimulated/wall/fakeglass2
	icon_state = "fakewindows2"
	opacity = 0

/turf/unsimulated/wall/other
	icon_state = "r_wall"

/turf/unsimulated/wall/fake_uranium_door
	icon = 'icons/obj/doors/Dooruranium.dmi'
	icon_state = "door_closed"
	name = "Sealed Door"

/turf/unsimulated/wall/fake_pod
	desc = "That looks like it doesn't open easily."
	icon = 'icons/obj/doors/rapid_pdoor.dmi'
	icon_state = "pdoor1"
	name = "Shuttle Bay Blast Door"
