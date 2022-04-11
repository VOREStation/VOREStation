// Compile in the map for CI testing if we're testing compileability of all the maps
#if MAP_TEST
#include "hybridshuttle.dmm"
#endif

// Map template for spawning the shuttle
/datum/map_template/om_ships/hybrid
	name = "OM Ship - Hybrid Shuttle"
	desc = "A prototype human/alien tech hybrid shuttle."
	mappath = 'hybridshuttle.dmm'
	annihilate = TRUE

// The shuttle's area(s)
/area/shuttle/blue_fo
	name = "\improper Hybrid Shuttle"
	icon_state = "shuttle2"
	requires_power = 1

// The shuttle's 'shuttle' computer
/obj/machinery/computer/shuttle_control/explore/hybridshuttle
	name = "short jump console"
	shuttle_tag = "XN-29 Prototype Shuttle"
	req_one_access = list(access_pilot)

// A shuttle lateloader landmark
/obj/effect/shuttle_landmark/shuttle_initializer/hybridshuttle
	name = "Origin - Hybrid Shuttle"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "omship_spawn_hybridshuttle"
	shuttle_type = /datum/shuttle/autodock/overmap/hybridshuttle

// The 'shuttle'
/datum/shuttle/autodock/overmap/hybridshuttle
	name = "XN-29 Prototype Shuttle"
	current_location = "omship_spawn_hybridshuttle"
	docking_controller_tag = "hybrid_shuttle_docker"
	shuttle_area = /area/shuttle/blue_fo
	fuel_consumption = 0
	defer_initialisation = TRUE //We're not loaded until an admin does it

// The 'ship'
/obj/effect/overmap/visitable/ship/landable/hybridshuttle
	name = "XN-29 Prototype Shuttle"
	icon_state = "unkn_o"
	scanner_desc = @{"[i]Registration[/i]: UNKNOWN
[i]Class[/i]: Shuttle
[i]Transponder[/i]: Transmitting (MIL), NanoTrasen
[b]Notice[/b]: Experimental vessel"}
	vessel_mass = 3000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "XN-29 Prototype Shuttle"