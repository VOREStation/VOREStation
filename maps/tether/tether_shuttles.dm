//////////////////////////////////////////////////////////////
// Escape shuttle and pods
/datum/shuttle/autodock/ferry/emergency/escape/New()
	..()
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
