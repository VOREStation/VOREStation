// Compile in the map for CI testing if we're testing compileability of all the maps
#ifdef MAP_TEST
#include "screebarge.dmm"
#endif

// Map template for spawning the shuttle
/datum/map_template/om_ships/screebarge
	name = "OM Ship - Battle Barge"
	desc = "The BATTLE BARGE."
	mappath = 'screebarge.dmm'
	annihilate = TRUE

// The shuttle's area(s)
/area/shuttle/screebarge
	icon_state = "shuttle2"
	requires_power = 1
/area/shuttle/screebarge/fore
	name = "\improper Battle Barge - Fore"
/area/shuttle/screebarge/mid
	name = "\improper Battle Barge - Mid"
/area/shuttle/screebarge/aft
	name = "\improper Battle Barge - Aft"

// The shuttle's 'shuttle' computer
/obj/machinery/computer/shuttle_control/explore/screebarge
	name = "short jump console"
	shuttle_tag = "XN-29 Prototype Shuttle"
	req_one_access = list(access_pilot)

// A shuttle lateloader landmark
/obj/effect/shuttle_landmark/shuttle_initializer/screebarge
	name = "Origin - Battle Barge"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "omship_spawn_battlebarge"
	shuttle_type = /datum/shuttle/autodock/overmap/screebarge

// The 'shuttle'
/datum/shuttle/autodock/overmap/screebarge
	name = "Battle Barge"
	current_location = "omship_spawn_battlebarge"
	docking_controller_tag = "battlebarge_docker"
	shuttle_area = list(/area/shuttle/screebarge/fore,/area/shuttle/screebarge/mid,/area/shuttle/screebarge/aft)
	fuel_consumption = 0
	defer_initialisation = TRUE //We're not loaded until an admin does it

// The 'ship'
/obj/effect/overmap/visitable/ship/landable/screebarge
	name = "Battle Barge"
	desc = "Some sort of makeshift battle barge. Appears to be armed."
	vessel_mass = 3000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Battle Barge"
