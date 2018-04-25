//
// SSshuttles subsystem - Handles initialization and processing of shuttles.
//

// This global variable exists for legacy support so we don't have to rename every shuttle_controller to SSshuttles yet.
var/global/datum/controller/subsystem/shuttles/shuttle_controller

SUBSYSTEM_DEF(shuttles)
	name = "Shuttles"
	wait = 2 SECONDS
	priority = FIRE_PRIORITY_SHUTTLES
	init_order = INIT_ORDER_SHUTTLES
	flags = SS_KEEP_TIMING|SS_NO_TICK_CHECK
	runlevels = RUNLEVEL_GAME|RUNLEVEL_POSTGAME

	var/list/shuttles = list()	// Maps shuttle tags to shuttle datums, so that they can be looked up.
	var/list/process_shuttles = list()	// Simple list of shuttles, for processing
	var/list/current_run = list() // Shuttles remaining to process this fire() tick
	var/list/docks_init_callbacks // List of callbacks to run when we finish setting up shuttle docks.
	var/docks_initialized = FALSE

/datum/controller/subsystem/shuttles/Initialize(timeofday)
	global.shuttle_controller = src
	setup_shuttle_docks()
	for(var/I in docks_init_callbacks)
		var/datum/callback/cb = I
		cb.InvokeAsync()
	LAZYCLEARLIST(docks_init_callbacks)
	docks_init_callbacks = null
	return ..()

/datum/controller/subsystem/shuttles/fire(resumed = 0)
	do_process_shuttles(resumed)

/datum/controller/subsystem/shuttles/stat_entry()
	var/msg = list()
	msg += "AS:[shuttles.len]|"
	msg += "PS:[process_shuttles.len]|"
	..(jointext(msg, null))

/datum/controller/subsystem/shuttles/proc/do_process_shuttles(resumed = 0)
	if (!resumed)
		src.current_run = process_shuttles.Copy()

	var/list/current_run = src.current_run // Cache for sanic speed
	while(current_run.len)
		var/datum/shuttle/S = current_run[current_run.len]
		current_run.len--
		if(istype(S) && !QDELETED(S))
			if(istype(S, /datum/shuttle/ferry)) // Ferry shuttles get special treatment
				var/datum/shuttle/ferry/F = S
				if(F.process_state || F.always_process)
					F.process()
			else
				S.process()
		else
			process_shuttles -= S
		if(MC_TICK_CHECK)
			return

// This should be called after all the machines and radio frequencies have been properly initialized
/datum/controller/subsystem/shuttles/proc/setup_shuttle_docks()
	// Find all declared shuttle datums and initailize them.
	for(var/shuttle_type in subtypesof(/datum/shuttle))
		var/datum/shuttle/shuttle = shuttle_type
		if(initial(shuttle.category) == shuttle_type)
			continue
		shuttle = new shuttle()
		shuttle.init_docking_controllers()
		shuttle.dock() //makes all shuttles docked to something at round start go into the docked state
		CHECK_TICK

	for(var/obj/machinery/embedded_controller/C in machines)
		if(istype(C.program, /datum/computer/file/embedded_program/docking))
			C.program.tag = null //clear the tags, 'cause we don't need 'em anymore
	docks_initialized = TRUE

// Register a callback that will be invoked once the shuttles have been initialized
/datum/controller/subsystem/shuttles/proc/OnDocksInitialized(datum/callback/cb)
	if(!docks_initialized)
		LAZYADD(docks_init_callbacks, cb)
	else
		cb.InvokeAsync()
