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
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN
	move_direction = NORTH

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
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN
	move_direction = EAST

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
	flags = SHUTTLE_FLAGS_PROCESS|SHUTTLE_FLAGS_SUPPLY
	move_direction = NORTH

//////////////////////////////////////////////////////////////
// Trade Ship
/datum/shuttle/autodock/multi/trade
	name = "Trade"
	current_location = "trade_dock"
	shuttle_area = /area/shuttle/trade
	docking_controller_tag = "trade_shuttle"
	warmup_time = 10	//want some warmup time so people can cancel.
	destination_tags = list(
		"trade_dock",
		"tether_dockarm_d1l",
		"aerostat_south",
		"beach_e",
		"beach_c",
		"beach_nw"
	)
	defer_initialisation = TRUE
	move_direction = WEST

//////////////////////////////////////////////////////////////
// Tether Shuttle
/datum/shuttle/autodock/ferry/tether_backup
	name = "Tether Backup"
	location = FERRY_LOCATION_OFFSITE //Offsite is the surface hangar
	warmup_time = 5
	move_time = 5
	landmark_offsite = "tether_backup_low"
	landmark_station = "tether_dockarm_d1a3"
	landmark_transition = "tether_backup_transit"
	shuttle_area = /area/shuttle/tether
	//crash_areas = list(/area/shuttle/tether/crash1, /area/shuttle/tether/crash2)
	docking_controller_tag = "tether_shuttle"
	move_direction = NORTH

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
		"aerostat_south",
		"beach_e",
		"beach_nw",
		"tether_solars_ne",
		"tether_solars_sw",
		"tether_mine_nw",
		"tether_space_NE",
		"tether_space_SE",
		"tether_space_SW",
		"tether_dockarm_d2l" //End of right docking arm
		)
	docking_controller_tag = "merc_shuttle"
	announcer = "Automated Traffic Control"
	arrival_message = "Attention. An unregistered vessel is approaching Virgo-3B."
	departure_message = "Attention. A unregistered vessel is now leaving Virgo-3B."
	defer_initialisation = TRUE
	move_direction = WEST

//////////////////////////////////////////////////////////////
// Ninja Shuttle
/datum/shuttle/autodock/multi/ninja
	name = "Ninja"
	warmup_time = 8
	move_time = 60
	can_cloak = TRUE
	cloaked = TRUE
	current_location = "ninja_base"
	landmark_transition = "ninja_transit"
	shuttle_area = /area/shuttle/ninja
	destination_tags = list(
		"ninja_base",
		"aerostat_northeast",
		"beach_e",
		"beach_nw",
		"tether_solars_ne",
		"tether_solars_sw",
		"tether_mine_nw",
		"tether_space_NE",
		"tether_space_SE",
		"tether_space_SW",
		"tether_dockarm_d1a3" //Inside of left dockarm
		)
	docking_controller_tag = "ninja_shuttle"
	announcer = "Automated Traffic Control"
	arrival_message = "Attention. An unregistered vessel is approaching Virgo-3B."
	departure_message = "Attention. A unregistered vessel is now leaving Virgo-3B."
	defer_initialisation = TRUE
	move_direction = NORTH

//////////////////////////////////////////////////////////////
// Skipjack
/datum/shuttle/autodock/multi/heist
	name = "Skipjack"
	warmup_time = 8
	move_time = 60
	can_cloak = TRUE
	cloaked = TRUE
	current_location = "skipjack_base"
	landmark_transition = "skipjack_transit"
	shuttle_area = /area/shuttle/skipjack
	destination_tags = list(
		"skipjack_base",
		"aerostat_south",
		"beach_e",
		"beach_nw",
		"tether_solars_ne",
		"tether_solars_sw",
		"tether_mine_nw",
		"tether_space_NE",
		"tether_space_SE",
		"tether_space_SW",
		"tether_dockarm_d1l" //End of left dockarm
		)
	//docking_controller_tag = ??? doesn't have one?
	announcer = "Automated Traffic Control"
	arrival_message = "Attention. An unregistered vessel is approaching Virgo-3B."
	departure_message = "Attention. A unregistered vessel is now leaving Virgo-3B."
	defer_initialisation = TRUE
	move_direction = NORTH

//////////////////////////////////////////////////////////////
// ERT Shuttle
/datum/shuttle/autodock/multi/specialops
	name = "NDV Phantom"
	can_cloak = TRUE
	cloaked = FALSE
	warmup_time = 8
	move_time = 60
	current_location = "specops_base"
	landmark_transition = "specops_transit"
	shuttle_area = /area/shuttle/specops/centcom
	destination_tags = list(
		"specops_base",
		"aerostat_south",
		"beach_e",
		"beach_nw",
		"tether_solars_ne",
		"tether_solars_sw",
		"tether_mine_nw",
		"tether_space_NE",
		"tether_space_SE",
		"tether_space_SW",
		"tether_dockarm_d1l" //End of left dockarm
		)
	docking_controller_tag = "ert1_control"
	announcer = "Automated Traffic Control"
	arrival_message = "Attention. An NT support vessel is approaching Virgo-3B."
	departure_message = "Attention. A NT support vessel is now leaving Virgo-3B."
	defer_initialisation = TRUE
	move_direction = WEST

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
	move_direction = EAST

/datum/shuttle/autodock/ferry/belter/New()
	move_time = move_time + rand(-5 SECONDS, 5 SECONDS)
	..()

//////////////////////////////////////////////////////////////
// Surface Mining Outpost Shuttle

/datum/shuttle/autodock/ferry/surface_mining_outpost
	name = "Mining Outpost"
	location = FERRY_LOCATION_STATION
	warmup_time = 5
	shuttle_area = /area/shuttle/mining_outpost
	landmark_station = "mining_station"
	landmark_offsite = "mining_outpost"
	docking_controller_tag = "mining_docking"
	move_direction = NORTH

/////Virgo Flyer/////
// The shuttle's 'shuttle' computer
/obj/machinery/computer/shuttle_control/explore/ccboat
	name = "Virgo Flyer control console"
	shuttle_tag = "Virgo Flyer"
	req_one_access = list(access_pilot)

/obj/effect/overmap/visitable/ship/landable/ccboat
	name = "NTV Virgo Flyer"
	desc = "A small shuttle from Central Command."
	vessel_mass = 1000
	vessel_size = SHIP_SIZE_TINY
	shuttle = "Virgo Flyer"
	known = TRUE

// A shuttle lateloader landmark
/obj/effect/shuttle_landmark/shuttle_initializer/ccboat
	name = "Central Command Shuttlepad"
	base_area = /area/shuttle/centcom/ccbay
	base_turf = /turf/simulated/floor/reinforced
	landmark_tag = "cc_shuttlepad"
	docking_controller = "cc_landing_pad"
	shuttle_type = /datum/shuttle/autodock/overmap/ccboat

/datum/shuttle/autodock/overmap/ccboat
	name = "Virgo Flyer"
	current_location = "cc_shuttlepad"
	docking_controller_tag = "ccboat" 
	shuttle_area = /area/shuttle/ccboat
	fuel_consumption = 0
	defer_initialisation = TRUE

/area/shuttle/ccboat
	icon = 'icons/turf/areas_vr.dmi'
	icon_state = "yelwhitri"
	name = "Virgo Flyer"
	requires_power = 0

/area/shuttle/centcom/ccbay
	icon = 'icons/turf/areas_vr.dmi'
	icon_state = "bluwhisqu"
	name = "Central Command Shuttle Bay"
	requires_power = 0
	dynamic_lighting = 0
