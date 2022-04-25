//
// Controller handling icon updates of open space turfs
//

GLOBAL_VAR_INIT(open_space_initialised, FALSE)

SUBSYSTEM_DEF(open_space)
	name = "Open Space"
	wait = 0.2 SECONDS
	init_order = INIT_ORDER_OPENSPACE
	var/list/turfs_to_process = list()		// List of turfs queued for update.
	var/list/turfs_to_process_old = null	// List of turfs currently being updated.
	var/counter = 1 // Can't use .len because we need to iterate in order
	var/static/image/over_OS_darkness		// Image overlayed over the bottom turf with stuff in it.

/datum/controller/subsystem/open_space/Initialize(timeofday)
	over_OS_darkness = image('icons/turf/open_space.dmi', "black_open")
	over_OS_darkness.plane = OVER_OPENSPACE_PLANE
	over_OS_darkness.layer = MOB_LAYER
	initialize_open_space()
	// Pre-process open space turfs once before the round starts.
	fire(FALSE, TRUE)

/datum/controller/subsystem/open_space/fire(resumed, no_mc_tick)
	// We use a different list so any additions to the update lists during a delay from MC_TICK_CHECK
	// don't cause things to be cut from the list without being updated.

	//If we're not resuming, this must mean it's a new iteration so we have to grab the turfs
	if (!resumed)
		src.counter = 1
		src.turfs_to_process_old = turfs_to_process
		turfs_to_process = list()

	//cache for sanic speed (lists are references anyways)
	var/list/turfs_to_process_old = src.turfs_to_process_old
	var/counter = src.counter
	while(counter <= turfs_to_process_old.len)
		var/turf/T = turfs_to_process_old[counter]
		counter += 1
		if(!QDELETED(T))
			update_turf(T)
		if (no_mc_tick)
			CHECK_TICK // Used during initialization processing
		else if (MC_TICK_CHECK)
			src.counter = counter // Save for when we're resumed
			return // Used during normal MC processing.

/datum/controller/subsystem/open_space/proc/update_turf(var/turf/T)
	for(var/atom/movable/A in T)
		A.fall()
	T.update_icon()

/datum/controller/subsystem/open_space/proc/add_turf(var/turf/T, var/recursive = 0)
	ASSERT(isturf(T))
	// Check for multiple additions
	// Pointless to process the same turf twice. But we need to push it to the end of the list
	// because any turfs below it need to process first.
	turfs_to_process -= T
	turfs_to_process += T
	if(recursive > 0)
		var/turf/above = GetAbove(T)
		if(above && isopenspace(above))
			add_turf(above, recursive)

// Queue the initial updates of open space turfs when the game starts. This will lag!
/datum/controller/subsystem/open_space/proc/initialize_open_space()
	// Do initial setup from bottom to top.
	for(var/zlevel = 1 to world.maxz)
		for(var/turf/simulated/open/T in block(locate(1, 1, zlevel), locate(world.maxx, world.maxy, zlevel)))
			add_turf(T)
		CHECK_TICK
	GLOB.open_space_initialised = TRUE

/datum/controller/subsystem/open_space/stat_entry(msg_prefix)
	return ..("T [turfs_to_process.len]")

/obj/update_icon()
	. = ..()
	if(GLOB.open_space_initialised && !invisibility && isturf(loc))
		var/turf/T = GetAbove(src)
		if(isopenspace(T))
			// log_debug("[T] ([T.x],[T.y],[T.z]) queued for update for [src].update_icon()")
			SSopen_space.add_turf(T, 1)

// We probably should hook Destroy() If we can think of something more efficient, lets hear it.
/obj/Destroy()
	if(GLOB.open_space_initialised && !invisibility && isturf(loc))
		var/turf/T = GetAbove(src)
		if(isopenspace(T))
			SSopen_space.add_turf(T, 1)
	. = ..() // Important that this be at the bottom, or we will have been moved to nullspace.
