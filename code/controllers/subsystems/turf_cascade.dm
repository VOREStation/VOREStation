SUBSYSTEM_DEF(turf_cascade)
	name = "Turf Cascade"
	wait = 0.1 SECONDS

	dependencies = list(
		/datum/controller/subsystem/mobs
	)
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	VAR_PRIVATE/list/currentrun = list()

	VAR_PRIVATE/list/pending_turfs = null
	VAR_PRIVATE/turf_replace_type = null // Once set, cannot be unset

/datum/controller/subsystem/turf_cascade/Initialize()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/turf_cascade/Shutdown()
	. = ..()

/datum/controller/subsystem/turf_cascade/stat_entry(msg)
	msg = "Q: [current_queue?.len] | Cr: [currentrun.len] | ty: [turf_replace_type]"
	return ..()

/datum/controller/subsystem/turf_cascade/fire()
	if(!pending_turfs || !turf_replace_type)
		return
	if(!currentrun.len)
		// Swap lists instead of copy, it's a lot faster.
		currentrun = pending_turfs
		pending_turfs = list()

	while(currentrun.len)
		var/turf/changing = currentrun[1]
		currentrun -= changing

		// Convert turf
		changing.ChangeTurf(turf_replace_type)
		var/list/expanding_options = changing.conversion_cascade_act()
		for(var/expand_dir in expanding_options)
			var/turf/next_turf = get_step(changing, expand_dir)
			if(next_turf && next_turf.type != turf_replace_type)
				pending_turfs.Add(next_turf)

		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/turf_cascade/proc/start_cascade(turf/start_turf, turf_path)
	// Once set in motion...
	if(turf_replace_type || pending_turfs || currentrun.len)
		return
	// ... We shall never come to rest.
	pending_turfs = list(start_turf)
	turf_replace_type = turf_path
