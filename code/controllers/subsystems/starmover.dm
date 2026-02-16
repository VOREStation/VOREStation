//
// Handles the moving star effects behind overmap shuttles during travel.
//
SUBSYSTEM_DEF(starmover)
	name = "Shuttle Star Movement"
	priority = FIRE_PRIORITY_STARMOVER
	wait = 1 // This needs to be done pretty quickly
	dependencies = list(
		/datum/controller/subsystem/points_of_interest
	)
	var/list/zqueue = list()
	var/list/current_movement = null
	//list used to track which zlevels are being 'moved' by the proc below
	var/list/moving_levels = list()
	var/list/currentrun = null
	var/current_direction = 0

/datum/controller/subsystem/starmover/Initialize()
	return SS_INIT_SUCCESS

#define CR_ZLEVEL 1
#define CR_DIRECTION 2
#define CR_TURFS 3

/datum/controller/subsystem/starmover/fire(resumed)
	// Get next in queue or dropout
	if(!resumed && !current_movement)
		if(!length(zqueue))
			return
		current_movement = zqueue[1]
		zqueue[1] = null
		zqueue -= null
		// Setup data
		var/zlevel = current_movement[CR_ZLEVEL]
		var/new_dir = current_movement[CR_DIRECTION]
		var/list/turf_list = current_movement[CR_TURFS]
		if(!length(turf_list) || moving_levels["[zlevel]"] == new_dir)
			clear_movement_run()
			return
		moving_levels["[zlevel]"] = new_dir
		currentrun = turf_list

	// Has a movement queued, process all turfs
	while(length(currentrun))
		var/turf/space/T = currentrun[length(currentrun)]
		currentrun.len--
		if(istype(T))
			T.toggle_transit(current_movement[CR_DIRECTION])
		if(MC_TICK_CHECK)
			return
	clear_movement_run()

/datum/controller/subsystem/starmover/proc/clear_movement_run()
	current_movement.Cut()
	current_movement = null
	currentrun = null

/datum/controller/subsystem/starmover/stat_entry(msg)
	msg = "Q:[length(zqueue)] C:[currentrun ? length(currentrun) : "-"]"
	return ..()

/// Used to 'move' stars in spess. null direction stops movement
/datum/controller/subsystem/starmover/proc/toggle_move_stars(zlevel, direction)
	if(!zlevel)
		return
	var/list/spaceturfs = block(locate(1, 1, zlevel), locate(world.maxx, world.maxy, zlevel))
	zqueue += list(list(zlevel,direction,spaceturfs))

#undef CR_ZLEVEL
#undef CR_DIRECTION
#undef CR_TURFS
