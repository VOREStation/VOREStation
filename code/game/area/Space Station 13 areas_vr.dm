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
	name = "NSS Adephagia (AM)"
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