// Compile in the map for CI testing if we're testing compileability of all the maps
#if MAP_TEST
#include "mercship.dmm"
#endif


// Map template for spawning the shuttle
/datum/map_template/om_ships/ert_ship
	name = "OM Ship - ERT Ship (New Z)"
	desc = "NT Emergency Response Ship."
	mappath = 'ertship.dmm'

	// The ship's area(s)
/area/ship/ert
	name = "\improper ERT Ship (Use a Subtype!)"
	icon_state = "shuttle2"
	requires_power = 1
	dynamic_lighting = 1

/area/ship/ert/engineering
	name = "\improper NRV Von Braun - Engineering"
/area/ship/ert/engineeringcntrl
	name = "\improper NRV Von Braun - Engineering Power Room"
/area/ship/ert/bridge
	name = "\improper NRV Von Braun - Bridge"
/area/ship/ert/atmos
	name = "\improper NRV Von Braun - Atmospherics"
/area/ship/ert/engine
	name = "\improper NRV Von Braun - RIG & Mech Bay"
/area/ship/ert/engine1
	name = "\improper NRV Von Braun - Engine"
/area/ship/ert/armoury_en
	name = "\improper NRV Von Braun - Energy Armoury"
/area/ship/ert/armoury_bl
	name = "\improper NRV Von Braun - Ballistics Armoury"
/area/ship/ert/hangar
	name = "\improper NRV Von Braun - Hangar"
/area/ship/ert/barracks
	name = "\improper NRV Von Braun - Barracks"
/area/ship/ert/med
	name = "\improper NRV Von Braun - Medical"
/area/ship/ert/med1
	name = "\improper NRV Von Braun - Surgery"
/area/ship/ert/hall1
	name = "\improper NRV Von Braun - Corridor"
/area/ship/ert/hall2
	name = "\improper NRV Von Braun - Corridor"
/area/ship/ert/southairlock
	name = "\improper NRV Von Braun - Starboard Airlock"
/area/ship/ert/northairlock
	name = "\improper NRV Von Braun - Port Airlock"

// The 'shuttle' of the excursion shuttle
// /datum/shuttle/autodock/overmap/ert_ship
//	name = "Unknown Vessel"
//	warmup_time = 0
//	current_location = "tether_excursion_hangar"
//	docking_controller_tag = "expshuttle_docker"
//	shuttle_area = list(/area/ship/ert/engineering, /area/ship/ert/engineeringcntrl, /area/ship/ert/bridge, /area/ship/ert/atmos, /area/ship/ert/air, /area/ship/ert/engine, /area/ship/ert/engine1, /area/ship/ert/armoury, /area/ship/ert/hangar, /area/ship/ert/barracks, /area/ship/ert/fighter, /area/ship/ert/med, /area/ship/ert/med1, /area/ship/ert/hall1, /area/ship/ert/hall2)
//	fuel_consumption = 3

// The 'ship'
/obj/effect/overmap/visitable/ship/ert_ship
	name = "NRV Von Braun"
	desc = "Spacefaring vessel. Broadcasting Emergency Response IFF."
	scanner_desc = @{"[i]Registration[/i]: Nanotrasen Rapid Response Vessel [i]Von Braun[/i]
[i]Class[/i]: [i]Kepler[/i]-class Frigate
[i]Transponder[/i]: Broadcasting
[b]Notice[/b]: Impeding or interfering with emergency response vessels is a breach of numerous interstellar codes. Approach with caution."}
	color = "#9999ff" //Red
	vessel_mass = 8000
	vessel_size = SHIP_SIZE_LARGE
	initial_generic_waypoints = list("ert_ship_fore", "ert_ship_aft", "ert_ship_port", "ert_ship_starboard", "ert_ship_base_dock")
	initial_restricted_waypoints = list("NRB Von Braun's Bay" = list("omship_spawn_ert_lander"))


//The boat's area
/area/shuttle/ert_ship_boat
	name = "\improper Carrier's Ship's Boat"
	icon_state = "yellow"
	requires_power = 0

// The shuttle's 'shuttle' computer
/obj/machinery/computer/shuttle_control/explore/ert_ship_boat
	name = "boat control console"
	shuttle_tag = "NRB Robineau"

// A shuttle lateloader landmark
/obj/effect/shuttle_landmark/shuttle_initializer/ert_ship_boat
	name = "NRV Von Braun's Bay"
	base_area = /area/ship/ert/hangar
	base_turf = /turf/simulated/floor/plating
	landmark_tag = "omship_spawn_ert_lander"
	docking_controller = "ert_boarding_shuttle_dock"
	shuttle_type = /datum/shuttle/autodock/overmap/mercboat

// The 'shuttle'
/datum/shuttle/autodock/overmap/ert_ship_boat
	name = "NRB Robineau"
	current_location = "omship_spawn_ert_lander"
	docking_controller_tag = "ert_boarding_shuttle"
	shuttle_area = /area/shuttle/ert_ship_boat
	fuel_consumption = 0
	defer_initialisation = TRUE