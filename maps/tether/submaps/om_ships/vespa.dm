// Compile in the map for CI testing if we're testing compileability of all the maps
#if MAP_TEST
#include "vespa.dmm"
#endif

// Map template for spawning the shuttle
/datum/map_template/om_ships/vespa
	name = "OM Ship - Vespa (New Z)"
	desc = "The Vespa, a Hephaestus Industries vessel."
	mappath = 'vespa.dmm'

// The shuttle's area(s)
/area/ship/expe
	name = "\improper Event Ship (Use a Subtype!)"
	icon_state = "shuttle2"
	requires_power = 1
	dynamic_lighting = 1

<<<<<<< HEAD









/area/ship/expe/emergencystorage
	name = "\improper Exp Ship - Emergency Storage"
=======
>>>>>>> Vespa1.5boogaloo
/area/ship/expe/telecomms
	name = "\improper Exp Ship - Telecommunications"
/area/ship/expe/enginestorage
	name = "\improper Exp Ship - Engine Storage"
/area/ship/expe/engineering
	name = "\improper Exp Ship - Engineering"
/area/ship/expe/atmospherics
	name = "\improper Exp Ship - Atmospherics"
/area/ship/expe/engineeringenginemonitoring
	name = "\improper Exp Ship - Engineering Power Station Monitoring"
/area/ship/expe/engineeringequipment
	name = "\improper Exp Ship - Engineering Equipment Room"
/area/ship/expe/engineeringcorridor
	name = "\improper Exp Ship - Engineering Corridor"
/area/ship/expe/engineeringlobby
	name = "\improper Exp Ship - Engineering Lobby"
/area/ship/expe/engineeringpublichall
	name = "\improper Exp Ship - Engineering Public Hallway"
/area/ship/expe/powerengine
	name = "\improper Exp Ship - Engine"
/area/ship/expe/enginestorage
	name = "\improper Exp Ship - Engine Storage"
/area/ship/expe/hangar
	name = "\improper Exp Ship - Hangar"
/area/ship/expe/hangarcontrol
	name = "\improper Exp Ship - Exploration Equipment Room"
/area/ship/expe/cabin1
	name = "\improper Exp Ship - Cabin 1"
/area/ship/expe/cabin2
	name = "\improper Exp Ship - Cabin 2"
/area/ship/expe/cryogenics
	name = "\improper Exp Ship - Cryogenics"
/area/ship/expe/cabin2
	name = "\improper Exp Ship - Cafeteria"
/area/ship/expe/cabin3
	name = "\improper Exp Ship - Cabin 3"
/area/ship/expe/cabin4
	name = "\improper Exp Ship - Cabin 4"
/area/ship/expe/cabin5
	name = "\improper Exp Ship - Cabin 5"
/area/ship/expe/cabin6
	name = "\improper Exp Ship - Cabin 6"
/area/ship/expe/cabin7
	name = "\improper Exp Ship - Cabin 7"
/area/ship/expe/corridor1
	name = "\improper Exp Ship - Corridor"
/area/ship/expe/corridor2
	name = "\improper Exp Ship - Corridor"
/area/ship/expe/corridor3
	name = "\improper Exp Ship - Corridor"
/area/ship/expe/corridor4
	name = "\improper Exp Ship - Corridor"
/area/ship/expe/corridor5p
	name = "\improper Exp Ship - Port Corridor"
/area/ship/expe/corridor5s
	name = "\improper Exp Ship - Starboard Corridor"
/area/ship/expe/corridor6
	name = "\improper Exp Ship - Corridor"
/area/ship/expe/corridor7
<<<<<<< HEAD
	name = "\improper Exp Ship - Port Section Corridor"
/area/ship/expe/corridor7p1
	name = "\improper Exp Ship - Port Section Corridor"
/area/ship/expe/corridor7inside
	name = "\improper Exp Ship - Port Section Corridor"
/area/ship/expe/corridor8
	name = "\improper Exp Ship - Starboard Section Corridor"
/area/ship/expe/corridor8p2
	name = "\improper Exp Ship - Starboard Section Corridor"
/area/ship/expe/corridor8inside
	name = "\improper Exp Ship - Starboard Section Corridor"
=======
	name = "\improper Exp Ship - Corridor"
/area/ship/expe/corridor8
	name = "\improper Exp Ship - Corridor"
>>>>>>> Vespa1.5boogaloo
/area/ship/expe/medical
	name = "\improper Exp Ship - Medical"
