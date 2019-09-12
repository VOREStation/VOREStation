
//
// Surface Base Z Levels
//

/area/anur/surfacebase
	icon = 'icons/turf/areas_vr.dmi'

/area/crew_quarters/sleep/maintDorm1
	name = "\improper Construction Dorm 1"
	icon_state = "Sleep"
	flags = RAD_SHIELDED

/area/crew_quarters/sleep/maintDorm2
	name = "\improper Construction Dorm 2"
	icon_state = "Sleep"
	flags = RAD_SHIELDED

/area/crew_quarters/sleep/maintDorm3
	name = "\improper Construction Dorm 3"
	icon_state = "Sleep"
	flags = RAD_SHIELDED

/area/crew_quarters/sleep/maintDorm4
	name = "\improper Construction Dorm 4"
	icon_state = "Sleep"
	flags = RAD_SHIELDED

//TFF 28/8/19 - cleanup of areas placement
/area/crew_quarters/sleep/vistor_room_1
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/vistor_room_2
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/vistor_room_3
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/vistor_room_4
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/vistor_room_5
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/vistor_room_6
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/vistor_room_7
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/vistor_room_8
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/vistor_room_9
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/vistor_room_10
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/vistor_room_11
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/vistor_room_12
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/Dorm_1
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/Dorm_2
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/Dorm_3
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/Dorm_4
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/Dorm_5
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/Dorm_6
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/Dorm_7
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/Dorm_8
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/Dorm_9
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/Dorm_10
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/Dorm_1/holo
	name = "\improper Dorm 1 Holodeck"
	icon_state = "dk_yellow"
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/Dorm_3/holo
	name = "\improper Dorm 3 Holodeck"
	icon_state = "dk_yellow"
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/Dorm_5/holo
	name = "\improper Dorm 5 Holodeck"
	icon_state = "dk_yellow"
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/Dorm_7/holo
	name = "\improper Dorm 7 Holodeck"
	icon_state = "dk_yellow"
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/holodeck/holodorm/source_basic
	name = "\improper Holodeck Source"
	flags = RAD_SHIELDED | BLUE_SHIELDED
/area/holodeck/holodorm/source_desert
	name = "\improper Holodeck Source"
	flags = RAD_SHIELDED | BLUE_SHIELDED
/area/holodeck/holodorm/source_seating
	name = "\improper Holodeck Source"
	flags = RAD_SHIELDED | BLUE_SHIELDED
/area/holodeck/holodorm/source_beach
	name = "\improper Holodeck Source"
	flags = RAD_SHIELDED | BLUE_SHIELDED
/area/holodeck/holodorm/source_garden
	name = "\improper Holodeck Source"
	flags = RAD_SHIELDED | BLUE_SHIELDED
/area/holodeck/holodorm/source_boxing
	name = "\improper Holodeck Source"
	flags = RAD_SHIELDED | BLUE_SHIELDED
/area/holodeck/holodorm/source_snow
	name = "\improper Holodeck Source"
	flags = RAD_SHIELDED | BLUE_SHIELDED
/area/holodeck/holodorm/source_space
	name = "\improper Holodeck Source"
	flags = RAD_SHIELDED | BLUE_SHIELDED
/area/holodeck/holodorm/source_off
	name = "\improper Holodeck Source"
	flags = RAD_SHIELDED | BLUE_SHIELDED

// Exclude some more areas from the atmos leak event so people don't get trapped when spawning.
/datum/event/atmos_leak/setup()
	excluded |= /area/anur/surfacebase/tram
	excluded |= /area/anur/surfacebase/atrium_one
	excluded |= /area/anur/surfacebase/atrium_two
	excluded |= /area/anur/surfacebase/atrium_three
	excluded |= /area/teleporter/departing
	excluded |= /area/hallway/station/upper
	..()
