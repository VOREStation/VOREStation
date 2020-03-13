// Compile in the map for CI testing if we're testing compileability of all the maps
#if MAP_TEST
#include "scoutship.dmm"
#endif

// Map template for spawning the shuttle
/datum/map_template/om_ships/scoutship
	name = "OM Ship - Scout Ship (New Z)"
	desc = "HP's new brand of scout ships."
	mappath = 'scoutship.dmm'

// The shuttle's area(s)
/area/ship/scoutship
	name = "\improper HP Ship (Use a Subtype!)"
	icon_state = "shuttle2"
	requires_power = 1
	dynamic_lighting = 1

/area/ship/scoutship/engineering
	name = "\improper Scout Ship - Engineering"
/area/ship/scoutship/botany
	name = "\improper Scout Ship - Botany"
/area/ship/scoutship/cargo
	name = "\improper Scout Ship - Cargo Bay"
/area/ship/scoutship/hallway
	name = "\improper Scout Ship - Hallway"
/area/ship/scoutship/recreation
	name = "\improper Scout Ship - Recreation"
/area/ship/scoutship/bridge
	name = "\improper Scout Ship - Bridge"
/area/ship/scoutship/engines
	name = "\improper Scout Ship - Engines"
/area/ship/scoutship/sensors
	name = "\improper Scout Ship - Sensors"


// The 'ship'
/obj/effect/overmap/visitable/ship/scoutship
	name = "HP Orel"
	desc = "An experimental design of a reconnaissance vessel. Designed and manufactored by Hephaestus Industries."
	color = "#00baff" //Bluey
	vessel_mass = 8000
	vessel_size = SHIP_SIZE_SMALL
	initial_generic_waypoints = list("scoutship_fore", "scoutship_aft", "scoutship_port", "scoutship_starboard")