/area/ship/expe/medical1
	name = "\improper Exp Ship - Medical Pacient Room"
/area/ship/expe/medicalchem
	name = "\improper Exp Ship - Chemistry"
/area/ship/expe/medicalmain
	name = "\improper Exp Ship - Medical Main"
/area/ship/expe/medicaleq
	name = "\improper Exp Ship - Medical Equipment Room"
/area/ship/expe/medicalsur
	name = "\improper Exp Ship - Medical Surgery"
/area/ship/expe/armoury
	name = "\improper Exp Ship - Lightweight Armoury"
/area/ship/expe/secmain
	name = "\improper Exp Ship - Security"
/area/ship/expe/seclobby
	name = "\improper Exp Ship - Security Lobby"
/area/ship/expe/seclobby2
	name = "\improper Exp Ship - Security Lobby"
/area/ship/expe/seceq
	name = "\improper Exp Ship - Security Equipment Room"
/area/ship/expe/sechall
	name = "\improper Exp Ship - Security Hall"
/area/ship/expe/seccells
	name = "\improper Exp Ship - Security Holding Cells"
/area/ship/expe/cafet
	name = "\improper Exp Ship - Cafeteria"
/area/ship/expe/cargo
	name = "\improper Exp Ship - Storage"
/area/ship/expe/bridge
	name = "\improper Exp Ship - Bridge"
/area/ship/expe/fuelbay
	name = "\improper Exp Ship - Fuel Bay"
/area/ship/expe/engines
	name = "\improper Exp Ship - Engines Port"
/area/ship/expe/engines2
	name = "\improper Exp Ship - Engines Starboard"
/area/ship/expe/captqua
	name = "\improper Exp Ship - Captain's Quarters"
/area/ship/expe/expedition
	name = "\improper Exp Ship - Expedition Prep"
/area/ship/expe/backupatmos
	name = "\improper Exp Ship - Atmos"
/area/ship/expe/northairlock
	name = "\improper Exp Ship - Airlock"
/area/ship/expe/southairlock
	name = "\improper Exp Ship - Airlock"
/area/ship/expe/maintenancerim1
	name = "\improper Exp Ship - Maintenance"
/area/ship/expe/maintenancerim2
	name = "\improper Exp Ship - Maintenance"
/area/ship/expe/maintenance1
	name = "\improper Exp Ship - Maintenance"
/area/ship/expe/maintenance2
	name = "\improper Exp Ship - Maintenance"
/area/ship/expe/shieldgen
	name = "\improper Exp Ship - Shield Generator"

// The 'ship'
/obj/effect/overmap/visitable/ship/vespa
	desc = "A spacefaring vessel, of Hephaestus design."
	scanner_name = "HPV Vespa"
	scanner_desc = @{"[i]Registration[/i]: HPV Vespa
[i]Class[/i]: Cruiser
[i]Transponder[/i]: Transmitting (CIV), Hephaestus Industries
[b]Notice[/b]: Corporate vessel"}
	color = "#4cad73" //Green
	vessel_mass = 10000
	vessel_size = SHIP_SIZE_LARGE
	initial_generic_waypoints = list("hpv_port", "hpv_starboard", "hpv_hangar")
	fore_dir = 4

// Boat deprecated because hangar was converted into one for the expedition shuttle

// The ship's boat
// /area/shuttle/vespaboat
	//name = "\improper Vespa's Ship's Boat"
	//icon_state = "shuttle"

// The shuttle's 'shuttle' computer
// /obj/machinery/computer/shuttle_control/explore/vespaboat
    //name = "Vespa's Shuttle control console"
    //shuttle_tag = "Vespa's Ship's Boat"
    //req_one_access = list(access_pilot)

// A shuttle lateloader landmark
// /obj/effect/shuttle_landmark/shuttle_initializer/vespaboat
    //name = "Vespa's Boat Bay"
    //base_area = /area/ship/expe/hangar
    //base_turf = /turf/simulated/floor/tiled/techfloor
    //landmark_tag = "omship_spawn_vespaboat"
    //docking_controller = "vespa_boatbay"
    //shuttle_type = /datum/shuttle/autodock/overmap/vespaboat

// The 'shuttle'
// /datum/shuttle/autodock/overmap/vespaboat
    //name = "Vespa's Ship's Boat"
    //current_location = "omship_spawn_vespaboat"
    //docking_controller_tag = "vespaboat_docker"
    //shuttle_area = /area/shuttle/vespaboat
    //fuel_consumption = 0
    //defer_initialisation = TRUE