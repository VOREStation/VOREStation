//////////////////////////////////////////////////////////////
// Escape shuttle and pods
/datum/shuttle/ferry/emergency/escape
	name = "Escape"
	location = 1 // At offsite
	warmup_time = 10
	area_offsite = /area/shuttle/escape/centcom
	area_station = /area/shuttle/escape/station
	area_transition = /area/shuttle/escape/transit
	docking_controller_tag = "escape_shuttle"
	dock_target_station = "escape_dock"
	dock_target_offsite = "centcom_dock"
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN

//////////////////////////////////////////////////////////////
/datum/shuttle/ferry/escape_pod/large_escape_pod1
	name = "Large Escape Pod 1"
	location = 0
	warmup_time = 0
	area_station = /area/shuttle/large_escape_pod1/station
	area_offsite = /area/shuttle/large_escape_pod1/centcom
	area_transition = /area/shuttle/large_escape_pod1/transit
	docking_controller_tag = "large_escape_pod_1"
	dock_target_station = "large_escape_pod_1_berth"
	dock_target_offsite = "large_escape_pod_1_recovery"
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN

//////////////////////////////////////////////////////////////
/datum/shuttle/ferry/escape_pod/large_escape_pod2
	name = "Large Escape Pod 2"
	location = 0
	warmup_time = 0
	area_station = /area/shuttle/large_escape_pod2/station
	area_offsite = /area/shuttle/large_escape_pod2/centcom
	area_transition = /area/shuttle/large_escape_pod2/transit
	docking_controller_tag = "large_escape_pod_2"
	dock_target_station = "large_escape_pod_2_berth"
	dock_target_offsite = "large_escape_pod_2_recovery"
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN

//////////////////////////////////////////////////////////////
// Supply shuttle
/datum/shuttle/ferry/supply/cargo
	name = "Supply"
	location = 1
	warmup_time = 10
	area_offsite = /area/supply/dock
	area_station = /area/supply/station
	docking_controller_tag = "supply_shuttle"
	dock_target_station = "cargo_bay"
	flags = SHUTTLE_FLAGS_PROCESS|SHUTTLE_FLAGS_SUPPLY

//////////////////////////////////////////////////////////////
// Trade Ship
/datum/shuttle/ferry/trade
	name = "Trade"
	location = 1
	warmup_time = 10	//want some warmup time so people can cancel.
	area_offsite = /area/shuttle/trade/centcom
	area_station = /area/shuttle/trade/station
	docking_controller_tag = "trade_shuttle"
	dock_target_station = "trade_shuttle_dock_airlock"
	dock_target_offsite = "trade_shuttle_bay"

//////////////////////////////////////////////////////////////
// Away Mission Shuttle
// TODO - Not implemented yet on new map
/*
/datum/shuttle/multi_shuttle/awaymission
	name = "AwayMission"
	legit = TRUE
	warmup_time = 8
	move_time = 60
	origin = /area/shuttle/awaymission/home
	interim = /area/shuttle/awaymission/warp
	start_location = "NSB Adephagia (AM)"
	destinations = list(
		"Old Engineering Base (AM)" = /area/shuttle/awaymission/oldengbase
	)
	docking_controller_tag = "awaymission_shuttle"
	destination_dock_targets = list(
		"NSB Adephagia (AM)" = "d1a2_dock_airlock"
	)
	announcer = "Automated Traffic Control"
	//These seem backwards because they are written from the perspective of the merc and vox ships
	departure_message = "Attention. The away mission vessel is approaching the colony."
	arrival_message = "Attention. The away mission vessel is now leaving from the colony."
*/

/datum/shuttle/multi_shuttle/awaymission/New()
	..()
	var/area/awaym_dest = locate(/area/shuttle/awaymission/away)
	if(awaym_dest && awaym_dest.contents.len) // Otherwise this is an empty imaginary area
		destinations["Unknown Location [rand(1000,9999)]"] = awaym_dest

