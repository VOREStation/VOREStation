// Compile in the map for CI testing if we're testing compileability of all the maps
#if MAP_TEST
#include "shelter_6.dmm"
#endif

// Map template for spawning the shuttle
/datum/map_template/om_ships/tabiranth
	name = "OM Ship - Tabiranth"
	desc = "A prototype deployable assault shuttle."
	mappath = 'shelter_6.dmm'
	annihilate = TRUE

// The shuttle's area(s)
/area/shuttle/tabiranth
	name = "\improper Tabiranth"
	icon_state = "blue-red2"
	flags = RAD_SHIELDED | BLUE_SHIELDED
	requires_power = 1

// The shuttle's 'shuttle' computer
/obj/machinery/computer/shuttle_control/explore/tabiranth
	name = "short jump console"
	shuttle_tag = "NDV Tabiranth"
	req_one_access = list(access_cent_general)

// A shuttle lateloader landmark
/obj/effect/shuttle_landmark/shuttle_initializer/tabiranth
	name = "Origin - Tabiranth"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "omship_spawn_tabiranth"
	shuttle_type = /datum/shuttle/autodock/overmap/tabiranth

// The 'shuttle'
/datum/shuttle/autodock/overmap/tabiranth
	name = "NDV Tabiranth"
	current_location = "omship_spawn_tabiranth"
	docking_controller_tag = "tabiranth_docker"
	shuttle_area = /area/shuttle/tabiranth
	fuel_consumption = 0
	defer_initialisation = TRUE //We're not loaded until an admin does it

// The 'ship'
/obj/effect/overmap/visitable/ship/landable/tabiranth
	name = "Experimental Dropship"
	scanner_desc = @{"[i]Registration[/i]: UNKNOWN
[i]Class[/i]: Assault Dropship
[i]Transponder[/i]: Transmitting (MIL), NanoTrasen
[b]Notice[/b]: Experimental vessel"}
	vessel_mass = 3000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "NDV Tabiranth"
