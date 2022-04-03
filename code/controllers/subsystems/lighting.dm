SUBSYSTEM_DEF(lighting)
	name = "Lighting"
<<<<<<< HEAD
	wait = 2
=======
	wait = 2  // SS_TICKER - Ticks
>>>>>>> a42e6b34466... Merge pull request #8497 from Spookerton/spkrtn/sys/30-inch-racks-01
	init_order = INIT_ORDER_LIGHTING
	flags = SS_TICKER
	var/static/list/sources_queue = list() // List of lighting sources queued for update.
	var/static/list/corners_queue = list() // List of lighting corners queued for update.
	var/static/list/objects_queue = list() // List of lighting objects queued for update.

/datum/controller/subsystem/lighting/stat_entry(msg)
	msg = "L:[length(sources_queue)]|C:[length(corners_queue)]|O:[length(objects_queue)]"
	return ..()


/datum/controller/subsystem/lighting/Initialize(timeofday)
	if(!subsystem_initialized)
		if (config.starlight)
			for(var/area/A in world)
				if (A.dynamic_lighting == DYNAMIC_LIGHTING_IFSTARLIGHT)
					A.luminosity = 0

		subsystem_initialized = TRUE
		create_all_lighting_objects()

	fire(FALSE, TRUE)

	return ..()

<<<<<<< HEAD
/datum/controller/subsystem/lighting/fire(resumed, init_tick_checks)
	MC_SPLIT_TICK_INIT(3)
	if(!init_tick_checks)
		MC_SPLIT_TICK
	var/list/queue = sources_queue
	var/i = 0
	for (i in 1 to length(queue))
		var/datum/light_source/L = queue[i]

		L.update_corners()

		L.needs_update = LIGHTING_NO_UPDATE

		if(init_tick_checks)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			break
	if (i)
		queue.Cut(1, i+1)
		i = 0

	if(!init_tick_checks)
		MC_SPLIT_TICK

	queue = corners_queue
	for (i in 1 to length(queue))
		var/datum/lighting_corner/C = queue[i]

		C.needs_update = FALSE //update_objects() can call qdel if the corner is storing no data
		C.update_objects()
		
		if(init_tick_checks)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			break
	if (i)
		queue.Cut(1, i+1)
		i = 0


	if(!init_tick_checks)
		MC_SPLIT_TICK

	queue = objects_queue
	for (i in 1 to length(queue))
		var/datum/lighting_object/O = queue[i]

		if (QDELETED(O))
			continue

		O.update()
=======
/datum/controller/subsystem/lighting/fire(resumed, no_mc_tick)
	var/timer
	if(!resumed)
		// Santity checks to make sure we don't somehow have items left over from last cycle
		// Or somehow didn't finish all the steps from last cycle
		if(LAZYLEN(currentrun) || stage)
			log_and_message_admins("SSlighting: Was told to start a new run, but the previous run wasn't finished! currentrun.len=[currentrun.len], stage=[stage]")
			resumed = TRUE
		else
			stage = SSLIGHTING_STAGE_LIGHTS // Start with Step 1 of course

	if(stage == SSLIGHTING_STAGE_LIGHTS)
		timer = TICK_USAGE
		internal_process_lights(resumed)
		cost_lights = MC_AVERAGE(cost_lights, TICK_DELTA_TO_MS(TICK_USAGE - timer))
		if(state != SS_RUNNING)
			return
		resumed = 0
		stage = SSLIGHTING_STAGE_CORNERS

	if(stage == SSLIGHTING_STAGE_CORNERS)
		timer = TICK_USAGE
		internal_process_corners(resumed)
		cost_corners = MC_AVERAGE(cost_corners, TICK_DELTA_TO_MS(TICK_USAGE - timer))
		if(state != SS_RUNNING)
			return
		resumed = 0
		stage = SSLIGHTING_STAGE_OVERLAYS

	if(stage == SSLIGHTING_STAGE_OVERLAYS)
		timer = TICK_USAGE
		internal_process_overlays(resumed)
		cost_overlays = MC_AVERAGE(cost_overlays, TICK_DELTA_TO_MS(TICK_USAGE - timer))
		if(state != SS_RUNNING)
			return
		resumed = 0
		stage = SSLIGHTING_STAGE_DONE

	// Okay, we're done! Woo! Got thru a whole air_master cycle!
	if(LAZYLEN(currentrun) || stage != SSLIGHTING_STAGE_DONE)
		log_and_message_admins("SSlighting: Was not able to complete a full lighting cycle despite reaching the end of fire(). This shouldn't happen.")
	else
		currentrun = null
		stage = null

/datum/controller/subsystem/lighting/proc/internal_process_lights(resumed = FALSE, init_tick_checks = FALSE)
	if (!resumed)
		// We swap out the lists so any additions to the global list during a pause don't make things wierd.
		src.currentrun = global.lighting_update_lights
		global.lighting_update_lights = list()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun
	while(currentrun.len)
		var/datum/light_source/L = currentrun[currentrun.len]
		currentrun.len--

		if(!L) continue
		if(L.check() || L.destroyed || L.force_update)
			L.remove_lum()
			if(!L.destroyed)
				L.apply_lum()

		else if(L.vis_update)	//We smartly update only tiles that became (in) visible to use.
			L.smart_vis_update()

		L.vis_update   = FALSE
		L.force_update = FALSE
		L.needs_update = FALSE

		DUAL_TICK_CHECK

/datum/controller/subsystem/lighting/proc/internal_process_corners(resumed = FALSE, init_tick_checks = FALSE)
	if (!resumed)
		// We swap out the lists so any additions to the global list during a pause don't make things wierd.
		src.currentrun = global.lighting_update_corners
		global.lighting_update_corners = list()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun
	while(currentrun.len)
		var/datum/lighting_corner/C = currentrun[currentrun.len]
		currentrun.len--

		if(!C) continue
		C.update_overlays()
		C.needs_update = FALSE

		DUAL_TICK_CHECK

/datum/controller/subsystem/lighting/proc/internal_process_overlays(resumed = FALSE, init_tick_checks = FALSE)
	if (!resumed)
		// We swap out the lists so any additions to the global list during a pause don't make things wierd.
		src.currentrun = global.lighting_update_overlays
		global.lighting_update_overlays = list()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun
	while(currentrun.len)
		var/atom/movable/lighting_overlay/O = currentrun[currentrun.len]
		currentrun.len--

		if(!O) continue
		O.update_overlay()
>>>>>>> a42e6b34466... Merge pull request #8497 from Spookerton/spkrtn/sys/30-inch-racks-01
		O.needs_update = FALSE
		if(init_tick_checks)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			break
	if (i)
		queue.Cut(1, i+1)


/datum/controller/subsystem/lighting/Recover()
	subsystem_initialized = SSlighting.subsystem_initialized
	..()
