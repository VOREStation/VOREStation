//TFF 28/8/19 - cleanup of areas placement - removes all but rogueminer_vr stuff.

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