//////////////////////////////////////////////////////////////
// Tether Shuttle
/datum/shuttle/ferry/tether_backup/goodluckmcgee
	name = "Tether Backup"
	location = 1 // At offsite
	warmup_time = 5
	move_time = 45
	area_offsite = /area/shuttle/tether/surface
	area_station = /area/shuttle/tether/station
	area_transition = /area/shuttle/tether/transit
	crash_areas = list(/area/shuttle/tether/crash1, /area/shuttle/tether/crash2)
	docking_controller_tag = "tether_shuttle"
	dock_target_station = "tether_dock_airlock"
	dock_target_offsite = "tether_pad_airlock"

//////////////////////////////////////////////////////////////
// Antag Space "Proto Shuttle" Shuttle
/datum/shuttle/multi_shuttle/protoshuttle
	name = "Proto"
	warmup_time = 8
	move_time = 60
	origin = /area/shuttle/antag_space/base
	interim = /area/shuttle/antag_space/transit
	start_location = "Home Base"
	destinations = list(
		"Nearby" = /area/shuttle/antag_space/north,
		"Docks" =  /area/shuttle/antag_space/docks
	)
	docking_controller_tag = "antag_space_shuttle"
	destination_dock_targets = list("Home Base" = "antag_space_dock")

//////////////////////////////////////////////////////////////
// Antag Surface "Land Crawler" Shuttle
/datum/shuttle/multi_shuttle/landcrawler
	name = "Land Crawler"
	warmup_time = 8
	move_time = 60
	origin = /area/shuttle/antag_ground/base
	interim = /area/shuttle/antag_ground/transit
	start_location = "Home Base"
	destinations = list(
		"Solar Array" = /area/shuttle/antag_ground/solars,
		"Mining Outpost" =  /area/shuttle/antag_ground/mining
	)
	docking_controller_tag = "antag_ground_shuttle"
	destination_dock_targets = list("Home Base" = "antag_ground_dock")

//////////////////////////////////////////////////////////////
// Mercenary Shuttle
/datum/shuttle/multi_shuttle/mercenary
	name = "Mercenary"
	warmup_time = 8
	move_time = 60
	origin = /area/syndicate_station/start
	//interim = /area/syndicate_station/transit // Disabled until this even exists.
	start_location = "Mercenary base"
	destinations = list(
		//"Northwest of the station" = /area/syndicate_station/northwest,
		//"North of the station" = /area/syndicate_station/north,
		//"Northeast of the station" = /area/syndicate_station/northeast,
		//"(Land) Southwest of Tether" = /area/syndicate_station/southwest,
		//"South of the station" = /area/syndicate_station/south,
		//"Southeast of the station" = /area/syndicate_station/southeast,
		//"Telecomms Satellite" = /area/syndicate_station/commssat,
		"(Land) Solar farm west of Tether" = /area/syndicate_station/mining,
		"Tether spaceport" = /area/syndicate_station/arrivals_dock
		)
	docking_controller_tag = "merc_shuttle"
	destination_dock_targets = list(
		"Mercenary base" = "merc_base",
		"Tether spaceport" = "nuke_shuttle_dock_airlock",
		)
	announcer = "Automated Traffic Control"

/datum/shuttle/multi_shuttle/mercenary/New()
	arrival_message = "Attention. An unregistered vessel is approaching Virgo-3B."
	departure_message = "Attention. A unregistered vessel is now leaving Virgo-3B."
	..()

//////////////////////////////////////////////////////////////
// RogueMiner "Belter: Shuttle
// TODO - Not implemented yet on new map
/*
/datum/shuttle/ferry/belter
	name = "Belter"
	location = 0
	warmup_time = 6
	move_time = 60
	area_station = /area/shuttle/belter/station
	area_offsite = /area/shuttle/belter/belt/zone1
	area_transition = /area/shuttle/belter/transit
	docking_controller_tag = "belter_docking"
	dock_target_station = "belter_nodocking" //Fake tags to prevent the shuttle from opening doors.
	dock_target_offsite = "belter_nodocking"

/datum/shuttle/ferry/belter/New()
	move_time = move_time + rand(10, 40)
	..()
*/
