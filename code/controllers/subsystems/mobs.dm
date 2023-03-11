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
<<<<<<< HEAD

	var/slept_mobs = 0
	var/list/process_z = list()
=======
	var/list/busy_z_levels = list()
	var/list/slept = list()
	var/skipped_mobs = 0
>>>>>>> f490b9c1916... Merge pull request #9049 from MistakeNot4892/mobsleep

/datum/controller/subsystem/mobs/stat_entry()
	..("P: [global.mob_list.len] | S: [skipped_mobs]")

/datum/controller/subsystem/mobs/fire(resumed = 0)
	if (!resumed)
<<<<<<< HEAD
=======
		skipped_mobs = 0
>>>>>>> f490b9c1916... Merge pull request #9049 from MistakeNot4892/mobsleep
		src.currentrun = mob_list.Copy()
		process_z.len = GLOB.living_players_by_zlevel.len
		slept_mobs = 0
		for(var/level in 1 to process_z.len)
			process_z[level] = GLOB.living_players_by_zlevel[level].len

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun
	var/times_fired = src.times_fired
	while(currentrun.len)
		var/mob/M = currentrun[currentrun.len]
		currentrun.len--

		if(!M || QDELETED(M))
			mob_list -= M
<<<<<<< HEAD
			continue
		else if(M.low_priority && !(M.loc && get_z(M) && process_z[get_z(M)]))
			slept_mobs++
			continue

		M.Life(times_fired)
=======
		else
			// Right now mob.Life() is unstable enough I think we need to use a try catch.
			// Obviously we should try and get rid of this for performance reasons when we can.
			try
				if(M.low_priority && !(M.z in busy_z_levels))
					skipped_mobs++
					if (MC_TICK_CHECK)
						return
					continue

				var/time = world.time
				M.Life(times_fired)
				if(time != world.time && !slept[M.type])
					slept[M.type] = TRUE
					log_debug("SSmobs: Type '[M.type]' slept for [world.time - time]ds in Life(). Suppressing further warnings.")

			catch(var/exception/e)
				log_runtime(e, M, "Caught by [name] subsystem")
>>>>>>> f490b9c1916... Merge pull request #9049 from MistakeNot4892/mobsleep

		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/mobs/proc/log_recent()
	var/msg = "Debug output from the [name] subsystem:\n"
	msg += "- This subsystem is processed tail-first -\n"
	if(!currentrun || !mob_list)
		msg += "ERROR: A critical list [currentrun ? "mob_list" : "currentrun"] is gone!"
		log_game(msg)
		log_world(msg)
		return
	msg += "Lists: currentrun: [currentrun.len], mob_list: [mob_list.len]\n"

	if(!currentrun.len)
		msg += "!!The subsystem just finished the mob_list list, and currentrun is empty (or has never run).\n"
		msg += "!!The info below is the tail of mob_list instead of currentrun.\n"

	var/datum/D = currentrun.len ? currentrun[currentrun.len] : mob_list[mob_list.len]
	msg += "Tail entry: [describeThis(D)] (this is likely the item AFTER the problem item)\n"

	var/position = mob_list.Find(D)
	if(!position)
		msg += "Unable to find context of tail entry in mob_list list.\n"
	else
		if(position != mob_list.len)
			var/additional = mob_list.Find(D, position+1)
			if(additional)
				msg += "WARNING: Tail entry found more than once in mob_list list! Context is for the first found.\n"
		var/start = clamp(position-2,1,mob_list.len)
		var/end = clamp(position+2,1,mob_list.len)
		msg += "2 previous elements, then tail, then 2 next elements of mob_list list for context:\n"
		msg += "---\n"
		for(var/i in start to end)
			msg += "[describeThis(mob_list[i])][i == position ? " << TAIL" : ""]\n"
		msg += "---\n"
	log_game(msg)
	log_world(msg)

/datum/controller/subsystem/mobs/fail()
	..()
	log_recent()

/datum/controller/subsystem/mobs/critfail()
	..()
	log_recent()