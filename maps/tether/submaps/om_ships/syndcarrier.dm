// Compile in the map for CI testing if we're testing compileability of all the maps
#if MAP_TEST
#include "syndcarrier.dmm"
#endif

// Map template for spawning the shuttle
/datum/map_template/om_ships/syndicatecarrier
	name = "OM Ship - Syndicate Carrier (New Z)"
	desc = "Syndicate Carrier."
	mappath = 'syndcarrier.dmm'

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



/area/shuttle/syndicateboat







// The 'ship'
/obj/effect/overmap/visitable/ship/syndicatecarrier
	name = "Unknown Vessel"
	desc = "An unknown vessel, clearly combatitive in design."
	color = "#f23000" //Red
	vessel_mass = 8000
	vessel_size = SHIP_SIZE_SMALL
	initial_generic_waypoints = list("aronai_fore", "aronai_aft", "aronai_port", "aronai_starboard")
	initial_restricted_waypoints = list("Aro's Ship's Boat" = list("omship_spawn_aroboat"))


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