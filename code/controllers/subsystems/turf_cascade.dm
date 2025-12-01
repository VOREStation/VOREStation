#define DEFAULT_CONVERSION_RATE 75
#define DEFAULT_CONVERSION_DELAY 0.25 SECONDS

SUBSYSTEM_DEF(turf_cascade)
	name = "Turf Cascade"
	wait = DEFAULT_CONVERSION_DELAY
	flags = SS_NO_INIT

	dependencies = list(
		/datum/controller/subsystem/mobs
	)
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	VAR_PRIVATE/list/currentrun = list()
	VAR_PRIVATE/list/remaining_turf = list()

	VAR_PRIVATE/turf_replace_type = null // Once set, cannot be unset
	VAR_PRIVATE/conversion_rate = DEFAULT_CONVERSION_RATE // Number of turfs converted in each batch

/datum/controller/subsystem/turf_cascade/stat_entry(msg)
	msg = "C: [currentrun.len] | R: [remaining_turf.len] | R: [conversion_rate] | P: [turf_replace_type]"
	. = ..()

/datum/controller/subsystem/turf_cascade/fire()
	if(!turf_replace_type || (!remaining_turf.len && !currentrun.len))
		can_fire = FALSE // We have nothing to do until told.
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
		var/turf/changing = pick(currentrun)
		currentrun -= changing

		// Convert turf if we are not the replacement type already
		if(changing.type != turf_replace_type)
			changing.ChangeTurf(turf_replace_type)
			var/list/expanding_options = changing.conversion_cascade_act()
			for(var/expand_dir in expanding_options)
				var/turf/next_turf = get_step(changing, expand_dir)
				if(next_turf && next_turf.type != turf_replace_type && !(next_turf in remaining_turf)) // Yes in currentrun is expensive, but less expensive than 6 dupes per turf potentially in the loop
					remaining_turf.Add(next_turf)

		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/turf_cascade/proc/start_cascade(turf/start_turf, turf_path, max_per_fire = DEFAULT_CONVERSION_RATE, time_delay = DEFAULT_CONVERSION_DELAY)
	// Once set in motion...
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
	// ... We shall never come to rest.

#undef DEFAULT_CONVERSION_RATE
