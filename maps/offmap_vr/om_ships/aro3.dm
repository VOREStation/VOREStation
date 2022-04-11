// Compile in the map for CI testing if we're testing compileability of all the maps
#if MAP_TEST
#include "aro3.dmm"
#endif

// Map template for spawning the shuttle
/datum/map_template/om_ships/aro3
	name = "OM Ship - Aronai 3.0 (New Z)"
	desc = "It's Aronai! As a spaceship."
	mappath = 'aro3.dmm'

/area/aro3
	requires_power = 1

/area/aro3/cockpit
	name = "Aronai - Cockpit"
/area/aro3/kitchen
	name = "Aronai - Kitchen"
/area/aro3/eva_hall
	name = "Aronai - EVA Hall"
/area/aro3/function
	name = "Aronai - Function Room"
/area/aro3/hallway_port
	name = "Aronai - Port Hallway"
/area/aro3/hallway_starboard
	name = "Aronai - Starboard Hallway"
/area/aro3/park
	name = "Aronai - Park"
/area/aro3/wc_port
	name = "Aronai - Port Public WC"
/area/aro3/wc_starboard
	name = "Aronai - Starboard Public WC"
/area/aro3/suite_port
	name = "Aronai - Port Suite (Room)"
/area/aro3/suite_starboard
	name = "Aronai - Starboard Suite (Room)"
/area/aro3/suite_port_wc
	name = "Aronai - Port Suite (WC)"
/area/aro3/suite_starboard_wc
	name = "Aronai - Starboard Suite (WC)"
/area/aro3/surfluid
	name = "Aronai - Surfluid Access"
/area/aro3/bunkrooms
	name = "Aronai - Bunkrooms"
/area/aro3/hallway_bunkrooms
	name = "Aronai - Bunkroom Access"
/area/aro3/bar
	name = "Aronai - Bar"
/area/aro3/medical
	name = "Aronai - Medical"
/area/aro3/workshop
	name = "Aronai - Workshop"
/area/aro3/repair_bay
	name = "Aronai - Repair Bay"
/area/aro3/flight_deck
	name = "Aronai - Flight Deck"
/area/aro3/atmos
	name = "Aronai - Atmospherics"
/area/aro3/power
	name = "Aronai - Power Supply"
/area/aro3/engines
	name = "Aronai - Engines"
	dynamic_lighting = FALSE

/area/shuttle/aroboat3
	name = "Aronai - Ship's Boat"
	requires_power = 1
	dynamic_lighting = 1
	base_turf = /turf/simulated/floor/reinforced

/turf/simulated/floor/water/indoors/surfluid
	name = "surfluid pool"
	desc = "A pool of inky-black fluid that shimmers oddly in the light if hit just right."
	description_info = "Surfluid is KHI's main method of production, using swarms of nanites to process raw materials into finished products at the cost of immense amounts of energy."
	color = "#222222"
	outdoors = OUTDOORS_NO
	reagent_type = "liquid_protean"

// The 'ship'
/obj/effect/overmap/visitable/ship/aro3
	name = "Aronai Sieyes"
	desc = "Spacefaring vessel. Friendly IFF detected."
	icon_state = "moe_cruiser_g"
	scanner_desc = @{"[i]Registration[/i]: Aronai Sieyes
[i]Class[/i]: Small Frigate (Low Displacement)
[i]Transponder[/i]: Transmitting (CIV), non-hostile
[b]Notice[/b]: Automated vessel"}
	color = "#00aaff" //Bluey
	vessel_mass = 8000
	vessel_size = SHIP_SIZE_SMALL
	initial_generic_waypoints = list("aronai3_foreport", "aronai3_forestbd", "aronai3_aftport", "aronai3_aftstbd")
	initial_restricted_waypoints = list("Aro's Boat" = list("omship_spawn_aroboat3"))
	fore_dir = NORTH
	known = FALSE

	skybox_icon = 'aro3.dmi'
	skybox_icon_state = "skybox"
	skybox_pixel_x = 130
	skybox_pixel_y = 120


// The shuttle's 'shuttle' computer
/obj/machinery/computer/shuttle_control/explore/aroboat3
	name = "boat control console"
	shuttle_tag = "Aro's Boat"
	req_one_access = list(access_cent_general)

// A shuttle lateloader landmark
/obj/effect/shuttle_landmark/shuttle_initializer/aroboat3
	name = "Aronai's Boat Bay"
	base_area = /area/aro3/flight_deck
	base_turf = /turf/simulated/floor/reinforced
	landmark_tag = "omship_spawn_aroboat3"
	docking_controller = "aroship3_boatbay"
	shuttle_type = /datum/shuttle/autodock/overmap/aroboat3

// The 'shuttle'
/datum/shuttle/autodock/overmap/aroboat3
	name = "Aro's Boat"
	current_location = "omship_spawn_aroboat3"
	docking_controller_tag = "aroboat3_docker"
	shuttle_area = /area/shuttle/aroboat3
	fuel_consumption = 0
	defer_initialisation = TRUE
	range = 1
