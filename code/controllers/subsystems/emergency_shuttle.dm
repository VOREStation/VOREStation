//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

// Controls the emergency shuttle
SUBSYSTEM_DEF(emergency_shuttle)
	can_fire = FALSE
	name = "Emergency Shuttle"
	wait =  1 SECOND
	runlevels = RUNLEVEL_GAME
	init_stage = INITSTAGE_LAST
	flags = SS_KEEP_TIMING

	var/datum/shuttle/autodock/ferry/emergency/shuttle // Set in shuttle_emergency.dm TODO - is it really?
	var/list/escape_pods = list()

	var/launch_time				//the time at which the shuttle will be launched
	var/auto_recall = FALSE		//if set, the shuttle will be auto-recalled
	var/evac = FALSE			//1 = emergency evacuation, 0 = crew transfer
	var/wait_for_launch = FALSE	//if the shuttle is waiting to launch
	var/autopilot = TRUE		//set to 0 to disable the shuttle automatically launching

	var/deny_shuttle = FALSE	//allows admins to prevent the shuttle from being called
	var/departed = FALSE		//if the shuttle has left the station at least once

	VAR_PRIVATE/auto_recall_time		//the time at which the shuttle will be auto-recalled
	VAR_PRIVATE/datum/announcement/priority/emergency_shuttle_docked
	VAR_PRIVATE/datum/announcement/priority/emergency_shuttle_called
	VAR_PRIVATE/datum/announcement/priority/emergency_shuttle_recalled
	VAR_PRIVATE/list/current_run

/datum/controller/subsystem/emergency_shuttle/Initialize()
	emergency_shuttle_docked = new(0, new_sound = sound('sound/AI/shuttledock.ogg'))
	emergency_shuttle_called = new(0, new_sound = sound('sound/AI/shuttlecalled.ogg'))
	emergency_shuttle_recalled = new(0, new_sound = sound('sound/AI/shuttlerecalled.ogg'))
	return SS_INIT_SUCCESS

/datum/controller/subsystem/emergency_shuttle/fire(resumed)
	if(!resumed)
		if(!wait_for_launch)
			return

		if(evac && auto_recall && world.time >= auto_recall_time)
			recall()
		if(world.time >= launch_time)	//time to launch the shuttle
			stop_launch_countdown()

			if(!shuttle.location)	//leaving from the station
				//launch the pods!
				current_run = escape_pods.Copy()

			if(autopilot)
				shuttle.launch(src)

	while(length(current_run))
		if(MC_TICK_CHECK)
			return
		var/escape_pod = current_run[length(current_run)]
		current_run.len--
		var/datum/shuttle/autodock/ferry/escape_pod/pod = escape_pods[escape_pod]
		if(!istype(pod, /datum/shuttle/autodock/ferry/escape_pod))
			continue
		if(!pod.arming_controller || pod.arming_controller.armed)
			pod.launch(src)

//called when the shuttle has arrived.

/datum/controller/subsystem/emergency_shuttle/proc/shuttle_arrived()
	if(shuttle.location)	//at station
		return

	if(autopilot)
		set_launch_countdown(SHUTTLE_LEAVETIME)	//get ready to return
		var/estimated_time = round(estimate_launch_time()/60,1)

		if(evac)
			emergency_shuttle_docked.Announce(replacetext(replacetext(using_map.emergency_shuttle_docked_message, "%dock_name%", "[using_map.dock_name]"),  "%ETD%", "[estimated_time] minute\s"))
		else
			GLOB.priority_announcement.Announce(replacetext(replacetext(using_map.shuttle_docked_message, "%dock_name%", "[using_map.dock_name]"),  "%ETD%", "[estimated_time] minute\s"), "Transfer System", 'sound/AI/tramarrived.ogg') //VOREStation Edit - TTS

	//arm the escape pods
	if(!evac)
		return

	for(var/key, value in escape_pods)
		var/datum/shuttle/autodock/ferry/escape_pod/pod = value
		if(!istype(pod, /datum/shuttle/autodock/ferry/escape_pod))
			continue
		if(pod.arming_controller)
			pod.arming_controller.arm()

