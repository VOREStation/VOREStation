// Compile in the map for CI testing if we're testing compileability of all the maps
#if MAP_TEST
#include "syndcarrier.dmm"
#endif

// Map template for spawning the shuttle
/datum/map_template/om_ships/syndicatecarrier
	name = "OM Ship - Syndicate Carrier (New Z)"
	desc = "Syndicate Carrier."
	mappath = 'syndcarrier.dmm'

//The mercenary base's areas
/area/mercbase/
	name = "\improper Asteroid Base"
	lightswitch = 1
	icon_state = "red"

/area/mercbase/roid
	name = "\improper Asteroid Base Exterior"
/area/mercbase/hall
	name = "\improper Asteroid Base Hallway"
/area/mercbase/eqroom
	name = "\improper Asteroid Base Equipment Room"
/area/mercbase/barracks
	name = "\improper Asteroid Base Barracks"
/area/mercbase/solar
	name = "\improper Asteroid Base Solar Control"
/area/mercbase/medical
	name = "\improper Asteroid Base Medical"
/area/mercbase/medicalOR
	name = "\improper Asteroid Base Medical - Operating Room"
/area/mercbase/medicalstorage
	name = "\improper Asteroid Base Medical Storage"
/area/mercbase/airlock1
	name = "\improper Asteroid Base Airlock"
/area/mercbase/airlock
	name = "\improper Asteroid Base Airlock"
/area/mercbase/atmos
	name = "\improper Asteroid Base Atmospherics"
/area/mercbase/command
	name = "\improper Asteroid Base Command Center"
/area/mercbase/panels
	name = "\improper Asteroid Base Solar Panels"
/area/mercbase/power
	name = "\improper Asteroid Base SMES Room"
/area/mercbase/engineering
	name = "\improper Asteroid Base Engineering"
/area/mercbase/fuel
	name = "\improper Asteroid Base Fuel Storage"
/area/mercbase/dock
	name = "\improper Asteroid Base Boat Dock"
/area/mercbase/cafeteria
	name = "\improper Asteroid Base Boat Cafeteria"







// The ship's area(s)
/area/ship/mercenary
	name = "\improper Syndc Ship (Use a Subtype!)"
	icon_state = "shuttle2"
	requires_power = 1
	dynamic_lighting = 1


/area/ship/mercenary/engineering
	name = "\improper Mercenary Ship - Engineering"
/area/ship/mercenary/engineeringcntrl
	name = "\improper Mercenary Ship - Engineering Power Room"
/area/ship/mercenary/bridge
	name = "\improper Mercenary Ship - Cockpit"
/area/ship/mercenary/atmos
	name = "\improper Mercenary Ship - Atmospherics"
/area/ship/mercenary/air
	name = "\improper Mercenary Ship - Airlock"
/area/ship/mercenary/engine
	name = "\improper Mercenary Ship - Engine"
/area/ship/mercenary/engine1
	name = "\improper Mercenary Ship - Engine"
/area/ship/mercenary/armoury
	name = "\improper Mercenary Ship - Armoury"
/area/ship/mercenary/hangar
	name = "\improper Mercenary Ship - Hangar"
/area/ship/mercenary/canopy
	name = "\improper Mercenary Ship - Canopy"
/area/ship/mercenary/barracks
	name = "\improper Mercenary Ship - Barracks"
/area/ship/mercenary/fighter
	name = "\improper Mercenary Ship - Fighter Maintenance"
/area/ship/mercenary/med
	name = "\improper Mercenary Ship - Medical"
/area/ship/mercenary/med1
	name = "\improper Mercenary Ship - Medical"
/area/ship/mercenary/hall1
	name = "\improper Mercenary Ship - Corridor"
/area/ship/mercenary/hall2
	name = "\improper Mercenary Ship - Corridor"
/area/ship/mercenary/rim
	name = "\improper Mercenary Ship - Rim"


// The 'ship'
/obj/effect/overmap/visitable/ship/syndicatecarrier
	name = "Unknown Vessel"
	desc = "An unknown vessel, of unknown design."
	color = "#f23000" //Red
	vessel_mass = 8000
	vessel_size = SHIP_SIZE_SMALL
	initial_generic_waypoints = list("carrier_fore", "carrier_aft", "carrier_port", "carrier_starboard", "base_dock")
	initial_restricted_waypoints = list("Carrier's Ship's Boat" = list("omship_spawn_syndboat"))


// The ship's 'shuttle' computer
// /obj/machinery/computer/shuttle_control/explore/merc_ship
//	name = "short jump console"
//	shuttle_tag = "Unknown Vessel"
//	req_one_access = list(access_syndicate)
// ask Ascian/Aro later for how to make this shit work

//The boat's area
/area/shuttle/mercboat
	name = "\improper Carrier's Ship's Boat"
	icon_state = "shuttle2"
	requires_power = 0


// The shuttle's 'shuttle' computer
/obj/machinery/computer/shuttle_control/explore/mercboat
	name = "boat control console"
	shuttle_tag = "Carrier's Ship's Boat"

// A shuttle lateloader landmark
/obj/effect/shuttle_landmark/shuttle_initializer/mercboat
	name = "Carrier's Boat Bay"
	base_area = /area/ship/mercenary/hangar
	base_turf = /turf/simulated/floor/plating
	landmark_tag = "omship_spawn_mercboat"
	docking_controller = "merc_boatbay"
	shuttle_type = /datum/shuttle/autodock/overmap/mercboat

// The 'shuttle'
/datum/shuttle/autodock/overmap/mercboat
	name = "Carrier's Ship's Boat"
	current_location = "omship_spawn_mercboat"
	docking_controller_tag = "mercboat_docker"
	shuttle_area = /area/shuttle/mercboat
	fuel_consumption = 0
//	defer_initialisation = TRUE