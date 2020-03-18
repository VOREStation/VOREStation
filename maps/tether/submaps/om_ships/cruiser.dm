// Compile in the map for CI testing if we're testing compileability of all the maps
#if MAP_TEST
#include "cruiser.dmm"
#endif

/datum/map_template/om_ships/cruiser
	name = "OM Ship - NT Cruiser (New Z)"
	desc = "A large NT cruiser."
	mappath = 'cruiser.dmm'

/obj/effect/overmap/visitable/ship/cruiser
	name = "NT Cruiser"
	desc = "A large military cruiser pinging NT IFF."
	color = "#00aaff" //Bluey
	vessel_mass = 15000
	vessel_size = SHIP_SIZE_LARGE
	initial_generic_waypoints = list("cruiser_fore", "cruiser_aft", "cruiser_port", "cruiser_starboard", "ws_port_dock_1", "ws_port_dock_2", "ws_starboard_dock_1", "ws_starboard_dock_2")
