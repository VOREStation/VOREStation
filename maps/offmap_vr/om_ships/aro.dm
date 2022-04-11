// Compile in the map for CI testing if we're testing compileability of all the maps
#if MAP_TEST
#include "aro.dmm"
#endif

// Map template for spawning the shuttle
/datum/map_template/om_ships/aro
	name = "OM Ship - Aronai (New Z)"
	desc = "It's Aronai! As a spaceship."
	mappath = 'aro.dmm'

// The shuttle's area(s)
/area/ship/aro
	name = "\improper Aro Ship (Use a Subtype!)"
	icon_state = "shuttle2"
	requires_power = 1

/area/ship/aro/engineering
	name = "\improper Aro Ship - Engineering"
/area/ship/aro/midshipshangars
	name = "\improper Aro Ship - Midships and Hangars"
/area/ship/aro/midshipshangars
	name = "\improper Aro Ship - Midships and Hangars"
/area/ship/aro/centralarea
	name = "\improper Aro Ship - Central Area"
/area/ship/aro/recreation
	name = "\improper Aro Ship - Recreation"
/area/ship/aro/bridge
	name = "\improper Aro Ship - Bridge"
/area/ship/aro/engines
	name = "\improper Aro Ship - Engines"
/area/ship/aro/holodeck
	name = "\improper Aro Ship - Holodeck"

/obj/machinery/computer/HolodeckControl/holodorm/aro
	name = "aro holodeck control"
	projection_area = /area/ship/aro/holodeck

// The ship's boat
/area/shuttle/aroboat
	name = "\improper Aro's Ship's Boat"
	icon_state = "shuttle"

// The 'ship'
/obj/effect/overmap/visitable/ship/aro
	name = "Aronai Sieyes"
	desc = "It's Aronai. Did you know he's actually a spaceship? Yeah it's weird."
	vessel_mass = 8000
	vessel_size = SHIP_SIZE_SMALL
	initial_generic_waypoints = list("aronai_fore", "aronai_aft", "aronai_port", "aronai_starboard")
	initial_restricted_waypoints = list("Aro's Ship's Boat" = list("omship_spawn_aroboat"))

	skybox_icon = 'aro2.dmi'
	skybox_icon_state = "skybox"
	skybox_pixel_x = 120
	skybox_pixel_y = 120

// The shuttle's 'shuttle' computer
/obj/machinery/computer/shuttle_control/explore/aroboat
	name = "boat control console"
	shuttle_tag = "Aro's Ship's Boat"
	req_one_access = list(access_cent_general)

// A shuttle lateloader landmark
/obj/effect/shuttle_landmark/shuttle_initializer/aroboat
	name = "Aronai's Boat Bay"
	base_area = /area/ship/aro/midshipshangars
	base_turf = /turf/simulated/floor/tiled/techfloor
	landmark_tag = "omship_spawn_aroboat"
	docking_controller = "aroship_boatbay"
	shuttle_type = /datum/shuttle/autodock/overmap/aroboat

// The 'shuttle'
/datum/shuttle/autodock/overmap/aroboat
	name = "Aro's Ship's Boat"
	current_location = "omship_spawn_aroboat"
	docking_controller_tag = "aroboat_docker"
	shuttle_area = /area/shuttle/aroboat
	fuel_consumption = 0
	defer_initialisation = TRUE
