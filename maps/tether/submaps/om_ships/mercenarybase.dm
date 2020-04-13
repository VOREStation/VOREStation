// Compile in the map for CI testing if we're testing compileability of all the maps
#if MAP_TEST
#include "mercenarybase.dmm"
#endif


// Map template for spawning the shuttle
/datum/map_template/om_ships/syndicatecarrier
	name = "OM Ship - Mercenary Ship (New Z)"
	desc = "Mercenary Ship."
	mappath = 'mercenarybase.dmm'



//The mercenary base's areas
/area/mercbase/
	name = "\improper Asteroid Base"
	lightswitch = 1
	icon_state = "red"

/area/mercbase/roid
	name = "\improper Mercenary Base Exterior"
/area/mercbase/hall
	name = "\improper Mercenary Base Hallway"
/area/mercbase/eqroom
	name = "\improper Mercenary Base Equipment Room"
/area/mercbase/barracks
	name = "\improper Mercenary Base Barracks"
/area/mercbase/solar
	name = "\improper Mercenary Base Solar Control"
/area/mercbase/medical
	name = "\improper Mercenary Base Medical"
/area/mercbase/medicalOR
	name = "\improper Mercenary Base Medical - Operating Room"
/area/mercbase/medicalstorage
	name = "\improper Mercenary Base Medical Storage"
/area/mercbase/airlock1
	name = "\improper Mercenary Base Airlock"
/area/mercbase/airlock
	name = "\improper Mercenary Base Airlock"
/area/mercbase/atmos
	name = "\improper Mercenary Base Atmospherics"
/area/mercbase/command
	name = "\improper Mercenary Base Command Center"
/area/mercbase/panels
	name = "\improper Mercenary Base Solar Panels"
/area/mercbase/power
	name = "\improper Mercenary Base SMES Room"
/area/mercbase/engineering
	name = "\improper Mercenary Base Engineering"
/area/mercbase/fuel
	name = "\improper Mercenary Base Fuel Storage"
/area/mercbase/dock
	name = "\improper Mercenary Base Boat Dock"
/area/mercbase/cafeteria
	name = "\improper Mercenary Base Boat Cafeteria"




// The ship's area(s)
/area/ship/mercenary
	name = "\improper Mercenary Ship (Use a Subtype!)"
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
	name = "\improper Mercenary Ship - Engineering Systems"
/area/ship/mercenary/engine
	name = "\improper Mercenary Ship - Engine"
/area/ship/mercenary/engine1
	name = "\improper Mercenary Ship - Engine"
/area/ship/mercenary/armoury
	name = "\improper Mercenary Ship - Armoury"
/area/ship/mercenary/hangar
	name = "\improper Mercenary Ship - Hangar"
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

// The 'shuttle' of the excursion shuttle
// /datum/shuttle/autodock/overmap/mercenaryship
//	name = "Unknown Vessel"
//	warmup_time = 0
//	current_location = "tether_excursion_hangar"
//	docking_controller_tag = "expshuttle_docker"
//	shuttle_area = list(/area/ship/mercenary/engineering, /area/ship/mercenary/engineeringcntrl, /area/ship/mercenary/bridge, /area/ship/mercenary/atmos, /area/ship/mercenary/air, /area/ship/mercenary/engine, /area/ship/mercenary/engine1, /area/ship/mercenary/armoury, /area/ship/mercenary/hangar, /area/ship/mercenary/barracks, /area/ship/mercenary/fighter, /area/ship/mercenary/med, /area/ship/mercenary/med1, /area/ship/mercenary/hall1, /area/ship/mercenary/hall2)
//	fuel_consumption = 3

// The 'ship'
/obj/effect/overmap/visitable/ship/mercship
	name = "Unknown Vessel"
	desc = "An unknown vessel, of unknown design."
	color = "#f23000" //Red
	vessel_mass = 8000
	vessel_size = SHIP_SIZE_SMALL
	initial_generic_waypoints = list("carrier_fore", "carrier_aft", "carrier_port", "carrier_starboard", "base_dock")
	initial_restricted_waypoints = list("Carrier's Ship's Boat" = list("omship_spawn_mercboat"))

// The ship's 'shuttle' computer
 /obj/machinery/computer/shuttle_control/explore/merc_ship
	name = "short jump console"
//	shuttle_tag = "Unknown Vessel"
	req_one_access = list(access_syndicate)
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
	defer_initialisation = TRUE