//Used to process objects.

SUBSYSTEM_DEF(processing)
	name = "Processing"
	priority = FIRE_PRIORITY_PROCESS
	flags = SS_BACKGROUND|SS_POST_FIRE_TIMING|SS_NO_INIT
	wait = 1 SECONDS

	var/stat_tag = "P" //Used for logging
	var/list/processing = list()
	var/list/currentrun = list()
	var/process_proc = /datum/proc/process

	var/debug_last_thing
	var/debug_original_process_proc // initial() does not work with procs
	var/datum/current_thing

/datum/controller/subsystem/processing/Recover()
	log_debug("[name] subsystem Recover().")
	if(SSprocessing.current_thing)
		log_debug("current_thing was: (\ref[SSprocessing.current_thing])[SSprocessing.current_thing]([SSprocessing.current_thing.type]) - currentrun: [SSprocessing.currentrun.len] vs total: [SSprocessing.processing.len]")
	var/list/old_processing = SSprocessing.processing.Copy()
	for(var/datum/D in old_processing)
		if(CHECK_BITFIELD(D.datum_flags, DF_ISPROCESSING))
			processing |= D

/datum/controller/subsystem/processing/stat_entry()
	..("[stat_tag]:[processing.len]")

/datum/controller/subsystem/processing/fire(resumed = FALSE)
	if (!resumed)
		currentrun = processing.Copy()
	//cache for sanic speed (lists are references anyways)
	var/list/current_run = currentrun

	while(current_run.len)
		current_thing = current_run[current_run.len]
		current_run.len--
		if(QDELETED(current_thing))
			processing -= current_thing
		else if(current_thing.process(wait) == PROCESS_KILL)
			// fully stop so that a future START_PROCESSING will work
			STOP_PROCESSING(src, current_thing)
		if (MC_TICK_CHECK)
			current_thing = null
			return

	current_thing = null

/datum/controller/subsystem/processing/proc/toggle_debug()
	if(!check_rights(R_DEBUG))
		return

	if(debug_original_process_proc)
		process_proc = debug_original_process_proc
		debug_original_process_proc = null
	else
		debug_original_process_proc	= process_proc
		process_proc = /datum/proc/DebugSubsystemProcess

	to_chat(usr, "[name] - Debug mode [debug_original_process_proc ? "en" : "dis"]abled")

/datum/controller/subsystem/processing/proc/log_recent()
	var/msg = "Debug output from the [name] subsystem:\n"
	msg += "- Process subsystems are processed tail-first -\n"
	if(!currentrun || !processing)
		msg += "ERROR: A critical list [currentrun ? "processing" : "currentrun"] is gone!"
		log_game(msg)
		log_world(msg)
		return
	msg += "Lists: current_run: [currentrun.len], processing: [processing.len]\n"

	if(!currentrun.len)
		msg += "!!The subsystem just finished the processing list, and currentrun is empty (or has never run).\n"
		msg += "!!The info below is the tail of processing instead of currentrun.\n"

	var/datum/D = currentrun.len ? currentrun[currentrun.len] : processing[processing.len]
	msg += "Tail entry: [describeThis(D)] (this is likely the item AFTER the problem item)\n"

	var/position = processing.Find(D)
	if(!position)
		msg += "Unable to find context of tail entry in processing list.\n"
	else
		if(position != processing.len)
			var/additional = processing.Find(D, position+1)
			if(additional)
				msg += "WARNING: Tail entry found more than once in processing list! Context is for the first found.\n"
		var/start = clamp(position-2,1,processing.len)
		var/end = clamp(position+2,1,processing.len)
		msg += "2 previous elements, then tail, then 2 next elements of processing list for context:\n"
		msg += "---\n"
		for(var/i in start to end)
			msg += "[describeThis(processing[i])][i == position ? " << TAIL" : ""]\n"
		msg += "---\n"
	log_game(msg)
	log_world(msg)

/datum/controller/subsystem/processing/fail()
	..()
	log_recent()

/datum/controller/subsystem/processing/critfail()
	..()
	log_recent()

/datum/proc/DebugSubsystemProcess(var/wait, var/times_fired, var/datum/controller/subsystem/processing/subsystem)
	subsystem.debug_last_thing = src
	var/start_tick = world.time
	var/start_tick_usage = world.tick_usage
	. = call(src, subsystem.debug_original_process_proc)(wait, times_fired)

	var/tick_time = world.time - start_tick
	var/tick_use_limit = world.tick_usage - start_tick_usage - 100 // Current tick use - starting tick use - 100% (a full tick excess)
	if(tick_time > 0)
		stack_trace("[log_info_line(subsystem.debug_last_thing)] slept during processing. Spent [tick_time] tick\s.")
	if(tick_use_limit > 0)
		stack_trace("[log_info_line(subsystem.debug_last_thing)] took longer than a tick to process. Exceeded with [tick_use_limit]%")

/**
 * This proc is called on a datum on every "cycle" if it is being processed by a subsystem. The time between each cycle is determined by the subsystem's "wait" setting.
 * You can start and stop processing a datum using the START_PROCESSING and STOP_PROCESSING defines.
 *
 * Since the wait setting of a subsystem can be changed at any time, it is important that any rate-of-change that you implement in this proc is multiplied by the seconds_per_tick that is sent as a parameter,
 * Additionally, any "prob" you use in this proc should instead use the SPT_PROB define to make sure that the final probability per second stays the same even if the subsystem's wait is altered.
 * Examples where this must be considered:
 * - Implementing a cooldown timer, use `mytimer -= seconds_per_tick`, not `mytimer -= 1`. This way, `mytimer` will always have the unit of seconds
 * - Damaging a mob, do `L.adjustFireLoss(20 * seconds_per_tick)`, not `L.adjustFireLoss(20)`. This way, the damage per second stays constant even if the wait of the subsystem is changed
 * - Probability of something happening, do `if(SPT_PROB(25, seconds_per_tick))`, not `if(prob(25))`. This way, if the subsystem wait is e.g. lowered, there won't be a higher chance of this event happening per second
 *
 * If you override this do not call parent, as it will return PROCESS_KILL. This is done to prevent objects that dont override process() from staying in the processing list
 */
/datum/proc/process(seconds_per_tick)
	set waitfor = FALSE
	return PROCESS_KILL
