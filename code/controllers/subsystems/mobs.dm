//
// Mobs Subsystem - Process mob.Life()
//
SUBSYSTEM_DEF(mobs)
	name = "Mobs"
	priority = 100
	wait = 2 SECONDS
	flags = SS_KEEP_TIMING|SS_NO_INIT
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME

	var/list/currentrun = list()

/datum/controller/subsystem/mobs/stat_entry()
	..("P: [global.mob_list.len]")

/datum/controller/subsystem/mobs/fire(resumed = 0)
	if (!resumed)
		src.currentrun = mob_list.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun
	var/times_fired = src.times_fired
	while(currentrun.len)
		var/mob/M = currentrun[currentrun.len]
		currentrun.len--

		if(QDELETED(M))
			mob_list -= M
		else
			// Right now mob.Life() is unstable enough I think we need to use a try catch.
			// Obviously we should try and get rid of this for performance reasons when we can.
			try
				M.Life(times_fired)
			catch(var/exception/e)
				log_runtime(e, M, "Caught by [name] subsystem")

		if (MC_TICK_CHECK)
			return
