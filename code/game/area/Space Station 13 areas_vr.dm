/area/shuttle/belter
	name = "Belter Shuttle"
	icon_state = "shuttle2"

//Rouguelike Mining
/area/asteroid/rogue
	has_gravity = 0
	requires_power = 1
	always_unpowered = 1
	power_light = 0
	power_equip = 0
	power_environ = 0
	var/asteroid_spawns = list()
	var/mob_spawns = list()
	var/shuttle_area //It would be neat if this were more dynamic, but eh.

/area/asteroid/rogue/zone1
	name = "Asteroid Belt Zone 1"
	icon_state = "red2"
	//shuttle_area = /area/shuttle/belter/belt/zone1

/area/asteroid/rogue/zone2
	name = "Asteroid Belt Zone 2"
	icon_state = "blue2"
	//shuttle_area = /area/shuttle/belter/belt/zone2

/area/asteroid/rogue/zone3
	name = "Asteroid Belt Zone 3"
	icon_state = "blue2"
	//shuttle_area = /area/shuttle/belter/belt/zone3

/area/asteroid/rogue/zone4
	name = "Asteroid Belt Zone 4"
	icon_state = "red2"
	//shuttle_area = /area/shuttle/belter/belt/zone4

/area/engineering/engine_gas
	name = "\improper Engine Gas Storage"
	icon_state = "engine_waste"

//holodeck 3/29/21
/area/holodeck/source_smoleworld
	name = "\improper Holodeck - Smolworld"

/area/holodeck/source_gym
	name = "\improper Holodeck - Gym"

/area/holodeck/source_game_room
	name = "\improper Holodeck - Game Room"

/area/holodeck/source_patient_ward
	name = "\improper Holodeck - Patient Ward"

/area/holodeck/the_uwu_zone
	name = "\improper Holodeck - Inside"
