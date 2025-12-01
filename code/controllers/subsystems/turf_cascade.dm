#define DEFAULT_CONVERSION_RATE 75
#define DEFAULT_CONVERSION_DELAY 0.25 SECONDS

SUBSYSTEM_DEF(turf_cascade)
	name = "Turf Cascade"
	wait = DEFAULT_CONVERSION_DELAY
	flags = SS_NO_INIT
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME

	VAR_PRIVATE/list/currentrun = list()
	VAR_PRIVATE/list/remaining_turf = list()

	VAR_PRIVATE/turf_replace_type = null // Turf path that turfs will be replaced with
	VAR_PRIVATE/conversion_rate = DEFAULT_CONVERSION_RATE // Number of turfs converted in each batch

/datum/controller/subsystem/turf_cascade/stat_entry(msg)
	msg = "C: [currentrun.len] | R: [remaining_turf.len] | R: [conversion_rate] | P: [turf_replace_type]"
	. = ..()

/datum/controller/subsystem/turf_cascade/fire()
	if(!turf_replace_type || (!remaining_turf.len && !currentrun.len))
		stop_cascade()
		return

	// Create a random list of tiles to expand with instead of doing it in order
	if(currentrun.len < conversion_rate && remaining_turf.len)
		var/i = (conversion_rate - currentrun.len)
		while(i-- > 0)
			var/turf/next = pick(remaining_turf)
			remaining_turf -= next
			currentrun += next
			if(MC_TICK_CHECK)
				return

	while(currentrun.len)
		var/turf/changing = currentrun[1]
		currentrun -= changing

		// Convert turf if we are not the replacement type already
		if(changing.type != turf_replace_type)
			changing.ChangeTurf(turf_replace_type)
			remaining_turf += changing.conversion_cascade_act(remaining_turf)

		if(MC_TICK_CHECK)
			return

/// Starts the turf cascade and boots up the subsystem. If a cascade is already in process, it will not start another till the first finishes.
/datum/controller/subsystem/turf_cascade/proc/start_cascade(turf/start_turf, turf_path, max_per_fire = DEFAULT_CONVERSION_RATE, time_delay = DEFAULT_CONVERSION_DELAY)
	if(turf_replace_type)
		return
	if(!isturf(start_turf) || !max_per_fire)
		return
	turf_replace_type = turf_path
	remaining_turf.Add(start_turf)
	conversion_rate = max_per_fire
	// Configure subsystem for the cascade... Doing it with tick delays is uglier than just making the subsystem slower or faster. Considering this will end the round anyway.
	can_fire = TRUE
	wait = time_delay
	if(wait <= 0) // Don't be a smartass
		wait = DEFAULT_CONVERSION_DELAY

/// Called when we have no more turfs to convert, or an admin wants to emergency stop
/datum/controller/subsystem/turf_cascade/proc/stop_cascade()
	turf_replace_type = null
	remaining_turf.Cut()
	currentrun.Cut()
	conversion_rate = DEFAULT_CONVERSION_RATE
	wait = DEFAULT_CONVERSION_DELAY
	can_fire = FALSE

#undef DEFAULT_CONVERSION_RATE
#undef DEFAULT_CONVERSION_DELAY
