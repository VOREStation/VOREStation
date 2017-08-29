//These lists are populated in /datum/shuttle_controller/New()
//Shuttle controller is instantiated in master_controller.dm.

//shuttle moving state defines are in setup.dm

/datum/shuttle
	var/name = ""
	var/warmup_time = 0
	var/moving_status = SHUTTLE_IDLE

	var/docking_controller_tag	//tag of the controller used to coordinate docking
	var/datum/computer/file/embedded_program/docking/docking_controller	//the controller itself. (micro-controller, not game controller)

	var/arrive_time = 0	//the time at which the shuttle arrives when long jumping
	var/flags = SHUTTLE_FLAGS_PROCESS
	var/category = /datum/shuttle

	var/ceiling_type = /turf/unsimulated/floor/shuttle_ceiling

/datum/shuttle/New()
	..()
	if(src.name in shuttle_controller.shuttles)
		CRASH("A shuttle with the name '[name]' is already defined.")
	shuttle_controller.shuttles[src.name] = src
	if(flags & SHUTTLE_FLAGS_PROCESS)
		shuttle_controller.process_shuttles += src
	if(flags & SHUTTLE_FLAGS_SUPPLY)
		if(supply_controller.shuttle)
			CRASH("A supply shuttle is already defined.")
		supply_controller.shuttle = src

/datum/shuttle/Destroy()
	shuttle_controller.shuttles -= src.name
	shuttle_controller.process_shuttles -= src
	if(supply_controller.shuttle == src)
		supply_controller.shuttle = null
	. = ..()

/datum/shuttle/proc/init_docking_controllers()
	if(docking_controller_tag)
		docking_controller = locate(docking_controller_tag)
		if(!istype(docking_controller))
			world << "<span class='danger'>warning: shuttle with docking tag [docking_controller_tag] could not find it's controller!</span>"

// Return false to abort a jump, before the 'warmup' phase.
/datum/shuttle/proc/pre_warmup_checks()
	return TRUE

// Ditto, but for afterwards.
/datum/shuttle/proc/post_warmup_checks()
	return TRUE

/datum/shuttle/proc/short_jump(var/area/origin,var/area/destination)
	if(moving_status != SHUTTLE_IDLE)
		return

	if(!pre_warmup_checks())
		return

	moving_status = SHUTTLE_WARMUP
	spawn(warmup_time*10)

		make_sounds(origin, HYPERSPACE_WARMUP)
		sleep(5 SECONDS) // so the sound finishes.

		if(!post_warmup_checks())
			moving_status = SHUTTLE_IDLE

		if (moving_status == SHUTTLE_IDLE)
			make_sounds(origin, HYPERSPACE_END)
			return	//someone cancelled the launch

		moving_status = SHUTTLE_INTRANSIT //shouldn't matter but just to be safe
		move(origin, destination)
		moving_status = SHUTTLE_IDLE
		make_sounds(destination, HYPERSPACE_END)

/datum/shuttle/proc/long_jump(var/area/departing, var/area/destination, var/area/interim, var/travel_time, var/direction)
	//world << "shuttle/long_jump: departing=[departing], destination=[destination], interim=[interim], travel_time=[travel_time]"
	if(moving_status != SHUTTLE_IDLE)
		return

	if(!pre_warmup_checks())
		return

	//it would be cool to play a sound here
	moving_status = SHUTTLE_WARMUP
	spawn(warmup_time*10)

		make_sounds(departing, HYPERSPACE_WARMUP)
		sleep(5 SECONDS) // so the sound finishes.

		if(!post_warmup_checks())
			moving_status = SHUTTLE_IDLE

		if (moving_status == SHUTTLE_IDLE)
			make_sounds(departing, HYPERSPACE_END)
			return	//someone cancelled the launch

		arrive_time = world.time + travel_time*10
		moving_status = SHUTTLE_INTRANSIT
		move(departing, interim, direction)

		if(process_longjump(departing, destination)) //VOREStation Edit - To hook custom shuttle code in
			return //VOREStation Edit - It handled it for us (shuttle crash or such)

		var/last_progress_sound = 0
		while (world.time < arrive_time)
			// Make the shuttle make sounds every four seconds, since the sound file is five seconds.
			if(last_progress_sound + 4 SECONDS < world.time)
				make_sounds(interim, HYPERSPACE_PROGRESS)
				last_progress_sound = world.time
			sleep(5)

		move(interim, destination, direction)
		moving_status = SHUTTLE_IDLE
		//make_sounds(destination, HYPERSPACE_END) //VOREStation Edit. See above comment.