//begins the launch countdown and sets the amount of time left until launch
/datum/controller/subsystem/emergency_shuttle/proc/set_launch_countdown(var/seconds)
	wait_for_launch = TRUE
	launch_time = world.time + (seconds * 10)
	can_fire = TRUE
	next_fire = world.time + wait

/datum/controller/subsystem/emergency_shuttle/proc/stop_launch_countdown()
	can_fire = FALSE
	wait_for_launch = FALSE

//calls the shuttle for an emergency evacuation
/datum/controller/subsystem/emergency_shuttle/proc/call_evac()
	if(!can_call())
		return

	//set the launch timer
	autopilot = TRUE
	set_launch_countdown(get_shuttle_prep_time())
	auto_recall_time = rand(world.time + 300, launch_time - 300)

	//reset the shuttle transit time if we need to
	shuttle.move_time = SHUTTLE_TRANSIT_DURATION
	var/estimated_time = round(estimate_arrival_time()/60, 1)

	evac = TRUE
	emergency_shuttle_called.Announce(replacetext(using_map.emergency_shuttle_called_message, "%ETA%", "[estimated_time] minute\s"))
	for(var/type, area in GLOB.areas_by_type)
		if(istype(area, /area/hallway))
			var/area/hallway/our_hallway = area
			our_hallway.readyalert()

	SSatc.reroute_traffic(yes = 1)

//calls the shuttle for a routine crew transfer
/datum/controller/subsystem/emergency_shuttle/proc/call_transfer()
	if(!can_call())
		return

	//set the launch timer
	autopilot = TRUE
	set_launch_countdown(get_shuttle_prep_time())
	auto_recall_time = rand(world.time + 300, launch_time - 300)

	//reset the shuttle transit time if we need to
	shuttle.move_time = SHUTTLE_TRANSIT_DURATION
	var/estimated_time = round(estimate_arrival_time()/60, 1)

	GLOB.priority_announcement.Announce(replacetext(replacetext(using_map.shuttle_called_message, "%dock_name%", "[using_map.dock_name]"),  "%ETA%", "[estimated_time] minute\s"), "Transfer System", 'sound/AI/tramcalled.ogg')
	SSatc.shift_ending()

//recalls the shuttle
/datum/controller/subsystem/emergency_shuttle/proc/recall()
	if(!can_recall())
		return

	stop_launch_countdown()
	shuttle.cancel_launch(src)

	if(evac)
		emergency_shuttle_recalled.Announce(using_map.emergency_shuttle_recall_message)

		for(var/type, area in GLOB.areas_by_type)
			if(istype(area, /area/hallway))
				var/area/hallway/our_hallway = area
				our_hallway.readyreset()
		evac = FALSE
		return
	GLOB.priority_announcement.Announce(using_map.shuttle_recall_message)

/datum/controller/subsystem/emergency_shuttle/proc/can_call()
	if(!GLOB.universe.OnShuttleCall(null))
		return FALSE
	if(deny_shuttle)
		return FALSE
	if(shuttle.moving_status != SHUTTLE_IDLE || !shuttle.location)	//must be idle at centcom
		return FALSE
	if(wait_for_launch)	//already launching
		return FALSE
	return TRUE

//this only returns 0 if it would absolutely make no sense to recall
//e.g. the shuttle is already at the station or wasn't called to begin with
//other reasons for the shuttle not being recallable should be handled elsewhere
/datum/controller/subsystem/emergency_shuttle/proc/can_recall()
	if(shuttle.moving_status == SHUTTLE_INTRANSIT)	//if the shuttle is already in transit then it's too late
		return FALSE
	if(!shuttle.location)	//already at the station.
		return FALSE
	if(!wait_for_launch)	//we weren't going anywhere, anyways...
		return FALSE
	return TRUE

