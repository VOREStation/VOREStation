// Compile in the map for CI testing if we're testing compileability of all the maps
#if MAP_TEST
#include "syndcarrier.dmm"
#endif

// Map template for spawning the shuttle
/datum/map_template/om_ships/syndicatecarrier
	name = "OM Ship - Syndicate Carrier (New Z)"
	desc = "Syndicate Carrier."
	mappath = 'syndcarrier.dmm'

//The syndicate base's areas
/area/syndbase/
	name = "\improper Asteroid Base"
	lightswitch = 0
	icon_state = "red"
/area/syndbase/roid
	name = "\improper Asteroid Base Exterior"
/area/syndbase/hall
	name = "\improper Asteroid Base Hallway"
/area/syndbase/eqroom
	name = "\improper Asteroid Base Equipment Room"
/area/syndbase/barracks
	name = "\improper Asteroid Base Barracks"
/area/syndbase/solar
	name = "\improper Asteroid Base Solar Control"
/area/syndbase/medical
	name = "\improper Asteroid Base Medical"
/area/syndbase/medicalOR
	name = "\improper Asteroid Base Medical - Operating Room"
/area/syndbase/medicalstorage
	name = "\improper Asteroid Base Medical Storage"
/area/syndbase/airlock1
	name = "\improper Asteroid Base Airlock"
/area/syndbase/airlock
	name = "\improper Asteroid Base Airlock"
/area/syndbase/atmos
	name = "\improper Asteroid Base Atmospherics"
/area/syndbase/command
	name = "\improper Asteroid Base Command Center"
/area/syndbase/panels
	name = "\improper Asteroid Base Solar Panels"
/area/syndbase/power
	name = "\improper Asteroid Base SMES Room"
/area/syndbase/engineering
	name = "\improper Asteroid Base Engineering"
/area/syndbase/fuel
	name = "\improper Asteroid Base Fuel Storage"



















// The shuttle's area(s)
/area/ship/syndicate
	name = "\improper Syndc Ship (Use a Subtype!)"
	icon_state = "shuttle2"
	requires_power = 1

/area/ship/syndicate/engineering
	name = "\improper Syndie Ship - Engineering"
/area/ship/syndicate/engineeringcntrl
	name = "\improper Syndie Ship - Engineering Power Room"
/area/ship/syndicate/bridge
	name = "\improper Syndie Ship - Cockpit"
/area/ship/syndicate/atmos
	name = "\improper Syndie Ship - Atmospherics"
/area/ship/syndicate/air
	name = "\improper Syndie Ship - Airlock"
/area/ship/syndicate/engine
	name = "\improper Syndie Ship - Engine"
/area/ship/syndicate/engine1
	name = "\improper Syndie Ship - Engine"
/area/ship/syndicate/armoury
	name = "\improper Syndie Ship - Armoury"
/area/ship/syndicate/hangar
	name = "\improper Syndie Ship - Hangar"
/area/ship/syndicate/canopy
	name = "\improper Syndie Ship - Canopy"
/area/ship/syndicate/barracks
	name = "\improper Syndie Ship - Barracks"
/area/ship/syndicate/fighter
	name = "\improper Syndie Ship - Fighter Maintenance"
/area/ship/syndicate/med
	name = "\improper Syndie Ship - Medical"
/area/ship/syndicate/med1
	name = "\improper Syndie Ship - Medical"
/area/ship/syndicate/hall1
	name = "\improper Syndie Ship - Corridor"
/area/ship/syndicate/hall2
	name = "\improper Syndie Ship - Corridor"
/area/ship/syndicate/rim
	name = "\improper Syndie Ship - Rim"



/area/shuttle/syndicateboat







// The 'ship'
/obj/effect/overmap/visitable/ship/syndicatecarrier
	name = "Unknown Vessel"
	desc = "An unknown vessel, of unknown design."
	color = "#f23000" //Red
	vessel_mass = 8000
	vessel_size = SHIP_SIZE_SMALL
	initial_generic_waypoints = list("carrier_fore", "carrier_aft", "carrier_port", "carrier_starboard")
	initial_restricted_waypoints = list("Carrier's Ship's Boat" = list("omship_spawn_syndboat"))


// The shuttle's 'shuttle' computer
/obj/machinery/computer/shuttle_control/explore/syndicateboat
	name = "boat control console"
	shuttle_tag = "Carrier's Ship's Boat"

// A shuttle lateloader landmark
/obj/effect/shuttle_landmark/shuttle_initializer/syndicateboat
	name = "Carrier's Boat Bay"
	base_area = /area/ship/syndicate/hangar
	base_turf = /turf/simulated/floor/tiled/techfloor
	landmark_tag = "omship_spawn_syndicateboat"
	docking_controller = "syndicate_boatbay"
	shuttle_type = /datum/shuttle/autodock/overmap/syndicateboat

// The 'shuttle'
/datum/shuttle/autodock/overmap/syndicateboat
	name = "Carrier's Ship's Boat"
	current_location = "omship_spawn_syndicateboat"
	docking_controller_tag = "syndicateboat_docker"
	shuttle_area = /area/shuttle/syndicateboat
	fuel_consumption = 0
	defer_initialisation = TRUE