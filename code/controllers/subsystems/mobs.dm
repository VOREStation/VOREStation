//
// Mobs Subsystem - Process mob.Life()
//

//VOREStation Edits - Contains temporary debugging code to diagnose extreme tick consumption.
//Revert file to Polaris version when done.

SUBSYSTEM_DEF(mobs)
	name = "Mobs"
	priority = 100
	wait = 2 SECONDS
	flags = SS_KEEP_TIMING|SS_NO_INIT
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME

	var/list/currentrun = list()
	var/log_extensively = FALSE
	var/list/timelog = list()

/datum/controller/subsystem/mobs/stat_entry()
	..("P: [global.mob_list.len]")

/datum/controller/subsystem/mobs/fire(resumed = 0)
	if (!resumed)
		src.currentrun = mob_list.Copy()
		if(log_extensively) timelog = list("-Start- [world.tick_usage]")

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
				var/time_before = world.tick_usage
				M.Life(times_fired)
				var/time_after = world.tick_usage
				if(log_extensively) timelog += list("[time_before] - [M] - [time_after]")
			catch(var/exception/e)
				log_runtime(e, M, "Caught by [name] subsystem")

		if (MC_TICK_CHECK)
			return
