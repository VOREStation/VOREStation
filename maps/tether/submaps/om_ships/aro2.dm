// Compile in the map for CI testing if we're testing compileability of all the maps
#if MAP_TEST
#include "aro2.dmm"
#endif

// Map template for spawning the shuttle
/datum/map_template/om_ships/aro2
	name = "OM Ship - Aronai 2.0 (New Z)"
	desc = "It's Aronai! As a spaceship."
	mappath = 'aro2.dmm'

/area/aro2
	requires_power = 1

/area/aro2/bighallway
	name = "Aronai - Central Hallway"
/area/aro2/powerroom
	name = "Aronai - Power Room"
/area/aro2/atmosroom
	name = "Aronai - Atmos Room"
/area/aro2/boatbay
	name = "Aronai - Boat Bay"
/area/aro2/couchroom
	name = "Aronai - Relax Room"
/area/aro2/resleeving
	name = "Aronai - Fox Printer"
/area/aro2/room0
	name = "Aronai - Aro's Bedroom"
/area/aro2/room1
	name = "Aronai - Bedroom One"
/area/aro2/room2
	name = "Aronai - Bedroom Two"
/area/aro2/room3
	name = "Aronai - Bedroom Three"
/area/aro2/cockpit
	name = "Aronai - Cockpit"
/area/aro2/cafe
	name = "Aronai - Cafe"
/area/aro2/storage
	name = "Aronai - Storage"
/area/aro2/holodeckroom
	name = "Aronai - Holodeck Room"
/area/aro2/holodeck
	name = "Aronai - Holodeck"

/area/shuttle/aroboat2
	name = "Aronai - Ship's Boat"
	requires_power = 1
	dynamic_lighting = 1

/obj/machinery/computer/HolodeckControl/holodorm/aro2
	name = "aro holodeck control"
	projection_area = /area/aro2/holodeck

// The 'ship'
/obj/effect/overmap/visitable/ship/aro2
	name = "Aronai Sieyes"
	desc = "It's Aronai. Did you know he's actually a spaceship? Yeah it's weird."
	color = "#00aaff" //Bluey
	vessel_mass = 8000
	vessel_size = SHIP_SIZE_SMALL
	initial_generic_waypoints = list("aronai2_fore", "aronai2_aft", "aronai2_port", "aronai2_starboard", "aronai2_alongside")
	initial_restricted_waypoints = list("Aro's Boat" = list("omship_spawn_aroboat2"))
	fore_dir = EAST

/obj/effect/overmap/visitable/ship/aro2/get_skybox_representation()
	var/image/I = image('aro2.dmi', "skybox")
	I.pixel_x = 80
	I.pixel_y = 100
	return I

// The shuttle's 'shuttle' computer
/obj/machinery/computer/shuttle_control/explore/aroboat2
	name = "boat control console"
	shuttle_tag = "Aro's Boat"
	req_one_access = list(access_cent_general)

// A shuttle lateloader landmark
/obj/effect/shuttle_landmark/shuttle_initializer/aroboat2
	name = "Aronai's Boat Bay"
	base_area = /area/aro2/boatbay
	base_turf = /turf/simulated/floor/reinforced
	landmark_tag = "omship_spawn_aroboat2"
	docking_controller = "aroship2_boatbay"
	shuttle_type = /datum/shuttle/autodock/overmap/aroboat2

// The 'shuttle'
/datum/shuttle/autodock/overmap/aroboat2
	name = "Aro's Boat"
	current_location = "omship_spawn_aroboat2"
	docking_controller_tag = "aroboat2_docker"
	shuttle_area = /area/shuttle/aroboat2
	fuel_consumption = 0
	defer_initialisation = TRUE