// Compile in the map for CI testing if we're testing compileability of all the maps
#if MAP_TEST
#include "curashuttle.dmm"
#endif

// Map template for spawning the shuttle
/datum/map_template/om_ships/curabiturmedical
	name = "OM Ship - Curabitur Rescue Shuttle (new Z)"
	desc = "A small corporate rescue shuttle."
	mappath = 'curashuttle.dmm'
	annihilate = TRUE

// The shuttle's area(s)
/area/shuttle/curabitur/curashuttle/eng
	name = "\improper Curabitur Rescue - Engineering"
	icon_state = "shuttle2"
	requires_power = 1

/area/shuttle/curabitur/curashuttle/med
	name = "\improper Curabitur Rescue - Medbay"
	icon_state = "shuttle2"
	requires_power = 1

/area/shuttle/curabitur/curashuttle/hangar
	name = "\improper Curabitur Rescue - Hangar"
	icon_state = "shuttle2"
	requires_power = 1

/area/shuttle/curabitur/curashuttle/cockpit
	name = "\improper Curabitur Rescue - Cockpit"
	icon_state = "shuttle2"
	requires_power = 1

// The shuttle's 'shuttle' computer
/obj/machinery/computer/shuttle_control/explore/curashuttle
	name = "short jump console"
	shuttle_tag = "Cura"
	req_one_access = list()

// The 'shuttle'
/datum/shuttle/autodock/overmap/curashuttle
	name = "Cura"
	current_location = "omship_spawn_curashuttle"
	docking_controller_tag = "curadocking"
	shuttle_area = list(/area/shuttle/curabitur/curashuttle/eng, /area/shuttle/curabitur/curashuttle/med, /area/shuttle/curabitur/curashuttle/hangar, /area/shuttle/curabitur/curashuttle/cockpit)
	defer_initialisation = TRUE //We're not loaded until an admin does it
	fuel_consumption = 3

// A shuttle lateloader landmark
/obj/effect/shuttle_landmark/shuttle_initializer/curashuttle
	name = "CRV Rescue"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "omship_spawn_curashuttle"
	shuttle_type = /datum/shuttle/autodock/overmap/curashuttle

// The 'ship'
/obj/effect/overmap/visitable/ship/landable/curashuttle
	name = "CRV Doom Delay"
	scanner_desc = @{"[i]Registration[/i]: Curabitur Scimed
[i]Class[/i]: Small Shuttle
[i]Transponder[/i]: Transmitting (CIV), non-hostile
[b]Notice[/b]: Small private vessel"}
	vessel_mass = 2000
	vessel_size = SHIP_SIZE_TINY
	shuttle = "Cura"