/area/crew_quarters/sleep/vistor_room_1
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/vistor_room_2
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/vistor_room_3
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/vistor_room_4
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/vistor_room_5
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/vistor_room_6
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/vistor_room_7
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/vistor_room_8
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/vistor_room_9
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/vistor_room_10
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/vistor_room_11
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/vistor_room_12
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/teleporter/departing
	name = "\improper Long-Range Teleporter"
	icon_state = "teleporter"
	music = "signal"

// Override telescience shielding on some areas
/area/security/armoury
	flags = BLUE_SHIELDED

/area/security/tactical
	flags = BLUE_SHIELDED

/area/security/nuke_storage
	flags = BLUE_SHIELDED

// New shuttles
/area/shuttle/administration/transit
	name = "Deep Space (AS)"
	icon_state = "shuttle"

/area/shuttle/administration/away_mission
	name = "Away Mission (AS)"
	icon_state = "shuttle"

/area/shuttle/awaymission/home
	name = "NSB Adephagia (AM)"
	icon_state = "shuttle2"

/area/shuttle/awaymission/warp
	name = "Deep Space (AM)"
	icon_state = "shuttle"

/area/shuttle/awaymission/away
	name = "Away Mission (AM)"
	icon_state = "shuttle2"

/area/shuttle/awaymission/oldengbase
	name = "Old Construction Site (AM)"
	icon_state = "shuttle2"

/area/shuttle/belter/station
	name = "Belter Shuttle Landed"
	icon_state = "shuttle2"
	base_turf = /turf/simulated/floor/tiled/asteroid_steel/airless

/area/shuttle/belter/belt //Don't use this one, use a subtype
	name = "Belter Shuttle Holding Position"
	icon_state = "shuttle2"

//Placeholders
/area/shuttle/belter/belt/zone1
/area/shuttle/belter/belt/zone2
/area/shuttle/belter/belt/zone3
/area/shuttle/belter/belt/zone4

/area/shuttle/belter/transit
	name = "Belter Shuttle Warp"
	icon_state = "shuttle"

//Rouguelike Mining
/area/asteroid/rogue
	var/asteroid_spawns = list()
	var/mob_spawns = list()
	var/shuttle_area //It would be neat if this were more dynamic, but eh.

/area/asteroid/rogue/zone1
	name = "Asteroid Belt Zone 1"
	icon_state = "red2"
	shuttle_area = /area/shuttle/belter/belt/zone1

/area/asteroid/rogue/zone2
	name = "Asteroid Belt Zone 2"
	icon_state = "blue2"
	shuttle_area = /area/shuttle/belter/belt/zone2

/area/asteroid/rogue/zone3
	name = "Asteroid Belt Zone 3"
	icon_state = "blue2"
	shuttle_area = /area/shuttle/belter/belt/zone3

/area/asteroid/rogue/zone4
	name = "Asteroid Belt Zone 4"
	icon_state = "red2"
	shuttle_area = /area/shuttle/belter/belt/zone4

/area/medical/resleeving
	name = "Resleeving Lab"
	icon_state = "genetics"

/area/bigship
	name = "Bigship"
	requires_power = 0
	flags = RAD_SHIELDED
	sound_env = SMALL_ENCLOSED
	base_turf = /turf/space
	icon_state = "red2"

/area/bigship/teleporter
	name = "Bigship Teleporter Room"

//////// Small Cruiser Areas ////////
/area/houseboat
	name = "Small Cruiser"
	requires_power = 0
	flags = RAD_SHIELDED
	base_turf = /turf/space
	icon_state = "red2"
	lightswitch = TRUE

/area/houseboat/holodeck_area
	name = "Small Cruiser - Holodeck"
	icon_state = "blue2"

/area/houseboat/holodeck/off
	name = "Small Cruiser Holo - Off"
	icon_state = "blue2"
/area/houseboat/holodeck/beach
	name = "Small Cruiser Holo - Beach"
	icon_state = "blue2"
/area/houseboat/holodeck/snow
	name = "Small Cruiser Holo - Snow"
	icon_state = "blue2"
/area/houseboat/holodeck/desert
	name = "Small Cruiser Holo - Desert"
	icon_state = "blue2"
/area/houseboat/holodeck/picnic
	name = "Small Cruiser Holo - Picnic"
	icon_state = "blue2"
/area/houseboat/holodeck/thunderdome
	name = "Small Cruiser Holo - Thunderdome"
	icon_state = "blue2"
/area/houseboat/holodeck/basketball
	name = "Small Cruiser Holo - Basketball"
	icon_state = "blue2"
/area/houseboat/holodeck/gaming
	name = "Small Cruiser Holo - Gaming Table"
	icon_state = "blue2"
/area/houseboat/holodeck/space
	name = "Small Cruiser Holo - Space"
	icon_state = "blue2"
/area/houseboat/holodeck/bunking
	name = "Small Cruiser Holo - Bunking"
	icon_state = "blue2"

/area/shuttle/cruiser/cruiser
	name = "Small Cruiser Shuttle - Cruiser"
	icon_state = "blue2"
	base_turf = /turf/simulated/floor/tiled/techfloor
/area/shuttle/cruiser/station
	name = "Small Cruiser Shuttle - Station"
	icon_state = "blue2"


// Tether Map has this shuttle
/area/shuttle/tether/surface
	name = "Tether Shuttle Landed"
	icon_state = "shuttle"
	base_turf = /turf/simulated/floor/reinforced

/area/shuttle/tether/station
	name = "Tether Shuttle Dock"
	icon_state = "shuttle2"

/area/shuttle/tether/transit
	name = "Tether Shuttle Transit"
	icon_state = "shuttle2"

// rnd (Research and Development)
/area/rnd/research/testingrange
	name = "\improper Weapons Testing Range"
	icon_state = "firingrange"

/area/rnd/outpost
	name = "\improper Research Outpost Hallway"
	icon_state = "research"

/area/rnd/outpost/airlock
	name = "\improper Research Outpost Airlock"
	icon_state = "green"

/area/rnd/outpost/eva
	name = "Research Outpost EVA Storage"
	icon_state = "eva"

/area/rnd/outpost/chamber
	name = "\improper Research Outpost Burn Chamber"
	icon_state = "engine"

/area/rnd/outpost/atmos
	name = "Research Outpost Atmospherics"
	icon_state = "atmos"

/area/rnd/outpost/storage
	name = "\improper Research Outpost Gas Storage"
	icon_state = "toxstorage"

/area/rnd/outpost/mixing
	name = "\improper Research Outpost Gas Mixing"
	icon_state = "toxmix"

/area/rnd/outpost/heating
	name = "\improper Research Outpost Gas Heating"
	icon_state = "toxmix"

/area/rnd/outpost/testing
	name = "\improper Research Outpost Testing"
	icon_state = "toxtest"

/area/maintenance/substation/outpost
	name = "Research Outpost Substation"

/area/engineering/engine_gas
	name = "\improper Engine Gas Storage"
	icon_state = "engine_waste"
