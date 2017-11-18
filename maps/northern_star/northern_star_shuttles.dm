// Escape shuttle and pods
/datum/shuttle/ferry/emergency/centcom
	name = "Escape"
	location = 1
	warmup_time = 10
	area_offsite = /area/shuttle/escape/centcom
	area_station = /area/shuttle/escape/station
	area_transition = /area/shuttle/escape/transit
	docking_controller_tag = "escape_shuttle"
	dock_target_station = "escape_dock"
	dock_target_offsite = "centcom_dock"
	transit_direction = NORTH
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN

/datum/shuttle/ferry/escape_pod/escape_pod_one
	name = "Escape Pod 1"
	location = 0
	warmup_time = 0
	area_station = /area/shuttle/escape_pod1/station
	area_offsite = /area/shuttle/escape_pod1/centcom
	area_transition = /area/shuttle/escape_pod1/transit
	docking_controller_tag = "escape_pod_1"
	dock_target_station = "escape_pod_1_berth"
	dock_target_offsite = "escape_pod_1_recovery"
	transit_direction = NORTH
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN

/datum/shuttle/ferry/escape_pod/escape_pod_two
	name = "Escape Pod 2"
	location = 0
	warmup_time = 0
	area_station = /area/shuttle/escape_pod2/station
	area_offsite = /area/shuttle/escape_pod2/centcom
	area_transition = /area/shuttle/escape_pod2/transit
	docking_controller_tag = "escape_pod_2"
	dock_target_station = "escape_pod_2_berth"
	dock_target_offsite = "escape_pod_2_recovery"
	transit_direction = NORTH
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN

/datum/shuttle/ferry/escape_pod/escape_pod_three
	name = "Escape Pod 3"
	location = 0
	warmup_time = 0
	area_station = /area/shuttle/escape_pod3/station
	area_offsite = /area/shuttle/escape_pod3/centcom
	area_transition = /area/shuttle/escape_pod3/transit
	docking_controller_tag = "escape_pod_3"
	dock_target_station = "escape_pod_3_berth"
	dock_target_offsite = "escape_pod_3_recovery"
	transit_direction = NORTH
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN

/datum/shuttle/ferry/escape_pod/escape_pod_four
	name = "Escape Pod 4"
	location = 0
	warmup_time = 0
	area_station = /area/shuttle/escape_pod4/station
	area_offsite = /area/shuttle/escape_pod4/centcom
	area_transition = /area/shuttle/escape_pod4/transit
	docking_controller_tag = "escape_pod_4"
	dock_target_station = "escape_pod_4_berth"
	dock_target_offsite = "escape_pod_4_recovery"
	transit_direction = NORTH //should this be SOUTH? I have no idea.
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN

/datum/shuttle/ferry/escape_pod/escape_pod_five
	name = "Escape Pod 5"
	location = 0
	warmup_time = 0
	area_station = /area/shuttle/escape_pod5/station
	area_offsite = /area/shuttle/escape_pod5/centcom
	area_transition = /area/shuttle/escape_pod5/transit
	docking_controller_tag = "escape_pod_5"
	dock_target_station = "escape_pod_5_berth"
	dock_target_offsite = "escape_pod_5_recovery"
	transit_direction = NORTH //should this be WEST? I have no idea.
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN

/datum/shuttle/ferry/escape_pod/escape_pod_six
	name = "Escape Pod 6"
	location = 0
	warmup_time = 0
	area_station = /area/shuttle/escape_pod6/station
	area_offsite = /area/shuttle/escape_pod6/centcom
	area_transition = /area/shuttle/escape_pod6/transit
	docking_controller_tag = "escape_pod_6"
	dock_target_station = "escape_pod_6_berth"
	dock_target_offsite = "escape_pod_6_recovery"
	transit_direction = NORTH //should this be WEST? I have no idea.
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN

/datum/shuttle/ferry/escape_pod/escape_pod_cryo
	name = "Cryostorage Shuttle"
	location = 0
	warmup_time = 0
	area_station = /area/shuttle/cryo/station
	area_offsite = /area/shuttle/cryo/centcom
	area_transition = /area/shuttle/cryo/transit
	docking_controller_tag = "cryostorage_shuttle"
	dock_target_station = "cryostorage_shuttle_berth"
	dock_target_offsite = "cryostorage_shuttle_recovery"
	transit_direction = NORTH
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN

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
	transit_direction = EAST
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN

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
	transit_direction = EAST
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN

// Cargo shuttle.
/datum/shuttle/ferry/supply/cargo
	name = "Supply"
	location = 1
	warmup_time = 10
	area_offsite = /area/supply/dock
	area_station = /area/supply/station
	docking_controller_tag = "supply_shuttle"
	dock_target_station = "cargo_bay"
	flags = SHUTTLE_FLAGS_PROCESS|SHUTTLE_FLAGS_SUPPLY

// The "Elevators"
/datum/shuttle/ferry/engineering
	name = "Engineering"
	warmup_time = 10
	area_offsite = /area/shuttle/constructionsite/site
	area_station = /area/shuttle/constructionsite/station
	docking_controller_tag = "engineering_shuttle"
	dock_target_station = "engineering_dock_airlock"
	dock_target_offsite = "edock_airlock"

