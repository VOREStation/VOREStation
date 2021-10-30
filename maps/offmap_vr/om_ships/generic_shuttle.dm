// Compile in the map for CI testing if we're testing compileability of all the maps
#if MAP_TEST
#include "generic_shuttle.dmm"
#endif

// Map template for spawning the shuttle
/datum/map_template/om_ships/hybrid
	name = "OM Ship - Generic Shuttle"
	desc = "A small privately-owned vessel."
	mappath = 'generic_shuttle.dmm'
	annihilate = TRUE

// The shuttle's area(s)
/area/shuttle/generic_shuttle/eng
	name = "\improper Private Vessel - Engineering"
	icon_state = "shuttle2"
	requires_power = 1

/area/shuttle/generic_shuttle/gen
	name = "\improper Private Vessel - General"
	icon_state = "shuttle2"
	requires_power = 1

// The shuttle's 'shuttle' computer
/obj/machinery/computer/shuttle_control/explore/generic_shuttle
	name = "short jump console"
	shuttle_tag = "Private Vessel"
	req_one_access = list(access_pilot)

// A shuttle lateloader landmark
/obj/effect/shuttle_landmark/shuttle_initializer/generic_shuttle
	name = "Origin - Private Vessel"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "omship_spawn_generic_shuttle"
	shuttle_type = /datum/shuttle/autodock/overmap/generic_shuttle

// The 'shuttle'
/datum/shuttle/autodock/overmap/generic_shuttle
	name = "Private Vessel"
	current_location = "omship_spawn_generic_shuttle"
	docking_controller_tag = "generic_shuttle_docker"
	shuttle_area = list(/area/shuttle/generic_shuttle/eng, /area/shuttle/generic_shuttle/gen)
	defer_initialisation = TRUE //We're not loaded until an admin does it

// The 'ship'
/obj/effect/overmap/visitable/ship/landable/generic_shuttle
	name = "Private Vessel"
	scanner_desc = @{"[i]Registration[/i]: PRIVATE
[i]Class[/i]: Small Shuttle
[i]Transponder[/i]: Transmitting (CIV), non-hostile
[b]Notice[/b]: Small private vessel"}
	vessel_mass = 1000
	vessel_size = SHIP_SIZE_TINY
	shuttle = "Private Vessel"