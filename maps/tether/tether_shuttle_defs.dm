//////////////////////////////////////////////////////////////
// Escape shuttle and pods
/datum/shuttle/autodock/ferry/emergency/escape
	name = "Escape"
	location = FERRY_LOCATION_OFFSITE
	shuttle_area = /area/shuttle/escape
	warmup_time = 10
	landmark_offsite = "escape_cc"
	landmark_station = "escape_station"
	landmark_transition = "escape_transit"
	//docking_controller_tag = "escape_shuttle"
	//dock_target_station = "escape_dock"
	//dock_target_offsite = "centcom_dock"
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN

//////////////////////////////////////////////////////////////
/datum/shuttle/autodock/ferry/escape_pod/large_escape_pod1
	name = "Large Escape Pod 1"
	location = FERRY_LOCATION_STATION
	shuttle_area = /area/shuttle/large_escape_pod1
	warmup_time = 0
	landmark_station = "escapepod1_station"
	landmark_offsite = "escapepod1_cc"
	landmark_transition = "escapepod1_transit"
	docking_controller_tag = "large_escape_pod_1"
	//dock_target_station = "large_escape_pod_1_berth"
	//dock_target_offsite = "large_escape_pod_1_recovery"
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN

//////////////////////////////////////////////////////////////
// Supply shuttle
/datum/shuttle/autodock/ferry/supply/cargo
	name = "Supply"
	location = FERRY_LOCATION_OFFSITE
	shuttle_area = /area/shuttle/supply
	warmup_time = 10
	landmark_offsite = "supply_cc"
	landmark_station = "supply_station"
	docking_controller_tag = "supply_shuttle"
	//dock_target_station = "cargo_bay"
	flags = SHUTTLE_FLAGS_PROCESS|SHUTTLE_FLAGS_SUPPLY

//////////////////////////////////////////////////////////////
// Trade Ship
/datum/shuttle/autodock/ferry/trade
	name = "Trade"
	location = FERRY_LOCATION_OFFSITE
	shuttle_area = /area/shuttle/trade
	warmup_time = 10	//want some warmup time so people can cancel.
	landmark_offsite = "trade_cc"
	landmark_station = "trade_station"
	docking_controller_tag = "trade_shuttle"
	//dock_target_station = "trade_shuttle_dock_airlock"
	//dock_target_offsite = "trade_shuttle_bay"

//////////////////////////////////////////////////////////////
// Tether Shuttle
/datum/shuttle/autodock/ferry/tether_backup
	name = "Tether Backup"
	location = FERRY_LOCATION_OFFSITE //Offsite is the surface hangar
	warmup_time = 5
	move_time = 45
	landmark_offsite = "tether_backup_low"
	landmark_station = "tether_backup_high"
	landmark_transition = "tether_backup_transit"
	shuttle_area = /area/shuttle/tether
	//crash_areas = list(/area/shuttle/tether/crash1, /area/shuttle/tether/crash2)
	docking_controller_tag = "tether_shuttle"
	//dock_target_station = "tether_dock_airlock"
	//dock_target_offsite = "tether_pad_airlock"

//////////////////////////////////////////////////////////////
// Antag Space "Proto Shuttle" Shuttle
/datum/shuttle/autodock/multi/protoshuttle
	name = "Proto"
	warmup_time = 8
	move_time = 60
	current_location = "antag_space_base"
	shuttle_area = /area/shuttle/antag_space
	landmark_transition = "antag_space_transit"
	destination_tags = list(
		"antag_space_nearby",
		"antag_space_docks"
		//"Nearby" = /area/shuttle/antag_space/north,
		//"Docks" =  /area/shuttle/antag_space/docks
	)
	docking_controller_tag = "antag_space_shuttle"
	//destination_dock_targets = list("Home Base" = "antag_space_dock")

//////////////////////////////////////////////////////////////
// Antag Surface "Land Crawler" Shuttle
/datum/shuttle/autodock/multi/landcrawler
	name = "Land Crawler"
	warmup_time = 8
	move_time = 60
	current_location = "antag_ground_base"
	shuttle_area = /area/shuttle/antag_ground
	landmark_transition = "antag_ground_transit"
	destination_tags = list(
		"antag_ground_solars",
		"antag_ground_mining"
		//"Solar Array" = /area/shuttle/antag_ground/solars,
		//"Mining Outpost" =  /area/shuttle/antag_ground/mining
	)
	docking_controller_tag = "antag_ground_shuttle"

//////////////////////////////////////////////////////////////
// Mercenary Shuttle
/datum/shuttle/autodock/multi/mercenary
	name = "Mercenary"
	warmup_time = 8
	move_time = 60
	current_location = "merc_base"
	shuttle_area = /area/shuttle/mercenary
	destination_tags = list(
		"merc_base",
		"merc_tether_solars",
		"merc_tether_dock"
		)
	docking_controller_tag = "merc_shuttle"
	announcer = "Automated Traffic Control"

/datum/shuttle/autodock/multi/mercenary/New()
	arrival_message = "Attention. An unregistered vessel is approaching Virgo-3B."
	departure_message = "Attention. A unregistered vessel is now leaving Virgo-3B."
	..()

//////////////////////////////////////////////////////////////
// RogueMiner "Belter: Shuttle

/datum/shuttle/autodock/ferry/belter
	name = "Belter"
	location = FERRY_LOCATION_STATION
	warmup_time = 5
	move_time = 30
	shuttle_area = /area/shuttle/belter
	landmark_station = "belter_station"
	landmark_offsite = "belter_zone1"
	landmark_transition = "belter_transit"
	docking_controller_tag = "belter_docking"
	//dock_target_station = "belter_nodocking" //Fake tags to prevent the shuttle from opening doors.
	//dock_target_offsite = "belter_nodocking"

/datum/shuttle/autodock/ferry/belter/New()
	move_time = move_time + rand(-5 SECONDS, 5 SECONDS)
	..()
