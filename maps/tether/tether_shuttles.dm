//////////////////////////////////////////////////////////////
// Escape shuttle and pods
/datum/shuttle/autodock/ferry/emergency/escape/New()
	..()
	move_direction = NORTH

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


//////////////////////////////////////////////////////////////
// Supply shuttle
/datum/shuttle/autodock/ferry/supply/cargo/New(_name)
	..()
	move_direction = NORTH

// "Tram" Emergency Shuttler
// Becuase the tram only has its own doors and no corresponding station doors, a docking controller is overkill.
// Just open the gosh darn doors!  Also we avoid having a physical docking controller obj for gameplay reasons.
/datum/shuttle/autodock/ferry/emergency
	var/tag_door_station = "escape_shuttle_hatch_station"
	var/tag_door_offsite = "escape_shuttle_hatch_offsite"

/datum/shuttle/autodock/ferry/emergency/New()
	..()
	move_direction = NORTH

/datum/shuttle/autodock/ferry/emergency/dock()
	..()
	// Open Doorsunes
	var/datum/signal/signal = new
	signal.data["tag"] = location ? tag_door_offsite : tag_door_station
	signal.data["command"] = "secure_open"
	post_signal(signal)

/datum/shuttle/autodock/ferry/emergency/undock()
	..()
	// Close Doorsunes
	var/datum/signal/signal = new
	signal.data["tag"] = location ? tag_door_offsite : tag_door_station
	signal.data["command"] = "secure_close"
	post_signal(signal)

/datum/shuttle/autodock/ferry/emergency/proc/post_signal(datum/signal/signal, var/filter = null)
	signal.transmission_method = TRANSMISSION_RADIO
	if(radio_connection)
		return radio_connection.post_signal(src, signal, filter)
	else
		qdel(signal)

//
// The backup tether shuttle uses experimental engines and can degrade and/or crash!
//
/* //Disabling the crash mechanics per request
/datum/shuttle/ferry/tether_backup
	crash_message = "Tether shuttle distress signal received. Shuttle location is approximately 200 meters from tether base."
	category = /datum/shuttle/ferry/tether_backup // So shuttle_controller.dm doesn't try and instantiate this type as an acutal mapped in shuttle.
	var/list/engines = list()
	var/obj/machinery/computer/shuttle_control/tether_backup/computer

/datum/shuttle/ferry/tether_backup/New()
	..()
	var/area/current_area = get_location_area(location)
	for(var/obj/structure/shuttle/engine/propulsion/E in current_area)
		engines += E
	for(var/obj/machinery/computer/shuttle_control/tether_backup/comp in current_area)
		computer = comp

/datum/shuttle/ferry/tether_backup/process_longjump(var/area/origin, var/area/intended_destination)
	var/failures = engines.len
	for(var/obj/structure/shuttle/engine/E as anything in engines)
		failures -= E.jump()

	#define MOVE_PER(x) move_time*(x/100) SECONDS

	computer.visible_message("[icon2html(computer), viewers(computer)] " + span_notice("Beginning flight and telemetry monitoring."))
	sleep(MOVE_PER(5))

	if(failures >= 1)
		computer.visible_message("[icon2html(computer), viewers(computer)] " + span_warning("Single engine failure, continuing flight."))
		sleep(MOVE_PER(10))

	if(failures >= 2)
		computer.visible_message("[icon2html(computer), viewers(computer)] " + span_warning("Second engine failure, unable to complete flight."))
		playsound(computer,'sound/mecha/internaldmgalarm.ogg',100,0)
		sleep(MOVE_PER(10))
		computer.visible_message("[icon2html(computer), viewers(computer)] " + span_warning("Commencing RTLS abort mode."))
		sleep(MOVE_PER(20))
		if(failures < 3)
			move(area_transition,origin)
			moving_status = SHUTTLE_IDLE
			return 1

	if(failures >= 3)
		computer.visible_message("[icon2html(computer), viewers(computer)] " + span_danger("Total engine failure, unable to complete abort mode."))
		playsound(computer,'sound/mecha/internaldmgalarm.ogg',100,0)
		sleep(MOVE_PER(5))
		computer.visible_message("[icon2html(computer), viewers(computer)] " + span_danger("Distress signal broadcast."))
		playsound(computer,'sound/mecha/internaldmgalarm.ogg',100,0)
		sleep(MOVE_PER(5))
		computer.visible_message("[icon2html(computer), viewers(computer)] " + span_danger("Stall. Stall. Stall. Stall."))
		playsound(computer,'sound/mecha/internaldmgalarm.ogg',100,0)
		sleep(MOVE_PER(5))
		playsound(computer,'sound/mecha/internaldmgalarm.ogg',100,0)
		sleep(MOVE_PER(5))
		computer.visible_message("[icon2html(computer), viewers(computer)] " + span_danger("Terrain! Pull up! Terrain! Pull up!"))
		playsound(computer,'sound/mecha/internaldmgalarm.ogg',100,0)
		playsound(computer,'sound/misc/bloblarm.ogg',100,0)
		sleep(MOVE_PER(10))
		do_crash(area_transition)
		return 1

	return 0

	#undef MOVE_PER
//
// The repairable engines
// TODO - These need a more advanced fixing sequence.
//
/obj/structure/shuttle/engine
	var/wear = 0

/obj/structure/shuttle/engine/proc/jump()
	. = !prob(wear)
	if(!.)
		wear = 100
	else
		wear += rand(5,20)

/obj/structure/shuttle/engine/attackby(obj/item/W as obj, mob/user as mob)
	src.add_fingerprint(user)
	if(repair_welder(user, W))
		return
	return ..()

//TODO require a multitool to diagnose and open engine panels or something

/obj/structure/shuttle/engine/proc/repair_welder(var/mob/user, var/obj/item/weldingtool/WT)
	if(!istype(WT))
		return 0
	if(wear <= 20)
		to_chat(user,span_notice("\The [src] doesn't seem to need repairs right now."))
		return 1
	if(!WT.remove_fuel(0, user))
		to_chat(user,span_warning("\The [WT] must be on to complete this task."))
		return 1
	playsound(src, 'sound/items/Welder.ogg', 50, 1)
	user.visible_message(span_notice("\The [user] begins \the [src] overhaul."),span_notice("You begin an overhaul of \the [src]."))
	if(!do_after(user, wear SECONDS, src))
		return 1
	if(!src || !WT.isOn())
		return 1
	user.visible_message(span_notice("\The [user] has overhauled \the [src]."),span_notice("You complete \the [src] overhaul."))
	wear = 20
	update_icon()
	return 1
*/
