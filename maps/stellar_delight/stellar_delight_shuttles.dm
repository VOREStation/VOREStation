//////////////////////////////////////////////////////////////
// Escape shuttle and pods
/datum/shuttle/autodock/ferry/escape_pod/portescape
	name = "Port Escape Pod"
	location = FERRY_LOCATION_STATION
	shuttle_area = /area/stellardelight/deck2/portescape
	warmup_time = 0
	landmark_station = "port_ship_berth"
	landmark_offsite = "port_escape_cc"
	landmark_transition = "port_escape_transit"
	docking_controller_tag = "port_escape_pod"
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN
	move_direction = EAST

/datum/shuttle/autodock/ferry/escape_pod/starboardescape
	name = "Starboard Escape Pod"
	location = FERRY_LOCATION_STATION
	shuttle_area = /area/stellardelight/deck2/starboardescape
	warmup_time = 0
	landmark_station = "starboard_ship_berth"
	landmark_offsite = "starboard_escape_cc"
	landmark_transition = "starboard_escape_transit"
	docking_controller_tag = "starboard_escape_pod"
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN
	move_direction = WEST

/////EXPLORATION SHUTTLE
/datum/shuttle/autodock/overmap/exboat
	name = "Exploration Shuttle"
	current_location = "sd_explo"
	docking_controller_tag = "explodocker"
	shuttle_area = /area/stellardelight/deck1/exploshuttle
	fuel_consumption = 0
	defer_initialisation = TRUE
	range = 1

/obj/effect/shuttle_landmark/shuttle_initializer/exploration/Initialize(mapload)
	shuttle_type = /datum/shuttle/autodock/overmap/exboat
	. = ..()

/datum/shuttle/autodock/overmap/mineboat
	name = "Mining Shuttle"
	current_location = "sd_mining"
	docking_controller_tag = "miningdocker"
	shuttle_area = /area/stellardelight/deck1/miningshuttle
	fuel_consumption = 0
	defer_initialisation = TRUE
	range = 1

/obj/effect/shuttle_landmark/shuttle_initializer/mining/Initialize(mapload)
	shuttle_type = /datum/shuttle/autodock/overmap/mineboat
	. = ..()

/datum/shuttle/autodock/overmap/sdboat
	name = "Starstuff"
	current_location = "port_shuttlepad"
	docking_controller_tag = "sdboat_docker"
	shuttle_area = list(/area/shuttle/sdboat/fore,/area/shuttle/sdboat/aft)
	fuel_consumption = 1
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/shuttle_initializer/sdboat/Initialize(mapload)
	shuttle_type = /datum/shuttle/autodock/overmap/sdboat
	. = ..()

/obj/item/paper/dockingcodes/sd/Initialize(mapload, ...)
	codes_from_z = Z_LEVEL_SHIP_LOW
	return ..()
