// Compile in the map for CI testing if we're testing compileability of all the maps
#if MAP_TEST
#include "cruiser.dmm"
#endif

//////// Mothership areas ////////
/area/mothership
	requires_power = 1
	flags = RAD_SHIELDED
	base_turf = /turf/space
	icon_state = "blue-red2"

/area/mothership/breakroom
	name = "Warship - Breakroom"

/area/mothership/hydroponics
	name = "Warship - Hydroponics"

/area/mothership/kitchen
	name = "Warship - Kitchen"

/area/mothership/eva
	name = "Warship - EVA"

/area/mothership/bathroom1
	name = "Warship - Bathroom 1"

/area/mothership/bathroom2
	name = "Warship - Bathroom 2"

/area/mothership/dorm1
	name = "Warship - Dorm 1"

/area/mothership/dorm2
	name = "Warship - Dorm 2"

/area/mothership/dorm3
	name = "Warship - Dorm 3"

/area/mothership/dorm4
	name = "Warship - Dorm 4"

/area/mothership/dorm5
	name = "Warship - Dorm 5"

/area/mothership/dorm6
	name = "Warship - Dorm 6"

/area/mothership/chemistry
	name = "Warship - Chemistry"

/area/mothership/surgery
	name = "Warship - Surgery"

/area/mothership/vault
	name = "Warship - Vault"
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/mothership/teleporter
	name = "Warship - Teleporter Room"

/area/mothership/security
	name = "Warship - Security Equipment"

/area/mothership/treatment
	name = "Warship - Treatment Center"

/area/mothership/medical
	name = "Warship - Medical Equipment"

/area/mothership/resleeving
	name = "Warship - Resleeving"

/area/mothership/morgue
	name = "Warship - Morgue"

/area/mothership/rnd
	name = "Warship - Research"

/area/mothership/robotics
	name = "Warship - Robotics"

/area/mothership/sechallway
	name = "Warship - Security Hallway"

/area/mothership/processing
	name = "Warship - Processing"

/area/mothership/warden
	name = "Warship - Warden"

/area/mothership/armory
	name = "Warship - Armory"
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/mothership/bridge
	name = "Warship - Bridge"

/area/mothership/holodeck
	name = "Warship - Holodeck Controls"
/area/mothership/holodeck/holo
	name = "Warship - Holodeck"
	icon_state = "dk_yellow"

/area/mothership/cryotube
	name = "Warship - Cryo chamber"

/area/mothership/engineering
	name = "Warship - Engineering"

/area/mothership/hallway
	name = "Warship - Main Hallway"

/area/mothership/telecomms1
	name = "Warship - Telecommunications Main"

/area/mothership/telecomms2
	name = "Warship - Telecommunications Relay"

/datum/map_template/om_ships/cruiser
	name = "OM Ship - NDV Tabiranth (New Z)"
	desc = "A large NT cruiser."
	mappath = 'cruiser.dmm'

/obj/effect/overmap/visitable/ship/cruiser
	name = "NDV Tabiranth"
	desc = "A large military cruiser pinging NT IFF. An automated message warns unauthorized vessels from getting close."
	color = "#00aaff" //Bluey
	vessel_mass = 15000
	vessel_size = SHIP_SIZE_LARGE
	initial_generic_waypoints = list("cruiser_fore", "cruiser_aft", "cruiser_port", "cruiser_starboard", "ws_port_dock_1", "ws_port_dock_2", "ws_starboard_dock_1", "ws_starboard_dock_2")