/datum/shuttle/ferry/mining
	name = "Mining"
	warmup_time = 10
	area_offsite = /area/shuttle/mining/outpost
	area_station = /area/shuttle/mining/station
	docking_controller_tag = "mining_shuttle"
	dock_target_station = "mining_dock_airlock"
	dock_target_offsite = "mining_outpost_airlock"

/datum/shuttle/ferry/research
	name = "Research"
	warmup_time = 10
	area_offsite = /area/shuttle/research/outpost
	area_station = /area/shuttle/research/station
	docking_controller_tag = "research_shuttle"
	dock_target_station = "research_dock_airlock"
	dock_target_offsite = "research_outpost_dock"

// Admin shuttles.
/datum/shuttle/ferry/centcom
	name = "Centcom"
	location = 1
	warmup_time = 10
	area_offsite = /area/shuttle/transport1/centcom
	area_station = /area/shuttle/transport1/station
	docking_controller_tag = "centcom_shuttle"
	dock_target_station = "centcom_shuttle_dock_airlock"
	dock_target_offsite = "centcom_shuttle_bay"

/datum/shuttle/ferry/administration
	name = "Administration"
	location = 1
	warmup_time = 10	//want some warmup time so people can cancel.
	area_offsite = /area/shuttle/administration/centcom
	area_station = /area/shuttle/administration/station
	docking_controller_tag = "admin_shuttle"
	dock_target_station = "admin_shuttle_dock_airlock"
	dock_target_offsite = "admin_shuttle_bay"

// Traders
/datum/shuttle/ferry/trade
	name = "Trade"
	location = 1
	warmup_time = 10	//want some warmup time so people can cancel.
	area_offsite = /area/shuttle/trade/centcom
	area_station = /area/shuttle/trade/station
	docking_controller_tag = "trade_shuttle"
	dock_target_station = "trade_shuttle_dock_airlock"
	dock_target_offsite = "trade_shuttle_bay"

// Is this even used?
/datum/shuttle/ferry/alien
	name = "Alien"
	area_offsite = /area/shuttle/alien/base
	area_station = /area/shuttle/alien/mine
	flags = SHUTTLE_FLAGS_NONE

// Mercenary
/datum/shuttle/multi_shuttle/mercenary
	name = "Mercenary"
	warmup_time = 0
	origin = /area/syndicate_station/start
	interim = /area/syndicate_station/transit
	can_cloak = TRUE
	cloaked = TRUE
	start_location = "Mercenary Base"
	destinations = list(
		"Northwest of the station" = /area/syndicate_station/northwest,
		"North of the station" = /area/syndicate_station/north,
		"Northeast of the station" = /area/syndicate_station/northeast,
		"Southwest of the station" = /area/syndicate_station/southwest,
		"South of the station" = /area/syndicate_station/south,
		"Southeast of the station" = /area/syndicate_station/southeast,
		"Telecomms Satellite" = /area/syndicate_station/commssat,
		"Mining Station" = /area/syndicate_station/mining,
		"Arrivals dock" = /area/syndicate_station/arrivals_dock,
		)
	docking_controller_tag = "merc_shuttle"
	destination_dock_targets = list(
		"Mercenary Base" = "merc_base",
		"Arrivals dock" = "nuke_shuttle_dock_airlock",
		)
	announcer = "Automated Traffic Control"

/datum/shuttle/multi_shuttle/mercenary/New()
	arrival_message = "Attention.  A vessel is approaching the colony."
	departure_message = "Attention.  A vessel is now leaving from the colony."
	..()

// Heist
/datum/shuttle/multi_shuttle/skipjack
	name = "Skipjack"
	warmup_time = 0
	origin = /area/skipjack_station/start
	interim = /area/skipjack_station/transit
	can_cloak = TRUE
	cloaked = TRUE
	destinations = list(
		"Fore Starboard Solars" = /area/skipjack_station/northeast_solars,
		"Fore Port Solars" = /area/skipjack_station/northwest_solars,
		"Aft Starboard Solars" = /area/skipjack_station/southeast_solars,
		"Aft Port Solars" = /area/skipjack_station/southwest_solars,
		"Mining Station" = /area/skipjack_station/mining
		)
	announcer = "Automated Traffic Control"

/datum/shuttle/multi_shuttle/skipjack/New()
	arrival_message = "Attention.  Unidentified object approaching the colony."
	departure_message = "Attention.  Unidentified object exiting local space.  Unidentified object expected to escape Kara gravity well with current velocity."
	..()

/datum/shuttle/ferry/multidock/specops/ert
	name = "Special Operations"
	location = 0
	warmup_time = 10
	area_offsite = /area/shuttle/specops/station	//centcom is the home station, the Exodus is offsite
	area_station = /area/shuttle/specops/centcom
	docking_controller_tag = "specops_shuttle_port"
	docking_controller_tag_station = "specops_shuttle_port"
	docking_controller_tag_offsite = "specops_shuttle_fore"
	dock_target_station = "specops_centcom_dock"
	dock_target_offsite = "specops_dock_airlock"