/datum/controller/subsystem/emergency_shuttle/proc/get_shuttle_prep_time()
	// During mutiny rounds, the shuttle takes twice as long.
	if(SSticker && SSticker.mode)
		return SHUTTLE_PREPTIME * SSticker.mode.shuttle_delay
	return SHUTTLE_PREPTIME


/*
	These procs are not really used by the controller itself, but are for other parts of the
	game whose logic depends on the emergency shuttle.
*/

//returns 1 if the shuttle is docked at the station and waiting to leave
/datum/controller/subsystem/emergency_shuttle/proc/waiting_to_leave()
	if(shuttle.location)
		return FALSE	//not at station
	return (wait_for_launch || shuttle.moving_status != SHUTTLE_INTRANSIT)

//so we don't have SSemergency_shuttle.shuttle.location everywhere
/datum/controller/subsystem/emergency_shuttle/proc/location()
	if(!shuttle)
		return 1 	//if we dont have a shuttle datum, just act like it's at centcom
	return shuttle.location

//returns the time left until the shuttle arrives at it's destination, in seconds
/datum/controller/subsystem/emergency_shuttle/proc/estimate_arrival_time()
	var/eta
	if(shuttle.has_arrive_time())
		//we are in transition and can get an accurate ETA
		eta = shuttle.arrive_time
	else
		//otherwise we need to estimate the arrival time using the scheduled launch time
		eta = launch_time + (shuttle.move_time * 10) + (shuttle.warmup_time * 10)
	return (eta - world.time) / 10

//returns the time left until the shuttle launches, in seconds
/datum/controller/subsystem/emergency_shuttle/proc/estimate_launch_time()
	return (launch_time - world.time) / 10

/datum/controller/subsystem/emergency_shuttle/proc/has_eta()
	return (wait_for_launch || shuttle.moving_status != SHUTTLE_IDLE)

//returns 1 if the shuttle has gone to the station and come back at least once,
//used for game completion checking purposes
/datum/controller/subsystem/emergency_shuttle/proc/returned()
	return (departed && shuttle.moving_status == SHUTTLE_IDLE && shuttle.location)	//we've gone to the station at least once, no longer in transit and are idle back at centcom

//returns 1 if the shuttle is not idle at centcom
/datum/controller/subsystem/emergency_shuttle/proc/online()
	if(!shuttle)
		return FALSE
	if(!shuttle.location)	//not at centcom
		return TRUE
	if(wait_for_launch || shuttle.moving_status != SHUTTLE_IDLE)
		return TRUE
	return FALSE

//returns 1 if the shuttle is currently in transit (or just leaving) to the station
/datum/controller/subsystem/emergency_shuttle/proc/going_to_station()
	return shuttle && (!shuttle.direction && shuttle.moving_status != SHUTTLE_IDLE)

//returns 1 if the shuttle is currently in transit (or just leaving) to centcom
/datum/controller/subsystem/emergency_shuttle/proc/going_to_centcom()
	return shuttle && (shuttle.direction && shuttle.moving_status != SHUTTLE_IDLE)

/datum/controller/subsystem/emergency_shuttle/proc/get_status_panel_eta()
	if(online())
		if(shuttle.has_arrive_time())
			var/timeleft = SSemergency_shuttle.estimate_arrival_time()
			return "ETA-[(timeleft / 60) % 60]:[add_zero(num2text(timeleft % 60), 2)]"

		if(waiting_to_leave())
			if(shuttle.moving_status == SHUTTLE_WARMUP)
				return "Departing..."

			var/timeleft = SSemergency_shuttle.estimate_launch_time()
			return "ETD-[(timeleft / 60) % 60]:[add_zero(num2text(timeleft % 60), 2)]"

	return ""
