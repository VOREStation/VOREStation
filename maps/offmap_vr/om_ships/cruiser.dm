// Compile in the map for CI testing if we're testing compileability of all the maps
#if MAP_TEST
#include "cruiser.dmm"
#endif

//////// Mothership areas ////////
/area/mothership
	requires_power = 1
	flags = RAD_SHIELDED
	base_turf = /turf/space
	icon_state = "blue2"

/area/mothership/breakroom
	name = "Daedalus - Breakroom"

/area/mothership/hydroponics
	name = "Daedalus - Hydroponics"

/area/mothership/kitchen
	name = "Daedalus - Kitchen"

/area/mothership/eva
	name = "Daedalus - EVA"

/area/mothership/bathroom1
	name = "Daedalus - Bathroom 1"

/area/mothership/bathroom2
	name = "Daedalus - Bathroom 2"

/area/mothership/dorm1
	name = "Daedalus - Dorm 1"

/area/mothership/dorm2
	name = "Daedalus - Dorm 2"

/area/mothership/dorm3
	name = "Daedalus - Dorm 3"

/area/mothership/dorm4
	name = "Daedalus - Dorm 4"

/area/mothership/dorm5
	name = "Daedalus - Dorm 5"

/area/mothership/dorm6
	name = "Daedalus - Dorm 6"

/area/mothership/chemistry
	name = "Daedalus - Chemistry"

/area/mothership/surgery
	name = "Daedalus - Surgery"

/area/mothership/vault
	name = "Daedalus - Vault"
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/mothership/teleporter
	name = "Daedalus - Teleporter Room"

/area/mothership/security
	name = "Daedalus - Security Equipment"

/area/mothership/treatment
	name = "Daedalus - Treatment Center"

/area/mothership/medical
	name = "Daedalus - Medical Equipment"

/area/mothership/resleeving
	name = "Daedalus - Resleeving"

/area/mothership/morgue
	name = "Daedalus - Morgue"

/area/mothership/rnd
	name = "Daedalus - Research"

/area/mothership/robotics
	name = "Daedalus - Robotics"

/area/mothership/sechallway
	name = "Daedalus - Security Hallway"

/area/mothership/processing
	name = "Daedalus - Processing"

/area/mothership/warden
	name = "Daedalus - Warden"

/area/mothership/armory
	name = "Daedalus - Armory"
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/mothership/bridge
	name = "Daedalus - Bridge"

/area/mothership/holodeck
	name = "Daedalus - Holodeck Controls"
/area/mothership/holodeck/holo
	name = "Daedalus - Holodeck"
	icon_state = "dk_yellow"

/area/mothership/cryotube
	name = "Daedalus - Cryo chamber"

/area/mothership/engineering
	name = "Daedalus - Engineering"

/area/mothership/hallway
	name = "Daedalus - Main Hallway"

/area/mothership/telecomms1
	name = "Daedalus - Hangar 1"
	has_gravity = 0

/area/mothership/telecomms2
	name = "Daedalus - Hangar 2"
	has_gravity = 0

/datum/map_template/om_ships/cruiser
	name = "OM Ship - Daedalus (New Z)"
	desc = "A large NT cruiser."
	mappath = 'cruiser.dmm'

/obj/effect/overmap/visitable/ship/cruiser
	name = "NDV Daedalus"
	icon_state = "oberth_destroyer_g"
	desc = "Spacefaring vessel. NanoTrasen IFF detected."
	scanner_desc = @{"[i]Registration[/i]: NDV Daedalus
[i]Class[/i]: Light Cruiser
[i]Transponder[/i]: Transmitting (MIL), NanoTrasen IFF
[b]Notice[/b]: Military vessel, do not approach"}
	vessel_mass = 15000
	vessel_size = SHIP_SIZE_LARGE
	initial_generic_waypoints = list("cruiser_fore", "cruiser_aft", "cruiser_port", "cruiser_starboard", "ws_port_dock_1", "ws_port_dock_2", "ws_starboard_dock_1", "ws_starboard_dock_2")

	skybox_icon = 'cruiser.dmi' //Art by Gwyvern, see ATTRIBUTIONS.md
	skybox_icon_state = "skybox"
	skybox_pixel_x = 370
	skybox_pixel_y = 370
