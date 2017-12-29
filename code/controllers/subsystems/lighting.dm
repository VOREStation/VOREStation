/*
** Lighting Subsystem - Process the lighting! Do it!
*/

#define SSLIGHTING_STAGE_LIGHTS 1
#define SSLIGHTING_STAGE_CORNERS 2
#define SSLIGHTING_STAGE_OVERLAYS 3
#define SSLIGHTING_STAGE_DONE 4
// This subsystem's fire() method also gets called once during Master.Initialize().
// During this fire we need to use CHECK_TICK to sleep and continue, but in all other fires we need to use MC_CHECK_TICK to pause and return.
// This leads us to a rather annoying little tidbit of code that I have stuffed into this macro so I don't have to see it.
#define DUAL_TICK_CHECK if (init_tick_checks) { CHECK_TICK; } else if (MC_TICK_CHECK) { return; }

// Globals
/var/lighting_overlays_initialised = FALSE
/var/list/lighting_update_lights    = list()    // List of lighting sources  queued for update.
/var/list/lighting_update_corners   = list()    // List of lighting corners  queued for update.
/var/list/lighting_update_overlays  = list()    // List of lighting overlays queued for update.

SUBSYSTEM_DEF(lighting)
	name = "Lighting"
	wait = 2 // Ticks, not deciseconds
	init_order = INIT_ORDER_LIGHTING
	flags = SS_TICKER

	var/list/currentrun = list()
	var/stage = null

	var/cost_lights = 0
	var/cost_corners = 0
	var/cost_overlays = 0

/datum/controller/subsystem/lighting/Initialize(timeofday)
	if(!lighting_overlays_initialised)
		// TODO - TG initializes starlight here.
		create_all_lighting_overlays()
		lighting_overlays_initialised = TRUE

	// Pre-process lighting once before the round starts.
	internal_process_lights(FALSE, TRUE)
	internal_process_corners(FALSE, TRUE)
	internal_process_overlays(FALSE, TRUE)
	return ..()

/datum/controller/subsystem/lighting/fire(resumed = FALSE)
	var/timer
	if(!resumed)
		ASSERT(LAZYLEN(currentrun) == 0)  // Santity checks to make sure we don't somehow have items left over from last cycle
		ASSERT(stage == null) // Or somehow didn't finish all the steps from last cycle
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
	ASSERT(LAZYLEN(currentrun) == 0) // Sanity checks to make sure there are really none left
	ASSERT(stage == SSLIGHTING_STAGE_DONE) // And that we didn't somehow skip past the last step
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
		O.needs_update = FALSE

		DUAL_TICK_CHECK

/datum/controller/subsystem/lighting/stat_entry(msg_prefix)
	var/list/msg = list(msg_prefix)
	msg += "T:{"
	msg += "S [total_lighting_sources] | "
	msg += "C [total_lighting_corners] | "
	msg += "O [total_lighting_overlays]"
	msg += "}"
	msg += "C:{"
	msg += "S [round(cost_lights, 1)] | "
	msg += "C [round(cost_corners, 1)] | "
	msg += "O [round(cost_overlays, 1)]"
	msg += "}"
	..(msg.Join())

#undef DUAL_TICK_CHECK
#undef SSLIGHTING_STAGE_LIGHTS
#undef SSLIGHTING_STAGE_CORNERS
#undef SSLIGHTING_STAGE_OVERLAYS
#undef SSLIGHTING_STAGE_STATS