/datum/shuttle/proc/dock()
	if (!docking_controller)
		return

	var/dock_target = current_dock_target()
	if (!dock_target)
		return

	docking_controller.initiate_docking(dock_target)

/datum/shuttle/proc/undock()
	if (!docking_controller)
		return
	docking_controller.initiate_undocking()

/datum/shuttle/proc/current_dock_target()
	return null

/datum/shuttle/proc/skip_docking_checks()
	if (!docking_controller || !current_dock_target())
		return 1	//shuttles without docking controllers or at locations without docking ports act like old-style shuttles
	return 0

//just moves the shuttle from A to B, if it can be moved
//A note to anyone overriding move in a subtype. move() must absolutely not, under any circumstances, fail to move the shuttle.
//If you want to conditionally cancel shuttle launches, that logic must go in short_jump() or long_jump()
/datum/shuttle/proc/move(var/area/origin, var/area/destination, var/direction=null)

	//world << "move_shuttle() called for [name] leaving [origin] en route to [destination]."

	//world << "area_coming_from: [origin]"
	//world << "destination: [destination]"

	if(origin == destination)
		//world << "cancelling move, shuttle will overlap."
		return

	if (docking_controller && !docking_controller.undocked())
		docking_controller.force_undock()

	var/list/dstturfs = list()
	var/throwy = world.maxy

	for(var/turf/T in destination)
		dstturfs += T
		if(T.y < throwy)
			throwy = T.y

	for(var/turf/T in dstturfs)
		var/turf/D = locate(T.x, throwy - 1, T.z)
		for(var/I in T)
			if(istype(I,/mob/living))
				var/mob/living/L = I
				L.gib()
			else if(istype(I,/obj))
				var/obj/O = I
				O.forceMove(D)

	origin.move_contents_to(destination, direction=direction)

	for(var/mob/M in destination)
		if(M.client)
			spawn(0)
				if(M.buckled)
					M << "<font color='red'>Sudden acceleration presses you into \the [M.buckled]!</font>"
					shake_camera(M, 3, 1)
				else
					M << "<font color='red'>The floor lurches beneath you!</font>"
					shake_camera(M, 10, 1)
		if(istype(M, /mob/living/carbon))
			if(!M.buckled)
				M.Weaken(3)

	// Power-related checks. If shuttle contains power related machinery, update powernets.
	var/update_power = 0
	for(var/obj/machinery/power/P in destination)
		update_power = 1
		break

	for(var/obj/structure/cable/C in destination)
		update_power = 1
		break

	if(update_power)
		makepowernets()
	return

//returns 1 if the shuttle has a valid arrive time
/datum/shuttle/proc/has_arrive_time()
	return (moving_status == SHUTTLE_INTRANSIT)

/datum/shuttle/proc/make_sounds(var/area/A, var/sound_type)
	var/sound_to_play = null
	switch(sound_type)
		if(HYPERSPACE_WARMUP)
			sound_to_play = 'sound/effects/shuttles/hyperspace_begin.ogg'
		if(HYPERSPACE_PROGRESS)
			sound_to_play = 'sound/effects/shuttles/hyperspace_progress.ogg'
		if(HYPERSPACE_END)
			sound_to_play = 'sound/effects/shuttles/hyperspace_end.ogg'
	for(var/obj/machinery/door/E in A)	//dumb, I know, but playing it on the engines doesn't do it justice
		playsound(E, sound_to_play, 50, FALSE)