// Compile in the map for CI testing if we're testing compileability of all the maps
#if MAP_TEST
#include "gecko_sh.dmm"
#endif

// Map template for spawning the shuttle
/datum/map_template/om_ships/gecko_stationhopper
	name = "OM Ship - Gecko Stationhopper (new Z)"
	desc = "A medium personnel transport shuttle."
	mappath = 'gecko_sh.dmm'
	annihilate = TRUE

// The shuttle's area(s)
/area/shuttle/gecko_sh	
	name = "\improper Gecko Stationhopper"
	icon_state = "shuttle"
	requires_power = 1
	has_gravity = 0

// The shuttle's 'shuttle' computer
/obj/machinery/computer/shuttle_control/explore/gecko_sh
	name = "short jump console"
	shuttle_tag = "Gecko Stationhopper"
	req_one_access = list()

// The 'shuttle'
/datum/shuttle/autodock/overmap/gecko_sh
	name = "Gecko Stationhopper"
	current_location = "omship_spawn_gecko_sh"
	docking_controller_tag = "geck_sh_docking"
	shuttle_area = list(/area/shuttle/gecko_sh)
	defer_initialisation = TRUE //We're not loaded until an admin does it
	fuel_consumption = 7.5

// A shuttle lateloader landmark
/obj/effect/shuttle_landmark/shuttle_initializer/gecko_sh
	name = "ITV Gecko I"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "omship_spawn_gecko_sh"
	shuttle_type = /datum/shuttle/autodock/overmap/gecko_sh

// The 'ship'
/obj/effect/overmap/visitable/ship/landable/gecko_sh
	scanner_name = "Gecko-class Transport"
	scanner_desc = @{"[i]Registration[/i]: ITV Sticky Fingers
[i]Class[/i]: Medium Shuttle
[i]Transponder[/i]: Transmitting (CIV), non-hostile
[b]Notice[/b]: Medium private vessel"}
	color = "#3366FF"
	vessel_mass = 6500
	vessel_size = SHIP_SIZE_LARGE
	shuttle = "Gecko Stationhopper"