
var/global/datum/shuttle_controller/shuttle_controller


/datum/shuttle_controller
	var/list/shuttles	//maps shuttle tags to shuttle datums, so that they can be looked up.
	var/list/process_shuttles	//simple list of shuttles, for processing

/datum/shuttle_controller/proc/process()
	//process ferry shuttles
	for (var/datum/shuttle/ferry/shuttle in process_shuttles)
		if (shuttle.process_state)
			shuttle.process()


//This is called by gameticker after all the machines and radio frequencies have been properly initialized
/datum/shuttle_controller/proc/setup_shuttle_docks()
	for(var/shuttle_tag in shuttles)
		var/datum/shuttle/shuttle = shuttles[shuttle_tag]
		shuttle.init_docking_controllers()
		shuttle.dock() //makes all shuttles docked to something at round start go into the docked state

	for(var/obj/machinery/embedded_controller/C in machines)
		if(istype(C.program, /datum/computer/file/embedded_program/docking))
			C.program.tag = null //clear the tags, 'cause we don't need 'em anymore

/datum/shuttle_controller/New()
	shuttles = list()
	process_shuttles = list()

	var/datum/shuttle/ferry/shuttle

	// Escape shuttle and pods
	shuttle = new/datum/shuttle/ferry/emergency()
	shuttle.location = 1
	shuttle.warmup_time = 10
	shuttle.area_offsite = locate(/area/shuttle/escape/centcom)
	shuttle.area_station = locate(/area/shuttle/escape/station)
	shuttle.area_transition = locate(/area/shuttle/escape/transit)
	shuttle.docking_controller_tag = "escape_shuttle"
	shuttle.dock_target_station = "escape_dock"
	shuttle.dock_target_offsite = "centcom_dock"
	shuttle.transit_direction = NORTH
	shuttle.move_time = SHUTTLE_TRANSIT_DURATION_RETURN
	//shuttle.docking_controller_tag = "supply_shuttle"
	//shuttle.dock_target_station = "cargo_bay"
	shuttles["Escape"] = shuttle
	process_shuttles += shuttle

	shuttle = new/datum/shuttle/ferry/escape_pod()
	shuttle.location = 0
	shuttle.warmup_time = 0
	shuttle.area_station = locate(/area/shuttle/escape_pod1/station)
	shuttle.area_offsite = locate(/area/shuttle/escape_pod1/centcom)
	shuttle.area_transition = locate(/area/shuttle/escape_pod1/transit)
	shuttle.docking_controller_tag = "escape_pod_1"
	shuttle.dock_target_station = "escape_pod_1_berth"
	shuttle.dock_target_offsite = "escape_pod_1_recovery"
	shuttle.transit_direction = NORTH
	shuttle.move_time = SHUTTLE_TRANSIT_DURATION_RETURN + rand(-30, 60)	//randomize this so it seems like the pods are being picked up one by one
	process_shuttles += shuttle
	shuttles["Escape Pod 1"] = shuttle

	shuttle = new/datum/shuttle/ferry/escape_pod()
	shuttle.location = 0
	shuttle.warmup_time = 0
	shuttle.area_station = locate(/area/shuttle/escape_pod2/station)
	shuttle.area_offsite = locate(/area/shuttle/escape_pod2/centcom)
	shuttle.area_transition = locate(/area/shuttle/escape_pod2/transit)
	shuttle.docking_controller_tag = "escape_pod_2"
	shuttle.dock_target_station = "escape_pod_2_berth"
	shuttle.dock_target_offsite = "escape_pod_2_recovery"
	shuttle.transit_direction = NORTH
	shuttle.move_time = SHUTTLE_TRANSIT_DURATION_RETURN + rand(-30, 60)	//randomize this so it seems like the pods are being picked up one by one
	process_shuttles += shuttle
	shuttles["Escape Pod 2"] = shuttle

	shuttle = new/datum/shuttle/ferry/escape_pod()
	shuttle.location = 0
	shuttle.warmup_time = 0
	shuttle.area_station = locate(/area/shuttle/escape_pod3/station)
	shuttle.area_offsite = locate(/area/shuttle/escape_pod3/centcom)
	shuttle.area_transition = locate(/area/shuttle/escape_pod3/transit)
	shuttle.docking_controller_tag = "escape_pod_3"
	shuttle.dock_target_station = "escape_pod_3_berth"
	shuttle.dock_target_offsite = "escape_pod_3_recovery"
	shuttle.transit_direction = NORTH
	shuttle.move_time = SHUTTLE_TRANSIT_DURATION_RETURN + rand(-30, 60)	//randomize this so it seems like the pods are being picked up one by one
	process_shuttles += shuttle
	shuttles["Escape Pod 3"] = shuttle

	shuttle = new/datum/shuttle/ferry/escape_pod()
	shuttle.location = 0
	shuttle.warmup_time = 0
	shuttle.area_station = locate(/area/shuttle/escape_pod4/station)
	shuttle.area_offsite = locate(/area/shuttle/escape_pod4/centcom)
	shuttle.area_transition = locate(/area/shuttle/escape_pod4/transit)
	shuttle.docking_controller_tag = "escape_pod_4"
	shuttle.dock_target_station = "escape_pod_4_berth"
	shuttle.dock_target_offsite = "escape_pod_4_recovery"
	shuttle.transit_direction = NORTH //should this be SOUTH? I have no idea.
	shuttle.move_time = SHUTTLE_TRANSIT_DURATION_RETURN + rand(-30, 60)	//randomize this so it seems like the pods are being picked up one by one
	process_shuttles += shuttle
	shuttles["Escape Pod 4"] = shuttle

	shuttle = new/datum/shuttle/ferry/escape_pod()
	shuttle.location = 0
	shuttle.warmup_time = 0
	shuttle.area_station = locate(/area/shuttle/escape_pod5/station)
	shuttle.area_offsite = locate(/area/shuttle/escape_pod5/centcom)
	shuttle.area_transition = locate(/area/shuttle/escape_pod5/transit)
	shuttle.docking_controller_tag = "escape_pod_5"
	shuttle.dock_target_station = "escape_pod_5_berth"
	shuttle.dock_target_offsite = "escape_pod_5_recovery"
	shuttle.transit_direction = NORTH //should this be WEST? I have no idea.
	shuttle.move_time = SHUTTLE_TRANSIT_DURATION_RETURN + rand(-30, 60)	//randomize this so it seems like the pods are being picked up one by one
	process_shuttles += shuttle
	shuttles["Escape Pod 5"] = shuttle

	shuttle = new/datum/shuttle/ferry/escape_pod()
	shuttle.location = 0
	shuttle.warmup_time = 0
	shuttle.area_station = locate(/area/shuttle/escape_pod6/station)
	shuttle.area_offsite = locate(/area/shuttle/escape_pod6/centcom)
	shuttle.area_transition = locate(/area/shuttle/escape_pod6/transit)
	shuttle.docking_controller_tag = "escape_pod_6"
	shuttle.dock_target_station = "escape_pod_6_berth"
	shuttle.dock_target_offsite = "escape_pod_6_recovery"
	shuttle.transit_direction = NORTH //should this be WEST? I have no idea.
	shuttle.move_time = SHUTTLE_TRANSIT_DURATION_RETURN + rand(-30, 60)	//randomize this so it seems like the pods are being picked up one by one
	process_shuttles += shuttle
	shuttles["Escape Pod 6"] = shuttle

	shuttle = new/datum/shuttle/ferry/escape_pod()
	shuttle.location = 0
	shuttle.warmup_time = 0
	shuttle.area_station = locate(/area/shuttle/cryo/station)
	shuttle.area_offsite = locate(/area/shuttle/cryo/centcom)
	shuttle.area_transition = locate(/area/shuttle/cryo/transit)
	shuttle.docking_controller_tag = "cryostorage_shuttle"
	shuttle.dock_target_station = "cryostorage_shuttle_berth"
	shuttle.dock_target_offsite = "cryostorage_shuttle_recovery"
	shuttle.transit_direction = NORTH //should this be WEST? I have no idea.
	shuttle.move_time = SHUTTLE_TRANSIT_DURATION_RETURN + rand(-30, 60)	//randomize this so it seems like the pods are being picked up one by one
	process_shuttles += shuttle
	shuttles["Cryostorage Shuttle"] = shuttle

	shuttle = new/datum/shuttle/ferry/escape_pod()
	shuttle.location = 0
	shuttle.warmup_time = 0
	shuttle.area_station = locate(/area/shuttle/large_escape_pod1/station)
	shuttle.area_offsite = locate(/area/shuttle/large_escape_pod1/centcom)
	shuttle.area_transition = locate(/area/shuttle/large_escape_pod1/transit)
	shuttle.docking_controller_tag = "large_escape_pod_1"
	shuttle.dock_target_station = "large_escape_pod_1_berth"
	shuttle.dock_target_offsite = "large_escape_pod_1_recovery"
	shuttle.transit_direction = EAST //should this be WEST? I have no idea.
	shuttle.move_time = SHUTTLE_TRANSIT_DURATION_RETURN + rand(-30, 60)	//randomize this so it seems like the pods are being picked up one by one
	process_shuttles += shuttle
	shuttles["Large Escape Pod 1"] = shuttle

	shuttle = new/datum/shuttle/ferry/escape_pod()
	shuttle.location = 0
	shuttle.warmup_time = 0
	shuttle.area_station = locate(/area/shuttle/large_escape_pod2/station)
	shuttle.area_offsite = locate(/area/shuttle/large_escape_pod2/centcom)
	shuttle.area_transition = locate(/area/shuttle/large_escape_pod2/transit)
	shuttle.docking_controller_tag = "large_escape_pod_2"
	shuttle.dock_target_station = "large_escape_pod_2_berth"
	shuttle.dock_target_offsite = "large_escape_pod_2_recovery"
	shuttle.transit_direction = EAST //should this be WEST? I have no idea.
	shuttle.move_time = SHUTTLE_TRANSIT_DURATION_RETURN + rand(-30, 60)	//randomize this so it seems like the pods are being picked up one by one
	process_shuttles += shuttle
	shuttles["Large Escape Pod 2"] = shuttle

	//give the emergency shuttle controller it's shuttles
	emergency_shuttle.shuttle = shuttles["Escape"]
	emergency_shuttle.escape_pods = list(
		shuttles["Escape Pod 1"],
		shuttles["Escape Pod 2"],
		shuttles["Escape Pod 3"],
		shuttles["Escape Pod 4"],
		shuttles["Escape Pod 5"],
		shuttles["Escape Pod 6"],
		shuttles["Cryostorage Shuttle"],
		shuttles["Large Escape Pod 1"],
		shuttles["Large Escape Pod 2"],
	)

	// Supply shuttle
	shuttle = new/datum/shuttle/ferry/supply()
	shuttle.location = 1
	shuttle.warmup_time = 10
	shuttle.area_offsite = locate(/area/supply/dock)
	shuttle.area_station = locate(/area/supply/station)
	shuttle.docking_controller_tag = "supply_shuttle"
	shuttle.dock_target_station = "cargo_bay"
	shuttles["Supply"] = shuttle
	process_shuttles += shuttle

	supply_controller.shuttle = shuttle

	// Admin shuttles.
	shuttle = new()
	shuttle.location = 1
	shuttle.warmup_time = 10
	shuttle.area_offsite = locate(/area/shuttle/transport1/centcom)
	shuttle.area_station = locate(/area/shuttle/transport1/station)
	shuttle.docking_controller_tag = "centcom_shuttle"
	shuttle.dock_target_station = "centcom_shuttle_dock_airlock"
	shuttle.dock_target_offsite = "centcom_shuttle_bay"
	shuttles["Centcom"] = shuttle
	process_shuttles += shuttle

	shuttle = new()
	shuttle.location = 1
	shuttle.warmup_time = 10	//want some warmup time so people can cancel.
	shuttle.area_offsite = locate(/area/shuttle/administration/centcom)
	shuttle.area_station = locate(/area/shuttle/administration/station)
	shuttle.docking_controller_tag = "admin_shuttle"
	shuttle.dock_target_station = "admin_shuttle_dock_airlock"
	shuttle.dock_target_offsite = "admin_shuttle_bay"
	shuttles["Administration"] = shuttle
	process_shuttles += shuttle

	shuttle = new()
	shuttle.location = 1
	shuttle.warmup_time = 10	//want some warmup time so people can cancel.
	shuttle.area_offsite = locate(/area/shuttle/trade/centcom)
	shuttle.area_station = locate(/area/shuttle/trade/station)
	shuttle.docking_controller_tag = "trade_shuttle"
	shuttle.dock_target_station = "trade_shuttle_dock_airlock"
	shuttle.dock_target_offsite = "trade_shuttle_bay"
	shuttles["Trade"] = shuttle
	process_shuttles += shuttle

	shuttle = new()
	shuttle.area_offsite = locate(/area/shuttle/alien/base)
	shuttle.area_station = locate(/area/shuttle/alien/mine)
	shuttles["Alien"] = shuttle
	//process_shuttles += shuttle	//don't need to process this. It can only be moved using admin magic anyways.

	// Public shuttles
	shuttle = new()
	shuttle.warmup_time = 10
	shuttle.area_offsite = locate(/area/shuttle/constructionsite/site)
	shuttle.area_station = locate(/area/shuttle/constructionsite/station)
	shuttle.docking_controller_tag = "engineering_shuttle"
	shuttle.dock_target_station = "engineering_dock_airlock"
	shuttle.dock_target_offsite = "edock_airlock"
	shuttles["Engineering"] = shuttle
	process_shuttles += shuttle

	shuttle = new()
	shuttle.warmup_time = 10
	shuttle.area_offsite = locate(/area/shuttle/mining/outpost)
	shuttle.area_station = locate(/area/shuttle/mining/station)
	shuttle.docking_controller_tag = "mining_shuttle"
	shuttle.dock_target_station = "mining_dock_airlock"
	shuttle.dock_target_offsite = "mining_outpost_airlock"
	shuttles["Mining"] = shuttle
	process_shuttles += shuttle

	shuttle = new()
	shuttle.warmup_time = 10
	shuttle.area_offsite = locate(/area/shuttle/research/outpost)
	shuttle.area_station = locate(/area/shuttle/research/station)
	shuttle.docking_controller_tag = "research_shuttle"
	shuttle.dock_target_station = "research_dock_airlock"
	shuttle.dock_target_offsite = "research_outpost_dock"
	shuttles["Research"] = shuttle
	process_shuttles += shuttle

	// ERT Shuttle
	var/datum/shuttle/ferry/multidock/specops/ERT = new()
	ERT.location = 0
	ERT.warmup_time = 10
	ERT.area_offsite = locate(/area/shuttle/specops/station)	//centcom is the home station, the player station is offsite
	ERT.area_station = locate(/area/shuttle/specops/centcom)
	ERT.docking_controller_tag = "specops_shuttle_port"
	ERT.docking_controller_tag_station = "specops_shuttle_port"
	ERT.docking_controller_tag_offsite = "specops_shuttle_fore"
	ERT.dock_target_station = "specops_centcom_dock"
	ERT.dock_target_offsite = "specops_dock_airlock"
	shuttles["Special Operations"] = ERT
	process_shuttles += ERT

	//Skipjack.
	var/datum/shuttle/multi_shuttle/VS = new/datum/shuttle/multi_shuttle()
	VS.origin = locate(/area/skipjack_station/start)

	VS.destinations = list(
		"Fore Starboard Solars" = locate(/area/skipjack_station/northeast_solars),
		"Fore Port Solars" = locate(/area/skipjack_station/northwest_solars),
		"Aft Starboard Solars" = locate(/area/skipjack_station/southeast_solars),
		"Aft Port Solars" = locate(/area/skipjack_station/southwest_solars), // Vorestation edit
		"[station_short] Arrivals Dock" = locate(/area/skipjack_station/southwest_solars),
		"Mining Station" = locate(/area/skipjack_station/mining)
		)

	VS.announcer = "Colony Automated Radar Array"
	VS.arrival_message = "Attention.  Unidentified object approaching the colony."
	VS.departure_message = "Attention.  Unidentified object exiting local space.  Unidentified object expected to escape Virgo-3's gravity well with current velocity." // Vorestation edit
	VS.interim = locate(/area/skipjack_station/transit)

	VS.warmup_time = 0
	shuttles["Skipjack"] = VS

	//Nuke Ops shuttle.
	var/datum/shuttle/multi_shuttle/MS = new/datum/shuttle/multi_shuttle()
	MS.origin = locate(/area/syndicate_station/start)
	MS.start_location = "Mercenary Base"

	MS.destinations = list(
		"Northwest of the station" = locate(/area/syndicate_station/northwest),
		"North of the station" = locate(/area/syndicate_station/north),
		"Northeast of the station" = locate(/area/syndicate_station/northeast),
		"Southwest of the station" = locate(/area/syndicate_station/southwest),
		"South of the station" = locate(/area/syndicate_station/south),
		"Southeast of the station" = locate(/area/syndicate_station/southeast),
		"Telecomms Satellite" = locate(/area/syndicate_station/commssat),
		"Mining Station" = locate(/area/syndicate_station/mining),
		"Arrivals dock" = locate(/area/syndicate_station/arrivals_dock),
		)

	MS.docking_controller_tag = "merc_shuttle"
	MS.destination_dock_targets = list(
		"Mercenary Base" = "merc_base",
		"Arrivals dock" = "nuke_shuttle_dock_airlock",
		)

	MS.announcer = "Automated Traffic Control"
	MS.arrival_message = "Attention.  A vessel is approaching the colony."
	MS.departure_message = "Attention.  A vessel is now leaving from the colony."
	MS.interim = locate(/area/syndicate_station/transit)

	MS.warmup_time = 0
	shuttles["Mercenary"] = MS

