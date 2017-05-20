
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

	//////////////////////////////////////////////////////////////
	// Escape shuttle and pods
	shuttle = new/datum/shuttle/ferry/emergency()
	shuttle.location = 1 // At offsite
	shuttle.warmup_time = 10
	shuttle.area_offsite = locate(/area/shuttle/escape/centcom)
	shuttle.area_station = locate(/area/shuttle/escape/station)
	shuttle.area_transition = locate(/area/shuttle/escape/transit)
	shuttle.docking_controller_tag = "escape_shuttle"
	shuttle.dock_target_station = "escape_dock"
	shuttle.dock_target_offsite = "centcom_dock"
	shuttle.move_time = SHUTTLE_TRANSIT_DURATION_RETURN
	shuttles["Escape"] = shuttle
	process_shuttles += shuttle

	//////////////////////////////////////////////////////////////
	shuttle = new/datum/shuttle/ferry/escape_pod()
	shuttle.location = 0 // At station
	shuttle.warmup_time = 0
	shuttle.area_station = locate(/area/shuttle/large_escape_pod1/station)
	shuttle.area_offsite = locate(/area/shuttle/large_escape_pod1/centcom)
	shuttle.area_transition = locate(/area/shuttle/large_escape_pod1/transit)
	shuttle.docking_controller_tag = "large_escape_pod_1"
	shuttle.dock_target_station = "large_escape_pod_1_berth"
	shuttle.move_time = SHUTTLE_TRANSIT_DURATION_RETURN + rand(-30, 60)	//randomize this so it seems like the pods are being picked up one by one
	process_shuttles += shuttle
	shuttles["Large Escape Pod 1"] = shuttle

	//////////////////////////////////////////////////////////////
	shuttle = new/datum/shuttle/ferry/escape_pod()
	shuttle.location = 0 // At station
	shuttle.warmup_time = 0
	shuttle.area_station = locate(/area/shuttle/large_escape_pod2/station)
	shuttle.area_offsite = locate(/area/shuttle/large_escape_pod2/centcom)
	shuttle.area_transition = locate(/area/shuttle/large_escape_pod2/transit)
	shuttle.docking_controller_tag = "large_escape_pod_2"
	shuttle.dock_target_station = "large_escape_pod_2_berth"
	shuttle.move_time = SHUTTLE_TRANSIT_DURATION_RETURN + rand(-30, 60)	//randomize this so it seems like the pods are being picked up one by one
	process_shuttles += shuttle
	shuttles["Large Escape Pod 2"] = shuttle

	//give the emergency shuttle controller it's shuttles
	emergency_shuttle.shuttle = shuttles["Escape"]
	emergency_shuttle.escape_pods = list(
		shuttles["Large Escape Pod 1"],
		shuttles["Large Escape Pod 2"],
	)

	//////////////////////////////////////////////////////////////
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

	//////////////////////////////////////////////////////////////
	// Trade Ship
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

	//////////////////////////////////////////////////////////////
	// Away Mission Shuttle
	var/datum/shuttle/multi_shuttle/AM = new/datum/shuttle/multi_shuttle()
	AM.legit = 1
	AM.origin = locate(/area/shuttle/awaymission/home)
	AM.start_location = "NSS Adephagia (AM)"

	AM.destinations = list(
		"Old Engineering Base (AM)" = locate(/area/shuttle/awaymission/oldengbase)
		)

	AM.docking_controller_tag = "awaymission_shuttle"
	AM.destination_dock_targets = list(
		"NSS Adephagia (AM)" = "d1a2_dock_airlock"
		)

	var/area/awaym_dest = locate(/area/shuttle/awaymission/away)
	if(awaym_dest.contents.len) //Otherwise this is an empty imaginary area
		AM.destinations["Unknown Location [rand(1000,9999)]"] = awaym_dest

	AM.announcer = "Automated Traffic Control"
	//These seem backwards because they are written from the perspective of the merc and vox ships
	AM.departure_message = "Attention. The away mission vessel is approaching the colony."
	AM.arrival_message = "Attention. The away mission vessel is now leaving from the colony."
	AM.interim = locate(/area/shuttle/awaymission/warp)

	AM.move_time = 60
	AM.warmup_time = 8
	shuttles["AwayMission"] = AM


	// TODO - Not implemented yet on new map
	///////////////////////////////////////////////
	//VOREStation Add - Belter Shuttle
	// shuttle = new/datum/shuttle/ferry()
	// shuttle.location = 0
	// shuttle.warmup_time = 6
	// shuttle.area_station = locate(/area/shuttle/belter/station)
	// shuttle.area_offsite = locate(/area/shuttle/belter/belt/zone1)
	// shuttle.area_transition = locate(/area/shuttle/belter/transit)
	// shuttle.docking_controller_tag = "belter_docking"
	// shuttle.dock_target_station = "belter_nodocking" //Fake tags to prevent the shuttle from opening doors.
	// shuttle.dock_target_offsite = "belter_nodocking"
	// shuttle.transit_direction = EAST
	// shuttle.move_time = 60 + rand(10,40)
	// process_shuttles += shuttle
	// shuttles["Belter"] = shuttle
	//VOREStation Add End - Belter Shuttle

	//////////////////////////////////////////////////////////////
	// Tether Shuttle
	var/datum/shuttle/ferry/tether_backup/TB = new()
	TB.location = 1 // At offsite
	TB.warmup_time = 5
	TB.move_time = 45
	TB.area_offsite = locate(/area/shuttle/tether/surface)
	TB.area_station = locate(/area/shuttle/tether/station)
	TB.area_transition = locate(/area/shuttle/tether/transit)
	TB.crash_areas = list(locate(/area/shuttle/tether/crash1), locate(/area/shuttle/tether/crash2))
	TB.docking_controller_tag = "tether_shuttle"
	TB.dock_target_station = "tether_dock_airlock"
	TB.dock_target_offsite = "tether_pad_airlock"
	shuttles["Tether Backup"] = TB
	process_shuttles += TB

	for(var/obj/structure/shuttle/engine/propulsion/E in TB.area_offsite)
		TB.engines += E
	for(var/obj/machinery/computer/shuttle_control/tether_backup/comp in TB.area_offsite)
		TB.computer = comp
		break


	//////////////////////////////////////////////////////////////
	// Antag Space "Proto Shuttle" Shuttle
	AM = new/datum/shuttle/multi_shuttle()
	AM.docking_controller_tag = "antag_space_shuttle"
	AM.start_location = "Home Base"
	AM.origin = locate(/area/shuttle/antag_space/base)
	AM.interim = locate(/area/shuttle/antag_space/transit)
	AM.destinations = list(
		"Nearby" = locate(/area/shuttle/antag_space/north),
		"Docks" =  locate(/area/shuttle/antag_space/docks)
	)
	AM.destination_dock_targets = list("Home Base" = "antag_space_dock")
	AM.move_time = 60
	AM.warmup_time = 8
	shuttles["Proto"] = AM

	//////////////////////////////////////////////////////////////
	// Antag Surface "Land Crawler" Shuttle
	AM = new/datum/shuttle/multi_shuttle()
	AM.docking_controller_tag = "antag_ground_shuttle"
	AM.start_location = "Home Base"
	AM.origin = locate(/area/shuttle/antag_ground/base)
	AM.interim = locate(/area/shuttle/antag_ground/transit)
	AM.destinations = list(
		"Solar Array" = locate(/area/shuttle/antag_ground/solars),
		"Mining Outpost" =  locate(/area/shuttle/antag_ground/mining)
	)
	AM.destination_dock_targets = list("Home Base" = "antag_ground_dock")
	AM.move_time = 60
	AM.warmup_time = 8
	shuttles["Land Crawler"] = AM
