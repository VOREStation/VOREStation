////////////////////////////////////////
// Tether custom shuttle implemnetations
////////////////////////////////////////

/obj/machinery/computer/shuttle_control/tether_backup
	name = "tether backup shuttle control console"
	shuttle_tag = "Tether Backup"
	req_one_access = list()
	ai_control = TRUE

/obj/machinery/computer/shuttle_control/multi/mercenary
	name = "vessel control console"
	shuttle_tag = "Mercenary"
	req_one_access = list(access_syndicate)

/obj/machinery/computer/shuttle_control/multi/ninja
	name = "vessel control console"
	shuttle_tag = "Ninja"
	//req_one_access = list()

/obj/machinery/computer/shuttle_control/multi/specops
	name = "vessel control console"
	shuttle_tag = "NDV Phantom"
	req_one_access = list(access_cent_specops)

/obj/machinery/computer/shuttle_control/multi/trade
	name = "vessel control console"
	shuttle_tag = "Trade"
	req_one_access = list(access_trader)

/obj/machinery/computer/shuttle_control/surface_mining_outpost
	name = "surface mining outpost shuttle control console"
	shuttle_tag = "Mining Outpost"
	req_one_access = list(access_mining)
	ai_control = TRUE

// Large Escape Pod 1
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

////////////////////////////////////////
//////// Excursion Shuttle /////////////
////////////////////////////////////////
// The 'shuttle' of the excursion shuttle
/datum/shuttle/autodock/overmap/excursion
	name = "Excursion Shuttle"
	warmup_time = 0
	current_location = "tether_excursion_hangar"
	docking_controller_tag = "expshuttle_docker"
	shuttle_area = list(/area/shuttle/excursion/cockpit, /area/shuttle/excursion/general, /area/shuttle/excursion/cargo, /area/shuttle/excursion/power)
	fuel_consumption = 3
	move_direction = NORTH

// The 'ship' of the excursion shuttle
/obj/effect/overmap/visitable/ship/landable/excursion
	name = "Excursion Shuttle"
	desc = "The traditional Excursion Shuttle. NT Approved!"
	icon_state = "htu_destroyer_g"
	vessel_mass = 8000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Excursion Shuttle"

/obj/machinery/computer/shuttle_control/explore/excursion
	name = "short jump console"
	shuttle_tag = "Excursion Shuttle"
	req_one_access = list(access_pilot)

////////////////////////////////////////
////////      Tour Bus     /////////////
////////////////////////////////////////
/datum/shuttle/autodock/overmap/tourbus
	name = "Tour Bus"
	warmup_time = 0
	current_location = "tourbus_dock"
	docking_controller_tag = "tourbus_docker"
	shuttle_area = list(/area/shuttle/tourbus/cockpit, /area/shuttle/tourbus/general)
	fuel_consumption = 1
	move_direction = NORTH

// The 'ship' of the excursion shuttle
/obj/effect/overmap/visitable/ship/landable/tourbus
	name = "Tour Bus"
	desc = "A small 'space bus', if you will."
	icon_state = "htu_frigate_g"
	vessel_mass = 2000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Tour Bus"

/obj/machinery/computer/shuttle_control/explore/tourbus
	name = "short jump console"
	shuttle_tag = "Tour Bus"
	req_one_access = list(access_pilot)

////////////////////////////////////////
////////      Medivac      /////////////
////////////////////////////////////////
/datum/shuttle/autodock/overmap/medivac
	name = "Medivac Shuttle"
	warmup_time = 0
	current_location = "tether_medivac_dock"
	docking_controller_tag = "medivac_docker"
	shuttle_area = list(/area/shuttle/medivac/cockpit, /area/shuttle/medivac/general, /area/shuttle/medivac/engines)
	fuel_consumption = 2
	move_direction = EAST

// The 'ship' of the excursion shuttle
/obj/effect/overmap/visitable/ship/landable/medivac
	name = "Medivac Shuttle"
	desc = "A medical evacuation shuttle."
	icon_state = "htu_frigate_g"
	vessel_mass = 4000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Medivac Shuttle"
	fore_dir = EAST

/obj/machinery/computer/shuttle_control/explore/medivac
	name = "short jump console"
	shuttle_tag = "Medivac Shuttle"

////////////////////////////////////////
////////      Securiship   /////////////
////////////////////////////////////////
/datum/shuttle/autodock/overmap/securiship
	name = "Securiship Shuttle"
	warmup_time = 0
	current_location = "tether_securiship_dock"
	docking_controller_tag = "securiship_docker"
	shuttle_area = list(/area/shuttle/securiship/cockpit, /area/shuttle/securiship/general, /area/shuttle/securiship/engines)
	fuel_consumption = 2
	move_direction = NORTH

// The 'ship' of the excursion shuttle
/obj/effect/overmap/visitable/ship/landable/securiship
	name = "Securiship Shuttle"
	desc = "A security transport ship."
	icon_state = "htu_frigate_g"
	vessel_mass = 4000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Securiship Shuttle"
	fore_dir = EAST

/obj/machinery/computer/shuttle_control/explore/securiship
	name = "short jump console"
	shuttle_tag = "Securiship Shuttle"

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
